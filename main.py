import re
import time
import os
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import NoSuchElementException, TimeoutException
from openpyxl import Workbook

CHROME_DRIVER_PATH = "chromedriver.exe"

chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--log-level=3")
chrome_options.add_experimental_option("detach", False)

service = Service(CHROME_DRIVER_PATH)
driver = webdriver.Chrome(service=service, options=chrome_options)

wait = WebDriverWait(driver, 20)
TFLITE_MODEL = "meu.tflite"
if os.path.exists(TFLITE_MODEL):
    import tflite_runtime.interpreter as tflite

    interpreter = tflite.Interpreter(
        model_path=TFLITE_MODEL,
        experimental_delegates=[]
    )
    interpreter.allocate_tensors()
    print("[DEBUG] Modelo TFLite carregado (CPU).")
else:
    print("[DEBUG] Modelo TFLite não encontrado – pulando.")

def extrair_id(link: str) -> str:
    m = re.search(r"id=(\d+)", link)
    return m.group(1) if m else ""

def salvar_excel(nome_arquivo: str, dados: list, colunas: list):
    wb = Workbook()
    ws = wb.active
    ws.append(colunas)
    for linha in dados:
        ws.append(linha)
    wb.save(nome_arquivo)
    print(f"[DEBUG] {nome_arquivo} salvo – {len(dados)} linhas")

def fazer_login():
    print("[DEBUG] Acessando página de login…")
    driver.get("SEU_LINK_AQUI") # PÁGINA DE LOGIN

    driver.find_element(By.ID, "username").send_keys("USUARIO_AQUI") #USUÁRIO
    driver.find_element(By.ID, "password").send_keys("SENHA_AQUI") #SENHA
    driver.find_element(By.ID, "loginbtn").click() #BOTÃO DE LOGIN

    wait.until(EC.presence_of_element_located((By.ID, "page-wrapper")))
    print("Login realizado com sucesso")

def coletar_cursos_destino():
    print("[DEBUG] Iniciando coleta de cursos destino…")
    driver.get("SEU_LINK_AQUI") #LINK DA PRIMEIRA COLETA
    dados = []

    while True:
        try:
            wait.until(
                EC.presence_of_all_elements_located((By.CSS_SELECTOR, "div.result h4.result-title a")) #DEFINIR AQUI O ELEMENTO COM O LINK
            )
            cursos = driver.find_elements(
                By.CSS_SELECTOR,
                'div.result h4.result-title a[href*="/course/view.php"]'
            )

            for curso in cursos:
                nome = curso.text.strip()
                link = curso.get_attribute("href")
                dados.append([link, nome, extrair_id(link)])

            # próxima página
            proxima = driver.find_elements(
                By.XPATH,
                '//li[@class="page-item" and not(contains(@class,"disabled"))]/a[span[contains(text(),"»")]]'
            )
            if proxima:
                driver.execute_script("arguments[0].click();", proxima[0])
                wait.until(EC.staleness_of(cursos[0])) 
            else:
                break

        except TimeoutException:
            print("[WARN] Timeout na página de busca; encerrando loop.")
            break

    return dados

def coletar_origens():
    print("[DEBUG] Iniciando coleta de cursos origem…")
    driver.get("SEU_LINK_AQUI")

    wait.until(EC.presence_of_all_elements_located((By.CSS_SELECTOR, "a.aalink")))
    cursos = driver.find_elements(By.CSS_SELECTOR, "a.aalink")

    dados_filtrados = []
    for c in cursos:
        texto = c.text.strip()
        link = c.get_attribute("href")
        if re.match(r"^(F\d+|ED-)", texto):
            dados_filtrados.append([texto, link, extrair_id(link)])

    return dados_filtrados

if __name__ == "__main__":
    try:
        fazer_login()

        destinos = coletar_cursos_destino()
        salvar_excel("cursos_e_links.xlsx",
                     destinos,
                     ["ENDERECO_DESTINO", "PARA-DESTINO", "ID_DESTINO"])

        origens = coletar_origens()
        salvar_excel("ORIGEM.xlsx",
                     origens,
                     ["DE-ORIGEM", "ENDERECO_ORIGEM", "ID_ORIGEM"])

        print("Coleta finalizada com sucesso!")

    finally:
        driver.quit()
        print("[DEBUG] Driver encerrado.")
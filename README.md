
# Python Scraper - Moodle SESI RS

Este projeto é um script em Python com Selenium para automatizar a coleta de **cursos de destino e origem** de uma instância Moodle.  
Os dados extraídos são salvos em **dois arquivos Excel (`.xlsx`)**, com colunas formatadas de acordo com a estrutura exigida para análise ou importação no sistema ASD.

---

## Funcionalidades

- Login automático no Moodle
- Busca de cursos por termo específico (`2025/2`, por exemplo)
- Coleta de dados de cursos de **destino** (via página de busca)
- Coleta de dados de cursos de **origem** (via página de categorias)
- Extração de IDs dos cursos diretamente dos links
- Salvamento em dois arquivos `.xlsx` separados:
  - `cursos_e_links.xlsx` (destinos)
  - `ORIGEM.xlsx` (origens)

---

## Estrutura dos Arquivos Gerados

### `cursos_e_links.xlsx`  
Coleta feita na busca por cursos com o termo "2025/2"

| ENDERECO_DESTINO | PARA-DESTINO | ID_DESTINO |
|------------------|---------------|------------|
| Link para o curso destino | Nome completo do curso destino | ID extraído do link |

---

### `ORIGEM.xlsx`  
Coleta feita a partir da categoria com ID `31` (origens EJA)

| DE-ORIGEM | ENDERECO_ORIGEM | ID_ORIGEM |
|-----------|------------------|-----------|
| Nome da origem (exibido na lista) | Link direto do curso origem | ID extraído do link |

**Importante:** Somente cursos cujo nome comece com `"F1"`, `"F2"`, `"F3"`, etc. ou com `"ED-"` são considerados na coleta de origem.

---

## Pré-requisitos

- Python 3.10 ou superior
- Google Chrome instalado
- ChromeDriver compatível com a versão do seu navegador
- Git (opcional, para clonar o repositório)

---

## RUN

Caso deseje automatizar o processo de preparação do ambiente e instalação de dependências, rode como Administrador o arquivo `run.bat`.
Este script faz tudo por você:
- Instala o Python (caso não tenha).
- Instala o Google Chrome (caso não tenha).
- Baixa automaticamente o ChromeDriver.
- Cria o ambiente virtual.
- Instala as dependências.
- Executa o script principal main.py.
- Recomendado para usuários iniciantes ou que desejam evitar configurações manuais.

---

## Instalação do ChromeDriver

1. Verifique a versão do Chrome em `chrome://settings/help`
2. Acesse: https://developer.chrome.com/docs/chromedriver/downloads
3. Baixe o `chromedriver-win64.zip` correspondente
4. Extraia o `chromedriver.exe` para a raiz do projeto

---

## Como preparar o ambiente

### Opção 1: Instalação automática com `setup.bat`

Execute com duplo clique ou terminal:

```
setup.bat
```

Isso irá:

- Criar o ambiente virtual
- Instalar as dependências listadas no `requirements.txt`

---

### Opção 2: Instalação manual

1. Crie o ambiente virtual:
```
python -m venv venv
```

2. Ative o ambiente:

No CMD:
```
venv\Scripts\activate.bat
```

No PowerShell:
```
venv\Scripts\Activate.ps1
```

3. Instale as dependências:
```
pip install -r requirements.txt
```

---

## Como executar

1. Ative o ambiente virtual
2. Execute o script principal:
```
python main.py
```

Os arquivos `cursos_e_links.xlsx` e `ORIGEM.xlsx` serão salvos na raiz do projeto.

---

## Segurança

As credenciais do Moodle estão no código-fonte por padrão, mas você pode movê-las para um arquivo `.env` utilizando a biblioteca `python-dotenv`.

Esse `.env` deve ser incluído no `.gitignore`.

---

## Arquivos ignorados (.gitignore)

- `chromedriver.exe`
- `venv/`
- `__pycache__/`
- `*.pyc`
- `cursos_e_links.xlsx`
- `ORIGEM.xlsx`
- `.env`

---

## Licença

Este projeto é de uso interno e segue as diretrizes do SESI RS.

### Créditos

Feito por Franco F. Wolff
https://www.linkedin.com/in/ffwolff/
https://github.com/ffwolff
@echo off
echo ================================================
echo INICIANDO SCRAPER - MOODLE SCRAPPER
echo ================================================

:: 1. Verifica se venv existe
if not exist venv (
    echo [ERRO] Ambiente virtual nao encontrado!
    echo Execute primeiro o setup.bat
    pause
    exit /b
)

:: 2. Ativa venv
call venv\Scripts\activate.bat

:: 3. Verifica chromedriver
if not exist chromedriver.exe (
    echo [ERRO] chromedriver.exe nao encontrado!
    echo Coloque o chromedriver na raiz do projeto.
    pause
    exit /b
)

:: 4. Verifica .env
if not exist .env (
    echo [ERRO] arquivo .env nao encontrado!
    echo Crie o .env com LOGIN_URL, USERNAME, PASSWORD, etc.
    pause
    exit /b
)

echo ================================================
echo EXECUTANDO main.py...
echo ================================================

python main.py

echo ================================================
echo EXECUCAO FINALIZADA
echo ================================================

pause
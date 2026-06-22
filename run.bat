@echo off
setlocal enabledelayedexpansion

echo ================================================
echo INICIALIZANDO SCRIPT - PREPARO DO AMBIENTE
echo ================================================

:: 1. Verificar Python
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo [INFO] Python nao encontrado. Baixando...
    powershell -Command "Invoke-WebRequest https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe -OutFile python-installer.exe"
    start /wait python-installer.exe /quiet InstallAllUsers=1 PrependPath=1
    del python-installer.exe
    echo [OK] Python instalado.
) else (
    echo [OK] Python ja instalado.
)

:: 2. Verificar Google Chrome
reg query "HKLM\Software\Google\Chrome" >nul 2>nul
if %errorlevel% neq 0 (
    echo [INFO] Google Chrome nao encontrado. Instalando...
    powershell -Command "Invoke-WebRequest https://dl.google.com/chrome/install/375.126/chrome_installer.exe -OutFile chrome-installer.exe"
    start /wait chrome-installer.exe /silent /install
    del chrome-installer.exe
    echo [OK] Chrome instalado.
) else (
    echo [OK] Google Chrome ja instalado.
)

:: 3. Baixar ChromeDriver correspondente
if not exist chromedriver.exe (
    echo [INFO] Baixando ChromeDriver correspondente...
    for /f "tokens=3" %%i in ('reg query "HKLM\Software\Google\Chrome\BLBeacon" /v version') do set CHROME_VERSION=%%i
    for /f "tokens=1 delims=." %%a in ("!CHROME_VERSION!") do set CHROME_MAJOR=%%a

    powershell -Command "$json = Invoke-RestMethod 'https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json'; $url = $json.channels.Stable.downloads.chromedriver | Where-Object { $_.platform -eq 'win64' } | Select-Object -ExpandProperty url; Invoke-WebRequest $url -OutFile 'chromedriver.zip'"
    tar -xf chromedriver.zip
    move chromedriver-win64\chromedriver.exe . >nul
    rmdir /s /q chromedriver-win64
    del chromedriver.zip
    echo [OK] ChromeDriver instalado.
) else (
    echo [OK] ChromeDriver ja existe.
)

:: 4. Criar ambiente virtual
if not exist venv (
    echo [INFO] Criando ambiente virtual...
    python -m venv venv
) else (
    echo [OK] Ambiente virtual ja existe.
)

:: 5. Ativar ambiente virtual
call venv\Scripts\activate.bat

:: 6. Instalar dependências
echo [INFO] Instalando dependencias...
pip install --upgrade pip >nul
pip install -r requirements.txt

:: 7. Executar script principal
echo [INFO] Executando main.py...
python main.py

echo ================================================
echo FINALIZADO
echo Pressione qualquer tecla para sair.
pause >nul
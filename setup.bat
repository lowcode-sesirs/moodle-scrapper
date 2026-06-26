@echo off
echo ================================
echo Criando ambiente virtual...
echo ================================

if not exist venv (
    python -m venv venv
) else (
    echo Ambiente virtual ja existe.
)

echo ================================
echo Ativando ambiente virtual...
echo ================================

call venv\Scripts\activate.bat

echo ================================
echo Atualizando pip...
echo ================================

python -m pip install --upgrade pip

echo ================================
echo Instalando dependencias...
echo ================================

pip install -r requirements.txt

echo ================================
echo VERIFICACAO CHROMEDRIVER
echo ================================

if exist chromedriver.exe (
    echo [OK] chromedriver.exe encontrado.
) else (
    echo [ERRO] chromedriver.exe NAO encontrado na pasta!
    echo Coloque o chromedriver.exe na raiz do projeto.
)

echo ================================
echo VERIFICACAO .env
echo ================================

if exist .env (
    echo [OK] arquivo .env encontrado.
) else (
    echo [WARN] arquivo .env nao encontrado.
    echo Crie um arquivo .env com LOGIN_URL, USERNAME, PASSWORD, etc.
)

echo ================================
echo Ambiente pronto!
echo ================================
pause
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
    echo Criando .env.example...

    (
        echo LOGIN_URL=https://seusite.com/login
        echo USERNAME=seu_usuario
        echo PASSWORD=sua_senha
        echo.
        echo COLETA_DESTINO_URL=https://seusite.com/destinos
        echo COLETA_ORIGEM_URL=https://seusite.com/origens
    ) > .env.example

    echo [OK] .env.example criado!
    echo Agora copie .env.example para .env e preencha os dados.
)

echo ================================
echo Ambiente pronto!
echo ================================
pause
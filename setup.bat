@echo off
echo ================================
echo Criando ambiente virtual...
echo ================================
python -m venv venv

echo ================================
echo Ativando ambiente virtual...
echo ================================
call venv\Scripts\activate.bat

echo ================================
echo Instalando dependências...
echo ================================
pip install --upgrade pip
pip install -r requirements.txt

echo ================================
echo Ambiente pronto!
echo Para ativar futuramente:
echo   venv\Scripts\activate.bat
echo ================================
pause
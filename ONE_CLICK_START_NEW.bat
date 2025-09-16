@echo off
echo ========================================
echo    BRIDGE GAD-01 - ONE CLICK START    
echo ========================================
echo.
echo Professional Bridge Design & Drawing Generation System
echo Author: Rajkumar Singh Chauhan
echo Email: crajkumarsingh@hotmail.com
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.8 or higher from https://python.org
    pause
    exit /b 1
)

echo Installing/Updating required packages...
pip install -r requirements.txt

echo.
echo Starting Bridge GAD Application...
echo.
echo The application will open in your web browser automatically.
echo If it doesn't open, navigate to: http://localhost:8501
echo.
echo To stop the application, press Ctrl+C
echo.

REM Create input and output folders if they don't exist
if not exist "SAMPLE_INPUT_FILES" mkdir SAMPLE_INPUT_FILES
if not exist "OUTPUT_01_16092025" mkdir OUTPUT_01_16092025

echo Starting Streamlit application...
streamlit run streamlit_app.py --server.port 8501

pause
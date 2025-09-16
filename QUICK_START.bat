@echo off
echo ========================================
echo      BRIDGE GAD-01 - QUICK START      
echo ========================================
echo.
echo Fast Launch for Experienced Users
echo.

REM Create folders if needed
if not exist "OUTPUT_01_16092025" mkdir OUTPUT_01_16092025

echo Starting Bridge Application...
streamlit run streamlit_app.py --server.port 8501
@echo off
echo ========================================
echo   BRIDGE GAD-01 - COMMAND LINE MODE   
echo ========================================
echo.
echo Generate bridge drawings from command line
echo.

echo Available bridge types:
echo - beam
echo - truss  
echo - arch
echo - suspension
echo - cable_stayed
echo - t_beam
echo - slab
echo.

echo Example usage:
echo python bridge_drawings.py beam --span 50 --width 12 --height 20 --output "OUTPUT_01_16092025/my_bridge"
echo.

echo Enter your command (or press Enter for examples):
set /p user_input=""

if "%user_input%"=="" (
    echo Generating example bridges...
    python bridge_drawings.py beam --examples
) else (
    %user_input%
)

pause
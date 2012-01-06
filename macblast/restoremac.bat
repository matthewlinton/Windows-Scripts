@echo off
@REM restoremac
@REM Will restore a hosts MAC address back to its default
@REM Updated 2008-01-07

set /P interface=Enter the Network Interface: 
echo Resetting "%interface%" to its default MAC address
Lib\macshift.exe -i "%interface%" -d
pause
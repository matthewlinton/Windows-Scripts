@ECHO off
@REM tostest-cap
@REM Helper script to capture packets
@REM Updated 2008-03-18

ECHO.
ECHO Capturing packets on interface:
ECHO %1
ECHO Logging results to "%2"
Lib\Windump.exe -n -v -i %1 > "%2"
pause
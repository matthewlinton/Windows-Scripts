@echo off
@REM iperf-server
@REM launch the iperf server which will wait for the iperf client to connect
@REM Updated 2008-02-19

SET PORT=5001
SET TCPWIN="128k"
SET FORMAT="m"
SET UDP=n

IF NOT EXIST Lib\iperf.exe ECHO Unable to find iperf.exe. Unable to continue & EXIT 1

SET /P PORT=Enter a port to run on (%PORT%): 
SET /P UDP=Run UDP test (y/N): 

ECHO.
<nul (SET/p anyvariable=iPerf server running on: )
ipconfig | Lib\grep.exe "IP Address" | Lib\sed.exe -e "s/IP Address//g" -e "s/[ .]*: //g"
ipconfig | Lib\grep.exe "IPv4 Address" | Lib\sed.exe -e "s/IPv4 Address//g" -e "s/[ .]*: //g"

IF %UDP% == n Lib\iperf.exe -s -p %PORT% -w %TCPWIN% -f %FORMAT%
IF %UDP% == N Lib\iperf.exe -s -p %PORT% -w %TCPWIN% -f %FORMAT%
IF %UDP% == Y Lib\iperf.exe -s -u -p %PORT% -w %TCPWIN% -f %FORMAT%
IF %UDP% == y Lib\iperf.exe -s -u -p %PORT% -w %TCPWIN% -f %FORMAT%

:END
ECHO Done
PAUSE


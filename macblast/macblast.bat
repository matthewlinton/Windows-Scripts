@ECHO off
@REM macblast
@REM uses macshift to change a hosts MAC address and request a new IP address
@REM Updated 2008-09-17

SET WAITTIME=30
SET COUNT=1
SET LOGFILE=logfile
SET NUMHOSTS=5
SET INTERFACE=

if not exist Lib\macshift.exe ECHO macshift.exe not found. Exiting & GOTO END

SET /P LOGFILE=Enter in a log name (w/o extension):
IF EXIST "%LOGFILE%.csv" GOTO OVERWRITELOG
:CONTINUE
SET /P INTERFACE=Enter the Network Interface:  
SET /P NUMHOSTS=Enter in the number of hosts to simulate(%NUMHOSTS%): 
SET /P WAITTIME=Enter in the time to wait between MAC changes(%WAITTIME%):

ECHO -----------------------------------------------
ECHO Simulating %NUMHOSTS% hosts
ECHO Using INTERFACE "%INTERFACE%"
ECHO requesting a new IP address every %WAITTIME% seconds.
ECHO logging results to "%LOGFILE%.csv"
ECHO -----------------------------------------------

ECHO HOST#,DATE,TIME,MAC ADDR,IP ADDR >> "%LOGFILE%.csv"

<NUL (SET/p anyvariable=0,%DATE%,%TIME%,) >> "%LOGFILE%.csv"
ipconfig /ALL | Lib\grep.exe "Physical Address" | Lib\sed.exe -e "s/        Physical Address. . . . . . . . . : //g" -e "s/-/:/g" >> "%LOGFILE%.csv"
<NUL (SET/p anyvariable=,) >> "%LOGFILE%.csv"
ipconfig | Lib\grep.exe -U "IP Address" | Lib\sed.exe -T -e "s/        IP Address. . . . . . . . . . . . : //g" >> "%LOGFILE%.csv"

:START
Lib\macshift.exe -i "%INTERFACE%" -r | Lib\sed.exe -T -e "s/Done//g"
Lib\Wait.exe %WAITTIME%
<NUL (SET/p anyvariable=%COUNT%,%DATE%,%TIME%,) >> "%LOGFILE%.csv"
ipconfig /ALL | Lib\grep.exe "Physical Address" | Lib\sed.exe -e "s/        Physical Address. . . . . . . . . : //g" -e "s/-/:/g" >> "%LOGFILE%.csv"
<NUL (SET/p anyvariable=,) >> "%LOGFILE%.csv"
ipconfig | Lib\grep.exe -U "IP Address" | Lib\sed.exe -T -e "s/        IP Address. . . . . . . . . . . . : //g" >> "%LOGFILE%.csv"
if %COUNT% == %NUMHOSTs% GOTO FINISHED
SET /A COUNT += 1
GOTO START

:FINISHED
ECHO done
ECHO Resetting "%INTERFACE%" to its default MAC address
Lib\macshift.exe -i "%INTERFACE%" -d


:END
ECHO Done
pause
EXIT 0

:OVERWRITELOG
SET ANS=n
ECHO ** "%LOGFILE%.csv" already exists.  Would you like to overwrite this file?
SET /P ANS=   (y/N): 
IF "%ANS%"=="n" GOTO SETUP
IF "%ANS%"=="N" GOTO SETUP
IF "%ANS%"=="y" del "%LOGFILE%.csv" & GOTO CONTINUE
IF "%ANS%"=="Y" del "%LOGFILE%.csv" & GOTO CONTINUE
ECHO    "%ANS%" is not valid
GOTO END
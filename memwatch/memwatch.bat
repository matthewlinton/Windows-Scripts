@ECHO off
@REM memwatch
@REM Watches a specified process and logs its memory usage
@REM Updated 2008-01-07

IF NOT EXIST Lib\pslist.exe ECHO pslist.exe not found. Unable to continue. & GOTO END
IF NOT EXIST Lib\sed.exe ECHO sed.exe not found. Unable to continue. & GOTO END
IF NOT EXIST Lib\grep.exe ECHO grep.exe not found. Unable to continue. & GOTO END
IF NOT EXIST Lib\gawk.exe ECHO gawk.exe not found. Unable to continue. & GOTO END
IF NOT EXIST Lib\tail.exe ECHO tail.exe not found. Unable to continue. & GOTO END
IF NOT EXIST Lib\wait.exe ECHO wait.exe not found.  memwatch will not wait between polling.

:SETUP
SET LOGFILE=logfile
SET PROCESS=explorer
SET WAITTIME=5

SET /P LOGFILE=Enter in a log name (w/o extension): 
IF EXIST "%LOGFILE%.csv" GOTO OVERWRITELOG
:CONTINUE
ECHO Enter the name of the PROCESS you would like to monitor
SET /P PROCESS=Do NOT include ".exe": 
SET /P WAITTIME=Enter a poling interval in minutes (%WAITTIME%):

ECHO -----------------------------------------------
ECHO Checking memory information for "%PROCESS%"
ECHO Polling PROCESS every %WAITTIME% Minutes
ECHO Logging results to: "%LOGFILE%.csv"
ECHO press CTRL+C to stop
ECHO -----------------------------------------------

ECHO Date,Time,Process,PID,Virtual Memory,Active Memory,Private VM,VM Peek,Page Faults,Non Paged Pool,Paged Pool > "%LOGFILE%.csv"

SET /A WAITTIME *= 60
:Loop
<nul (SET/p anyvariable=%DATE%,%TIME%, ) >> "%LOGFILE%.csv"
Lib\pslist.exe -m %PROCESS% | Lib\grep.exe -i %PROCESS% | Lib\sed.exe "s/[ ]\+/,/g" >> "%LOGFILE%.csv" 2> NUL
Lib\tail.exe -n 1 "%LOGFILE%.csv" | Lib\gawk.exe "BEGIN { FS = \",\" } { print \"[\"$1,$2\"] (\"$3,\") Vmem: \"$5\"    Amem: \"$5 }"
Lib\Wait.exe %WAITTIME%
GOTO LOOP

:END
ECHO Done
pause
exit 0

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
@ECHO off
@REM filetest-flat
@REM uses creatfil to generate a  user defined number of files within a single directory
@REM Updated 2008-09-16

IF NOT EXIST Lib\creatfil.exe ECHO Could not find creatfil.exe. Unable to continue & EXIT 1

:SETUP
SET DESTINATION=%TEMP%
SET LOGFILE="logfile"
SET MAXFILE=1
SET FILESIZE=1024
SET PARALEL=n

SET /P LOGFILE=Enter in a logfile name (w/o extension): 
IF EXIST "%LOGFILE%.log" GOTO OVERWRITELOG
:CONTINUE
SET /P DESTINATION=Enter in the destination folder: 
SET /P MAXFILE=Enter in the maximum number of files to create: 
SET /P FILESIZE=Enter in the file size for each file in kilobytes(%FILESIZE%): 
SET /P PARALEL=Will each file be created in paralel with the others?(%PARALEL%): 

IF NOT EXIST %DESTINATION% MKDIR %DESTINATION%

ECHO %DATE% %TIME% >> "%LOGFILE%.txt"
ECHO Starting test filetest-flat >> "%LOGFILE%.txt"
ECHO Destination: %DESTINATION% >> "%LOGFILE%.txt"
ECHO Number of Files: %MAXFILE% >> "%LOGFILE%.txt"
ECHO Filesize: %FILESIZE% >> "%LOGFILE%.txt"
ECHO Paralel Test: %SERIAL% >> "%LOGFILE%.txt"
ECHO -------------------------------------------------- >> "%LOGFILE%.txt"

SET i=0
:LOOP
<NUL (SET/p anyvariable=Creating file "%DESTINATION%\test%i%.dat" ... )
ECHO Creating File "%DESTINATION%\test%i%.dat" >> "%LOGFILE%.txt"
IF "%PARALEL%"=="y" GOTO LOOPPARALEL
IF "%PARALEL%"=="Y" GOTO LOOPPARALEL
Lib\creatfil.exe "%DESTINATION%\test%i%.dat" %FILESIZE%
ECHO Done
GOTO LOOPCHOICE
:LOOPPARALEL
START Lib\creatfil.exe "%DESTINATION%\test%i%.dat" %FILESIZE% 
ECHO Working...
:LOOPCHOICE
SET /A i+=1
IF NOT %i%==%MAXFILE% GOTO LOOP

:END
ECHO DONE
PAUSE
EXIT 0

:OVERWRITELOG
SET ANS=n
ECHO ** "%LOGFILE%.txt" already exists.  Would you like to overwrite this file?
SET /P ANS=   (y/N): 
IF "%ANS%"=="n" GOTO SETUP
IF "%ANS%"=="N" GOTO SETUP
IF "%ANS%"=="y" del "%LOGFILE%.txt" & GOTO CONTINUE
IF "%ANS%"=="Y" del "%LOGFILE%.txt" & GOTO CONTINUE
ECHO    "%ANS%" is not valid
GOTO END
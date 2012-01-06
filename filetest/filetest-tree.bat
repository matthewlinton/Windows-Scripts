@ECHO off
@REM filetest-tree
@REM uses creatfil to generate a  user defined number of files within a directory tree
@REM Updated 2008-06-26

IF NOT EXIST Lib\creatfil.exe ECHO Could not find creatfil.exe. Unable to continue & EXIT 1

:SETUP
SET DESTINATION=%TEMP%
SET LOGFILE="logfile"
SET MAXFILE=1
SET DIRDEPTH=1
SET DIRWIDTH=1
SET FILESIZE=1024

SET /P LOGFILE=Enter in a logfile name (w/o extension): 
IF EXIST "%LOGFILE%.log" GOTO OVERWRITELOG
:CONTINUE
SET /P DESTINATION=Enter in the destination folder: 
SET /P MAXFILE=Enter in the maximum number of files to create: 
SET /P DIRDEPTH=Enter in the depth for the directory tree: 
SET /P DIRWIDTH=Enter in the width for the directory tree: 
SET /P FILESIZE=Enter in the file size for each file in kilobytes(%FILESIZE%): 

IF NOT EXIST %DESTINATION% MKDIR %DESTINATION%

ECHO %DATE% %TIME% >> "%LOGFILE%.txt"
ECHO Starting test filetest-tree >> "%LOGFILE%.txt"
ECHO Destination: %DESTINATION% >> "%LOGFILE%.txt"
ECHO Number of Files: %MAXFILE% >> "%LOGFILE%.txt"
ECHO Directory Depth: %DIRDEPTH% >> "%LOGFILE%.txt"
ECHO Directory Width: %DIRWIDTH% >> "%LOGFILE%.txt"
ECHO Filesize: %FILESIZE% >> "%LOGFILE%.txt"
ECHO -------------------------------------------------- >> "%LOGFILE%.txt"

@REM create directory structure

@REM Add files to directory structure

:OVERWRITELOG
SET ANS=n
ECHO ** "%LOGFILE%.txt" already exists.  Would you like to overwrite this file?
SET /P ANS=   (y/N): 
IF "%ANS%"=="n" GOTO SETUP
IF "%ANS%"=="N" GOTO SETUP
IF "%ANS%"=="y" DEL "%LOGFILE%.txt" & GOTO CONTINUE
IF "%ANS%"=="Y" DEL "%LOGFILE%.txt" & GOTO CONTINUE
ECHO    "%ANS%" is not valid
GOTO END
@ECHO off
@REM F5D8235v1000
@REM This is a device specific script to download and parse information from the router's home page
@REM USAGE:  F5D8235v1000.bat <workingdir> <tempdir> <retry> <timeout> <ipaddy> <logfile>
@REM Updated 2008-10-21

:DEFAULTS
SET IPADDY=192.168.2.1
SET WORKINGDIR=.
SET LOGFILE=logfile
SET TEMPDIR=TEMP
SET TIMEOUT=10
SET RETRY=1

:OPTIONS


:FETCH
Lib\wget.exe -t %RETRY% -T %TIMEOUT% -P %TEMPDIR% http://%IPADDY%/index.html
:PARSE


:END
EXIT 0
@echo off
@REM surftest
@REM Simulates users surfing the web by opening a wget session for each URL in the specified config file
@REM Updated 2008-05-21

IF NOT EXIST Lib\wget.exe echo wget.exe NOT found. Unable to continue & exit 1
IF NOT EXIST Lib\sed.exe echo sed.exe NOT found. Unable to continue & exit 1

:SETUP
SET CONF=Conf
SET URLCONFIG=urllist-medium.txt
SET LOOPWAIT=1
SET DLTEMP=urltmp
SET DEPTH=0
SET WGETRETRY=5
SET USERAGENT="SurfTest/1.0"
 
ECHO Available URL lists:
ECHO ---------------------------------------------------
DIR /B /D %CONF% | Lib\sed.exe "s/^/-- /g"
ECHO ---------------------------------------------------
SET /P URLCONFIG=Enter a URL list to use (%URLCONFIG%): 

IF NOT EXIST "%CONF%\%URLCONFIG%" ECHO URL configuration file (%URLCONFIG%) not found. & GOTO SETUP

FOR /F %%I IN ( %CONF%\%URLCONFIG% ) DO start Lib\wget.exe -nv -r -l %DEPTH% -p -H --delete-after -t %WGETRETRY% --random-wait -U %USERAGENT% -P %DLTEMP% %%I & Lib\Wait.exe %LOOPWAIT%
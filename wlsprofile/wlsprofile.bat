@ECHO off
@REM wlsprofile
@REM uses regedit.exe to generate multiple complete profiles for the BWCU
@REM Updated 2008-10-17


IF ERRORLEVEL 1 ECHO Unable to enable delayed expansion. Cannot continue. & EXIT 1

IF NOT EXIST Lib\sed.exe ECHO sed.exe could not be found. Cannot continue. & EXIT 1

:SETUP
SET REGTREE=HKEY_CURRENT_USER
SET BASEKEY=%REGTREE%\\Software\\Belkin\\BelkinWireless\\Profile
SET BASEPROFILE=%BASEKEY%\\wlsprofile
SET MAXPROFILE=1
SET CONFIG=Conf
SET TEMP=TEMP

SET /P MAXPROFILE=Enter in the number of profiles you wish to create (%MAXPROFILE%): 

ECHO Before continuing, Exit the Belkin Wireless utility.
PAUSE

IF NOT EXIST %TEMP% MKDIR %TEMP%

@REM Create a list of available config files
DIR /B "%CONFIG%" > "%TEMP%\CONFIG.LST"

@REM Add entries into the registry
SET i=0
:LOOP
FOR /F %%R IN ( %TEMP%\CONFIG.LST ) DO (
   SETLOCAL ENABLEDELAYEDEXPANSION
   ECHO %BASEPROFILE%%i% | Lib\sed.exe -T -e "s:\\\\:\\:g"
   TYPE Conf\%%R | Lib\sed.exe -T -e "s:#PROFILE#:%BASEPROFILE%!i!:g" -e "s:#SSID#:!i!:g" > "%TEMP%\PROFILE.REG"
   regedit.exe /S "%TEMP%\PROFILE.REG"
   SET /A i+=1
   IF %i% GTR %MAXPROFILE% GOTO ENDLOOP
)
IF NOT %i% GTR %MAXPROFILE% GOTO LOOP
:ENDLOOP

:END
ECHO DONE
ENDLOCAL
PAUSE
EXIT 0
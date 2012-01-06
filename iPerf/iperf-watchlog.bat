@ECHO off
@REM iperf-watchlog
@REM A helper script for iperf-client that updates the user on log activity
@REM Updated 2008-01-15

IF "%1"=="" ECHO USAGE: iperf-watchlog.bat "logfile" & pause & EXIT 1
IF NOT EXIST Lib\tail.exe ECHO tail.exe not found. Unable to continue & EXIT 1
IF NOT EXIST Lib\Wait.exe ECHO Wait.exe not found. iperf-watchlog may not function properly.

ECHO Watchlog started reporting from "%1"
Lib\Wait.exe 5
Lib\tail.exe -F "%1"
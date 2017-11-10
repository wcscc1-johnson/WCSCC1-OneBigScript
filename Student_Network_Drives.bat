@echo off
::
:: This script gets ran on every logon for every user:
::
:: IF the computer has an IP Address on the WiFi adapter withing our 10.21.0.0/16 Subnet:
::     Mount the Student's Network Drives.
::     Checks the see if the current logged in user is an Admin of the Local Computer. 
::     By Default, Azure AD allows the "@wcscc.net" user that enrolled the device into Azure AD the capabiltiy to Administer the Local Computer
::     In "1-1 Theory":
::         Only 1 user should always sign into the device. And that 1 user is the user that enrolled the device into Azure AD.
::         Therefor, The "Azure AD Device Owner" is an "Administrator" of the local machine.
::     IF the currently logged in user is not an Admin then
::         that person who just signed in is using a device that that person did NOT enroll into Azure. In other words, IT IS NOT THIER DEVICE
::         In this case, the Computer Name and Username gets logged to "\\wcscc-nas\Tech\1-1 Logs\Suspicious_Logins.csv"
::
:: IF the computer DOES NOT have IP Address on the WiFi adapter withing our 10.21.0.0/16 Subnet:
::     The Device is not connected to our network
::     Unmount the Student's Network Drives.
::     Exit the Sript.

setlocal EnableDelayedExpansion
FOR /F "TOKENS=2,3,4 eol=/ DELIMS=/ " %%A IN ('DATE/T') DO SET date=%%A/%%B/%%C
FOR /F "TOKENS=*" %%A IN ('TIME/T') DO SET time=%%A
for /f "tokens=3,4 delims=:. " %%a in ('netsh interface IPv4 show addresses "Wi-fi" ^| findstr /C:"IP Address"') do (set IP_Addy=%%a%%b)

NET USE K: /delete /YES
NET USE P: /delete /YES
NET USE U: /delete /YES

if %IP_Addy% NEQ 1021 EXIT

if %IP_Addy% == 1021 goto TenTwentyOne
:TenTwentyOne
set "cmd=net localgroup administrators | find /C /I "%username%""
for /f %%a in ('!cmd!') do set number=%%a
NET USE K: \\WCSCC-NAS\APPS /YES
NET USE P: \\WCSCC-data\Student-PUBLIC /YES
NET USE U: \\wcscc-data\students\%username% /YES
if %number% == 0 echo %date%,%time%,%computername%,%username% >> "\\10.21.15.113\E$\Tech\1-1 Logs\Suspicious_Logins.csv"
EXIT
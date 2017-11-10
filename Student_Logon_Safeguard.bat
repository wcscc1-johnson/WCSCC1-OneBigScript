@echo off
::
:: READ ME     READ ME     READ ME     READ ME     READ ME     READ ME     READ ME     READ ME     READ ME     
::
:: Purpose:
::   1.)  To catch a device where the "Student Account Setup" has been skipped.
::   2.)  To prevent students from having time to learn how to obtain Admin access across our Domain by looking at "One_Big_Script"
::
:: Info:
::     This Script Gets put in the "All Users Startup Folder" by "One_Big_Script" right after Azure Enrollment but before the student account gets signed in.
::     If this script is on a device, you can get to this folder by typing "shell:common startup" inside a "Run" box (Win + R)
::
:: How Does It Work?
:: -- notes a command in the script... The following line explains its functionality

::     This Script is used to count the NUMBER of times a student has logged into the device.
::     if the NUMBER reaches a value of 3 or more, the computer freezes with a prompt on the screen saying
::        If you are a student:
::        Your computer was not completely setup
::        Bring your computer up to the TRC so the IT Dept can finish the setup...
::
:: --  echo %ComputerName% %UserName% %date% %time% >> C:\Users\Public\Documents\LogonCount.txt
::          Adds 1 line to a local file "C:\Users\Public\Documents\LogonCount.txt"
:: --  for /f "tokens=4 delims=: " %%a in ('find /c /v "" C:\Users\Public\Documents\LogonCount.txt') do set numb=%%a
::          Counts the number of non empty lines in "C:\Users\Public\Documents\LogonCount.txt"
:: --  if %numb% GEQ 3 (
::          Executes all commands within the ( ) block.
:: --  echo commands
::     **NOTE** echos instructions to the command line before erroring out the script
:: --  C:\Users\Public\Documents\notmyfault64.exe /hang /accepteula
::              Hangs up the Computer for 10 - 15 seconds before a Blue Screen.
::
:: --  if %USERNAME%==WCSCC (
::         Executes all commands within the ( ) block.
:: --  del C:\Users\Public\Documents\LogonCount.txt
::         Remove the file that gets its lines counted. So you can log in as the student to Finish setting up thier account

if %USERNAME%==WCSCC (
del C:\Users\Public\Documents\LogonCount.txt
echo You can now sign back in as the student and try finishing the script!!!
echo 
echo.
type C:\Users\Public\Documents\UserAccount.txt
echo.
pause
shutdown -l
exit
)
echo %ComputerName% %UserName% %date% %time% >> C:\Users\Public\Documents\LogonCount.txt
for /f "tokens=4 delims=: " %%a in ('find /c /v "" C:\Users\Public\Documents\LogonCount.txt') do set numb=%%a

if %numb% GEQ 3 (
color e0
echo If you are a student:
echo Your computer was not completely setup
echo Bring your computer up to the TRC so the IT Dept can finish the setup...
echo.
echo.
echo.
echo If you are an IT Dept Worker:
echo Sign in as WCSCC then follow directions on screen...
echo.
C:\Users\Public\Documents\notmyfault64.exe /hang /accepteula
)
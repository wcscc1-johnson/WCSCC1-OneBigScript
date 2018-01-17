::            READ THIS ENTIRE COMMENT SECTION!
:: This is WCSCC's 1-1 image Script for "HPStream"
::
::
:: If the script is erroring out in a certain section, Look for that section in the script and read the comments to get an idea what is happening.
::
::
:: FULLY READ THE IMPORTANT SECTION BELOW!!!!!!!!!!!!!!!
:: THIS WILL HELP YOU UNDERSTAND THE ENTIRE SCRIPT
:: ***NOTE***  FILE NAMES AND PATHS ARE EXTREMELY IMPORTANT
::
:: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
:: IMPORTANT     IMPORTANT     IMPORTANT     IMPORTANT     IMPORTANT     IMPORTANT     IMPORTANT     IMPORTANT     IMPORTANT     
:: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
::
::
:: _________________________________________________________________________
:: V A R I A B L E S   U S E D   I N   T H I S   S C R I P T
::
:: This section refers to all variables that are created during this script, what their purpose is, and what section(s) they are assigned OR have had their value changed.
:: For the more important variables, more detail is discussed.
::
:: *******The most important variables are:********
:: "%Naming_file%"  ------  This refers to the centralized naming file that all devices running this script refer to. This file is used to verify that only 1 name exists for each device's MAC address 
::                     and that each particular generated hostname exists only once in the file.
::                     This variable is set in the :NameGenerate_Check section and is refered to in almost all sections after that until the **END OF THE FIRST BOOT!!!**
::                     Specifically it is refered to in the following sections:  :NameGenerate_Check, :NameGenerate_Check_No_Naming_File, :NameGenerate_Check_Create_Naming_File, :NameGenerate_Check_Error, :NameGenerate_Create_NewName, and :RenameComputer
::                     This variable refers (in this script) to the file "T:\1-1 Image Setup\HPStream_Name.csv" which maps to the full UNC path of "\\wcscc-nas\tech\1-1 Image Setup\HPStream_Name.csv"
::
:: %DeviceModel%  ---  This refers to the "base name" of the device. Meaning, this will be the first part of your auto-generated hostnames.
::                     This gets set at the "Top Of The Script" right after "@echo off" and is refered to in the sections :NameGenerate_Check_No_Naming_File, :NameGenerate_Check_Create_Naming_File, and :NameGenerate_Create_NewName
::
:: %NewName%  -------  This variable gets assigned the value that the device will use to rename itself. 
::                     This value gets set in the section :RenameComputer  and is refered to in the sections :RenameComputer and :RenameComputer_Error
::                     The line that matches this device's %MAC% gets pulled down from the "%Naming_file%" and is used to create the C:\Users\Public\Documents\MACcomputer.txt file.
::                     The C:\Users\Public\Documents\MACcomputer.txt file is used to assign the value of this variable
::
:: %MAC%  -----------  This refers to the "Wi-Fi" MAC Address of this device.
::                     This variable is set in the :MAC section and is refered to in the sections :NameGenerate_Check, :NameGenerate_Check_Error, and :NameGenerate_Create_NewName
::
:: %date%  ----------  Today's Date in the format mm/dd/yyyy
::                     This variable is set at the top of the script and is used at the :AssignedDeviceDocumentation section
::
:: %serial%  --------  Serial Number of this Device.
::                     This variable is set at the top of the script and is used at the :AssignedDeviceDocumentation section
::
:: 
::
:: %uname%  ---------  This variable refers to the user inputed value in the :Specific section
::                     It is used to find ONE student account in the C:\Users\Public\Documents\Student.csv file. The value %uname% is used to search through the 'Student.csv' file (counting the results... with 1 being the goal)
::                     It is posible to set this value to "1234" to manually specify Student credentials. This is useful in cases when the student info does not exist in the 'Student.csv' file.  Example, a new student enrolls mid-school year
::
:: ************************************************
::
::
:: OTHER not so widely used variables that are important and are created during this script are:
:: %compname%  ------  Used at the top of script. value is set to the first section of the %COMPUTERNAME% using the dash character "-" as a delimeter. Used to see if the computer is named "Generic-PC" or "Desktop-xxxxx"
:: %number%  --------  This variable gets created at multiple sections. Each section is independent of each other. I will describe the purpose of the %number% variable as it relates to each section.
::      :NameGenerate_Check   - -   Here, %number% is used to test the potential number of times the %MAC% was found in the "%Naming_file%"
::      :NameGenerate_Create_NewName   -    %number% value gets reset to the number of lines that are currently in the "%Naming_file%"
::      :RenameComputer  -    %Number2% value is the number of times the Hostname exists in the "%Naming_file%"
::      :Specific  - - - -    %number% value refers to the number of matches found for the %uname% variable in the C:\Users\Public\Documnts\Student.csv file.  this is used to "Specify" the "1" student to be used for the "1" device. hence, "one to one"
::      :AssignedDeviceDocumentation  -  Count of the number of devices previously assigned to a given student.
:: %full%  ----------  This variable refers to the line that will get added to the "%Naming_file%".  This line contains the hostname the device will use when being renamed.
::
:: V A R I A B L E S   U S E D   I N   T H I S   S C R I P T
:: _________________________________________________________________________
::
::
::
::
:: _________________________________________________________________________
:: C H A N G I N G    T H E    D E V I C E    M O D E L
::
:: In order to change this script for a new device, you need to do manually do the first 2 things and let the script take care of step 3.
:: 1.)   Replace all instances of "HPStream" with the new device name. Use "Control + H"   This will update the %DeviceModel% variable in the script.
::       This will be the first part of your new computer's automatically generated hostname. Followed by a 3 digit number  000  -  999 
:: 2.)   Save the NEWLY MODIFIED SCRIPT and change the file name accordingly meaning --->   (Remove "HPStream" and append the new device name)
:: 3.)   Create a blank .csv file... The script will give you an error upon first run for a new model asking you if you want the script to create the file!
::       See the (:NameGenerate_Check_No_Naming_File) portion of the script!
::
:: C H A N G I N G    T H E    D E V I C E    M O D E L
:: _________________________________________________________________________
::
::
:: _________________________________________________________________________
::      M A N U A L     C H A N G E S
::
:: It is NECESSARY to do the Following!!!!!!!!!
::
:: 1.)  If you are setting up a New Model... Not an "HPStream"...  Refer to "C H A N G I N G    T H E    D E V I C E    M O D E L"
::
:: 2.)  You MUST keep the Student.csv file in the folder "\\wcscc-nas\Tech\1-1 Image Setup\Public_Documents\" up-to-date with ALL of our Student's information
::      This means you will need to update the .csv file when a new student enrolls over the summer or throughout the year!
::      Otherwise, The script will not be able to enroll into Azure AD. Therefor, You can never complete the setup process via this script.
::      PLEASE NOTE!!  The Format of the Student.csv file MUST stay the same. This script pulls "cells" that are located in very particular positions.
::                     Meaning,  DO NOT move the coloumns around in the Student.csv Spreadsheet.
::      If you are trying to add a NEW STUDENT ACCOUNT INFORMATION to the spreadsheet, MAKE SURE TO FOLLOW THE FORMAT OF THE SPREADSHEET!
::      THE FORMAT OF THE   "Student.csv"   FILE IS...
::
::      StudentID Number,FirstName,LastName,Email Address,Username,Password,ProgramCode    
::
::      680111772,HUGO,AMEZCUA,16amehug@wcscc.net,16amehug,Fold@rep2,EXS2
::         Example ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::
::
:: 3.)  If you want to MODIFY THE SCRIPT and replicate it to all other devices, Place and Modify the script in the "\\wcscc-nas\Tech\1-1 Image Setup\Public_Documents\" folder
::
::
::      M A N U A L     C H A N G E S
:: _________________________________________________________________________
::
::
::
:: It is posible and NECESSARY to update the Student Account Information
:: This *Normally* can be found on the Staff intranet under Student Information --> Student Accounts-Username/Password
:: Over the Summer, the IT Dept supervisor, will have this for incoming Juniors
:: Download, MODIFY, and place the new .csv file on the "Tech" drive in the folder "\\wcscc-nas\Tech\1-1 Image Setup\Public_Documents\"
:: The CSV file MUST be named "Student.csv" see "::      M A N U A L     C H A N G E S"
:: The CSV file SHOULD contain an entry for the student you want to assign a device. Otherwise, you will have to type "1234" in the :Specific section to manually specify a student
::
:: It is also possible to update the Services_Install MSI Files. We may want to do this when Services_Install releases a new version.
:: Also, you can update the WCSCC_Student wireless profile. This MUST be done when we change the Student Wi-Fi password!!
::
:: \\WCSCC-NAS\Tech\1-1 Image Setup\Public_Documents\MobileFilterx64.msi  <<----   PLACE NEWER VERSION IN THIS LOCATION WITH THIS NAME
:: \\WCSCC-NAS\Tech\1-1 Image Setup\Public_Documents\LMA_Setupx64.msi     <<----   PLACE NEWER VERSION IN THIS LOCATION WITH THIS NAME
:: \\WCSCC-NAS\Tech\1-1 Image Setup\Public_Documents\Student.csv           <<----   PLACE NEW CSV IN THIS LOCATION CONTAINING UPDATED STUDENT ACCOUNTS
::      **NOTE** The most recent Student Accounts, can be found in Microsoft Online and on our Staff Intranet
::               Noted Above ^^^^^      Contact a supervisor (Cheryl) for more details.
:: \\WCSCC-NAS\Tech\1-1 Image Setup\Public_Documents\WCSCC_Student.xml            <<----   PLACE NEW WCSCC_Student.xml TO UPDATE WIFI PASSWORD TO CONNECT TO OUR NETWORK
::      **NOTE** To get updated WCSCC_Student.xml run this command from a privledged command prompt after you connect to the student wifi...
::               netsh wlan export profile key=clear
::
::
:: <<<<<<<---- SCRIPT REFERENCE FILES ---->>>>>>><<<<<<<---- SCRIPT REFERENCE FILES ---->>>>>>>
::
:: \\wcscc-nas\tech\1-1 Image Setup\HPStream_Name.csv            <<----   FOR RENAMING AND **OPTIONAL** FOG HOST REGISTRATION
:: \\wcscc-nas\tech\1-1 Image Setup\Live_Accounts.txt            <<----   FOR MONITORING DURING Azure Registraion and Next Login
:: \\WCSCC-NAS\Tech\1-1 Image Setup\%DeviceModel%_Assigned_Device.csv  <<----   FOR DOCUMENTATION OF WHAT DEVICE GETS ASSIGNED TO WHAT STUDENT.
::
:: <<<<<<<---- SCRIPT REFERENCE FILES ---->>>>>>><<<<<<<---- SCRIPT REFERENCE FILES ---->>>>>>>
::
:: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
:: IMPORTANT     IMPORTANT     IMPORTANT     IMPORTANT     IMPORTANT     IMPORTANT     IMPORTANT     IMPORTANT     IMPORTANT     
:: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
:: 
::
:: -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
:: F I L E   L I S T       LOCAL FILES
:: -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
::
::
:: Public Documents  --  N O T E --  This Folder gets pulled down from our Tech Drive in the (:Pull_Latest_Documents_Tech_Drive) section
:: C:\Users\Public\Documents\WCSCC_Student.xml      ----------   Export of our Student Wireless network profile
:: C:\Users\Public\Documents\logon.reg    --------------------   Disables Username Display at the login screen.
:: C:\Users\Public\Documents\win.reg      --------------------   Disables autologin and accepts Windows Media Player's EULA
:: C:\users\Public\Documents\MobileFilterx64.msi     ---------   Services_Install Mobile Filter Installer
:: C:\users\Public\Documents\LMA_Setupx64.msi     ------------   Services_Install Agent installer
:: C:\users\Public\Documents\AppAssoc.xml     ----------------   Sets Default App for .pdf files
:: C:\users\Public\Documents\Azure.ps1    --------------------   Powershell script that keeps the Azure AD database clean by deleting duplicate computer entries.
:: C:\users\Public\Documents\Office365.url    ----------------   This file gets move to the student's desktop after they sign in
:: C:\users\Public\Documents\OneDrive Tutorial Document.docx -   This file gets moved to the student's onedrive for business folder on the desktop after they sign in
:: C:\Users\Public\Documents\Student.csv   --------------------   This file gets pulled down A SECOND TIME at the top of the ":Passport" section... right before typing the student account info!
::  ^ ^ ^ ^ ^      I stress the importance of keeping this "Student.csv" file up to date at all times!!!!!!!!
:: ____________________________________________________________________________________________________________________________________________________________________________________________
::
:: Public Desktop
:: C:\Users\Public\Desktop\One_Big_Script_HPStream.bat      -----      This File!!!!  Where it should be located!
::
:: Made During The Script     ----    LOCAL FILES
:: C:\Users\Public\Documents\compname.txt          <<---- Used at the very top of the script for IF statement redirection
:: C:\Users\Public\Documents\uname.txt             <<---- One line for specified student. Pulled from C:\Users\Public\Documents\Student.csv in the ":Passport" section
:: C:\Users\Public\Documents\UserAccount.txt       <<---- Used during Azure Enrollment and Office 365 Setup. Contains Username and Password.
:: C:\Users\Public\Documents\MACcomputer.txt       <<---- One line from CSV file for generated hostnames.  Host is renamed based on this file!
:: C:\Users\Public\Documents\AzureADSearchResults.txt <<- See the last matches for Azure AD powershell cleanup script
:: C:\Users\Public\Documents\AzureADSearchString.txt  <<- See the last search string used in the last Azure AD powershell script
:: C:\users\public\documents\NameGenerate_Create_NewName_HasBeenRan.txt  <<-  Gets Created in the :NameGenerate_Create_NewName section. Used to automatically bypass the AzureAD script.
:: C:\Users\Public\Documents\AzureCompname.txt     <<---- Contains Hostname of the device. Used in the Azure.ps1 script
:: C:\users\public\documents\StudentEmail.txt      <<---- Contains the Email Address of the Student Account. Used to automatically Copy the Email for pasting purposes during Azure Enrollment and Office 365 setup.
:: C:\users\public\documents\StudentPassword.txt   <<---- Contains the Password of the Student Account. Used to automatically Copy the Email for pasting purposes during Azure Enrollment and Office 365 setup.
:: C:\Users\Public\Documents\AssignedDevice.txt    <<---- Contains all known devices that have previously been assigned to the Student.
:: C:\Users\Public\Documents\AssignedDevice_Count.txt <<- Counts the number of lines in C:\Users\Public\Documents\AssignedDevice.txt. Used to Auto-Increment the device signed out to the student.
:: C:\users\public\documents\Student_Assigned_MAC.txt <<- Finds the MAC address in C:\users\public\documents\Student_Assigned_MAC.txt. Used to see if the script needs to document this device (if it is new) or not? (if it is a reimage)
:: C:\users\public\documents\SIRSI_TAG.txt         <<---- Has the SIRSI Tag of the device...  You scan it during the :NameGenerate_Create_NewName Section


:Top_Of_The_Script
@echo off
::
:: Sets a few Global Variables.   date, MAC, serial, DeviceModel
::
::
:: Where should the script redirect you?
::    First boot  -- :Pull_Latest_Documents_Tech_Drive      if %USERNAME%==WCSCC goto Pull_Latest_Documents_Tech_Drive
::    Second boot -- :PASSPORT        if %compname% NEQ GENERIC  (  if %USERNAME%==WCSCC goto PASSPORT  ))
::    Third boot  -- :Office_Setup    all "if" statements were false.
::
echo :Top_Of_The_Script
FOR /F "TOKENS=2,3,4 eol=/ DELIMS=/ " %%A IN ('DATE/T') DO SET date=%%A/%%B/%%C
echo %date%
set C_Pub_Docs=C:\users\public\Documents\
set "Naming_File=T:\1-1 Image Setup\HPStream_Name.csv"
set "SN_File=T:\1-1 Image Setup\HPStream_SerialNumber.csv"
setlocal EnableDelayedExpansion
for /f "usebackq tokens=3 delims=," %%a in (`getmac /fo csv /v ^| find "Wi-Fi"`) do set MAC=%%~a
echo %MAC%
set torun=wmic bios get serialnumber /format:value
for /f "tokens=2 delims==" %%a in ('%torun%') do set serial=%%a
echo %serial%
set DeviceModel=HPStream
:: Moves script to Public Desktop
if EXIST "C:\users\%USERNAME%\Desktop\One_Big_Script_%DeviceModel%.bat" (
move "C:\users\%USERNAME%\Desktop\One_Big_Script_%DeviceModel%.bat" C:\users\public\desktop\ && C:\users\public\Desktop\One_Big_Script_%DeviceModel%.bat
)
echo.
echo Here We Go!
net accounts /maxpwage:unlimited
if %errorlevel% NEQ 0 goto No_Admin_Rights
call :TechDrive_Script_and_Documents_Updater_Checker

:: Dont Skip over This Line
if EXIST "C:\users\%USERNAME%\Desktop\OneDrive - Wayne County Schools Career Center\OneDrive Tutorial Document.*" goto LGPO
:: Dont Skip over This Line
echo %COMPUTERNAME% > %C_Pub_Docs%compname.txt
for /f "delims=- tokens=1" %%g in ( %C_Pub_Docs%compname.txt ) do (echo %%g)
for /f "delims=- tokens=1" %%g in ( %C_Pub_Docs%compname.txt ) do (set compname=%%g)
del %C_Pub_Docs%compname.txt
if %USERNAME%==Administrator goto createwcscc

:: Second Boot     --------  Computer will be named HPStreamxxx and WCSCC will be the logged in user.  goto :PASSPORT
if %compname% NEQ GENERIC  (
if %compname% NEQ DESKTOP  (
if %USERNAME%==WCSCC goto PASSPORT
)
)

::    First boot   --------  Computer name starts with "Generic" or "Desktop" and "WCSCC" is signed in. goto :WCSCC_Student_and_Power_Settings
if %USERNAME%==WCSCC goto WCSCC_Student_and_Power_Settings

::  Third boot     --------  %USERNAME% is not WCSCC making the above conditions false. You are signed in as a student!
goto Office_Setup



:No_Admin_Rights
color e0
cls
echo :No_Admin_Rights
echo. 
echo RUN THE SCRIPT WITH ADMIN PRIVLEGES!!!!
echo.
echo.
pause
exit


:Pull_Latest_Documents_Tech_Drive
@echo off
:: :TechDrive_Script_and_Documents_Updater_Checker redirected you here!
:: Goes back to :TechDrive_Script_and_Documents_Updater_Checker after this section completes SUCCESSFULLY!!  <- key word...
::
:: Pulls down everything in the Public_Documents folder
:: If above was sucessful, goto WCSCC_Student_and_Power_Settings. If above failed, goto No_Network_Connection and give an error about the Network Connection
cls
echo :Pull_Latest_Documents_Tech_Drive
echo.
xcopy Public_Documents\* %C_Pub_Docs% /Y
IF %ERRORLEVEL% == 1 goto No_Network_Connection
goto :eof



:TechDrive_Script_and_Documents_Updater_Checker
@echo off
:: Checks to see if the One_Big_Script.bat needs to be updated and replaced
echo Checks to see if the One_Big_Script.bat needs to be updated and replaced
echo :TechDrive_Script_and_Documents_Updater_Checker
echo.
NET USE T: "\\wcscc-nas\TECH" /USER:wcscc1\foggy yggofthefrog
timeout /nobreak 2
net time \\wcscc-nas /set /Y
IF %ERRORLEVEL% == 2 goto No_Network_Connection
echo.
T:
cd "/1-1 Image Setup"
timeout /nobreak 5
:: Creates 2 text files. one is the directory of Public_Documents on the Tech Drive. The other is directory of the C:\Users\Public\Documents\ folder
:: "fc" makes sure the directories are the same...
:: Note: any change to the files size or contents will cause "fc" to recopy all of the documents in the "\\wcscc-nas\1-1 Image Setup\Public_Documents" folder down to the C: Drive
cls
if exist %C_Pub_Docs%Listing_Of_Tech_Drive_PublicDocuments.txt move /Y %C_Pub_Docs%Listing_Of_Tech_Drive_PublicDocuments.txt %C_Pub_Docs%Listing_Of_C_Drive_PublicDocuments.txt
dir "T:\1-1 Image Setup\Public_Documents" /O:N | find /V "bytes" | find /V "Volume " | find /V "Directory of " | findstr /B /R /V ^$ > %C_Pub_Docs%Listing_Of_Tech_Drive_PublicDocuments.txt
timeout 1
fc %C_Pub_Docs%Listing_Of_Tech_Drive_PublicDocuments.txt %C_Pub_Docs%Listing_Of_C_Drive_PublicDocuments.txt >nul
echo %errorlevel%         0 All Documents on Tech Drive are the same
echo           1 Documents on Tech Drive are newer.
echo           2 Documents have not been pulled down from the Tech Drive yet.
if %errorlevel% == 1 (
call :Pull_Latest_Documents_Tech_Drive
)
if %errorlevel% == 2 (
call :Pull_Latest_Documents_Tech_Drive
)
echo.
echo Does the One_Big_Script need to be updated???   %errorlevel%      0 No    1 Yes       2 Doesnt Exist
echo.
fc C:\Users\Public\Desktop\One_Big_Script_%DeviceModel%.bat "T:\1-1 Image Setup\Public_Documents\One_Big_Script_%DeviceModel%.bat" >nul
if %errorlevel% == 0 goto :eof
if %errorlevel% == 2 goto :eof
if %errorlevel% == 1 (
copy /Y "T:\1-1 Image Setup\Public_Documents\One_Big_Script_%DeviceModel%.bat" C:\Users\Public\Desktop\ && C:\users\public\Desktop\One_Big_Script_%DeviceModel%.bat
goto Top_Of_The_Script
)






:No_Network_Connection
:: :TechDrive_Script_and_Documents_Updater_Checker, :LGPO, or :Pull_Latest_Documents_Tech_Drive redirected you here!
::
:: This error is a result from the script not being able to talk to our \\wcscc-nas server.   "ping 10.21.15.113" to see if the server is up...
:: To fix this, plug in a ethernet cable or add the device to wifi
::
cls
color e0
echo :No_Network_Connection
echo.
echo.
echo Plug in a Network Cable
echo.
echo.
pause
exit



:WCSCC_Student_and_Power_Settings
:: :Pull_Latest_Documents_Tech_Drive redirected you here!
::
::  Adding and connecting Student Wifi
::
cls
echo :WCSCC_Student_and_Power_Settings
echo.
netsh wlan add profile filename="%C_Pub_Docs%WCSCC_Student.xml"
timeout /t 4
netsh wlan connect name=WCSCC_Student
timeout /t 4
tzutil /s "Eastern Standard Time"




::  *************************  START OF THE NAME GENERATION PROCESS *******************************
::  ***********************************************************************************************
:NameGenerate_Check
:: :NameGenerate_Check follows :TechDrive   also this section is redirected to (WITH GOOD REASON) from :NameGenerate_Check_No_Naming_File, :NameGenerate_Create_NewName, and :NameGenerate_Check_Create_Naming_File
:: ALL OF THE "NAME GENERATE" SECTIONS focus on the task of --- locating the name for this device or creating a unique name for this device!
::
:: This section in particular looks for the MAC address in a centralized naming file on the Tech drive.
:: based on the number of matches found for the MAC address determines where the if statements will redirect the script
::
::  If statement conditions for Automatically Generating Hostnames follows.
::    %number%==0     If MAC Addy is not in CSV file goto NameGenerate_Create_NewName              to create a unique hostname.
::    %number%==1     If MAC exists once it will goto RenameComputer                 to actually change the hostname and Reboot
::    %number% GEQ 2  If MAC exists more than once it will goto NameGenerate_Check_Error   Should never ever happen!
::  Set File Variable Naming_File
::
T:
cd "/1-1 Image Setup"
cls
echo :NameGenerate_Check
call :First_Boot_User_Script_Additions
echo :NameGenerate_Check
color 07
:: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
IF NOT EXIST "%Naming_file%" goto NameGenerate_Check_No_Naming_File
:: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
:: Searches for the MAC Address  %MAC%  in the Naming File  "%Naming_file%"      Sets a variable %number% equal to the result
set "MAC_Count=findstr /R /N "^^" "%Naming_file%" | find /C "%MAC%""
for /f %%a in ('!MAC_Count!') do set number=%%a
findstr /R "%MAC%" "%Naming_file%" > %C_Pub_Docs%MACcomputer.txt
echo.
echo %number% matches for %MAC% found in "%Naming_file%"
echo.
if %number%==0 goto NameGenerate_Create_NewName
if %number%==1 echo FOUND 1 MATCH FOR THE MAC ADDRESS      GOOD!!!
if %number%==1 goto RenameComputer
if %number% GEQ 2 goto NameGenerate_Check_Error





:NameGenerate_Check_No_Naming_File
:: :NameGenerate_Check redirected you here!         **NOTE**  "%Naming_file%" was assigned in :NameGenerate_Check section
::
:: the script could not see the centralized naming file ("%Naming_file%")
:: the script then waits 20 seconds to make sure the computer has had sufficent time to connect to \\wcscc-nas     timeout /nobreak 20
:: if the script sees the "%Naming_file%" go back to the main section :NameGenerate_Check     IF EXIST "%Naming_file%" goto NameGenerate_Check
:: if the script still cant see the "%Naming_file%"  prompt for creation.               choice /c YNE /M "Do you want to create a blank %DeviceModel%_Name.csv file?     Yes, No, Exit"
::
:: After this process, the script will go back to :NameGenerate_Check or will exit if you choose to.
cls
echo :NameGenerate_Check_No_Naming_File
color e0
echo Could not find the "%Naming_file%" file
echo   Waiting 20 seconds to retry
echo   Will prompt for creation if no file exists
echo.
timeout /nobreak 20
T:
cd "/1-1 Image Setup"
cls
echo ************************************************************
echo ***********************CAREFUL******************************
echo ************************************************************
echo.
echo You can accedenntally overwrite the current naming file if you choose "Y"
echo **NOTE** ONLY CHOOSE "Y" if this is a new model / first run of a new naming convw
echo          If this model has been imaged before, a File should exist!
echo.
echo Select "C" to Check to see if the naming file exists again.
echo.
echo ************************************************************
echo ***********************CAREFUL******************************
echo ************************************************************
IF EXIST "%Naming_file%" goto NameGenerate_Check
echo.
echo.
echo Here is a list of all 1-1 device Name files.
dir *_Name.csv
echo.
echo MAKE SURE THE MAC FILE DOES NOT EXIST BEFORE SELECTING    "Y"
echo.
choice /c YCE /M "Do you want to create a blank %DeviceModel%_Name.csv file?     Yes, Check Again, Exit"
IF %ERRORLEVEL% == 1 goto NameGenerate_Check_Create_Naming_File
IF %ERRORLEVEL% == 2 goto NameGenerate_Check
IF %ERRORLEVEL% == 3 exit
pause
goto NameGenerate_Check






:NameGenerate_Check_Create_Naming_File
:: :NameGenerate_Check_No_Naming_File redirected you here!
::
:: The script has now went through a few checks and timers to make sure the "%Naming_file%" really doesn't exist.
:: The goal is to create a blank Naming_File to be used as a central location for the name generation process.
::
:: After this, it will send you back to the :NameGenerate_Check section to make the first entry in the newly created "%Naming_file%"
:: **NOTE**  %DeviceModel% was assigned right after "@echo off" at the top of the script
::
cls
color 07
echo.
echo.
echo.
echo :NameGenerate_Check_Create_Naming_File
echo.
echo.
copy Blank_Dont_Touch.csv %DeviceModel%_Name.csv
goto NameGenerate_Check






:NameGenerate_Check_Error
:: :NameGenerate redirected you here!      This Should NEVER happen.
:: If it does, follow the directions on the screen.
:: Manually assign the hostname for the device.
::
cls
color 1f
echo :NameGenerate_Check_Error     Play_Error
echo More than one instance of %MAC% in Hostname File
pause
echo.
echo.
echo ERROR
echo.
echo We found %number% results for the MAC Address
echo There should only be 1 result
echo Search for the MAC Address %MAC% in the file "%Naming_file%" in the folder
echo \\wcscc-nas\TECH\1-1 Image Setup\
echo.
echo.
echo -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
echo The FOLLOWING is EXTREMELY IMPORTANT!!!!!
echo -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
echo.
echo Manually assign Hostname to the latest instance of the MAC address. 
echo.
echo                        %MAC%
echo.
echo.
findstr /R "%MAC%" "%Naming_file%"
echo.
echo        DONT DELETE DUPLICATE LINES IN "%Naming_file%"
echo        DELETING LINES IN THAT FILE WILL CAUSE ISSUES
echo.
echo -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
echo The ABOVE is EXTREMELY IMPORTANT!!!!!
echo -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
notepad.exe "%Naming_file%"
SystemPropertiesComputerName
pause
exit





:NameGenerate_Create_NewName
:: :NameGenerate_Check redirected you here!     This is where the magic happens. 
:: This section generates a hostname that is unique for this host!
::  
:: The unique name is generated by counting the number of lines in the centralized naming file "%Naming_file%" and then adding 1 to it.
:: If that number is less than 100, add a leading "0"   This is the %FZ% variable
:: If that number is less than 10, add a leading "0"   This is the %SZ% variable       Resulting in a name like HPStream003, HPStream026, or HPStream279
:: 
:: After this process, go back up to :NameGenerate_Check section to retest the conditions. The :NameGenerate_Check section should now find 1 match. (Created in this section)
:: It will endlessly loop if the script tries to add a line to the "%Naming_file%" and the "%Naming_file%" is open in another program...  Most Likely EXCEL Spreadsheets
cls
echo :NameGenerate_Create_NewName
echo.
echo If you miss-type the Sirsi Tag, You MUST close the script and rerun...
echo.
set sirsi=No_Tag_Specified
set /p sirsi="Scan or Type the Sirsi Tag that is on the Device:   
if %sirsi%==No_Tag_Specified echo Please Scan the SIRSI Tag!!!!!!
if %sirsi%==No_Tag_Specified goto NameGenerate_Create_NewName
echo %sirsi%> %C_Pub_Docs%SIRSI_TAG.txt
set comma=,
set fog=,,,9,14
for /f "usebackq tokens=3 delims=," %%a in (`getmac /fo csv /v ^| find "Wi-Fi"`) do set MAC=%%~a
set "cmd=findstr /R /N "^^" "%Naming_file%" | find /C ":""
for /f %%a in ('!cmd!') do set number=%%a
set /a numb=%number%+1
If %numb% LEQ 99 set /a FZ=0
If %numb% LEQ 9 set /a SZ=0
set full=%MAC%%comma%%DeviceModel%%FZ%%SZ%%numb%%fog%
echo %full%>> "%Naming_file%"
echo YES, This is the first time ever running the script on this device... > %C_Pub_Docs%NameGenerate_Create_NewName_HasBeenRan.txt
cls
echo %full%
echo.
echo.
goto NameGenerate_Check
::  **************************  END OF THE NAME GENERATION PROCESS  *******************************
::  ***********************************************************************************************







::  *************************  START OF THE DEVICE RENAMING PROCESS *******************************
::  ***********************************************************************************************
:RenameComputer
:: :NameGenerate_Check redirected you here.     This section retests the "%Naming_file%" to make sure only 1 entry exists for the hostname 
:: This section is very important because... When running this script on multiple new devices at the same when all devices are appending the "%Naming_file%" at the same time.
:: there is a chance that two devices will count the # of lines of the "%Naming_file%" at the same time and consequently get the same name.
:: 
:: This section waits 10 seconds to allow all devices running the script (that may potentially have the same hostname) to have time to finish appending the "%Naming_file%"
:: The "if statements" test the %number2% value to make sure this computer doesnt get the same name as another device.
::   if %number2%==1  goto RenameComputer2  ----------   The computer is allowed to rename because only 1 entry for that specific HOSTNAME exists in the "%Naming_file%"
::   if %number2% NEQ 1 goto RenameComputer_Error  ---   The computer is NOT allowed to rename. multiple entries exist for that specific HOSTNAME exists in the "%Naming_file%"
::
cls
echo :RenameComputer
echo.
dism /online /Import-DefaultAppAssociations:%C_Pub_Docs%AppAssoc.xml
timeout /t 5
echo.
for /f "delims=, tokens=2" %%g in (%C_Pub_Docs%MACcomputer.txt ) do (echo %%g)
for /f "delims=, tokens=2" %%g in (%C_Pub_Docs%MACcomputer.txt ) do (set NewName=%%g)
set "MAC_Count2=findstr /R /N "^^" "%Naming_file%" | find /C "%NewName%""
for /f %%a in ('!MAC_Count2!') do set number2=%%a
findstr /R "%NewName%" "%Naming_file%"
echo %number2% matches for %NewName% found in "%Naming_file%"
echo.
if %number2%==1 echo FOUND 1 MATCH FOR THE HOSTNAME      GOOD!!!
if %number2%==1 goto RenameComputer2
if %number2% NEQ 1 goto RenameComputer_Error




:RenameComputer2
:: :RenameComputer redirected you here.
::
:: This section actually renames the computer and then restarts with a 10 second timer!
::
cls
echo :RenameComputer2
wmic computersystem where caption='%COMPUTERNAME%' call rename '%NewName%' >nul
echo.
echo.
echo.
echo OLD NAME --------- %COMPUTERNAME%  
echo NEW NAME --------- %NewName%
echo.
echo "The PC will restart to change its name."
echo Import Hosts into FOG Server (if needed)
shutdown -r -t 10 -c "RESTARTING...         %COMPUTERNAME%   will become   %NewName%"
pause
exit



:RenameComputer_Error
:: :RenameComputer redirected you here.
::
:: This happens when more than one line in the "%Naming_file%" contains %NewName%      Preventing 2 or more devices from renaming to the same name is VERY IMPORTANT.
:: This section instructs the user to stop running the script on ALL DEVICES and then MANUALLY change the inappropriate numbering in the "%Naming_file%"
::
color e0
cls
timeout /t 2
cls
echo :RenameComputer_Error
echo.
echo.
findstr /R "%NewName%" "%Naming_file%"
echo.
echo %number2% matches for %NewName% found in "%Naming_file%"
echo.
echo You will need to manually correct the numbering in "%Naming_file%"
echo After you make the appropriate numbering change,
echo save the "%Naming_file%" and resume this script!
echo.
echo -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
echo The FOLLOWING is EXTREMELY IMPORTANT!!!!!
echo -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
echo.
echo Have EVERYONE STOP running this script before unpausing 5 Times
echo on this device to manually edit this Hostname File!!!!!!!
echo.
echo THIS IS WHAT IS IN THE HOSTNAME FILE...
findstr /R "%NewName%" "%Naming_file%"
echo.
echo Search for    %NewName%   and manually correct the numbering!!!!!!!
echo.
echo  BE SURE TO SAVE THE FILE AFTER EDITING!!!!!!!!!!!!!!!!!!!!!!!!
echo.
echo -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
echo The ABOVE is EXTREMELY IMPORTANT!!!!!
echo -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
pause
echo 4     Has The Script stopped on all devices?????
pause
echo 3     The Script needs to be stopped on all devices!!!!!
pause
echo 2     OK  !!!!!!!
pause
echo 1     Last pause.
pause
notepad.exe "%Naming_file%"
pause
pause
color 07
goto NameGenerate_Check
::  **************************  END OF THE DEVICE RENAMING PROCESS  *******************************
::  ***********************************************************************************************

::  ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** *******
::  ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** *******
::           END OF THE FIRST BOOT!!!    The Main Goal was to generate a unique hostname and rename the device! 
::  ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** *******
::  ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** *******

:: #######################################################################################################################
:: #######################################################################################################################
:: #######################################################################################################################
:: #######################################################################################################################
:: #######################################################################################################################
:: #######################################################################################################################
:: #######################################################################################################################
:: #######################################################################################################################
:: #######################################################################################################################

::  ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** *******
::  ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** *******
:: START OF THE SECOND BOOT     The Main Goal is to assign the device to one student, hence "one to one", and enroll into Azure AD.
::  ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** *******
::  ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** *******

:PASSPORT
:: if statements at the "Top Of The Script" redirected you here.
::
:: Disabling Username Display, disable autologin of WCSCC, imports default application to extension mappings for new users.
:: Provides instructions to monitor student account information Live using a Linux laptop.
::
cls
echo :PASSPORT
echo.
echo Taking Care of a few things...
echo.
echo  IMPORTANT   IMPORTANT    IMPORTANT   IMPORTANT    IMPORTANT   IMPORTANT    IMPORTANT   IMPORTANT
echo     Copies the file Student.csv in the folder "\\wcscc-nas\Tech\1-1 Image Setup\Public_Documents"
echo     KEEP THIS "Student.csv" file updated with the latest Student Information!!!!!!!!!!!!!!!!!!!!!!
echo  IMPORTANT   IMPORTANT    IMPORTANT   IMPORTANT    IMPORTANT   IMPORTANT    IMPORTANT   IMPORTANT
echo.
echo.
echo.
:: Gets Latest "Student.csv" file for Student Account lookup.
timeout /t 1
cd Public_Documents
copy Student.csv %C_Pub_Docs% /Y
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v dontdisplaylastusername /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\Recommended" /v ShowHomeButton /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v ForceBrowserSignin /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v RestrictSigninToPattern /t REG_SZ /d "*@wcscc.net" /f
REG ADD "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 0 /f
regedit /s %C_Pub_Docs%logon.reg
regedit /s %C_Pub_Docs%win.reg
echo %COMPUTERNAME%> %C_Pub_Docs%AzureCompname.txt
cls
echo.
if %USERNAME%==Administrator goto createwcscc
echo The current login is %USERNAME%
echo.
echo.
del %C_Pub_Docs%UserAccount.txt
cls
echo FOR THE NEXT STEP IF YOU ARE DOING MULTIPLE MACHINES,
echo You may want to monitor the file live using Ubuntu
echo   If so do the following BEFORE HAND on an Ubuntu laptop
echo   CONNECT TO WIFI FIRST!!!!!!
echo **NOTE**   sudo password is the Ubuntu login password
echo.
echo   sudo apt-get install cifs-utils    
echo   sudo mkdir /mnt/tech
echo   sudo mount.cifs //wcscc-nas/Tech /mnt/tech -o user=foggy
echo                 **NOTE**  password for foggy is      yggofthefrog
echo   cd /mnt/tech
echo   cd 1-1       press tab to autocomplete
echo   ls           "LS"   see files to make sure
echo   tail -f Live_Accounts.txt
echo.
setlocal EnableDelayedExpansion




:Specific
:: Follows :PASSPORT but can also be redirected to by :GoodStudentAsk, :ManStudAdd, or :Specific
::
:: This section searches for the user inputted value %uname% inside of the C:\Users\Public\Student.csv file counting the matching lines.
:: If %uname% is found 0 or more than 1 times, loop back to the top of :Specific to get a new user defined %uname% value
:: If %uname% is found exactly 1 time, goto :GoodStudentAsk    to make sure it found the correct student...
:: If %uname% set to the value "1234", goto :ManStudAdd    to manually specify student account login information.
::
echo :Specific
echo Find Student Account in C:\Users\Public\Documents\Student.csv
echo ---------FOR MANUAL ENTRY TYPE "1234"-----------
echo.
set uname=No_Search_String_Specified
set /p uname="type the username for student:   
if %uname%==No_Search_String_Specified echo Please Specify a Search String!!!!!!
if %uname%==No_Search_String_Specified goto Specific
if %uname% == 1234 echo Manual Entry Selected
if %uname% == 1234 goto ManStudAdd
findstr /I "%uname%" %C_Pub_Docs%Student.csv > %C_Pub_Docs%uname.txt
cls
set "cmd=FINDSTR /R /N "^.*" %C_Pub_Docs%uname.txt | find /c ":""
for /f %%a in ('!cmd!') do set number=%%a
echo %number%
if %number% EQU 1 goto GoodStudentAsk
cls
echo Found %number% results
echo.
for /f "delims=, tokens=2,3,4,7" %%g in ( %C_Pub_Docs%uname.txt ) do (echo %%j   %%i    %%g  %%h )
echo.
echo Search String == %uname%
echo There should be only one result
echo.
echo Please look at the output for the correct student and
echo be more specific with the Search String. You Can Do This By...
echo copying the Email Address from the output above. If it was listed.
echo.
echo ALSO, Make sure the Student.csv file contains the latest student info
echo You can place the Newest "Student.csv" file on the Desktop.
echo **NOTE** Must contain that name ^^ exactly   "Student.csv"
echo          You will need to close this script to see new .csv file
echo.
echo  MORE INFO ON HOW TO GET THE UPDATED CSV FILE IN THE "IMPORTANT"
echo  SECTION AT THE TOP OF SCRIPT.
echo.
if %number% NEQ 1 goto Specific
echo.
echo.



:GoodStudentAsk
:: :Specific redirected you here.
::
:: This section will prompt you "Is this the right student?"   and will display the student's First and Last name  followed by the program they are enrolled in.
::    Answering y will goto :GoodStudentYes
::    Answering n will goto :Specific
::
cls
echo :GoodStudentAsk
echo.
for /f "delims=, tokens=2,3,7" %%g in ( %C_Pub_Docs%uname.txt ) do (echo %%g %%h    in %%i)
choice /c YN /M "Is this the right student?"
IF %ERRORLEVEL% == 1 goto GoodStudentYes
IF %ERRORLEVEL% == 2 goto Specific




:GoodStudentYes
:: :GoodStudentAsk redirected you here.     You verified that was the correct student...
::
:: This section creates a local file "C:\users\Public\Documents\UserAccount.txt" that will be used to allow copying and pasting student credentials for Azure AD enrollment and Office365 setup procedure.
:: This section also appends the file "Live_Accounts.txt" that you can monitor live using a linux laptop to view student login credentials for when this computer reboots.
::
cls
call :Second_Boot_User_Script_Additions
cls
echo :GoodStudentYes
echo.
echo.
for /f "delims=, tokens=2,3,4,6" %%g in ( %C_Pub_Docs%uname.txt ) do (echo %%g %%h ) > %C_Pub_Docs%UserAccount.txt
echo. >> %C_Pub_Docs%UserAccount.txt
for /f "delims=, tokens=2,3,4,6" %%g in ( %C_Pub_Docs%uname.txt ) do (echo %%i) >> %C_Pub_Docs%UserAccount.txt
for /f "delims=, tokens=2,3,4,6" %%g in ( %C_Pub_Docs%uname.txt ) do (set studentemail=%%i)
for /f "delims=, tokens=2,3,4,6" %%g in ( %C_Pub_Docs%uname.txt ) do (set studentpassword=%%j)
for /f "delims=, tokens=2,3,4,6" %%g in ( %C_Pub_Docs%uname.txt ) do (echo %%g %%h) > %C_Pub_Docs%varuser.csv
echo. >> %C_Pub_Docs%UserAccount.txt
for /f "delims=, tokens=2,3,4,6" %%g in ( %C_Pub_Docs%uname.txt ) do (echo %%j) >> %C_Pub_Docs%UserAccount.txt
echo. >> %C_Pub_Docs%UserAccount.txt
for /f "delims=, tokens=5" %%g in ( %C_Pub_Docs%uname.txt ) do (set studentname=%%g) >> %C_Pub_Docs%UserAccount.txt
echo https://wcscc-my.sharepoint.com/personal/%studentname%_wcscc_net/_layouts/15/onedrive.aspx >> %C_Pub_Docs%UserAccount.txt
for /f "delims=, tokens=2,3,4,6" %%g in ( %C_Pub_Docs%uname.txt ) do (echo %COMPUTERNAME%  --  %%i  %%j  --  %%g %%h ) >> "T:\1-1 Image Setup\Live_Accounts.txt"
echo. >> "T:\1-1 Image Setup\Live_Accounts.txt"
echo %studentemail%>%C_Pub_Docs%StudentEmail.txt
echo %studentpassword%>%C_Pub_Docs%StudentPassword.txt
clip < %C_Pub_Docs%StudentEmail.txt




:: Azure AD Logic Structures
:: Tests to see if the Azure AD Powershell script has been ran before
if EXIST %C_Pub_Docs%AzureADSearchString.txt goto AzureADScriptSecondRun
:: Tests to see if the NameGenerate_Create_NewName has been ran to generate a hostname
if EXIST %C_Pub_Docs%NameGenerate_Create_NewName_HasBeenRan.txt goto AzureADScriptBypass
if NOT EXIST %C_Pub_Docs%NameGenerate_Create_NewName_HasBeenRan.txt goto AzureADScript


:AzureADScript
:: This section follows :GoodStudentYes  
::
:: This section will execute the powershell script to clean up the Azure AD database prior to enrolling this device into Azure.
:: **NOTE**  The powershell script gives you the option Y or N to decide whether or not to delete the entries.  In most circumstances, Y is the right option because in "one to one", 1 and only 1 device SHOULD be assigned to each student. 
:: After choosing whether or not to remove the entries in the Azure AD Database, the script will open up the screen to join the device into Azure AD and will open
::
::
echo :AzureADScript
echo.
echo ARE YOU 100 PERCENT SURE THIS IS THE COMPUTER FOR THE CORRECT STUDENT?????
echo IF YOU ARE NOT, CLOSE THE SCRIPT NOW AND SPECIFY A NEW STUDENT NEXT RUN
echo.
echo.
echo UNPAUSING NOW WILL PROMPT TO DELETE ALL INSTANCES OF %COMPUTERNAME% FROM AZURE AD
echo AND WILL PROMPT TO DELETE ALL COMPUTERS ASSIGNED TO %studentemail% FROM AZURE AD
echo.
color 1f
pause
pause
color 07
cls
echo Running Powershell Script to clean up Azure AD.
echo This will take a minute.
echo.
echo This will list ALL computers currently registered in Azure AD as the student
echo AND will list ALL computers with the name %COMPUTERNAME% in Azure AD
echo.
echo.
echo.
echo **NOTE**
echo You can choose whether or not to remove all entries.
echo Most of the time, Y is the right option because of the idea of 1-1
echo 1 laptop assigned to 1 student...
echo.
echo.
echo.
powershell Set-ExecutionPolicy Unrestricted
powershell %C_Pub_Docs%Azure.ps1
powershell Set-ExecutionPolicy restricted

:AzureADScriptBypass
:: Bypass section called by :AzureADScriptSecondRun or is ran sequencially after :AzureADScript
:: This section is so you dont have to wait for the Powershell "Azure.ps1" script
:: Removes Student.csv before restarting... So it doesn't end up in students hands
cls
color 0a
echo :AzureADScriptBypass
echo.
echo.
echo NOTE...    The Students Email is already copied...
echo            Unpause a second time to copy the Students Password
echo  OR,       Manually copy and paste from the text file...
echo.
echo ENROLL DEVICE IN AZURE AD!
echo     1.)  Click   "Connect"
echo     2.)  Click "Join this device to Azure AD"
echo     3.)  Join using the students credentials
echo.
echo UNPAUSE TWICE TO COPY THE STUDENTS PASSWORD
echo.
echo  #####  ALT + TAB  #####  --- for quick switching between windows.
start /min %C_Pub_Docs%UserAccount.txt
start ms-settings:workplace
pause
pause
clip < %C_Pub_Docs%StudentPassword.txt
echo.
echo.
echo PASSWORD   COPIED
echo FINISH AZURE ENROLLMENT
echo UNPAUSE TWICE TO RESTART THE DEVICE.
pause
pause
:: Makes sure the Whole Student.csv Spreadsheet is not on the local computer... 
:: In case we "skip" a device over the Summer and give the device to the student without finishing the Office/Google/Onedrive setup. 
:: The student cant see other student's credentials
del /s /q %C_Pub_Docs%Student.csv
:: Reg Add ...   makes sure the "Windows Hello PIN setup doesn't prompt on first student login"
reg ADD HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\PassportForWork /v Enabled /t REG_DWORD /d 0 /f
:: Logon_Safeguard is Not used yet... The idea is to count the number of times the student logs into a device... 
:: If the number reaches 3 or 4, Crash / Hang the computer if the One_Big_Script still exists on the desktop... Also display a message like "Bring your computer in for repair!!!"
copy %C_Pub_Docs%Student_Logon_Safeguard.bat "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
shutdown -r -t 15 -c "Sign In As The Student.  Login info is on T:\1-1 image setup\Live_Accounts.txt"
pause
exit



:AzureADScriptSecondRun
:: Redirected by the IF statement...      if EXIST %C_Pub_Docs%AzureADSearchString.txt goto AzureADScriptSecondRun
:: This is to allow for the rerun of the PowerShell script with newly defined search strings.
::
cls
echo :AzureADScriptSecondRun
echo.
echo READ EVERYTHING IN THIS SECTION!!
echo.
echo CAUTION!!!!!!! YOU ARE RERUNNING THE SCRIPT
echo.
echo There are only 2 good reasons to rerun the script...
echo YOU ARE EITHER RERUNNING THE SCRIPT BECAUSE YOU SELECTED THE WRONG STUDENT THE FIRST TIME
echo    ( AND ) YOU HAVENT JOINED INTO AZURE AD YET!!!!!!!!!!!!
echo OR BECAUSE YOU CLOSED OUT OF THE STUDENTS CREDENTIALS .txt FILE BEFORE AZURE ENROLLMENT
echo.
echo NOTE**    You cant disconnect and reconnect to azure very easily. A Reimage is probably the best option.
echo           If you accidently joined Azure AD as the wrong student!
echo.
echo You can choose whether or not to rerun the powershell script to clean Azure AD
echo You dont have to if the Username and Computername following is the same. 
echo Unless, you didnt select the delete option last time and you want to!
echo.
echo ###############################################################################
echo ###############################################################################
echo.
echo OLD SEARCH RESULTS
type %C_Pub_Docs%AzureADSearchResults.txt
echo.
echo -------------------------------------------------------------------------------
echo -------------------------------------------------------------------------------
echo -------------------------------------------------------------------------------
echo.
echo OLD AZURE SCRIPT SEARCH PARAMETERS  --  FROM THE LAST TIME IT RAN!!!!
type %C_Pub_Docs%AzureADSearchString.txt
echo.
echo NEW AZURE SCRIPT SEARCH PARAMETERS
echo %COMPUTERNAME%
findstr "@wcscc.net" %C_Pub_Docs%UserAccount.txt
echo ###############################################################################
echo ###############################################################################
echo.
choice /c YN /M "Do you want to rerun the Azure AD Cleanup script with the new search strings?"
IF %ERRORLEVEL% == 1 goto AzureADScript
IF %ERRORLEVEL% == 2 goto AzureADScriptBypass




:ManStudAdd
:: :Specific redirected you here.   you typed "1234" for the %uname% value
::
:: This section allows you to manually specify student account information.
:: it will then ask you if it looks correct.
:: if you choose n, you will go back up to :Specific
:: if you choose y, you will finish this section, a file containing the student login information will be created and the "Live_Accounts.txt" file will be appended with this students info.
:: After this section, the script redirects up to :AzureADScript to keep the Azure AD Database clean
::
echo :ManStudAdd
echo.
echo WARNING: IT IS BETTER TO USE THIS SCRIPT TO DO THE LOOKUP.
echo          TO UPDATE THE STUDENT ACCOUNT.
echo          Try to avoid manually adding as much as possible for the best documentation at the end
echo.
echo --------------------------------------------
echo      FORMAT: 15LasFir
echo --------------------------------------------
set /p studentname="Type Username in:      
echo %studentname%@wcscc.net>%C_Pub_Docs%StudentEmail.txt
for /f "delims=" %%x in (%C_Pub_Docs%StudentEmail.txt) do set studentemail=%%x
set /p pass="Type Password in:      
echo.
echo.
echo    %studentemail%
echo    %pass%
echo.
choice /c YN /M "Is this the correct info?"
IF %ERRORLEVEL% == 2 goto Specific
echo 111111111,,Manually,Entered,%studentemail%t,%studentname%,%pass%,PROGRAM > %C_Pub_Docs%uname.txt
goto GoodStudentYes


::  ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** *******
::  ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** *******
::   END OF THE SECOND BOOT     The Main Goal was to assign the device to one student, hence "one to one", and enroll into Azure AD.
::  ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** *******
::  ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** *******

:: #######################################################################################################################
:: #######################################################################################################################
:: #######################################################################################################################
:: #######################################################################################################################
:: #######################################################################################################################
:: #######################################################################################################################
:: #######################################################################################################################
:: #######################################################################################################################
:: #######################################################################################################################

::  ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** *******
::  ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** *******
:: START OF THE THIRD BOOT     The Main Goal is to set up the student's office 365, OneDrive for Business, Google Chrome, and Services_Install services.
::  ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** *******
::  ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** ******* ******** *******
:: AS STUDENT LOGIN
:: SET UP OFFICE, ONEDRIVE FOR BUSINESS, Google Chrome AND Services_Install MDM


:Office_Setup
:: if statements at "Top Of The Script" redirected you here.
::
:: This section provides some information on the procedure and will open Microsoft Word and will open the text file "C:\Users\Public\Documents\UserAccount.txt" to allow for quick copying and pasting of student information.
:: There is a forced 20 second timer to make sure Word opens.
::
del /s /q %C_Pub_Docs%Student.csv
cls
echo :Office_Setup
call :Third_Boot_User_Script_Additions
cls
echo :Office_Setup
echo.
reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f
reg ADD HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\PassportForWork /v Enabled /t REG_DWORD /d 0 /f
if exist %C_Pub_Docs%Student.csv del /s /q %C_Pub_Docs%Student.csv
echo.
start /min %C_Pub_Docs%UserAccount.txt
echo.
echo Keep the NOTEPAD file OPEN to aid in each of the 3 steps below!!!!!  
echo For Copying and Pasting purposes!
echo.
echo ALT + TAB    --- for quick switching between windows.
clip < %C_Pub_Docs%StudentEmail.txt
echo.
echo THE USERNAME OF THE STUDENT IS ALREADY COPIED
echo.
echo Complete Each Step Before continuing to the next!
echo.
echo THIS IS A   3   STEP PROCESS
echo.
echo 1.)   Active Office 365 via Word 2016
echo 2.)   Setup OneDrive for Business on the DESKTOP
echo 3.)   Sign into Google Chrome
echo.
pause
cls
echo ---------STEP 1------------
echo.
echo First we will activate Microsoft Office.
echo.
echo %USERNAME%@wcscc.net    ---  Use this Email to sign in!
echo.
echo ****************  KEYBOARD SHORTCUT FOR MULTIPLE DEVICES  ****************************
echo Use    Alt L       ,       Alt F    ,    Alt D    to quickly pull up "Accounts"
echo    Blank Document          File     ,   Accounts 
echo.
echo Hold down  Alt  and you can press  L  F  D  as fast as you can   :)
echo ****************  KEYBOARD SHORTCUT FOR MULTIPLE DEVICES  ****************************
echo.
echo Or
echo.
echo Click   "Blank Document", "File", "Accounts"
echo.
echo VERIFY THAT YOU SEE "OneDrive - Wayne County Schools Career Center" AS A "Connected Service"
echo.
echo.
start winword.exe
timeout /nobreak 20
choice /m "Do you see 'OneDrive' as a 'Connected Service'?        "
if %errorlevel% == 1 goto OneDrive_Step2
if %errorlevel% == 2 goto Office_Setup_Error



:Office_Setup_Error
:: You chose that you did NOT see "OneDrive - Wayne County Schools Career Center" at the bottom of :Office_Setup
:: It restarts Microsoft Word and tells you to try again...
:: If you still do not see "OneDrive" the script gives you some instructions on what to try next.
taskkill /IM winword.exe /f
timeout /nobreak 1
start winword.exe
cls
echo :Office_Setup_Error
echo.
echo You do NOT see "OneDrive - Wayne County Schools Career Center" listed in "Connected Services"
echo.
echo Word 2016 was just Restarted...
echo 
echo.
echo Here are some steps to try...
echo   1.)   See if you can see "OneDrive - Wayne County Schools Career Center" now.  If so, you are good!
echo   2.)   "Sign Out" of Word and Manually Sign back in...  With the info from the "Notepad" file
echo   3.)   Give Word adequate time to sync... 1 minute...
echo   4.)   Restart The Computer!!!!!!   Try Again
echo.
echo      If all else fails,  Reimage the device!!!!!!!
echo.
echo.
timeout /nobreak 20
pause
echo.
echo Srcipt Will Exit...    Resolve Office Issues Manually!!!!!!!!!!!!
pause
exit



:OneDrive_Step2
:: This section follows :Office_Setup
::
:: This section kills Word if it is running. Then, it opens OneDrive for Business and prompts for you to sync OneDrive to the Desktop.
:: After syncing OneDrive for Business and resuming the script, the script will wait for 15 seconds and perform a test to see if OneDrive for Business was in fact set tup on the Desktop.
cls
echo :OneDrive_Step2
echo.
echo ---------STEP 2------------
echo.
cls
taskkill /IM winword.exe /f
timeout /nobreak 1
start groove.exe
cls
color 4e
echo.
echo SET ONEDRIVE UP ON YOUR DESKTOP
echo SET ONEDRIVE UP ON YOUR DESKTOP
echo SET ONEDRIVE UP ON YOUR DESKTOP
echo.
echo.
echo.
echo Click  "Change" 
echo Click  "Desktop"
echo Click  "OK"
echo.
echo Click  "Sync Now"
echo.
echo.
timeout /nobreak /t 15
pause
color 07
cls

IF EXIST "C:\users\%USERNAME%\Desktop\OneDrive - Wayne County Schools Career Center\" goto Onedrivepass
IF NOT EXIST "C:\users\%USERNAME%\Desktop\OneDrive - Wayne County Schools Career Center\" goto Onedrivefail



:Onedrivepass
:: :OneDrive_Step2 redirected you here.    OneDrive for Business was set up on the Desktop.
::
:: This section copies over the OneDrive tutorial document and a shortcut to Office.com
:: Then, the script will send you to :Services_Install to run the installers. 
::
cls
echo :Onedrivepass
echo.
echo Creating a file to guide the Student using onedrive
echo Creating a shortcut to www.office.com
echo.
timeout /nobreak /t 15
copy "%C_Pub_Docs%OneDrive Tutorial Document.docx" "C:\users\%USERNAME%\Desktop\OneDrive - Wayne County Schools Career Center\"
copy "%C_Pub_Docs%Office365.url" "C:\users\%USERNAME%\Desktop\"
echo.
echo.
echo Congrats!! Office is Setup.   Next, Lets sign into Google Chrome
echo.
echo.
goto ChromeSignin


:Onedrivefail
:: :OneDrive_Step2 redirected you here.    OneDrive for Business was NOT set up on the Desktop.
::
:: This section will provice you with details on how to fix this error.
:: After fixing this and resuming the script, the script will delete the files and will take you to the section :OneDrive_Step2
::
cls
echo :Onedrivefail
color e0
echo Onedrive For Business was not setup on the Desktop.
echo.
echo Please right click the Onedrive for Business icon in the notification panel
echo Select "Stop Syncing a Folder" and stop syncing the one folder.
echo.
echo After that is done, Resume this script
pause
pause
del /s /q "C:\users\%USERNAME%\OneDrive - Wayne County Schools Career Center"
rmdir /s /q "C:\users\%USERNAME%\OneDrive - Wayne County Schools Career Center"
taskkill /im groove.exe
color 0a
goto OneDrive_Step2


:ChromeSignin
:: :Onedrivepass redirected you here.
:: 
:: Sign into chrome using automated username ad password copying or the text file in the background.
cls
echo :ChromeSignin
echo.
echo Sign into Google Chrome as the student!
echo Open Chrome Settings page
echo.
echo Shortcut for Settings page when chrome opens is:
echo    (Alt + e)    S         TAB TAB     Enter
echo.
echo UNPAUSE TWICE TO COPY THE STUDENTS PASSWORD
echo.
clip < %C_Pub_Docs%StudentEmail.txt
start chrome.exe
timeout /t 5
pause
pause
clip < %C_Pub_Docs%StudentPassword.txt
echo.
echo PASSWORD HAS BEEN COPIED
echo.
echo UNPAUSE TWICE TO CONTINUE
pause
pause
taskkill /T /F /IM chrome.exe

:Installing_Chrome
cls
echo :Installing_Chrome
echo.
echo.
echo Wait for chrome to install!!!!!
echo.
echo.
%C_Pub_Docs%ChromeSetup-61.exe
echo.
timeout /nobreak 5
taskkill /f /t /im chrome.exe

:LGPO
T:
cd "/1-1 Image Setup"
cls
echo :LGPO
echo.
echo.
echo Pulling all documents to Public Downloads
xcopy Public_Documents\* C:\Users\Public\Downloads\ /Y /S
IF %ERRORLEVEL% NEQ 0 goto No_Network_Connection
echo.
echo Copying LGPO.exe to System32
copy %C_Pub_Docs%LGPO.exe C:\Windows\System32
echo.
timeout 2
echo Applying the Chrome Fix Cheese!
lgpo.exe /g C:\users\public\Downloads\LGPO_Policies
rmdir /S /Q C:\Users\Public\Downloads\LGPO_Policies
del /s /q C:\Users\Public\Downloads\*.*


:: Installing Services_Install, FOG and Aristotle
:Services_Install
cls
echo :Services_Install
echo installing Services_Install LMA     v3.1.2  "updated 10/4/2017"
echo %C_Pub_Docs%LMA_Setupx64.msi
msiexec.exe /i %C_Pub_Docs%LMA_Setupx64.msi /quiet CUSTOMER_ID=60-8820-A000 ENROLLMENT_CODE=o-6043 ASSOCIATE_USER=1 MM=1 CO=0
echo installing Services_Install Mobile Filter   v6.2.6  "updated 10/4/2017"
echo %C_Pub_Docs%MobileFilterx64.msi
msiexec.exe /i %C_Pub_Docs%MobileFilterx64.msi /quiet SERVERS=cloudfilter-east01.Services_Installsystems.com
echo.
echo Installing FOG Client
msiexec /i %C_Pub_Docs%FOGService.msi /quiet USETRAY="0" HTTPS="0" WEBADDRESS="10.21.0.105" WEBROOT="/fog" ROOTLOG="1"
echo.
echo installing AristotleNT v7.2.47
msiexec.exe /i %C_Pub_Docs%AristotleNT.msi /quiet
echo.
if exist "C:\Program Files\Lightspeed Systems\Mobile Filter\LSMFSvc.exe" (
goto Services_Start
)
echo.
echo Services_Install is not installed
echo resync Lightspeed MDM or Manually install MSI files
echo.
color e0
pause
color 07
goto MDM_Sync_and_Product_Key_Activation

:: Sets Services_Install Services to Delayed Auto.
:Services_Start
cls
echo :Services_Start
echo.
sc config FOGService start= auto
net start FOGService
echo.
sc config LSMFSvc start=delayed-auto
sc config LMA_Service start=delayed-auto
SC failure LSMFSvc reset= 86400 actions= restart/1000/restart/1000/restart/1000
SC failure LMA_Service reset= 86400 actions= restart/1000/restart/1000/restart/1000
net start LSMFSvc
net start LMA_Service
echo.
echo.



:MDM_Sync_and_Product_Key_Activation
:: Sync the Services_Install MDM (Mobile Device Management)
cls
echo :MDM_Sync_and_Product_Key_Activation
echo.
echo.
echo Sync Services_Install and any other MDMs
start ms-settings:workplace
echo.
powercfg.exe -x -monitor-timeout-ac 20
powercfg.exe -x -monitor-timeout-dc 10
powercfg.exe -x -disk-timeout-ac 90
powercfg.exe -x -disk-timeout-dc 60
powercfg.exe -x -standby-timeout-ac 60
powercfg.exe -x -standby-timeout-dc 30
powercfg.exe -x -hibernate-timeout-ac 90
powercfg.exe -x -hibernate-timeout-dc 60
echo.
wmic path softwarelicensingservice get OA3xOriginalProductKey | findstr /V OA3x | findstr /V /B ^$ > C:\Users\%Username%\Documents\ProductKey.txt
for /f "delims=, tokens=1" %%g in ( C:\Users\%Username%\Documents\ProductKey.txt ) do (set Product_Key=%%g)
echo %Product_Key%
changepk.exe /productkey %Product_Key%
echo.
echo.
pause

:AssignedDeviceDocumentation
:: This Section is to document the student that we gave this device to...
:: Reads the Sirsi Tag
:: It will only append the file if it needs to, the decision is based on whether or not the WiFi MAC Address has already been assigned to the students UserName...
:: It will endlessly loop if the script tries to add a line to T:\1-1 Image Setup\%DeviceModel%_Assigned_Device.csv and that file is open in another program...   Somebody on the network probably has it open in EXCEL Spreadsheet.
cls
echo :AssignedDeviceDocumentation
echo.
set /p SIRSI=<%C_Pub_Docs%SIRSI_TAG.txt
for /f "delims=, tokens=1" %%g in ( %C_Pub_Docs%uname.txt ) do (set studentID=%%g)
find "%studentID%" "T:\1-1 Image Setup\%DeviceModel%_Assigned_Device.csv" > %C_Pub_Docs%AssignedDevice.txt
find /C "%studentID%" "T:\1-1 Image Setup\%DeviceModel%_Assigned_Device.csv" > %C_Pub_Docs%AssignedDevice_Count.txt
for /f "delims=: tokens=3" %%g in ( %C_Pub_Docs%AssignedDevice_Count.txt ) do (set /a Number=%%g)
if %Number% GEQ 1 set /a NewerDevice=%Number%+1
if %Number% EQU 0 set NewerDevice=1
echo How many devices have already been previously assigned to the student?      %Number%
echo Where does this device fall in line?  (One higher than last number)         %NewerDevice%
find /C "%MAC%" %C_Pub_Docs%AssignedDevice.txt > %C_Pub_Docs%Student_Assigned_MAC.txt
for /f "delims=: tokens=3" %%g in ( %C_Pub_Docs%Student_Assigned_MAC.txt ) do (set /a MAC_Number=%%g)
echo Has this computer already been assigned AND documented?                     %MAC_Number%
echo                                                   0 is No     1 is Yes     ^^^^^^
echo.
echo studentID = %studentID%
echo.
echo.
if %MAC_Number% NEQ 0 echo Device is already documented and assigned... Not Adding it again!
if %MAC_Number% NEQ 0 goto Battery_Check
echo ADDING A NEW LINE TO T:\1-1 Image Setup\%DeviceModel%_Assigned_Device.csv
echo This is a new device for the student...
echo Meaning, the MAC Address (%MAC%) has NEVER been assigned to the student (%studentID%) before!
echo.
for /f "delims=, tokens=1,2,3,4,5,6,7" %%f in ( %C_Pub_Docs%uname.txt ) do (echo %SIRSI%,%%f,%computername%,%serial%,%MAC%,%%g %%h,%%j,%%l,%date%,%NewerDevice%,%Product_Key%)
for /f "delims=, tokens=1,2,3,4,5,6,7" %%f in ( %C_Pub_Docs%uname.txt ) do (echo %SIRSI%,%%f,%computername%,%serial%,%MAC%,%%g %%h,%%j,%%l,%date%,%NewerDevice%,%Product_Key%) >> "T:\1-1 Image Setup\%DeviceModel%_Assigned_Device.csv"
echo.
echo Above is the new line in the T:\1-1 Image Setup\%DeviceModel%_Assigned_Device.csv
echo.
echo.
timeout /t 15
goto AssignedDeviceDocumentation

:END_OF_SCRIPT
echo.
echo.
echo WooooHoooo!!!!!
echo.
echo :END_OF_SCRIPT      Unpause Once to FINISH UP
echo The Script is Complete.  FINALLY!!!!
echo.
echo.
copy %C_Pub_Docs%Student_Network_Drives.bat "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\"
for /f "delims=, tokens=1,2,3,4,5,6,7" %%f in ( %C_Pub_Docs%uname.txt ) do (echo %SIRSI%,%%f,%computername%,%serial%,%MAC%,%%g %%h,%%j,%%l,%date%)>> "T:\1-1 Image Setup\Logs\Imaging_Log.csv"
shutdown -s -t 30 -c "The Script is Done!  Deleting all Temp Files NOW!!"
net use /delete T:    /YES
timeout /nobreak 5
del /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\Student_Logon_Safeguard.bat"
del /s /q %C_Pub_Docs%*.* && del C:\Users\Public\Desktop\One_Big_Script*.bat



:Battery_Check
@echo off
cls
echo :Battery_Check
echo.
FOR /F "tokens=1,2 delims=," %%A IN ('WMIC Path Win32_Battery Get EstimatedChargeRemaining /Format:csv ^| findstr %computername%') DO ( SET batteryPercent=%%B )
echo.
echo The battery is   %batteryPercent% percent charged
echo.
echo.
if %batteryPercent% LEQ 30 (
color cf
echo CHARGE THE BATTERY !!!!!!!!!!!
)
if %batteryPercent% LEQ 50 if %batteryPercent% GTR 30 (
color e0
echo CONSIDER:  charging the battery !!!!!!!!!!!
)
if %batteryPercent% GTR 50 (
color 0a
echo The Battery is charged enough !!!!!!!!!!!
timeout /t 10
goto END_OF_SCRIPT
)
echo.
echo.
echo Do you want to check the battery again?
choice /t 10 /d y /m "To finish the script regardless press     n       "
if %errorlevel% == 1 goto Battery_Check
if %errorlevel% == 2 goto END_OF_SCRIPT



:First_Boot_User_Script_Additions
:: These commands will be ran when the computer first boots up after being imaged
echo :First_Boot_User_Script_Additions
timeout 3
:: START ENTERING COMMANDS HERE

:: END ENTERING COMMANDS HERE
goto :eof



:Second_Boot_User_Script_Additions
:: These commands will be ran when the computer first boots up after being imaged
:: Note: The computer name should be %DeviceModel%xxx and the logged in user should be WCSCC
::       This will be ran before Azure AD enrollment
@echo off
echo :Second_Boot_User_Script_Additions
timeout 3
:: START ENTERING COMMANDS HERE

:: END ENTERING COMMANDS HERE
goto :eof



:Third_Boot_User_Script_Additions
:: These commands will be ran when the computer first boots up after being imaged
:: Note: The computer name should be %DeviceModel%xxx and the logged in user should be WCSCC
::       This will be ran before Azure AD enrollment
@echo off
echo :Third_Boot_User_Script_Additions
timeout 3
:: START ENTERING COMMANDS HERE

:: END ENTERING COMMANDS HERE
goto :eof

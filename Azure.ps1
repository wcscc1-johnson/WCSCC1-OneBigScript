Start-Job {
Get-AppxPackage *3dbuilder* | Remove-AppxPackage
Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage
Get-AppxPackage *windowscamera* | Remove-AppxPackage
Get-AppxPackage *officehub* | Remove-AppxPackage
Get-AppxPackage *skypeapp* | Remove-AppxPackage
Get-AppxPackage *getstarted* | Remove-AppxPackage
Get-AppxPackage *zunemusic* | Remove-AppxPackage
Get-AppxPackage *solitairecollection* | Remove-AppxPackage
Get-AppxPackage *zunevideo* | Remove-AppxPackage
Get-AppxPackage *onenote* | Remove-AppxPackage
Get-AppxPackage *people* | Remove-AppxPackage
Get-AppxPackage *windowsphone* | Remove-AppxPackage
Get-AppxPackage *bingsports* | Remove-AppxPackage
Get-AppxPackage *soundrecorder* | Remove-AppxPackage
Get-AppxPackage *xboxapp* | Remove-AppxPackage
} > $null
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module azureadpreview -force


$user = "hp@wcscc.net"
$passwd = "stream"
$secpasswd = ConvertTo-SecureString "$passwd" -AsPlainText -Force
$creden = New-Object System.Management.Automation.PSCredential ("$user", $secpasswd)
Connect-AzureAD -credential $creden
cls


$Compname = Get-Content C:\Users\Public\Documents\AzureCompname.txt
$Account = findstr "@wcscc.net" C:\Users\Public\Documents\UserAccount.txt
cls
echo "SEARCH STRING1  ------------------  $Compname"
echo "    Devices Matching $Compname -------------------------------"
Get-AzureADDevice -SearchString $Compname | Select-Object -Property DisplayName, DeviceOSVersion, ApproximateLastLogonTimeStamp
Get-AzureADDevice -SearchString $Compname | Select-Object -Property DisplayName, DeviceOSVersion, ApproximateLastLogonTimeStamp > C:\Users\Public\Documents\AzureADSearchResults.txt
Write-Host  
Write-Host  
echo "SEARCH STRING2  ------------------  $Account"
echo "    Devices Matching $Account -------------------------------"
Get-AzureADUser -SearchString $Account | Get-AzureADUserOwnedDevice  | Select-Object -Property DisplayName, DeviceOSVersion, ApproximateLastLogonTimeStamp
Get-AzureADUser -SearchString $Account | Get-AzureADUserOwnedDevice  | Select-Object -Property DisplayName, DeviceOSVersion, ApproximateLastLogonTimeStamp >> C:\Users\Public\Documents\AzureADSearchResults.txt
$Compname > C:\Users\Public\Documents\AzureADSearchString.txt
$Account >> C:\Users\Public\Documents\AzureADSearchString.txt
Write-Host   >> C:\Users\Public\Documents\AzureADSearchString.txt


$confirmation = Read-Host "Are you sure you want to delete these devices? [y/n]"
while($confirmation -ne "y")
{
    if ($confirmation -eq 'n') {
    echo "Delete Selected? -- NO!!!" >> C:\Users\Public\Documents\AzureADSearchString.txt
    exit}
    $confirmation = Read-Host "If you want to delete these devices press 'y' otherwise press 'n' [y/n]"
}


Get-AzureADUser -SearchString $Account | Get-AzureADUserOwnedDevice | Remove-AzureADDevice
Get-AzureADDevice -SearchString $Compname | Remove-AzureADDevice
echo "Delete Selected? -- YES!!!" >> C:\Users\Public\Documents\AzureADSearchString.txt
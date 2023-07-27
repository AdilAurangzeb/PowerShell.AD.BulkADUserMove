Import-Module ActiveDirectory

Write-Host "This script moves users from one group to another" -ForegroundColor green

# Import users from old group
$oldGroupName = Read-Host -Prompt "Enter Old Group"
$OldGroup = Get-ADGroupMember -identity $oldGroupName | select SamAccountName -expandproperty SamAccountName


# User inputs group name to compare with
$newGroupName = Read-Host -Prompt "Type in new group name"


$NewGroupList = Get-ADGroupMember $newGroupName | select SamAccountName -expandproperty SamAccountName


# Initiating Array for possible problem users
$problemUsers = @()



foreach($user in $OldGroup)
{
    if ($NewGroupList -Notcontains $user)
    {
        Add-ADGroupMember -Identity $newGroupName -Members $user
        Write-Host "$user Moved" -ForegroundColor green
    }
    
    else 
    {
        Write-Host  "$user NOT Moved" -ForegroundColor red -BackgroundColor white
        $problemUsers = $problemUsers + $user 
    }
}


$problemUsers | Out-File ".\problemUsers.txt"
$problemCount = $problemUsers.Count
Write-Host "$problemCount have not been added, refer to generated text file if needed." -ForegroundColor green

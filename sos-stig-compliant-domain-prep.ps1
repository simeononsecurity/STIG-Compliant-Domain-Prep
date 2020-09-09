######Script for Import and Setup of GPOs and WMI Filters on Domain Controllers#####
#Continue on error
$ErrorActionPreference= 'silentlycontinue'

#Require elivation for script run
#Requires -RunAsAdministrator
Write-Output "Elevating priviledges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

foreach ($gpocategory in Get-ChildItem "$(Get-Location)\Files\GPOs") {
    
    Write-Output "Importing $gpocategory GPOs"

    Foreach ($gpo in (Get-ChildItem "$(Get-Location)\Files\GPOs\$gpocategory")) {
        $gpopath = "$gposdir\$gpocategory\$gpo"
        Write-Output "Importing $gpo"
        New-GPO -Name "$gpo" -Comment "Created by simeononsecurity.ch" 
        Import-GPO -BackupGpoName "$gpo" -Path "$gpopath" -TargetName "$gpo" -CreateIfNeeded 
    }
}


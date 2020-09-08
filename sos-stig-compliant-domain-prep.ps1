######Script for Import and Setup of GPOs and WMI Filters on Domain Controllers#####
#Continue on error
$ErrorActionPreference= 'silentlycontinue'

#Require elivation for script run
#Requires -RunAsAdministrator
Write-Output "Elevating priviledges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

Foreach ($dodgpo in Get-ChildItem .\Files\GPOs\DoD) {
    $gpopath = "$(Get-Location)\Files\GPOs\DoD\$dodgpo"
    Write-Output "Importing $dodgpo"
    New-GPO -Name "$dodgpo" -Comment "Created by simeononsecurity.ch" 
    Import-GPO -BackupGpoName "$dodgpo" -Path "$gpopath" -TargetName "$dodgpo" -CreateIfNeeded
    }

Foreach ($nsagpo in Get-ChildItem .\Files\GPOs\NSACyber) {
    $gpopath = "$(Get-Location)\Files\GPOs\NSACyber\$nsagpo"
    Write-Output "Importing $nsagpo"
    New-GPO -Name "$nsagpo" -Comment "Created by simeononsecurity.ch" 
    Import-GPO -BackupGpoName "$nsagpo" -Path "$gpopath" -TargetName "$nsagpo" -CreateIfNeeded
    }

Foreach ($sosgpo in Get-ChildItem .\Files\GPOs\SoS) {
    $gpopath = "$(Get-Location)\Files\GPOs\Files\GPOs\SoS\$sosgpo"
    Write-Output "Importing $sosgpo"
    New-GPO -Name "$sosgpo" -Comment "Created by simeononsecurity.ch" 
    Import-GPO -BackupGpoName "$sosgpo" -Path "$gpopath" -TargetName "$sosgpo" -CreateIfNeeded 
    }

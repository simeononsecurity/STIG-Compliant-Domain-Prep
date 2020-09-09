######Script for Import and Setup of GPOs and WMI Filters on Domain Controllers#####
#Continue on error
$ErrorActionPreference= 'silentlycontinue'

#Require elivation for script run
#Requires -RunAsAdministrator
Write-Output "Elevating priviledges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)


#Import PolicyDefinitions
start-job -ScriptBlock {takeown /f C:\WINDOWS\PolicyDefinitions /r /a; icacls C:\WINDOWS\PolicyDefinitions /grant Administrators:(OI)(CI)F /t; Copy-Item -Path .\Files\PolicyDefinitions\* -Destination C:\Windows\PolicyDefinitions -Force -Recurse -ErrorAction SilentlyContinue}

#Import GPOS into GPMC
$gposdir "$(Get-Location)\Files\GPOs"
Foreach ($gpocategory in Get-ChildItem "$(Get-Location)\Files\GPOs") {
    
    Write-Output "Importing $gpocategory GPOs"

    Foreach ($gpo in (Get-ChildItem "$(Get-Location)\Files\GPOs\$gpocategory")) {
        $gpopath = "$gposdir\$gpocategory\$gpo"
        Write-Output "Importing $gpo"
        New-GPO -Name "$gpo" -Comment "Created by simeononsecurity.ch" 
        Import-GPO -BackupGpoName "$gpo" -Path "$gpopath" -TargetName "$gpo" -CreateIfNeeded 
    }
}


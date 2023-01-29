######Script for Import and Setup of GPOs and Policy Definitons on Domain Controllers#####
#Continue on error
$ErrorActionPreference= 'silentlycontinue'

#Require elivation for script run
#Requires -RunAsAdministrator
Write-Output "Elevating priviledges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

#Set Directory to PSScriptRoot
if ((Get-Location).Path -NE $PSScriptRoot) { Set-Location $PSScriptRoot }

#Import PolicyDefinitions
# Import to Central Store
try {
    Start-Job -ScriptBlock {
        takeown /f C:\WINDOWS\PolicyDefinitions /r /a -ErrorAction Stop
        icacls C:\WINDOWS\PolicyDefinitions /grant Administrators:(OI)(CI)F /t -ErrorAction Stop
        Copy-Item -Path .\Files\PolicyDefinitions\* -Destination C:\Windows\PolicyDefinitions -Force -Recurse -ErrorAction Stop
    } -ErrorAction Stop -AsJob -UseTransaction -Verbose
    # Get all child items of the "C:\Windows\SYSVOL\sysvol" directory
    $sysvolpaths = Get-ChildItem "C:\Windows\SYSVOL\sysvol" -ErrorAction Stop
    # Iterate through each child item
    foreach ($sysvolpath in $sysvolpaths) {
        # Create the "PolicyDefinitions" directory if it doesn't exist
        if (!(Test-Path "C:\Windows\SYSVOL\sysvol\$sysvolpath\Policies\PolicyDefinitions\")) {
            New-Item "C:\Windows\SYSVOL\sysvol\$sysvolpath\Policies\PolicyDefinitions\" -Force
        }
        # Copy the files to the "PolicyDefinitions" directory
        Copy-Item -Path "$(Get-Location)\Files\PolicyDefinitions\*" -Destination "C:\Windows\SYSVOL\sysvol\$sysvolpath\Policies\PolicyDefinitions\" -Force -Recurse
    }
} catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
}


#Import GPOS into GPMC
$gposdir = "$(Get-Location)\Files\GPOs"
Foreach ($gpocategory in Get-ChildItem $gposdir) {
    
    Write-Output "Importing $gpocategory GPOs"

    Foreach ($gpo in (Get-ChildItem "$gposdir\$gpocategory")) {
        $gpopath = "$gposdir\$gpocategory\$gpo"
        Write-Output "Importing $gpo"
        New-GPO -Name "$gpo" -Comment "Created by simeononsecurity.ch" 
        Import-GPO -BackupGpoName "$gpo" -Path "$gpopath" -TargetName "$gpo" -CreateIfNeeded 
        #Import-GPO -BackupGpoName "$gpo" -Path "$gpopath" -TargetName "$gpo" -MigrationTable ".\Files\Migration Table\importtable.migtable" -CreateIfNeeded 
    }
}


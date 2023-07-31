# Continue on error
$ErrorActionPreference = 'Continue'

# Elevate privileges for this process
Write-Output "Elevating privileges for this process"
do {
    Start-Process -FilePath "$PSHOME\powershell.exe" -Verb RunAs
    Start-Sleep -Seconds 1
} until ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))

# Set directory to PSScriptRoot
$scriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
Set-Location $scriptPath

# Import PolicyDefinitions
$policyDefinitionsSource = Join-Path $scriptPath 'Files\PolicyDefinitions'
$policyDefinitionsDestination = 'C:\Windows\PolicyDefinitions'

try {
    Write-Output "Copying Policy Definitions to Central Store"
    # Take ownership of the PolicyDefinitions folder and grant full control to Administrators
    takeown /f "$policyDefinitionsDestination" /r /a /d y | Out-Null
    icacls "$policyDefinitionsDestination" /grant "Administrators:(OI)(CI)F" /t | Out-Null
    # Copy the files to the PolicyDefinitions folder
    Copy-Item -Path "$policyDefinitionsSource\*" -Destination $policyDefinitionsDestination -Force -Recurse -ErrorAction Stop
    # Get all SYSVOL paths
    $sysvolPaths = Get-ChildItem "C:\Windows\SYSVOL\sysvol" -Directory -ErrorAction Stop
    # Copy the files to the PolicyDefinitions folder in each SYSVOL path
    foreach ($sysvolPath in $sysvolPaths) {
        $policyDefinitionsSysvolDestination = Join-Path $sysvolPath.FullName 'Policies\PolicyDefinitions'
        if (!(Test-Path $policyDefinitionsSysvolDestination)) {
            New-Item -Path $policyDefinitionsSysvolDestination -ItemType Directory -Force | Out-Null
        }
        Copy-Item -Path "$policyDefinitionsSource\*" -Destination $policyDefinitionsSysvolDestination -Force -Recurse
    }
} catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
}

# Import GPOs into GPMC
$gposDir = Join-Path $scriptPath 'Files\GPOs'
$gpoCategoryDirs = Get-ChildItem -Path $gposDir -Directory

foreach ($gpoCategoryDir in $gpoCategoryDirs) {
    Write-Output "Importing GPOs from $gpoCategoryDir"
    $gpoFiles = Get-ChildItem -Path $gpoCategoryDir.FullName -File

    foreach ($gpoFile in $gpoFiles) {
        $gpoPath = $gpoFile.FullName
        $gpoName = $gpoFile.BaseName
        Write-Output "Importing $gpoName"
        New-GPO -Name $gpoName -Comment "Created by simeononsecurity.ch"
        Import-GPO -BackupGpoName $gpoName -Path $gpoPath -TargetName $gpoName -CreateIfNeeded
    }
}

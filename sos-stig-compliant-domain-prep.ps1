<#
.SYNOPSIS

    Create a STIG complaint domain.

.DESCRIPTION

    Import all the GPOs provided by SimeonOnSecurity to assist in making your
    domain compliant with all applicable STIGs and SRGs.

    Note: This script should work for most, if not all, systems without issue.
    While @SimeonOnSecurity creates, reviews, and tests each repo intensivly,
    we can not test every possible configuration nor does @SimeonOnSecurity
    take any responsibility for breaking your system. If something goes wrong,
    be prepared to submit an issue. Do not run this script if you don't
    understand what it does.

.PARAMETER logFile

    File name to log the output of certain operations to, in order to enable
    easier troubleshooting in case something doesn't work as expected. The file
    will be created within the path where the script is located.

.INPUTS

    None. You cannot pipe objects into sos-stig-compliant-domain-prep.ps1.

.OUTPUTS

    System.String. The script outputs messages of the process and what
                   operations it is performing.

.EXAMPLE

    PS> .\sos-stig-compliant-domain-prep.ps1 -logFile 'YYYYmmdd_prep.log'

#>
[CmdletBinding()]
param (
    [string]$logFile = 'domain_prep.log'
)

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

$logFilePath = Join-Path "$scriptPath" "$logFile"

$startTime = Get-Date -Format "yyyy-MM-ddTHH:mmK"
Add-Content -Path "$logFilePath" -Value "Start running script at: ${startTime}"

# Import PolicyDefinitions
$policyDefinitionsSource = Join-Path $scriptPath 'Files\PolicyDefinitions'
$policyDefinitionsDestination = 'C:\Windows\PolicyDefinitions'

try {
    Write-Output "Copying Policy Definitions to Central Store"
    # Take ownership of the PolicyDefinitions folder and grant full control to Administrators
    takeown /f "$policyDefinitionsDestination" /r /a /d y | Out-File -FilePath "$logFilePath" -Append
    icacls "$policyDefinitionsDestination" /grant "Administrators:(OI)(CI)F" /t | Out-File -FilePath "$logFilePath" -Append
    # Copy the files to the PolicyDefinitions folder
    Copy-Item -Path "$policyDefinitionsSource\*" -Destination $policyDefinitionsDestination -Force -Recurse -ErrorAction Stop
    # Get all SYSVOL paths
    $sysvolPaths = Get-ChildItem "C:\Windows\SYSVOL\sysvol" -Directory -ErrorAction Stop
    # Copy the files to the PolicyDefinitions folder in each SYSVOL path
    foreach ($sysvolPath in $sysvolPaths) {
        $policyDefinitionsSysvolDestination = Join-Path $sysvolPath.FullName 'Policies\PolicyDefinitions'
        if (!(Test-Path $policyDefinitionsSysvolDestination)) {
            New-Item -Path $policyDefinitionsSysvolDestination -ItemType Directory -Force | Out-File -FilePath "$logFilePath" -Append
        }
        Copy-Item -Path "$policyDefinitionsSource\*" -Destination $policyDefinitionsSysvolDestination -Force -Recurse
    }
}
catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
}

# Import GPOs into GPMC
function Import-GPOs {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$gposDir
    )

    try {
        $gpoCategoryDirs = Get-ChildItem -Path "$gposDir" -Directory

        # Check if any GPO categories were found
        if ($null -eq $gpoCategoryDirs) {
            Write-Error "No GPO categories/vendors found in $gposDir"
            return
        }

        foreach ($gpoCategoryDir in $gpoCategoryDirs) {

            $gpoFiles = Get-ChildItem -Path $gpoCategoryDir.FullName -Directory

            Write-Output "Importing GPOs from $($gpoFiles.FullName)"

            # Check if any GPO files were found
            if ($null -eq $gpoFiles) {
                Write-Warning "No GPO files found in $($gpoFiles.FullName)"
                continue
            }

            foreach ($gpoFile in $gpoFiles) {
                $gpoPath = $gpoFile.FullName
                $gpoName = $gpoFile.BaseName
                Write-Output "Importing $gpoName"
                New-GPO -Name $gpoName -Comment "Created by simeononsecurity.ch"

                try {
                    Import-GPO -BackupGpoName $gpoName -Path $gpoPath -TargetName $gpoName -CreateIfNeeded -ErrorAction Stop
                }
                catch {
                    Write-Error "Failed to import GPO '$gpoName': $_"
                }
            }
        }
    }
    catch {
        Write-Error "An unexpected error occurred: $_"
    }
}

# Import GPOs into GPMC
$gposDir = Join-Path $scriptPath 'Files\GPOs'
Import-GPOs -gposDir "$gposDir"

$endTime = Get-Date -Format "yyyy-MM-ddTHH:mmK"
Add-Content -Path "$logFilePath" -Value "Finish running script at: ${endTime}"

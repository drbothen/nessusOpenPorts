# nessusOpenPorts
# Version: $version$
# Changeset: $sha$

if ($PSVersionTable.PSVersion.Major -ge 3) {
    $script:IgnoreErrorPreference = 'Ignore'
    $outNullModule = 'Microsoft.PowerShell.Core'
}
else {
    $script:IgnoreErrorPreference = 'SilentlyContinue'
    $outNullModule = 'Microsoft.PowerShell.Utility'
}

# Tried using $ExecutionState.InvokeCommand.GetCmdlet() here, but it does not trigger module auto-loading the way
# Get-Command does.  Since this is at import time, before any mocks have been defined, that's probably acceptable.
# If someone monkeys with Get-Command before they import Pester, they may break something.

$script:SafeCommands = @{
    'Add-Member'          = Get-Command -Name Add-Member          -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Add-Type'            = Get-Command -Name Add-Type            -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Compare-Object'      = Get-Command -Name Compare-Object      -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Export-ModuleMember' = Get-Command -Name Export-ModuleMember -Module Microsoft.PowerShell.Core       -CommandType Cmdlet -ErrorAction Stop
    'ForEach-Object'      = Get-Command -Name ForEach-Object      -Module Microsoft.PowerShell.Core       -CommandType Cmdlet -ErrorAction Stop
    'Format-Table'        = Get-Command -Name Format-Table        -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Get-ChildItem'       = Get-Command -Name Get-ChildItem       -Module Microsoft.PowerShell.Management -CommandType Cmdlet -ErrorAction Stop
    'Get-Command'         = Get-Command -Name Get-Command         -Module Microsoft.PowerShell.Core       -CommandType Cmdlet -ErrorAction Stop
    'Get-Content'         = Get-Command -Name Get-Content         -Module Microsoft.PowerShell.Management -CommandType Cmdlet -ErrorAction Stop
    'Get-Date'            = Get-Command -Name Get-Date            -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Get-Item'            = Get-Command -Name Get-Item            -Module Microsoft.PowerShell.Management -CommandType Cmdlet -ErrorAction Stop
    'Get-Location'        = Get-Command -Name Get-Location        -Module Microsoft.PowerShell.Management -CommandType Cmdlet -ErrorAction Stop
    'Get-Member'          = Get-Command -Name Get-Member          -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Get-Module'          = Get-Command -Name Get-Module          -Module Microsoft.PowerShell.Core       -CommandType Cmdlet -ErrorAction Stop
    'Get-PSDrive'         = Get-Command -Name Get-PSDrive         -Module Microsoft.PowerShell.Management -CommandType Cmdlet -ErrorAction Stop
    'Get-Variable'        = Get-Command -Name Get-Variable        -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Get-WmiObject'       = Get-Command -Name Get-WmiObject       -Module Microsoft.PowerShell.Management -CommandType Cmdlet -ErrorAction Stop
    'Group-Object'        = Get-Command -Name Group-Object        -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Join-Path'           = Get-Command -Name Join-Path           -Module Microsoft.PowerShell.Management -CommandType Cmdlet -ErrorAction Stop
    'Measure-Object'      = Get-Command -Name Measure-Object      -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'New-Item'            = Get-Command -Name New-Item            -Module Microsoft.PowerShell.Management -CommandType Cmdlet -ErrorAction Stop
    'New-Module'          = Get-Command -Name New-Module          -Module Microsoft.PowerShell.Core       -CommandType Cmdlet -ErrorAction Stop
    'New-Object'          = Get-Command -Name New-Object          -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'New-PSDrive'         = Get-Command -Name New-PSDrive         -Module Microsoft.PowerShell.Management -CommandType Cmdlet -ErrorAction Stop
    'New-Variable'        = Get-Command -Name New-Variable        -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Out-Null'            = Get-Command -Name Out-Null            -Module $outNullModule                  -CommandType Cmdlet -ErrorAction Stop
    'Out-String'          = Get-Command -Name Out-String          -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Pop-Location'        = Get-Command -Name Pop-Location        -Module Microsoft.PowerShell.Management -CommandType Cmdlet -ErrorAction Stop
    'Push-Location'       = Get-Command -Name Push-Location       -Module Microsoft.PowerShell.Management -CommandType Cmdlet -ErrorAction Stop
    'Remove-Item'         = Get-Command -Name Remove-Item         -Module Microsoft.PowerShell.Management -CommandType Cmdlet -ErrorAction Stop
    'Remove-PSBreakpoint' = Get-Command -Name Remove-PSBreakpoint -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Remove-PSDrive'      = Get-Command -Name Remove-PSDrive      -Module Microsoft.PowerShell.Management -CommandType Cmdlet -ErrorAction Stop
    'Remove-Variable'     = Get-Command -Name Remove-Variable     -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Resolve-Path'        = Get-Command -Name Resolve-Path        -Module Microsoft.PowerShell.Management -CommandType Cmdlet -ErrorAction Stop
    'Select-Object'       = Get-Command -Name Select-Object       -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Set-Content'         = Get-Command -Name Set-Content         -Module Microsoft.PowerShell.Management -CommandType Cmdlet -ErrorAction Stop
    'Set-PSBreakpoint'    = Get-Command -Name Set-PSBreakpoint    -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Set-StrictMode'      = Get-Command -Name Set-StrictMode      -Module Microsoft.PowerShell.Core       -CommandType Cmdlet -ErrorAction Stop
    'Set-Variable'        = Get-Command -Name Set-Variable        -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Sort-Object'         = Get-Command -Name Sort-Object         -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Split-Path'          = Get-Command -Name Split-Path          -Module Microsoft.PowerShell.Management -CommandType Cmdlet -ErrorAction Stop
    'Start-Sleep'         = Get-Command -Name Start-Sleep         -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Test-Path'           = Get-Command -Name Test-Path           -Module Microsoft.PowerShell.Management -CommandType Cmdlet -ErrorAction Stop
    'Where-Object'        = Get-Command -Name Where-Object        -Module Microsoft.PowerShell.Core       -CommandType Cmdlet -ErrorAction Stop
    'Write-Error'         = Get-Command -Name Write-Error         -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Write-Progress'      = Get-Command -Name Write-Progress      -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Write-Verbose'       = Get-Command -Name Write-Verbose       -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'Write-Warning'       = Get-Command -Name Write-Warning       -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
    'New-TimeSpan'        = Get-Command -Name New-TimeSpan        -Module Microsoft.PowerShell.Utility    -CommandType Cmdlet -ErrorAction Stop
}

# little sanity check to make sure we don't blow up a system with a typo up there
# (not that I've EVER done that by, for example, mapping New-Item to Remove-Item...)

foreach ($keyValuePair in $script:SafeCommands.GetEnumerator()) {
    if ($keyValuePair.Key -ne $keyValuePair.Value.Name) {
        throw "SafeCommands entry for $($keyValuePair.Key) does not hold a reference to the proper command."
    }
}

$moduleRoot = & $script:SafeCommands['Split-Path'] -Path $MyInvocation.MyCommand.Path

"$moduleRoot\Functions\*.ps1" |
& $script:SafeCommands['Resolve-Path'] |
& $script:SafeCommands['Where-Object'] { -not ($_.ProviderPath.ToLower().Contains(".tests.")) } |
& $script:SafeCommands['ForEach-Object'] { . $_.ProviderPath }

function Invoke-NessusOpenPorts {
<#
.SYNOPSIS
This module consumes nessus files and output the open ports detected on the host

.PARAMETER Nessu
The location of the nessus file(s)

.PARAMETER packagename
The Name of the package

.PARAMETER outPut
The location you want the output

.EXAMPLE

.LINK

.VERSION
2.0.0 (01.05.2016)
    -Refactor the code to include better functions, unit testing, and modulized the code base
1.0.0 ()
    -Intial Release

#>

    [CmdletBinding(DefaultparameterSetName="None")]
    Param(
        [Parameter(Mandatory=$true,Position=0,HelpMessage="Location of Nessus File")]
        [ValidateNotNull()]
        [string]$Nessus,

        [Parameter(Mandatory=$true,Position=2,HelpMessage="Provide the name of the package for report generation")]
        [ValidateNotNull()]
        [string]$packagename,

        [Parameter(Mandatory=$true,Position=1,HelpMessage="You must provide the folder path for the report")]
        [ValidateNotNull()]
        [string]$outPut,

        [Parameter(Mandatory=$false,Position=1,HelpMessage="Recursive switch for get nessus files")]
        [switch]$recursive


    )

    BEGIN {
        # initialize global variables
        $script:start = & $script:SafeCommands['Get-Date']
        $script:dateObject = & $script:SafeCommands['new-object'] system.globalization.datetimeformatinfo
        $script:_output = $outPut.Trim('"').Trim("'")
        $script:reportName = "$($packagename)_OpenPorts_$($script:start.Day)$($script:dateObject.GetMonthName($script:start.Month))$($script:start.Year).csv"
        $script:reportNoPortName = "$($packagename)_NoOpenPorts_$($script:start.Day)$($script:dateObject.GetMonthName($script:start.Month))$($script:start.Year).csv"

        Try {
            & $script:SafeCommands['Write-Verbose'] -Message "BEGIN BLOCK - Start Time: $($script:start)"
            & $script:SafeCommands['Write-Verbose'] -Message "BEGIN BLOCK - Creating Output Directory: $($script:_output)"
            Get-OutPutDir -Path $script:_output -ErrorAction Stop -ErrorVariable ERRORBEGINCHECKOUTPUTDIR
            & $script:SafeCommands['Write-Verbose'] -Message "BEGIN BLOCK - Looking for Nessus Files"
            if($recursive) {
                $script:nessusFileList = GET-NessusFile -Path $NESSUS -recursive -ErrorAction Stop -ErrorVariable ERRORBEGINGETNESSUSFILES
            }
            else {
                $script:nessusFileList = GET-NessusFile -Path $NESSUS -ErrorAction Stop -ErrorVariable ERRORBEGINGETNESSUSFILES
            }
            & $script:SafeCommands['Write-Verbose'] -Message "Found $($script:nessusFileList.Count) Nesssus File(s)"
            & $script:SafeCommands['Write-Verbose'] -Message "BEGIN BLOCK - End time: $(& $script:SafeCommands['Get-Date'])"
        }
        Catch {
            & $script:SafeCommands['Write-Verbose'] -Message "BEGIN BLOCK - Something has gone wrong"
            if($ERRORBEGINCHECKOUTPUTDIR) {
                & $script:SafeCommands['Write-Verbose'] -Message "BEGIN BLOCK - Could not create output directory at $($script:_output)"
                & $script:SafeCommands['Write-Verbose'] -Message "BEGIN BLOCK - Running Time Before Error: $(Get-Timediff -start $script:start -end $(& $script:SafeCommands['Get-Date']))"
                Throw $ERRORBEGINCHECKOUTPUTDIR[1]
            }
            if($ERRORBEGINGETNESSUSFILES) {
                & $script:SafeCommands['Write-Verbose'] -Message "BEGIN BLOCK - Cannot find $($Nessus)"
                & $script:SafeCommands['Write-Verbose'] -Message "BEGIN BLOCK - Running Time Before Error: $(Get-Timediff -start $script:start -end $(& $script:SafeCommands['Get-Date']))"
                Throw $ERRORBEGINGETNESSUSFILES
            }
        }
    }
    Process {
        Try {
            & $script:SafeCommands['Write-Verbose'] -Message "PROCESS BLOCK - Start Time: $(& $script:SafeCommands['Get-Date'])"
            & $script:SafeCommands['Write-Verbose'] -Message "PROCESS BLOCK - Starting to process Nessus Files"
            $Script:compiledNessusObjReal = @()
            $Script:noportsDetectedReal = @()
            foreach($script:file in $script:nessusFileList) {
                & $script:SafeCommands['Write-Verbose'] -Message "PROCESS BLOCK - Processing: $($script:file.Name)"
                $Script:compiledNessusObj, $Script:noportsDetected = $(Import-NessusOpenPortsPlugin -file $script:file -ErrorAction Stop -ErrorVariable ERRORPROCESSPROCESSNESSUSFILE)
                $Script:compiledNessusObjReal += $Script:compiledNessusObj
                $Script:noportsDetectedReal += $Script:noportsDetected
            }
            & $script:SafeCommands['Write-Verbose'] -Message "PROCESS BLOCK - End Time: $(& $script:SafeCommands['Get-Date'])"
        }
        Catch{
            & $script:SafeCommands['Write-Verbose'] -Message "PROCESS BLOCK - Something has gone wrong"
            if($ERRORPROCESSPROCESSNESSUSFILE) {
                & $script:SafeCommands['Write-Verbose'] -Message "PROCESS BLOCK - $($script:file.FullName) did not validate as a proper Nessus File"
                & $script:SafeCommands['Write-Verbose'] -Message "PROCESS BLOCK - Running Time Before Error: $(Get-Timediff -start $script:start -end $(& $script:SafeCommands['Get-Date']))"
                Throw $ERRORPROCESSPROCESSNESSUSFILE[1]
            }
        }
    }
    END {
        $Script:end = & $script:SafeCommands['Get-Date']
        Try{
            & $script:SafeCommands['Write-Verbose'] -Message "END BLOCK - Start Time: $(& $script:SafeCommands['Get-Date'])"
            & $script:SafeCommands['Write-Verbose'] -Message "END BLOCK - Exporting Open Ports to: $($script:_output)\$script:reportName"
            $Script:compiledNessusObjReal | Export-Csv -Path "$($script:_output)\$script:reportName" -NoTypeInformation -ErrorAction Stop -ErrorVariable ERRORENDCREATECSVREPORT
            if($Script:noportsDetectedReal) {
                $Script:noportsDetectedReal | Export-Csv -Path "$($script:_output)\$script:reportNoPortName" -NoTypeInformation -ErrorAction Stop -ErrorVariable ERRORENDCREATECSVREPORT
            }
            & $script:SafeCommands['Write-Verbose'] -Message "END BLOCK - End Time: $(& $script:SafeCommands['Get-Date'])"
            & $script:SafeCommands['Write-Verbose'] -Message "END BLOCK - Total Script Run Time: $(Get-Timediff -start $script:start -end $Script:end)"
        }
        Catch{
            & $script:SafeCommands['Write-Verbose'] -Message  "END BLOCK - Something has gone wrong"
            if($ERRORENDCREATECSVREPORT) {
                & $script:SafeCommands['Write-Verbose'] -Message "END BLOCK - Could not create Report"
                & $script:SafeCommands['Write-Verbose'] -Message "PROCESS BLOCK - Running Time Before Error: $(Get-Timediff -start $script:start -end $Script:end))"
                Throw $ERRORENDCREATECSVREPORT
            }
        }
    }
}
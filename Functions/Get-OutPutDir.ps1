function Get-OutPutDir {
<#
.SYNOPSIS
This function looks to see if the path provided exsists. if not it will be created

.PARAMETER Path
Path to look for

.EXAMPLE

.LINK

.VERSION
1.0.0 (01.05.2016)
    -Intial Release

#>

    [cmdletBinding()]
    Param(
        [ValidateNotNull()]
        [string]$Path = $(Throw "No Path Provided")
    )
    if (& $SafeCommands['Test-Path'] $Path) {
        return 'Path Exsits'
    }
    else {
        & $SafeCommands['New-Item'] -ItemType directory -Path $Path | Out-Null
        return 'Created Path'
    }

}

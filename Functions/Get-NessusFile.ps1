function Get-NessusFile {
<#
.SYNOPSIS
This function looks in the provided directory(s) and returns all files that end in .nessus

.PARAMETER Path
The location of the nessus file(s)

.PARAMETER recurse
This is a switch and tells the function if it should traverse the path that it was given looking for all
nessus files

.EXAMPLE

.LINK

.VERSION
1.0.0 (01.05.2016)
    -Intial Release

#>
    [cmdletBinding()]
    Param(
        [ValidateNotNull()]
        [string]$Path = $(Throw "No Path Provided"),

        [Parameter(Mandatory = $false)]
        [switch]$recursive
    )
    if($recursive){
        $Private:listing = & $SafeCommands['Get-ChildItem'] -Path $Path -Filter "*.nessus" -Recurse
    }
    else{
        $Private:listing = & $SafeCommands['Get-ChildItem'] -Path $Path -Filter "*.nessus"
    }
    if(!($Private:listing)){
        Throw "No Nessus Files Found"
    }
    else{
        return $Private:listing
    }
}

function Get-NessusFile {
<#
.SYNOPSIS

.PARAMETER Path
The location of the nessus file(s)

.PARAMETER recurse
This is a switch and tells the function if it should traverse the path that it was given looking for all
nessus files

.EXAMPLE

.LINK

.VERSION
1.0.0

#>
    [cmdletBinding()]
    Param(
        [Paramter(Mandatory = $true)]
        [string]$Path,

        [Paramter(Mandatory = $false)]
        [switch]$recurse
    )
    $Script:SafeCommands['Get-Right']
    if($recursive){
        $Private:listing = Get-ChildItem -Path $Path -Filter "*.nessus" -Recurse
    }
    else{
        $Private:listing = Get-ChildItem -Path $Path -Filter "*.nessus"
    }
    if(!($Private:listing)){
        Throw "No Nessus Files Found"
    }
    else{
        return $Private:listing
    }
}

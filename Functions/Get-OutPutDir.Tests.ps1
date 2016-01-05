$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

$moduleName = "nessusOpenPorts"

Import-Module "..\$($moduleName)"
InModuleScope nessusOpenPorts {
    Describe "Get-OutPutDir" {
        Setup -Dir Temp

        It "should return Path Exsits" {
            Get-OutPutDir -Path TestDrive:\Temp | Should Be 'Path Exsits'
        }

        It "should return Created Path" {
            Get-OutPutDir -Path TestDrive:\Test | Should Be 'Created Path'
        }

        It "Should Throw No Path Provided" {
            {Get-OutPutDir} | Should Throw "No Path Provided"
        }
    }
}
Remove-Module $moduleName

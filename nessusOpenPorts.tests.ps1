$here = Split-Path -Parent $MyInvocation.MyCommand.Path

$manifestPath = "$here\nessusOpenPorts.psd1"
$changeLogPath = "$here\CHANGELOG.md"
$guidCheck = '9cf0111c-2993-4826-8c5c-c2076bffcb20'
$moduletName = 'nessusOpenPorts'
$tempPath = "H:\Powershell\Modules\Custom\NessusOpenPorts"

# General manifest annd Changelog checks
Describe -Tags 'VersionChecks' "nessusOpenPorts manifest and changelog" {
    $Script:manifest - $null
        It "has a valid manifest" {
            {
                $Script:manifest = Test-ModuleManifest -Path $manifestPath -ErrorAction Stop -WarningAction SilentlyContinue 
            } | Should Not Throw
        }

        It "has a valid name in the manifest" {
            $Script:manifest.Name | Should Be $moduletName
        }
        
        It "has a valid guid in the manifest" {
            $Script:manifest.Guid | Should Be $guidCheck
        }

        It "has a version listed in the manifest" {
            $Script:manifest.Version -as [version] | Should Not BeNullOrEmpty
        }

        $Script:changeLogVersion = $null
        It "has a valid version in the changelog" {
            foreach ($line in (Get-Content $changeLogPath)) {
                if ($line -match "^\D*(?<Version>(\d+\.){1,3}\d+)") {
                    $Script:changeLogVersion = $matches.Version
                    break
                }
            }
            $Script:changeLogVersion | Should Not BeNullOrEmpty
            $Script:changeLogVersion -as [Version] | Should Not BeNullOrEmpty
        }

        It "changelog and manifest versions are the same" {
            $Script:changeLogVersion -as [Version] | Should Be ($Script:manifest.Version -as [Version])
        }
}

# General env Checks

# all commands are called from the safe command table
Import-Module "$((Get-Location).Path)\$($moduletName)"
InModuleScope nessusOpenPorts {
    Describe 'SafeCommands table' {
        $path = $ExecutionContext.SessionState.Module.ModuleBase
        $filesToCheck = Get-ChildItem -Path $path -Recurse -Include *.ps1,*.psm1 -Exclude *.Tests.ps1
        $i = 0
        $callsToSafeCommands = @(
            foreach ($file in $filesToCheck) {
                $i += 1
                $tokens = $parseErrors = $null
                $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref] $tokens, [ref] $parseErrors)
                #Write-Host $ast
                $filter = {
                    $args[0] -is [System.Management.Automation.Language.CommandAst] -and
                    $args[0].InvocationOperator -eq [System.Management.Automation.Language.TokenKind]::Ampersand -and
                    $args[0].CommandElements[0] -is [System.Management.Automation.Language.IndexExpressionAst] -and
                    $args[0].CommandElements[0].Target -is [System.Management.Automation.Language.VariableExpressionAst] -and
                    $args[0].CommandElements[0].Target.VariablePath.UserPath -match '^(?:script:)?SafeCommands$'
                }

                $ast.FindAll($filter, $true)
                #Write-Host $ast.FindAll($filter, $true) $i
            }
        )
        #write-host $callsToSafeCommands.GetType()
        $uniqueSafeCommands = $callsToSafeCommands | ForEach-Object { $_.CommandElements[0].Index.Value } | Select-Object -Unique
        #write-host $callsToSafeCommands
        $missingSafeCommands = $uniqueSafeCommands | Where-Object { -not $script:SafeCommands.ContainsKey($_) }

        It 'The SafeCommands table contains all commands that are called from the module' {
            $missingSafeCommands | Should Be $null
        }
    }
}

# Style Enforcement
Describe 'Style rules' {
    #$moduleRoot = (Get-Module $moduletName).ModuleBase $tempPath

    $files = @(
        Get-ChildItem "$((Get-Location).Path)" -Include *ps1, *psm1
        Get-ChildItem "$((Get-Location).Path)\Functions" -Include *.ps1, *.psm1 -Recurse
    )

    It "$($moduletName) source files contain no trailing whitespace" {
        $badLines = @(
            foreach ($file in $files) {
                $lines = [System.IO.File]::ReadAllLines($file.FullName)
                $lineCount = $lines.Count

                for ($i = 0; $i -lt $lineCount; $i++) {
                    if ($lines[$i] -match '\s+$') {
                        'File: {0}, Line: {1}' -f $file.FullName, ($i + 1)
                    }
                }
            }
        )

        if ($badLines.Count -gt 0) {
            Throw "The following $($badLines.Count) lines contain trailing whitespace: `r`n`r`n$($badLines -join '`r`n')"
        }
    }

    It "$($moduletName) source files all end with a new line" {
        $badFiles = @(
            foreach ($file in $files) {
                $string = [System.IO.File]::ReadAllText($file.FullName)
                if ($string.Length -gt 0 -and $string[-1] -ne "`n") {
                    $file.FullName
                }
            }
        )

        if ($badFiles.Count -gt 0) {
            throw "The following files fo not end with newline: `r`n`r`n$($badFiles -join '`r`n')"
        }
    }
}
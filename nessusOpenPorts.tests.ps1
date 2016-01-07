﻿$here = Split-Path -Parent $MyInvocation.MyCommand.Path

$manifestPath = "$here\nessusOpenPorts.psd1"
$changeLogPath = "$here\CHANGELOG.md"
$guidCheck = '9cf0111c-2993-4826-8c5c-c2076bffcb20'
$moduleName = 'nessusOpenPorts'
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
            $Script:manifest.Name | Should Be $moduleName
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

# Module Checks
Import-Module "$((Get-Location).Path)\$($moduleName)"
Describe "Invoke-NessusOpenPorts" {
        Setup -File sample.nessus
        Setup -File anothersample.nessus
        Setup -File sample2.nessus
        Setup -File sample3.nessus
        Setup -File sample4.nessus

        Setup -Dir Test

        Set-Content -Path TestDrive:\sample.nessus -Value @'
<?xml version="1.0" ?>
<NessusClientData_v2>
	<Policy>
		<policyName>
		</policyName>
		<Preferences>
		</Preferences>
		<FamilySelection>
		</FamilySelection>
		<IndividualPluginSelection>
		</IndividualPluginSelection>
	</Policy>
	<Report name="Test Scan" xmlns:cm="http://wwww.nessus.org/cm">
		<ReportHost name="192.168.1.1">
			<HostProperties>
				<tag name="Credentialed_Scan">true</tag>
				<tag name="host-ip">192.168.1.1</tag>
				<tag name="host-fq">randomhost1.randomsubdomain.randomdomain</tag>
			</HostProperties>
			<ReportItem port="2868" svc_name="npep-messaging?" protocol="tcp" severity="0" pluginID="25221" pluginName="Remote listeners enumeration (Linux / AIX)" pluginFamily="Service detection">

				<agent>unix</agent>

				<description>Remote listeners enumeration (Sample Description)</description>

				<fname>process_on_port.nasl</fname>

				<plugin_modification_date>2015/06/02</plugin_modification_date>

				<plugin_name>Remote listeners enumeration (Linux / AIX)</plugin_name>

				<plugin_publication_date>2007/05/16</plugin_publication_date>

				<plugin_type>local</plugin_type>

				<risk_factor>None</risk_factor>

				<script_version>1.17</script_version>

				<solution>n/a</solution>

				<synopsis>Using the supplied credentials, it is possible to identify the process listening on the remote port.</synopsis>

				<plugin_output>
  Process id   : 2544
  Executable   : /opt/vmware/sbin/vami-lighttpd
  Command line : /opt/vmware/sbin/vami-lighttpd -f /opt/vmware/etc/lighttpd/lighttpd.conf </plugin_output>

			</ReportItem>
			<ReportItem port="514" svc_name="syslog?" protocol="udp" severity="0" pluginID="25221" pluginName="Remote listeners enumeration (Linux / AIX)" pluginFamily="Service detection">

				<agent>unix</agent>

				<description>Remote listeners enumeration (Sample Description)</description>

				<fname>process_on_port.nasl</fname>

				<plugin_modification_date>2015/06/02</plugin_modification_date>

				<plugin_name>Remote listeners enumeration (Linux / AIX)</plugin_name>

				<plugin_publication_date>2007/05/16</plugin_publication_date>

				<plugin_type>local</plugin_type>

				<risk_factor>None</risk_factor>

				<script_version>1.17</script_version>

				<solution>n/a</solution>

				<synopsis>Using the supplied credentials, it is possible to identify the process listening on the remote port.</synopsis>

				<plugin_output>  Process id   : 2118
  Executable   : /sbin/syslog-ng
  Command line : /sbin/syslog-ng </plugin_output>

			</ReportItem>
		</ReportHost>
		<ReportHost name="192.168.1.2">
			<HostProperties>
				<tag name="Credentialed_Scan">true</tag>
				<tag name="host-ip">192.168.1.2</tag>
				<tag name="host-fq">randomhost2.randomsubdomain.randomdomain</tag>
			</HostProperties>
			<ReportItem port="445" svc_name="cifs" protocol="tcp" severity="0" pluginID="34252" pluginName="Microsoft Windows Remote Listeners Enumeration (WMI)" pluginFamily="Windows">

				<description>WMI (Sample Description)</description>

				<fname>wmi_process_on_port.nbin</fname>

				<plugin_modification_date>2015/08/24</plugin_modification_date>

				<plugin_name>Microsoft Windows Remote Listeners Enumeration (WMI)</plugin_name>

				<plugin_publication_date>2008/09/23</plugin_publication_date>

				<plugin_type>local</plugin_type>

				<risk_factor>None</risk_factor>

				<script_version>$Revision: 1.32 $</script_version>

				<solution>n/a</solution>

				<synopsis>It is possible to obtain the names of processes listening on the remote UDP and TCP ports.</synopsis>

				<plugin_output>
The Win32 process &apos;System&apos; is listening on this port (pid 4).</plugin_output>
			</ReportItem>

			<ReportItem port="49152" svc_name="dce-rpc" protocol="tcp" severity="0" pluginID="34252" pluginName="Microsoft Windows Remote Listeners Enumeration (WMI)" pluginFamily="Windows">

				<description>WMI (Sample Description)</description>

				<fname>wmi_process_on_port.nbin</fname>

				<plugin_modification_date>2015/08/24</plugin_modification_date>

				<plugin_name>Microsoft Windows Remote Listeners Enumeration (WMI)</plugin_name>

				<plugin_publication_date>2008/09/23</plugin_publication_date>

				<plugin_type>local</plugin_type>

				<risk_factor>None</risk_factor>

				<script_version>$Revision: 1.32 $</script_version>

				<solution>n/a</solution>

				<synopsis>It is possible to obtain the names of processes listening on the remote UDP and TCP ports.</synopsis>

				<plugin_output>
The Win32 process &apos;wininit.exe&apos; is listening on this port (pid 488).</plugin_output>

			</ReportItem>

		</ReportHost>
		<ReportHost name="192.168.1.3">
			<HostProperties>
				<tag name="Credentialed_Scan">true</tag>
				<tag name="host-ip">192.168.1.3</tag>
				<tag name="host-fq">randomhost3.randomsubdomain.randomdomain</tag>
			</HostProperties>
		</ReportHost>
	</Report>
</NessusClientData_v2>
'@
        Set-Content -Path TestDrive:\sample2.nessus -Value @'
<?xml version="1.0" encoding="UTF-8"?>
<note>
	<to>Tove</to>
	<from>Jani</from>
	<heading>Reminder</heading>
	<body>Don't forget me this weekend!</body>
</note>
'@

        Set-Content -Path TestDrive:\sample3.nessus -Value @'
<?xml version="1.0" ?>
<NessusClientData_v2>
	<Policy>
		<policyName>
		</policyName>
		<Preferences>
		</Preferences>
		<FamilySelection>
		</FamilySelection>
		<IndividualPluginSelection>
		</IndividualPluginSelection>
	</Policy>
	<Report name="Test Scan" xmlns:cm="http://wwww.nessus.org/cm">
		<ReportHost name="192.168.1.1">
			<HostProperties>
				<tag name="Credentialed_Scan">true</tag>
				<tag name="host-ip">192.168.1.1</tag>
				<tag name="host-fq">randomhost1.randomsubdomain.randomdomain</tag>
			</HostProperties>
			<ReportItem port="2868" svc_name="npep-messaging?" protocol="tcp" severity="0" pluginID="34252" pluginName="Remote listeners enumeration (Linux / AIX)" pluginFamily="Service detection">

				<agent>unix</agent>

				<description>Remote listeners enumeration (Sample Description)</description>

				<fname>process_on_port.nasl</fname>

				<plugin_modification_date>2015/06/02</plugin_modification_date>

				<plugin_name>Remote listeners enumeration (Linux / AIX)</plugin_name>

				<plugin_publication_date>2007/05/16</plugin_publication_date>

				<plugin_type>local</plugin_type>

				<risk_factor>None</risk_factor>

				<script_version>1.17</script_version>

				<solution>n/a</solution>

				<synopsis>Using the supplied credentials, it is possible to identify the process listening on the remote port.</synopsis>

				<plugin_output>
  Process id   : 2544
  Executable   : /opt/vmware/sbin/vami-lighttpd
  Command line : /opt/vmware/sbin/vami-lighttpd -f /opt/vmware/etc/lighttpd/lighttpd.conf </plugin_output>

			</ReportItem>
			<ReportItem port="514" svc_name="syslog?" protocol="udp" severity="0" pluginID="34252" pluginName="Remote listeners enumeration (Linux / AIX)" pluginFamily="Service detection">

				<agent>unix</agent>

				<description>Remote listeners enumeration (Sample Description)</description>

				<fname>process_on_port.nasl</fname>

				<plugin_modification_date>2015/06/02</plugin_modification_date>

				<plugin_name>Remote listeners enumeration (Linux / AIX)</plugin_name>

				<plugin_publication_date>2007/05/16</plugin_publication_date>

				<plugin_type>local</plugin_type>

				<risk_factor>None</risk_factor>

				<script_version>1.17</script_version>

				<solution>n/a</solution>

				<synopsis>Using the supplied credentials, it is possible to identify the process listening on the remote port.</synopsis>

				<plugin_output>  Process id   : 2118
  Executable   : /sbin/syslog-ng
  Command line : /sbin/syslog-ng </plugin_output>

			</ReportItem>
		</ReportHost>
		<ReportHost name="192.168.1.2">
			<HostProperties>
				<tag name="Credentialed_Scan">true</tag>
				<tag name="host-ip">192.168.1.2</tag>
				<tag name="host-fq">randomhost2.randomsubdomain.randomdomain</tag>
			</HostProperties>
			<ReportItem port="445" svc_name="cifs" protocol="tcp" severity="0" pluginID="11111" pluginName="Microsoft Windows Remote Listeners Enumeration (WMI)" pluginFamily="Windows">

				<description>WMI (Sample Description)</description>

				<fname>wmi_process_on_port.nbin</fname>

				<plugin_modification_date>2015/08/24</plugin_modification_date>

				<plugin_name>Microsoft Windows Remote Listeners Enumeration (WMI)</plugin_name>

				<plugin_publication_date>2008/09/23</plugin_publication_date>

				<plugin_type>local</plugin_type>

				<risk_factor>None</risk_factor>

				<script_version>$Revision: 1.32 $</script_version>

				<solution>n/a</solution>

				<synopsis>It is possible to obtain the names of processes listening on the remote UDP and TCP ports.</synopsis>

				<plugin_output>
The Win32 process &apos;System&apos; is listening on this port (pid 4).</plugin_output>
			</ReportItem>

			<ReportItem port="49152" svc_name="dce-rpc" protocol="tcp" severity="0" pluginID="11111" pluginName="Microsoft Windows Remote Listeners Enumeration (WMI)" pluginFamily="Windows">

				<description>WMI (Sample Description)</description>

				<fname>wmi_process_on_port.nbin</fname>

				<plugin_modification_date>2015/08/24</plugin_modification_date>

				<plugin_name>Microsoft Windows Remote Listeners Enumeration (WMI)</plugin_name>

				<plugin_publication_date>2008/09/23</plugin_publication_date>

				<plugin_type>local</plugin_type>

				<risk_factor>None</risk_factor>

				<script_version>$Revision: 1.32 $</script_version>

				<solution>n/a</solution>

				<synopsis>It is possible to obtain the names of processes listening on the remote UDP and TCP ports.</synopsis>

				<plugin_output>
The Win32 process &apos;wininit.exe&apos; is listening on this port (pid 488).</plugin_output>

			</ReportItem>

		</ReportHost>
	</Report>
</NessusClientData_v2>
'@

        Set-Content -Path TestDrive:\sample4.nessus -Value  @'
<?xml version="1.0" ?>
<NessusClientData_v2>
	<Policy>
		<policyName>
		</policyName>
		<Preferences>
		</Preferences>
		<FamilySelection>
		</FamilySelection>
		<IndividualPluginSelection>
		</IndividualPluginSelection>
	</Policy>
	<Report name="Test Scan" xmlns:cm="http://wwww.nessus.org/cm">
		<ReportHost name="192.168.1.1">
			<HostProperties>
				<tag name="Credentialed_Scan">true</tag>
				<tag name="host-ip">192.168.1.1</tag>
				<tag name="host-fq">randomhost1.randomsubdomain.randomdomain</tag>
			</HostProperties>
			<ReportItem port="2868" svc_name="npep-messaging?" protocol="tcp" severity="0" pluginID="25221" pluginName="Remote listeners enumeration (Linux / AIX)" pluginFamily="Service detection">

				<agent>unix</agent>

				<description>Remote listeners enumeration (Sample Description)</description>

				<fname>process_on_port.nasl</fname>

				<plugin_modification_date>2015/06/02</plugin_modification_date>

				<plugin_name>Remote listeners enumeration (Linux / AIX)</plugin_name>

				<plugin_publication_date>2007/05/16</plugin_publication_date>

				<plugin_type>local</plugin_type>

				<risk_factor>None</risk_factor>

				<script_version>1.17</script_version>

				<solution>n/a</solution>

				<synopsis>Using the supplied credentials, it is possible to identify the process listening on the remote port.</synopsis>

				<plugin_output>
  Process id   : 2544
  Executable   : /opt/vmware/sbin/vami-lighttpd
  Command line : /opt/vmware/sbin/vami-lighttpd -f /opt/vmware/etc/lighttpd/lighttpd.conf </plugin_output>

			</ReportItem>
			<ReportItem port="514" svc_name="syslog?" protocol="udp" severity="0" pluginID="25221" pluginName="Remote listeners enumeration (Linux / AIX)" pluginFamily="Service detection">

				<agent>unix</agent>

				<description>Remote listeners enumeration (Sample Description)</description>

				<fname>process_on_port.nasl</fname>

				<plugin_modification_date>2015/06/02</plugin_modification_date>

				<plugin_name>Remote listeners enumeration (Linux / AIX)</plugin_name>

				<plugin_publication_date>2007/05/16</plugin_publication_date>

				<plugin_type>local</plugin_type>

				<risk_factor>None</risk_factor>

				<script_version>1.17</script_version>

				<solution>n/a</solution>

				<synopsis>Using the supplied credentials, it is possible to identify the process listening on the remote port.</synopsis>

				<plugin_output>  Process id   : 2118
  Executable   : /sbin/syslog-ng
  Command line : /sbin/syslog-ng </plugin_output>

			</ReportItem>
		</ReportHost>
		<ReportHost name="192.168.1.2">
			<HostProperties>
				<tag name="Credentialed_Scan">false</tag>
				<tag name="host-ip">192.168.1.2</tag>
				<tag name="host-fq">randomhost2.randomsubdomain.randomdomain</tag>
			</HostProperties>
			<ReportItem port="445" svc_name="cifs" protocol="tcp" severity="0" pluginID="34252" pluginName="Microsoft Windows Remote Listeners Enumeration (WMI)" pluginFamily="Windows">

				<description>WMI (Sample Description)</description>

				<fname>wmi_process_on_port.nbin</fname>

				<plugin_modification_date>2015/08/24</plugin_modification_date>

				<plugin_name>Microsoft Windows Remote Listeners Enumeration (WMI)</plugin_name>

				<plugin_publication_date>2008/09/23</plugin_publication_date>

				<plugin_type>local</plugin_type>

				<risk_factor>None</risk_factor>

				<script_version>$Revision: 1.32 $</script_version>

				<solution>n/a</solution>

				<synopsis>It is possible to obtain the names of processes listening on the remote UDP and TCP ports.</synopsis>

				<plugin_output>
The Win32 process &apos;System&apos; is listening on this port (pid 4).</plugin_output>
			</ReportItem>

			<ReportItem port="49152" svc_name="dce-rpc" protocol="tcp" severity="0" pluginID="34252" pluginName="Microsoft Windows Remote Listeners Enumeration (WMI)" pluginFamily="Windows">

				<description>WMI (Sample Description)</description>

				<fname>wmi_process_on_port.nbin</fname>

				<plugin_modification_date>2015/08/24</plugin_modification_date>

				<plugin_name>Microsoft Windows Remote Listeners Enumeration (WMI)</plugin_name>

				<plugin_publication_date>2008/09/23</plugin_publication_date>

				<plugin_type>local</plugin_type>

				<risk_factor>None</risk_factor>

				<script_version>$Revision: 1.32 $</script_version>

				<solution>n/a</solution>

				<synopsis>It is possible to obtain the names of processes listening on the remote UDP and TCP ports.</synopsis>

				<plugin_output>
The Win32 process &apos;wininit.exe&apos; is listening on this port (pid 488).</plugin_output>

			</ReportItem>

		</ReportHost>
	</Report>
</NessusClientData_v2>
'@
    $dateObject = new-object system.globalization.datetimeformatinfo
    $date = Get-Date

    It "[End Block] should create a csv export" {
        Invoke-NessusOpenPorts -Nessus TestDrive:\sample.nessus -packagename "Test" -outPut TestDrive:\
        $report = Get-Item -Path "TestDrive:\Test_OpenPorts_$($date.Day)$($dateObject.GetMonthName($date.Month))$($date.Year).csv" 
        $report.name | Should Be "Test_OpenPorts_$($date.Day)$($dateObject.GetMonthName($date.Month))$($date.Year).csv"
    }

    It "[End Block] csv should have 4 total detected open ports" {
        Invoke-NessusOpenPorts -Nessus TestDrive:\sample.nessus -packagename "Test" -outPut TestDrive:\
        $report = Import-Csv -Path "TestDrive:\Test_OpenPorts_$($date.Day)$($dateObject.GetMonthName($date.Month))$($date.Year).csv"
        $report.Count | Should Be 4
    }

    It "[End Block] csv should find 2 plugins with ID 25221 (linux)" {
        Invoke-NessusOpenPorts -Nessus TestDrive:\sample.nessus -packagename "Test" -outPut TestDrive:\
        $report = Import-Csv -Path "TestDrive:\Test_OpenPorts_$($date.Day)$($dateObject.GetMonthName($date.Month))$($date.Year).csv"
        $test = $report | Where-Object{$_.Plugin -eq 25221}
        $test.Count | Should Be 2
    }

    It "[End Block] csv should find 2 plugins with ID 34252 (windows)" {
        Invoke-NessusOpenPorts -Nessus TestDrive:\sample.nessus -packagename "Test" -outPut TestDrive:\
        $report = Import-Csv -Path "TestDrive:\Test_OpenPorts_$($date.Day)$($dateObject.GetMonthName($date.Month))$($date.Year).csv"
        $test = $report | Where-Object{$_.Plugin -eq 34252}
        $test.Count | Should Be 2
    }

    It "[End Block] csv should find 2 unique hosts" {
        Invoke-NessusOpenPorts -Nessus TestDrive:\sample.nessus -packagename "Test" -outPut TestDrive:\
        $report = Import-Csv -Path "TestDrive:\Test_OpenPorts_$($date.Day)$($dateObject.GetMonthName($date.Month))$($date.Year).csv"
        $test = $report | %{$_.IP} | Get-Unique
        $test.Count | Should Be 2
    }
    
    It "[End Block] should create a no open ports report" {
        Invoke-NessusOpenPorts -Nessus TestDrive:\sample.nessus -packagename "Test" -outPut TestDrive:\
        $report = Get-Item -Path "TestDrive:\Test_NoOpenPorts_$($date.Day)$($dateObject.GetMonthName($date.Month))$($date.Year).csv"
        $report.name | Should Be "Test_NoOpenPorts_$($date.Day)$($dateObject.GetMonthName($date.Month))$($date.Year).csv"
    }

    It "[End Block] should have 1 system in no open ports report" {
        Invoke-NessusOpenPorts -Nessus TestDrive:\sample.nessus -packagename "Test" -outPut TestDrive:\
        $report = Import-Csv -Path "TestDrive:\Test_NoOpenPorts_$($date.Day)$($dateObject.GetMonthName($date.Month))$($date.Year).csv"
        $report.("#text") | Should Be "192.168.1.3"
    }

    It "[Begin Block] should throw unable to create at provided path" {
        {Invoke-NessusOpenPorts -Nessus TestDrive:\sample.nessus -packagename "Test" -outPut TempDrive:\} | Should Throw "unable to create at provided path: TempDrive:\"
    }

    It "[Begin Block] should throw path not found" {
        {Invoke-NessusOpenPorts -Nessus TempDrive:\sample.nessus -packagename "Test" -outPut TestDrive:\} | Should Throw "path not found"
    }

    It "[Begin Block] should throw path not found (Recursive)" {
        {Invoke-NessusOpenPorts -Nessus TempDrive:\ -packagename "Test" -outPut TestDrive:\ -recursive} | Should Throw "path not found"
    }

    It "[Begin Block] should throw No Nessus Files Found" {
        {Invoke-NessusOpenPorts -Nessus TestDrive:\Test -packagename "Test" -outPut TestDrive:\ -recursive} | Should Throw "No Nessus Files Found"
    }

    It "[Process Block] should throw Not an XML Document" {
        {Invoke-NessusOpenPorts -Nessus TestDrive:\anothersample.nessus -packagename "Test" -outPut TestDrive:\} | Should Throw "$((Get-Item TestDrive:\anothersample.nessus).name) Not an XML Document"
    }

    It "[Process Block] should throw Not a Nessus File" {
        {Invoke-NessusOpenPorts -Nessus TestDrive:\sample2.nessus -packagename "Test" -outPut TestDrive:\} | Should Throw "$((Get-Item TestDrive:\sample2.nessus).name) Not a Nessus File"
    }

    It "[Process Block] should throw Not a credentialed Scan" {
        {Invoke-NessusOpenPorts -Nessus TestDrive:\sample4.nessus -packagename "Test" -outPut TestDrive:\} | Should Throw "$((Get-Item TestDrive:\sample4.nessus).name) Not a credentialed Scan"
    }
}
Remove-Module $moduleName

#Invoke-NessusOpenPorts

# General env Checks

# all commands are called from the safe command table
Import-Module "$((Get-Location).Path)\$($moduleName)"
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
Remove-Module $moduleName

# Style Enforcement
Describe 'Style rules' {

    $files = @(
        Get-ChildItem "$((Get-Location).Path)" -Include *ps1, *psm1
        Get-ChildItem "$((Get-Location).Path)\Functions" -Include *.ps1, *.psm1 -Recurse
    )

    It "$($moduleName) source files contain no trailing whitespace" {
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

    It "$($moduleName) source files all end with a new line" {
        $badFiles = @(
            foreach ($file in $files) {
                $string = [System.IO.File]::ReadAllText($file.FullName)
                if ($string.Length -gt 0 -and $string[-1] -ne "`n") {
                    $file.FullName
                }
            }
        )

        if ($badFiles.Count -gt 0) {
            throw "The following files do not end with newline: `r`n`r`n$($badFiles -join '`r`n')"
        }
    }
}

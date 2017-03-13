$date = Get-Date -Format g
$releaseNotes = @"
	What's New in Polution
	$date

	* Initial Version
"@

function Main {
	TestModule
	PublishModule
	TestModuleUpload
}

function TestModule {
	Invoke-Pester
}

function PublishModule {
	$NuGetApiKey = Read-Host 'What is the NuGetApi key?' -AsSecureString
	$NuGetApiKey = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
		[Runtime.InteropServices.Marshal]::SecureStringToBSTR($NuGetApiKey))


	$p = @{
		Path = [string] "$PSScriptRoot\Polution"
		NuGetApiKey = [string] $NuGetApiKey
	}

	# Publish-Module @p
}

function TestModuleUpload {
	$modules = Find-Module Polution
	if($modules.Length -eq 0){
		Write-Error "Could not find Polution in Powershell Gallery"
	}else if($modules.Length -ne 1){
		Write-Error "Found more than one Powershell Module Polution in Gallery"
	}
}

main
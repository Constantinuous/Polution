$releaseNotes = @"
	What's New in Polution
	$date

	* Initial Version

"@

function Main {
	TestModule
	PublishModule
}

function TestModule {
	Invoke-Pester
}

function PublishModule {
	$NuGetApiKey = Read-Host 'What is the NuGetApi key?' -AsSecureString
	$NuGetApiKey = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
		[Runtime.InteropServices.Marshal]::SecureStringToBSTR($NuGetApiKey))

	$date = Get-Date -Format g

	$p = @{
		Path = [string] "$PSScriptRoot\Polution"
		NuGetApiKey = [string] $NuGetApiKey
	}

	Publish-Module @p
}

main
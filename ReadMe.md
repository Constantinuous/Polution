# Polution

A Powershell Module to parse solutions (.sln) and project (.csproj, .vbproj) files.

## Use

### Short

* Download module `Install-Module -Name Polution`
* Import module `Import-Module Polution`
* Get the commands `Get-Command -Module Polution`
* Get help `Get-Help Get-Projects`

### Long

* Download Polution from [Powershell Gallery](https://www.powershellgallery.com/) via `Install-Module -Name Polution`
* You should now find Polution in your module script location `Get-ChildItem "C:\Program Files\WindowsPowerShell\Modules"`
* When you import a powershell module it looks in a couple of locations: `$Env:PSModulePath | Split-String ";"`
* Import the module `Import-Module Polution`
* Get the available commands `Get-Command -Module Polution`
* Or get the output of a specific command `(Get-Command Get-Projects).OutputType`
* And get help for a command `Get-Help Get-Projects` or specific examples `Get-Help Get-Projects -Examples`

## Test

* Run `Install-Module -Name Pester` to get pester from the Powershell Gallery
* Then run `Invoke-Pester`


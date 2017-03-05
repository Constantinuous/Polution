Import-Module $PSScriptRoot\Polution.psm1

Describe "BuildIfChanged" {
  Context "When there are changes" {
    $projects = Get-Projects "test\TestSolution\TestSolution.sln"

      It "Builds the next version" {
          ($projects).Count | Should Be 2
      }
    }
}
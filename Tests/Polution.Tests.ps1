using module Polution

if(Get-Module Polution){
	Remove-Module Polution
}

Import-Module $PSScriptRoot\..\Polution\Polution.psd1 -Force

$module = (Get-Module Polution)
Write-Host "Testing Module: $($module.Path) in Version $($module.Version)" -foregroundcolor "DarkCyan"

Describe "Blank Solution parsing" {
    [SolutionProject[]]$projects = Get-Projects "$PSScriptRoot\TestData\BlankSolution\BlankSolution.sln"

    It "Should find no projects" {
        ($projects).Count | Should Be 0
    }
}

Describe "Solution parsing" {
    $projects = Get-Projects "$PSScriptRoot\TestData\TestSolution\TestSolution.sln"

    It "Should find three projects" {
        ($projects).Count | Should Be 4
    }
}

Describe "Empty Project parsing" {
    $projectInfo = Get-ProjectInfo "$PSScriptRoot\TestData\TestSolution\Empty\Empty.csproj"

    It "Should determine correct name" {
        ($projectInfo).Name | Should Be "Empty.csproj"
    }
	
	It "Should not find content items" {
        ($projectInfo).Content.Length | Should Be 0
    }
	
	It "Should not find none items" {
        ($projectInfo).None.Length | Should Be 0
    }
	
	It "Should not find compile items" {
        ($projectInfo).Compile.Length | Should Be 0
    }
}

Describe "Test Project parsing" {
    [ProjectInfo] $projectInfo = Get-ProjectInfo "$PSScriptRoot\TestData\TestSolution\UnitTestProject\UnitTestProject.csproj"

    It "Should determine correct name" {
        ($projectInfo).Name | Should Be "UnitTestProject.csproj"
    }
	
	It "Should not find content items" {
        ($projectInfo).Content.Length | Should Be 0
    }
	
	It "Should not find none items" {
        ($projectInfo).None.Length | Should Be 0
    }
	
	It "Should find compile items" {
        ($projectInfo).Compile.Length | Should Be 2
    }
	
	It "Should find UnitTest" {
        ($projectInfo).Compile -contains "UnitTest1.cs" | Should Be $true
    }
	
	It "Should find AssemblyInfo" {
        ($projectInfo).Compile -contains "Properties\AssemblyInfo.cs" | Should Be $true
    }
}

Describe "Visual Basic Project parsing" {
    $projectInfo = Get-ProjectInfo "$PSScriptRoot\TestData\TestSolution\Web\Web.vbproj"

    It "Should determine correct name" {
        ($projectInfo).Name | Should Be "Web.vbproj"
    }

    It "Should determine correct language" {
        ($projectInfo).Language | Should Be ([Language]::VisualBasic)
    }

    It "Should find all content items" {
        ($projectInfo).Content.Length | Should Be 3
    }

    It "Should find all none items" {
        ($projectInfo).None.Length | Should Be 5
    }

    It "Should find all compile items" {
        ($projectInfo).Compile.Length | Should Be 7
    }

    It "Should find all publish profile items" {
        ($projectInfo).PublishProfile.Length | Should Be 1
    }

    It "Should find WebForm in project content" {
        ($projectInfo).Content -contains "WebForm1.aspx" | Should Be $true
    }

    It "Should find parameters.xml in project none" {
        ($projectInfo).None -contains "Parameters.xml" | Should Be $true
    }

    It "Should find Package publish profile in profiles" {
        ($projectInfo).PublishProfile -contains "My Project\PublishProfiles\Package.pubxml" | Should Be $true
    }
}

Describe "C Sharp Project parsing" {
    $projectInfo = Get-ProjectInfo "$PSScriptRoot\TestData\TestSolution\Job\Job.csproj"

    It "Should determine correct name" {
        ($projectInfo).Name | Should Be "Job.csproj"
    }

    It "Should find all content items" {
        ($projectInfo).Content.Length | Should Be 0
    }

    It "Should find all none items" {
        ($projectInfo).None.Length | Should Be 5
    }

    It "Should find all compile items" {
        ($projectInfo).Compile.Length | Should Be 2
    }

    It "Should find all publish profile items" {
        ($projectInfo).PublishProfile.Length | Should Be 1
    }

    It "Should find packages.config in project none" {
        ($projectInfo).None -contains "packages.config" | Should Be $true
    }

    It "Should find Package publish profile in profiles" {
        ($projectInfo).PublishProfile -contains "Properties\PublishProfiles\Package.pubxml" | Should Be $true
    }
}
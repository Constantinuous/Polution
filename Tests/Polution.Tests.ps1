Import-Module $PSScriptRoot\..\Polution -Force


Describe "Solution parsing" {
    [SolutionProject[]] $projects = Get-Projects "$PSScriptRoot\TestData\TestSolution\TestSolution.sln"

    It "Should find two projects" {
        ($projects).Count | Should Be 2
    }
}

Describe "Visual Basic Project parsing" {
    [ProjectInfo] $projectInfo = Get-ProjectInfo "$PSScriptRoot\TestData\TestSolution\Web\Web.vbproj"

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
    [ProjectInfo] $projectInfo = Get-ProjectInfo "$PSScriptRoot\TestData\TestSolution\Job\Job.csproj"

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
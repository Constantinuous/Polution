# Dot Source files
Get-ChildItem -Path $PSScriptRoot | Where { 
    $_.Extension -eq ".ps1" 
} | Foreach { 
    . $_.FullName 
}

<# 
 .SYNOPSIS
  Gets the projects in a solution.

 .DESCRIPTION
  Gets the projects in a solution. Parses a .sln file and returns the projects referenced by the solution in the form of a of [SolutionProject[]].

 .PARAMETER solutionFile
  The path to a solution (.sln) file.

 .EXAMPLE
   # Get the projectinfo for a solutio
   Get-Projects SomeSolution.sln
#>
function Get-Projects{
    [CmdletBinding()]    
    [OutputType([SolutionProject[]])] 
    param(
	    [Parameter(ValueFromPipeline, Position=1, Mandatory=0)]
	    [ValidateNotNullOrEmpty()]
	    [string[]] $solutionFile
    )
    process {
        if(!(Test-Path $solutionFile)){
            throw "Solution $solutionFile does not exist"
        }

        $content = Get-Content $solutionFile
	    $matchInfo = $content | Select-String -pattern "Project\(`"\{[\w-]*\}`"\) = `"([\w _]*.*)`", `"(.*\.(cs|vcx|vb)proj)`"" -AllMatches
		$matches = if($matchInfo){ $matchInfo.Matches } else { @() }
	
	    $solutionProjects = $matches | Foreach {
            $solutionProject = [SolutionProject]::new($_.Groups[1], $_.Groups[2])
        
            $solutionProject
        }

        $solutionProjects
    }
}

<# 
 .SYNOPSIS
  Gets the information in a project file.

 .DESCRIPTION
  Gets the information in a project file. Parses .csproj or .vbproj files.
  Returns what contents, nones, compiles the project describes.

 .PARAMETER solutionFile
  The path to project (.csproj or .vbproj) files.

 .EXAMPLE
   # Get the projects inside a solution
   Get-ProjectInfo SomeProject.csproj
#>
function Get-ProjectInfo{
    [CmdletBinding()]
    [OutputType([ProjectInfo[]])]
    param(
	    [Parameter(ValueFromPipeline, Position=1, Mandatory=0)]
	    [ValidateNotNullOrEmpty()]
	    [string[]] $projectFile
    )
    process {
        if(!(Test-Path $projectFile)){
            throw "Project $projectFile does not exist"
        }
        $projectFile = $projectFile | Resolve-Path

        [xml] $xmlDoc = Get-Content $projectFile
        $projectInfo = [ProjectInfo]::new($projectFile, $xmlDoc)

        $projectInfo
    }
}
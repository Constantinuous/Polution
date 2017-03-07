function Get-Projects{
    [CmdletBinding()]
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
	
	    $solutionProjects = $matchInfo.Matches | % {
            $solutionProject = [SolutionProject]::new($_.Groups[1], $_.Groups[2])
        
            $solutionProject
        }

        $solutionProjects
    }
}

function Get-ProjectInfo{
    [CmdletBinding()]
    param(
	    [Parameter(ValueFromPipeline, Position=1, Mandatory=0)]
	    [ValidateNotNullOrEmpty()]
	    [string[]] $projectFile
    )
    process {
        if(!(Test-Path $projectFile)){
            throw "Solution $projectFile does not exist"
        }
        $projectFile = $projectFile | Resolve-Path

        [xml] $xmlDoc = Get-Content $projectFile
        $projectInfo = [ProjectInfo]::new($projectFile, $xmlDoc)

        $projectInfo
    }
}
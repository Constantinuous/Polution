
Class SolutionProject {
    [String] $ProjectName
    [String] $ProjectLocation

    SolutionProject([String] $projectName, [String] $projectLocation){
        $this.ProjectName = $projectName
        $this.ProjectLocation = $projectLocation
    }
}

Enum ProjectType {
    Unknown
    VisualBasic
    Csharp
}

Class ProjectInfo {
    [String] $Path
    [String] $Name
    [ProjectType] $ProjectType

    [String[]] $Content
    [String[]] $None
    [String[]] $Compile
    [String[]] $ProjectReference
    [String[]] $Reference

    [String[]] $PublishProfile

    [object[]] TableFormat() {
        return @{ Label=”Name”; Expression={$_.Name} },
            @{ Label=”Type”; Expression={$_.ProjectType} },

            @{ Label=”Content#”; Expression={$_.Content.Count} },
            @{ Label=”None#”; Expression={$_.None.Count} },
            @{ Label=”Compile#”; Expression={$_.Compile.Count} },
            @{ Label=”ProjectReference#”; Expression={$_.ProjectReference.Count} },
            @{ Label=”Reference#”; Expression={$_.Reference.Count} },

            @{ Label=”PublishProfile#”; Expression={$_.PublishProfile.Count} }
    }

    ProjectInfo([string] $path, [xml] $projectXml){
        $this.Path = $path
        $this.Name = Split-Path $path -Leaf
        $extension = [System.IO.Path]::GetExtension($this.Name)
        if($extension -eq ".csproj"){ $this.ProjectType = [ProjectType]::Csharp }
        elseif($extension -eq ".vbproj"){ $this.ProjectType = [ProjectType]::VisualBasic }
        else{ $this.ProjectType = [ProjectType]::Unknown }


        $this.Content = $projectXml.Project.ItemGroup.Content.Include
        $this.None = $projectXml.Project.ItemGroup.None.Include
        $this.Compile = $projectXml.Project.ItemGroup.Compile.Include
        $this.ProjectReference = $projectXml.Project.ItemGroup.ProjectReference.Include
        $this.Reference = $projectXml.Project.ItemGroup.Reference.Include

        $this.PublishProfile = $this.GetPublishProfiles()
    }

    hidden [string] GetProjectPropertiesPath(){
        [string] $propertyPath = ""
        if($this.ProjectType -eq [ProjectType]::Csharp){
            $propertyPath = "Properties"
        }elseif($this.ProjectType -eq [ProjectType]::VisualBasic){
            $propertyPath = "My Project"
        }

        return $propertyPath
    }

    hidden [string[]] GetPublishProfiles(){
        [string[]] $profiles = @()
        $pattern = "$($this.GetProjectPropertiesPath())\\.*\.pubxml"
        $profiles = $this.None | Select-String -Pattern $pattern
        return $profiles
    }
}

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

function Get-ProjectFiles{
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

        $projectInfo | Format-Table $projectInfo.TableFormat()
    }
}


Export-ModuleMember -Function Get-Projects
Export-ModuleMember -Function Get-ProjectFiles
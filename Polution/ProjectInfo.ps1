Enum Language {
    Unknown
    VisualBasic
    Csharp
}

Class ProjectInfo {
    [String] $Path
    [String] $Name
    [Language] $Language

    [String[]] $Content
    [String[]] $None
    [String[]] $Compile

    [String[]] $ProjectReference
    [String[]] $Reference

    [String[]] $PublishProfile

    ProjectInfo([string] $path, [xml] $projectXml){
        $this.Path = $path
        $this.Name = Split-Path $path -Leaf
        $extension = [System.IO.Path]::GetExtension($this.Name)
        if($extension -eq ".csproj"){ $this.Language = [Language]::Csharp }
        elseif($extension -eq ".vbproj"){ $this.Language = [Language]::VisualBasic }
        else{ $this.Language = [Language]::Unknown }

        Write-Host $path
        $this.Content = $projectXml.Project.ItemGroup.Content.Include
        $this.None = $projectXml.Project.ItemGroup.None.Include
        $this.Compile = $projectXml.Project.ItemGroup.Compile.Include
        $this.ProjectReference = $projectXml.Project.ItemGroup.ProjectReference.Include
        $this.Reference = $projectXml.Project.ItemGroup.Reference.Include

        $this.PublishProfile = $this.GetPublishProfiles()
    }

    hidden [string] GetProjectPropertiesPath(){
        [string] $propertyPath = ""
        if($this.Language -eq [Language]::Csharp){
            $propertyPath = "Properties"
        }elseif($this.Language -eq [Language]::VisualBasic){
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
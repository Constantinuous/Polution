

Class SolutionProject {
    [String] $ProjectName
    [String] $ProjectLocation

    SolutionProject([String] $projectName, [String] $projectLocation){
        $this.ProjectName = $projectName
        $this.ProjectLocation = $projectLocation
    }
}
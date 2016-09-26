param($installPath, $toolsPath, $package, $project)

$list = @("ManagedONS")

# Need to load MSBuild assembly if it's not loaded yet.
Add-Type -AssemblyName 'Microsoft.Build, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'

# Grab the loaded MSBuild project for the project
$currentProject = [Microsoft.Build.Evaluation.ProjectCollection]::GlobalProjectCollection.GetLoadedProjects($project.FullName) | Select-Object -First 1

foreach($reference in $currentProject.GetItems('Reference'))
{
    # Get Include attribute of Reference Element
    $include = $reference.Xml.Include

    foreach($item in $list){
        
        # If Include match
        if ($include -match ".*$item.*$"){
            # Get HintPath of Reference Element
            $hintPath = $reference.GetMetadataValue("HintPath")
            
            # Update HintPath
            $newHintPath = $hintPath -replace '(.*\\)(x64)(\\.*\.dll)$', '$1$(BuildPlatform)$3'
            $newHintPath = $newHintPath -replace '(.*\\)(x86)(\\.*\.dll)$', '$1$(BuildPlatform)$3'
            $newHintPath = $newHintPath -replace '(.*\\)(AnyCPU)(\\.*\.dll)$', '$1$(BuildPlatform)$3'
            
            Write-Host "Update HintPath to $newHintPath"
            $newMetadataValue = $reference.SetMetadataValue("HintPath", $newHintPath);
        }
    }
}


# Save the project
$project.Save()
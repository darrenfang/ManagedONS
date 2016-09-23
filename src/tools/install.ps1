param($installPath, $toolsPath, $package, $project)

$list = @("ManagedONS")    

# Full assembly name is required
Add-Type -AssemblyName 'Microsoft.Build, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'

$projectCollection = [Microsoft.Build.Evaluation.ProjectCollection]::GlobalProjectCollection
 
# There is no indexer on ICollection<T> and we cannot call
# Enumerable.First<T> because Powershell does not support it easily and
# we do not want to end up MethodInfo.MakeGenericMethod.
$allProjects = $projectCollection.GetLoadedProjects($project.Object.Project.FullName).GetEnumerator(); 

if($allProjects.MoveNext())
{
    $currentProject = $allProjects.Current
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
                $newHintPath = $hintPath -replace '(.*\\)(x64)(\\.*\.dll)$', '$1$(PlatformTarget)$3'
                $newHintPath = $newHintPath -replace '(.*\\)(x86)(\\.*\.dll)$', '$1$(PlatformTarget)$3'
                $newHintPath = $newHintPath -replace '(.*\\)(AnyCPU)(\\.*\.dll)$', '$1$(PlatformTarget)$3'
                
                Write-Host "Update HintPath to $newHintPath"
                $newMetadataValue = $reference.SetMetadataValue("HintPath", $newHintPath);
            }
        }
    }
    
    $currentProject.Save()
}
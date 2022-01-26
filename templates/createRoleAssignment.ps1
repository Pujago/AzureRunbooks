# Example

# .\createRoleAssignment.ps1 -AutomationAccountName "AAA-Pujah" -ResourceGroupName "pujahrg" -RoleDefinition "Contributor" -Scope /subscriptions/<subscriptionId>/resourceGroups/<your resourcegroup name>


[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    $AutomationAccountName,

    [Parameter(Mandatory=$true)]
    $ResourceGroupName,

    [Parameter(Mandatory=$true)]
    $RoleDefinition,

    [Parameter(Mandatory=$true)]
    $Scope
)

$AutomationAccountName = "$AutomationAccountName" 
$ResourceGroupName = "$ResourceGroupName"
$RoleDefinition = "$RoleDefinition" # "Contributor"
$Scope = "$Scope" # /subscriptions/<subscriptionId>/pujarg

try 
{
    $automationObject = (Get-AzAutomationAccount -Name $AutomationAccountName -ResourceGroupName $ResourceGroupName).Identity.PrincipalId
    if($null -eq (Get-AzRoleAssignment -ObjectId $automationObject -RoleDefinitionName "$RoleDefinition" -ResourceGroupName $ResourceGroupName -erroraction 'silentlycontinue'))
    {
        Write-Host -f Yellow "##[warning] Role definition '$($RoleDefinition)' for object '$($automationObject)' does not exists, creating one ..."
        New-AzRoleAssignment -ObjectId $automationObject -RoleDefinitionName $RoleDefinition -Scope $Scope
        Write-Host -f Green "##[section] Role definition '$($RoleDefinition)' for object '$($automationObject)' created successfully"
        Write-Host ""
    }
    else {
        Write-Host -f Yellow "##[warning] Role definition '$($RoleDefinition)' for object '$($automationObject)' already Exists" 
        Write-Host ""
    }
}
catch {
    $message = $_.Exception.message
    Write-Error "##vso[task.LogIssue type=error;] $message"
    Write-host ""
    exit
}






##################### Example to call######################
# .\registerRunbooksToASchedule.ps1 -AutomationAccountName "AAA-Pujah" -ResourceGroupName "pujahrg"  -RunbooksName "GetAllResourcegroups,GetAResourceGroup" -ScheduleName "RunEveryEvening"
###########################################################

[CmdletBinding()]
param (

    [Parameter(Mandatory=$true)]
    $AutomationAccountName,

    [Parameter(Mandatory=$true)]
    $ResourceGroupName,

    [Parameter(Mandatory=$true)]
    $RunbooksName,

    [Parameter(Mandatory=$true)]
    $ScheduleName
)

$AutomationAccountName = "$AutomationAccountName" 
$ResourceGroupName = "$ResourceGroupName"
$RunbooksName = "$RunbooksName"
$ScheduleName ="$ScheduleName"

$RunbooksList = $RunbooksName.Split(",")

foreach ($item in $RunbooksList) {   
    $item = $item.Trim() 
    try {
        if($null -eq (Get-AzAutomationScheduledRunbook -AutomationAccountName $AutomationAccountName -RunbookName $item -ResourceGroupName $ResourceGroupName -erroraction 'silentlycontinue'))
        {
            Write-Host "Adding runbook '$($item)' to schedule '$($ScheduleName)'..."
            Write-Host ""
            Register-AzAutomationScheduledRunbook -AutomationAccountName $AutomationAccountName -Name $item -ScheduleName $ScheduleName -ResourceGroupName $ResourceGroupName
            Write-Host -f Green "##[section] Runbook '$($item)' added to the schedule '$($ScheduleName)' successfully."
            Write-Host ""
        }
        else {
            Write-Host -f Yellow "##[warning] Runbook '$($item)' already has a schedule."
            Write-Host ""
        }
    }
    catch {
        $message = $_.Exception.message
        Write-Error "##vso[task.LogIssue type=error;] $message"
        Write-host ""
        exit
    }
}

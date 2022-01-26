
##################### Example to call######################
# .\CreateAndImportRunbooks.ps1 -AutomationAccountName "AAA-Pujah" -ResourceGroupName "pujahRg"  -RunbooksPath "./runbooks/rgs" 
###########################################################

[CmdletBinding()]
param (

    [Parameter(Mandatory=$true)]
    $AutomationAccountName,

    [Parameter(Mandatory=$true)]
    $ResourceGroupName,

    [Parameter(Mandatory=$true)]
    $RunbooksPath
)

$AutomationAccountName = "$AutomationAccountName" 
$ResourceGroupName = "$ResourceGroupName"
$RunbooksPath = "$RunbooksPath" # .\runbooks\rgs

try {

    $files = Get-Childitem -Path $RunbooksPath 
    foreach ($file in $files.Name) {
        $RunbookName = [System.IO.Path]::GetFileNameWithoutExtension($file)
        $RunbookPath = "$RunbooksPath/$file"

        if($null -eq (Get-AzAutomationRunbook -AutomationAccountName $AutomationAccountName -Name $RunbookName -ResourceGroupName $ResourceGroupName -erroraction 'silentlycontinue'))
        {
            Write-Host -f Yellow "##[warning] Runbook with name '$($RunbookName)' does not exists, creating one ..."
            # Create Runbook 
            New-AzAutomationRunbook -Name $RunbookName -Type PowerShell -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName
            # Import Runbook
            Import-AzAutomationRunbook -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -Path $RunbookPath -Type PowerShell -Name $RunbookName -Force
            # Publish Runbook
            Publish-AzAutomationRunbook -Name $RunbookName -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName
           
            Write-Host -f Green "##[section] Runbook '$($RunbookName)' created successfully"
            Write-Host ""
        }
        else {
            Write-Host -f Yellow "##[warning] Runbook with name '$($RunbookName)' already Exists" 
            Write-Host ""
        }
    }

}
catch {
    $message = $_.Exception.message
    Write-Error "##vso[task.LogIssue type=error;] $message"
    Write-host ""
    exit
}


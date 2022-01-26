# Example
# .\createAutomationAccount.ps1 -AutomationAccountName "AAA-Pujah" -ResourceGroupName "PujahRg" -Location "AustraliaEast"

[CmdletBinding()]

param (

    [Parameter(Mandatory=$true)]
    $AutomationAccountName,

    [Parameter(Mandatory=$true)]
    $ResourceGroupName,

    [Parameter(Mandatory=$true)]
    $Location
)

$AutomationAccountName = "$AutomationAccountName" 
$ResourceGroupName = "$ResourceGroupName"
$Location = "$Location"

try {
    if($null -eq (Get-AzAutomationAccount -ResourceGroupName "$ResourceGroupName" -Name "$AutomationAccountName" -ErrorAction 'silentlycontinue'))
    {
        Write-Host -f Yellow "##[warning] Account with name '$($AutomationAccountName)' does not exists, creating one ..."
        $result = New-AzAutomationAccount -Name $AutomationAccountName -Location $Location -ResourceGroupName $ResourceGroupName -AssignSystemIdentity
        if($null -ne $result)
        {
            Write-Host -f Green "##[section] Account '$($AutomationAccountName)' created successfully"
            Write-Host ""
        }
    }
    else {
        Write-Host -f Yellow "##[warning] Account with name '$($AutomationAccountName)' already Exists" 
        Write-Host ""
    }
    
}
catch {
    $message = $_.Exception.message
    Write-Error "##vso[task.LogIssue type=error;] $message"
    Write-host ""
    exit
}


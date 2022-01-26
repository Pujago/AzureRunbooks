# .\createSchedule.ps1 -AutomationAccountName "AAA-Pujah" -ResourceGroupName "pujahrg" -ScheduleName "RunEveryEvening" -Time "18:00:00"

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    $AutomationAccountName,

    [Parameter(Mandatory=$true)]
    $ResourceGroupName,

    [Parameter(Mandatory=$true)]
    $ScheduleName,

    [Parameter(Mandatory=$true)]
    $Time
)

$AutomationAccountName = "$AutomationAccountName" 
$ResourceGroupName = "$ResourceGroupName"
$ScheduleName = "$ScheduleName"
$Time = "$Time" # in format 00:00:00

$TimeZone = ([System.TimeZoneInfo]::Local).Id

# Recurring
$startTime = (Get-Date "$Time").AddDays(1)
[System.DayOfWeek[]]$WeekDays = @([System.DayOfWeek]::Monday..[System.DayOfWeek]::Friday)

try {
    if($null -eq (Get-AzAutomationSchedule -AutomationAccountName $AutomationAccountName -Name $ScheduleName -ResourceGroupName $ResourceGroupName -erroraction 'silentlycontinue'))
    {
        Write-Host -f Yellow "##[warning] Schedule with name '$($ScheduleName)' does not exists, creating one ..."
        New-AzAutomationSchedule -AutomationAccountName $AutomationAccountName -Name $ScheduleName -StartTime $startTime -WeekInterval 1 -DaysOfWeek $WeekDays -ResourceGroupName $ResourceGroupName -TimeZone $TimeZone
        Write-Host -f Green "##[section] Schedule '$($ScheduleName)' created successfully"
        Write-Host ""
    }
    else {
        Write-Host -f Yellow "##[warning] Schedule with name '$($ScheduleName)' already Exists" 
        Write-Host ""
    }
}
catch {
    $message = $_.Exception.message
    Write-Error "##vso[task.LogIssue type=error;] $message"
    Write-host ""
    exit
}

# Once
# $startTime = Get-Date "15:45:00"
# New-AzAutomationSchedule -AutomationAccountName $AutomationAccountName -Name $ScheduleName -StartTime $startTime -HourInterval 1 -ResourceGroupName $ResourceGroupName -TimeZone $TimeZone
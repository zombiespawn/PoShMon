Function Invoke-OSMonitoring
{
    [CmdletBinding()]
    Param(
        #[parameter(Mandatory=$true, HelpMessage=�Path to file�)]
        [string]$EnvironmentName = "Environment",
        [int]$MinutesToScanHistory = 15,
        [string[]]$ServerNames = @(),
        [string[]]$MailToList = @(),
        [string[]]$EventLogCodes = 'Critical',
        [hashtable]$EventIDIgnoreList = @{},
        [string[]]$TestsToSkip = @(),
        [bool]$SendEmail = $true,
        [bool]$SendEmailOnlyOnFailure = $false,
        [string]$MailFrom,
        [string]$SMTPAddress
    )

    $stopWatch = [System.Diagnostics.Stopwatch]::StartNew()

    $outputValues = @()

    # Event Logs
    if (!$TestsToSkip.Contains("EventLogs"))
    {
        foreach ($eventLogCode in $EventLogCodes)
            { $outputValues += Test-EventLogs -ServerNames $ServerNames -MinutesToScanHistory $MinutesToScanHistory -SeverityCode $eventLogCode }
    }

    # Drive Space
    if (!$TestsToSkip.Contains("DriveSpace"))
        { $outputValues += Test-DriveSpace -ServerNames $ServerNames }

    $stopWatch.Stop()

    Confirm-SendMonitoringEmail -TestOutputValues $outputValues -SkippedTests $TestsToSkip -SendEmailOnlyOnFailure $SendEmailOnlyOnFailure -SendEmail $SendEmail `
        -EnvironmentName $EnvironmentName -MailToList $MailToList -MailFrom $MailFrom -SMTPAddress $SMTPAddress -TotalElapsedTime $stopWatch.Elapsed

    return $outputValues
}
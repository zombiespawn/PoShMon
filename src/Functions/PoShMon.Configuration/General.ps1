Function General
{
    [CmdletBinding()]
    param(
        #[scriptblock]$bodyScript,
        [string]$EnvironmentName = $null,
        [int]$MinutesToScanHistory = 15,
        [string[]]$TestsToSkip = @(),
        [parameter(HelpMessage="For monitoring a 'farm'' product, like SharePoint, specify a server name to run the main monitoring operations.")]
        [string]$PrimaryServerName,
        [parameter(HelpMessage="For monitoring standalone servers, specify the names of the servers to monitor.")]
        [string[]]$ServerNames = @(),
        [parameter(HelpMessage="A ConfiguratioName for PowerShell to create remote sessions using pre-existing configurations")]
        [string]$ConfigurationName = $null,
        [switch]$SkipVersionUpdateCheck = $false        
    )

    if ($Script:PoShMon.ConfigurationItems.General -eq $null)
        { $Script:PoShMon.ConfigurationItems.General = @{} }
    else {
        throw "General configuration group already created."
    }

    if ($PrimaryServerName -eq $null -and $ServerNames.Count -eq 0)
        { $ServerNames += $env:COMPUTERNAME }
    elseif ($PrimaryServerName -ne "" -and $ServerNames.Count -gt 0)
        { throw "You cannot specify both PrimaryServerName and ServerNames. If you are monitoring a 'farm' product, like SharePoint, specify PrimaryServerName on which to run the main monitoring operations." `
            + "Alternatively, if you are instead wanting to monitor a set of standalone servers, supply ServerNames and do not supply a value for the PrimaryServerName parameter." }

    $remoteSessionName = "PoShMonSession"

    return @{
            TypeName = "PoShMon.ConfigurationItems.General"
            EnvironmentName = $EnvironmentName
            MinutesToScanHistory = $MinutesToScanHistory
            TestsToSkip = $TestsToSkip
            PrimaryServerName = $PrimaryServerName
            ServerNames = $ServerNames
            ConfigurationName = $ConfigurationName
            RemoteSessionName = $remoteSessionName
            SkipVersionUpdateCheck = $SkipVersionUpdateCheck
        }
}
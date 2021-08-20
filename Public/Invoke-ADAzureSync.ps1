function Invoke-ADAzureSync {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
	[string]$ComputerName=$AzureSyncServer,
	[int]$MaxTrys=42
    )

    $Count = 0
    $CommandArgs = @{
	ComputerName = $ComputerName
	ScriptBlock  = {Start-ADSyncSyncCycle -PolicyType Delta}
	ErrorAction  = "SilentlyContinue"
    }

    Write-Host "Running Azure AD Sync on $ComputerName..."

    do {
	$Count++
	$Azure = Invoke-Command @CommandArgs
	if ($Azure.Result -eq "Success") {
	    Write-Output "Azure AD Sync on $ComputerName completed successfully."
	    return
	} else {
	    Write-Warning "Azure AD Sync on $ComputerName Failed. Trying again in 10 seconds..."
	    Write-SleepProgress 10 "Azure Sync"
	}
    } until ($Azure.Result -eq "Success" -Or $Count -gt $MaxTrys)

    Write-Warning "Reached $MaxTrys attempts. Aborting."
}

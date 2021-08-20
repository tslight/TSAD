function Sync-AzureAndWait {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
	[int]$Seconds=180,
	[string]$Msg="Azure sync"
    )

    if (Invoke-ADAzureSync) {
	Write-SleepProgress $Seconds $Msg
	Invoke-ADAzureSync
    } else {
	Write-Warning "Running 1st Azure sync failed fatally. Aborting."
    }
}

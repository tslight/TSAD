function Get-ADOldUsers {
    [CmdletBinding(SupportsShouldProcess,DefaultParameterSetName='years')]
    Param (
	[Parameter(ParameterSetName='years')]
	[int]$Years,
	[Parameter(ParameterSetName='months')]
	[int]$Months,
	[Parameter(ParameterSetName='days')]
	[int]$Days,
	[switch]$AllProperties
    )

    if ($Years) {
	$Date = (Get-Date).AddYears(-$Years)
    } elseif ($Months) {
	$Date = (Get-Date).AddMonths(-$Months)
    } else {
	$Date = (Get-Date).AddDays(-$Days)
    }

    Write-Host @Cyan (
	"Finding enabled AD Users whose last log on date is older than $Date..."
    )

    $Params = @{
	Filter = {Enabled -eq $True}
	Server = $ADGlobalCatalog
	Properties = @(
	    "Name",
	    "SamAccountName",
	    "UserPrincipalName",
	    "EmailAddress",
	    "Enabled",
	    "LastLogonDate",
	    "AccountExpirationDate"
	)
    }

    if ($AllProperties) {
	Get-ADUser @Params | Where-Object {
	    ($_.LastLogonDate -ne $Null) -And
	    ($_.LastLogonDate -lt $Date)
	} | Sort-Object -Property LastLogonDate | Get-ADUserAllProperties
    } else {
	Get-ADUser @Params | Where-Object {
	    ($_.LastLogonDate -ne $Null) -And
	    ($_.LastLogonDate -lt $Date)
	} | Sort-Object -Property LastLogonDate
    }
}

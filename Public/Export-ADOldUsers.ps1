function Export-ADOldUsers {
    [CmdletBinding(SupportsShouldProcess,DefaultParameterSetName='years')]
    Param (
	[Parameter(Mandatory)]
	[System.IO.FileInfo]$Path,
	[string]$Name="ADUsersOlderThan",
	[Parameter(ParameterSetName='years')]
	[int]$Years,
	[Parameter(ParameterSetName='months')]
	[int]$Months,
	[Parameter(ParameterSetName='days')]
	[int]$Days
    )

    $Date = Get-Date -UFormat '%Y-%m-%d'
    New-Path $Path -Type Directory
    Write-Host @Cyan (
	"Creating Old AD users report at $Path..."
    )

    $Selection = @(
	@{
	    Name = 'AD Enabled'
	    Expression = {$_.Enabled}
	}
	@{
	    Name = 'AD Sam Account Name'
	    Expression = {$_.SamAccountName}
	}
	@{
	    Name = 'AD Last Logon Date'
	    # Piping date object to get-date is more efficient than type conversion.
	    # Expression = {$_(.LastLogonDate).ToString().SubString(0,10)}
	    Expression = {$_.LastLogonDate | Get-Date -UFormat '%Y-%m-%d'}
	}
    )

    if ($Years) {
	$CsvPath = "$Path\$Name-$($Years)Years-$Date.csv"
	Get-ADOldUsers -Years $Years |
	  Select-Object $Selection |
	  Export-Csv -NoTypeInformation $CsvPath
    } elseif ($Months) {
	$CsvPath = "$Path\$Name-$($Months)Months-$Date.csv"
	Get-ADOldUsers -Months $Months |
	  Select-Object $Selection |
	  Export-Csv -NoTypeInformation $CsvPath
    } else {
	$CsvPath = "$Path\$Name-$($Days)Days-$Date.csv"
	Get-ADOldUsers -Days $Days |
	  Select-Object $Selection |
	  Export-Csv -NoTypeInformation $CsvPath
    }

    $XlsPath = $CsvPath -Replace ".csv",""
    Convert-CsvToXls -Csv $CsvPath -Xlsx $XlsPath
}

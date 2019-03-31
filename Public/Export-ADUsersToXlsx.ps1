function Export-ADUsersToXlsx {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
	[Parameter(Mandatory,ValueFromPipeline)]
	[array]$Users,
	[string]$Name,
	[System.IO.FileInfo]$Path="."
    )

    process {
	Write-Host -Back Black -Fore Magenta "Exporting users to $Path\$Name.csv..."
	try {
	    $Users | Export-Csv "$Path\$Name.csv" -NoTypeInformation
	    Write-Host -Back Black -Fore Cyan "Successfully exported users to $Path\$Name.csv."
	} catch {
	    throw
	}

	Write-Host -Back Black -Fore Magenta "Converting $Name.csv to $Name.xlsx"
	try {
	    $Xlsx = "$Path\$Name"
	    Get-ChildItem "$Path\$Name.csv" | Convert-CsvToXls -Xlsx $Xlsx
	    Write-Host -Back Black -Fore Cyan "Successfully created $Path\$Name.xlsx"
	    Write-Output "$Xlsx.xlsx"
	} catch {
	    throw
	}
    }
}

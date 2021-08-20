function Get-ADUserBySam {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
	[Parameter(Mandatory,ValueFromPipeline)]
	[string]$Sam,
	[string]$Domain,
	[object]$Creds
    )

    $Params = @{
	Filter		= {SamAccountName -eq $Sam}
	ErrorAction	= "SilentlyContinue"
	Properties      = "*"
    }

    if ($Domain -And $Creds) {
	if ($ADUser = Get-ADUser -Server $Domain -Credential $Creds @Params) {
	    return $ADUser
	} else {
	    Write-Verbose "Couldn't find $Sam in AD."
	}
    } elseif ($ADUser = Get-ADUser -Server $ADGlobalCatalog @Params) {
	$ADUser | Get-ADUserAllProperties
    } else {
	Write-Verbose "Couldn't find $Sam in AD."
    }
}

function Get-ADUserByName {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
	[Parameter(Mandatory,ValueFromPipeline)]
	[string]$Name,
	[string]$Domain,
	[object]$Creds
    )

    process {
	if ($Name -notmatch '^\s+$|^$' -and $Name -ne $Null) {
	    $NameWildcard = '*' + $Name + '*'
	    if ($Domain -And $Creds) {
		$Params = @{
		    Server	= $Domain
		    Credential	= $Creds
		    Properties	= '*'
		}
		if ($ADUser = Get-ADUser @Params -Filter {Name -eq $Name}) {
		    return $ADUser
		} elseif ($ADUser = Get-ADUser @Params -Filter {Name -like $NameWildcard}) {
		    return $ADUser
		} else {
		    Write-Verbose "Couldn't find $Name in $Domain AD."
		}
	    } else {
		if ($ADUser = Get-ADUser -Filter {Name -eq $Name} -Server $ADGlobalCatalog) {
		    $ADUser | Get-ADUserAllProperties
		} elseif ($ADUser = Get-ADUser -Filter {Name -like $NameWildcard} -Server $ADGlobalCatalog) {
		    $ADUser | Get-ADUserAllProperties
		} else {
		    Write-Verbose "Couldn't find $Name in AD."
		}
	    }
	} else {
	    throw "Name parameter is an empty string."
	}
    }
}

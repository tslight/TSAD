function Get-ADUserAllProperties {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
	[Parameter(Mandatory,ValueFromPipeline)]
	[Microsoft.ActiveDirectory.Management.ADAccount[]]$ADUser,
	[string]$Domain,
	[object]$Creds
    )

    process {
	$Name = $ADUser.Name
	$Params = @{
	    Properties	= '*'
	    Filter	= {Name -eq $Name}
	}
	if ($Domain -And $Creds) {
	    Get-ADUser @Params -Server $Domain -Credential $Creds
	} else {
	    $Domain = Get-ADDomainName $ADUser
	    Get-ADUser @Params -Server $Domain
	}
    }
}

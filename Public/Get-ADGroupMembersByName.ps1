function Get-ADGroupMembersByName {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
	[Parameter(Mandatory,ValueFromPipeline)]
	[string]$Name,
	[switch]$Quick
    )

    process {
	$Params = @{
	    Server     = $ADGlobalCatalog
	    Properties = @('CanonicalName')
	}
	try {
	    $Group = Get-ADGroup $Name @Params
	} catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
	    $Group = Get-ADGroup -Filter {
		(Name -eq $Name) -or (SamAccountName -eq $Name)
	    } @Params
	} catch {
	    throw
	}
	$Domain = $Group.CanonicalName.Substring(0, $Group.CanonicalName.IndexOf("/"))
	if ($Quick) {
	    Get-ADGroupMember $Group.DistinguishedName -Server $Domain
	} else {
	    Get-ADGroupMember $Group.DistinguishedName -Recursive -Server $Domain |
	      Get-ADUserAllProperties
	}
    }
}

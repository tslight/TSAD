function Get-ADUserGroups {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
	[Parameter(Mandatory,ValueFromPipeline)]
	[Microsoft.ActiveDirectory.Management.ADAccount]$ADUser,
	[string]$Domain,
	[object]$Creds
    )

    $Sam = $ADUser.SamAccountName

    if ($Domain -And $Creds) {
	return Get-ADPrincipalGroupMemberShip $Sam -Server $Domain -Credential $Creds
    }

    if ($Domain = Get-ADDomainName $ADUser) {
	return Get-ADPrincipalGroupMemberShip $Sam -Server $Domain
    } else {
	Write-Warning "Couldn't find domain for $Sam."
    }
}

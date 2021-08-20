function Get-ADUserByEmail {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
	[Parameter(Mandatory,ValueFromPipeline)]
	[mailaddress]$EmailAddress
    )

    process {
	$Email = $EmailAddress.Address
	$Params = @{
	    Filter = {
		(EmailAddress -eq $Email) -Or
		(mail -eq $Email) -Or
		(UserPrincipalName -eq $Email)
	    }
	    Server = $ADGlobalCatalog
	    Properties = @('EmailAddress')
	}
	Get-ADUser @Params | Get-ADUserAllProperties
    }
}

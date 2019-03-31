function Get-ADUserDomain {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
	[Parameter(Mandatory,ValueFromPipeline)]
	[Microsoft.ActiveDirectory.Management.ADAccount[]]
	$ADUser
    )

    begin {
	# (?i) enables case insensitivity for rest of expression
	# \w matches a word, {1,} match one or more word, ? lazily
	# \b matches a word boundary (any non word char)
	$RegEx = '(?i)DC=\w{1,}?\b'
    }

    process {
	$DN  = $ADUser.DistinguishedName
	$Sam = $ADUser.SamAccountName
	Write-Verbose "Finding domain for $Sam..."
	$DN  = (
	    [RegEx]::Matches($DN, $RegEx) |
	      ForEach-Object {
		  $_.Value
	      }
	) -Join ','

	if ($DNToDomain[$DN]) {
	    Write-Verbose "$Sam is in $($DNToDomain[$DN])."
	    return $DNToDomain[$DN]
	} else {
	    Write-Verbose "$Sam can't be found in any domain!"
	}
    }
}

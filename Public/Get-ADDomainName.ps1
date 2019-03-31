function Get-ADDomainName {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
	[Parameter(Mandatory,ValueFromPipeline)]
	[object[]]$ADObject
    )

    begin {
	# (?i) enables case insensitivity for rest of expression
	# \w matches a word, {1,} match one or more word, ? lazily
	# \b matches a word boundary (any non word char)
	$RegEx = '(?i)DC=\w{1,}?\b'
    }

    process {
	$DN  = $ADObject.DistinguishedName
	$Sam = $ADObject.SamAccountName
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

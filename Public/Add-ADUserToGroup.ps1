function Add-ADUserToGroup {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
	[Parameter(Mandatory,ValueFromPipeline)]
	[string]$GroupDN,
	[Parameter(Mandatory)]
	[object]$User,
	[Parameter(Mandatory)]
	[string]$Domain,
	[AllowNull()]
	[object]$Creds
    )

    begin {
	$NoNeed     = @()
	$Added      = @()
	$Failed     = @()
    }

    process {
	$UserName = $User.Name
	$GroupName = ($GroupDN -Split "=|,")[1] -Replace "\\|\#",""

	Write-Verbose "Checking if $UserName already exists in $GroupName..."
	if ($Creds) {
	    $Members = Get-ADGroupMember $GroupDN -Server $Domain -Credential $Creds |
	      Select-Object -ExpandProperty Name
	} else {
	    $Domain = Get-ADGroup $GroupDN -Server $ADGlobalCatalog | Get-ADDomainName
	    $Members = Get-ADGroupMember $GroupDN -Server $Domain |
	      Select-Object -ExpandProperty Name
	}

	if ($Members -contains $UserName) {
	    Write-Verbose "$UserName is already a member of $GroupName"
	    $NoNeed += $GroupDN
	} else {
	    try {
		if ($Creds) {
		    Add-ADGroupMember $GroupDN -Members $User -Server $Domain -Credential $Creds
		} else {
		    $Domain = Get-ADGroup $GroupDN -Server $ADGlobalCatalog | Get-ADDomainName
		    Add-ADGroupMember $GroupDN -Members $User -Server $Domain
		}
		Write-Verbose "Successfully added $UserName to $GroupName group."
		$Added += $GroupDN
	    } catch	{
		Write-Warning "FAILED to add $UserName to $GroupName group."
		Write-Warning $_.InvocationInfo.ScriptName
		Write-Warning $_.InvocationInfo.Line
		Write-Warning $_.Exception.Message
		$Failed += $GroupDN
	    }
	}
    }

    end {
	return [Tuple]::Create($NoNeed,$Added,$Failed)
    }
}

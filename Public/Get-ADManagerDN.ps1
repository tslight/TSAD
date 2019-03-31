function Get-ADManagerDN {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
	[Parameter(Mandatory,Position=0)]
	[string]$LineManager,
	[Parameter(Mandatory,Position=1)]
	[object]$Template,
	[Parameter(Position=2)]
	[string]$Domain=$ADGlobalCatalog,
	[Parameter(Position=3)]
	[object]$Creds
    )

    $GetLineManArgs = @{
	Filter		= {Name -eq $LineManager}
	Server		= $Domain
	Properties	= @('Manager','CanonicalName')
    }

    if ($Creds) {
	$ManagerADObject = Get-ADUser @GetLineManArgs -Credential $Creds
    } else {
	$ManagerADObject = Get-ADUser @GetlineManArgs
    }

    if ($ManagerADObject) {
	$ManagerDN = $ManagerADObject.DistinguishedName
    } else {
	$ManagerDN = $Template.Manager
    }

    if ($ManagerDN -is [array]) {
	$ManagerDN = $ManagerDN[0]
    }

    return $ManagerDN
}

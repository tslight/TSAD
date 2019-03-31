function Move-ADComputer {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
	[Parameter(Mandatory,ValueFromPipeline)]
	[string]$Hostname,
	[Parameter(Mandatory)]
	[string]$Target
    )

    $Computer	= Get-ADComputer $Hostname -Server $ADGlobalCatalog
    $Domain	= Get-ADDomainName $Computer
    $Computer	= Get-ADComputer $Hostname -Server $Domain
    $CurrentOU	= $Computer.DistinguishedName -Replace ("CN=$Hostname,","")
    $CurrentOU	= Get-ADOrganizationalUnit $CurrentOU -Server $Domain -Properties CanonicalName

    Write-Host @Cyan "$Hostname is in $($CurrentOU.CanonicalName)..."

    $TargetOU	= Get-ADOrganizationalUnit -Filter {Name -eq $Target} -Server $ADGlobalCatalog
    $Domain	= Get-ADDomainName $TargetOU
    $TargetOU	= Get-ADOrganizationalUnit $TargetOU -Server $Domain -Properties CanonicalName

    Write-Host @Magenta "Moving to $($TargetOU.Canonicalname)..."

    try {
	Move-ADObject $Computer -TargetPath $TargetOU.DistinguishedName -Server $Domain
	Write-Host @Green (
	    "Successfully moved $Hostname to $($TargetOU.Canonicalname)..."
	)
    } catch {
	Write-Warning "Failed to move $Hostname to $($TargetOU.Canonicalname)."
	Write-Warning $_.InvocationInfo.ScriptName
	Write-Warning $_.InvocationInfo.Line
	Write-Warning $_.Exception.Message
    }
}

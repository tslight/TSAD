function Get-ADUsersByDate {
    [CmdletBinding(SupportsShouldProcess)]
    param (
	[Parameter(Position=0)]
	[int]$Days=7
    )

    $Users = @()
    $When = ((Get-Date).AddDays(-$Days)).Date
    $ADUsers = Get-ADUser -Filter {whenCreated -ge $When} -Server $ADGlobalCatalog

    foreach ($user in $ADUsers) {
	$Domain = Get-ADDomainName $user
	Write-Verbose "Searching $Domain for $($user.Name)"
	$Users += Get-ADUser -Filter {Name -eq $user.Name} -Server $Domain -Properties *
	Write-Verbose "Added $($user.Name)."
    }

    $Users | Sort-Object whenCreated
}

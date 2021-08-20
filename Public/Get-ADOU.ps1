function Get-ADOU {
    [CmdletBinding()]
    Param (
	[Parameter(Mandatory)]
	[object]$Template
    )

    $CN = $Template.cn
    $DN = $Template.DistinguishedName
    $OU = $DN -Replace "CN=$CN,",""

    return $OU
}

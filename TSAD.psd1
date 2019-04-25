@{
    RootModule = 'TSAD'
    ModuleVersion = '0.0.1'
    # CompatiblePSEditions = @()
    GUID = '4a860704-4e47-46a4-819e-8fc494937a31'
    Author = 'Toby Slight'
    # CompanyName = 'Unknown'
    Copyright = '(c) Toby Slight. All rights reserved.'
    Description = 'Active Directory Extension Module.'
    # PowerShellVersion = ''
    # PowerShellHostName = ''
    # PowerShellHostVersion = ''
    # DotNetFrameworkVersion = ''
    # CLRVersion = ''
    # ProcessorArchitecture = ''
    RequiredModules = @(
	'TSDate'
	'TSUtils'
    )
    # RequiredAssemblies = @()
    # ScriptsToProcess = @()
    # TypesToProcess = @()
    # FormatsToProcess = @()
    # NestedModules = @()
    FunctionsToExport = '*'
    CmdletsToExport = '*'
    VariablesToExport = '*'
    AliasesToExport = '*'
    # DscResourcesToExport = @()
    # ModuleList = @()
    # FileList = @()
    # Private data to pass to the module specified in RootModule/ModuleToProcess.
    # This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
	PSData = @{
	    # These help with module discovery in online galleries.
	    # Tags = @()
	    # LicenseUri = ''
	    # ProjectUri = ''
	    # IconUri = ''
	    # ReleaseNotes = ''
	}
    }
    # HelpInfoURI = ''
    # DefaultCommandPrefix = ''
}

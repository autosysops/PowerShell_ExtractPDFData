# ===================================================================
# ================== INSTALL NUGET PACKAGE ==========================
# ===================================================================
$loaded = $false
$installed = $false

Write-Verbose "Check if FreeSpire.PDF nuget package is present"
$package = Get-Package -Name FreeSpire.PDF -ErrorAction SilentlyContinue
if ($package) {
    $installed = $true
    Write-Verbose "Package is already installed"
    if ([System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.FullName -like "Spire.PDF*" }) {
        $loaded = $true
        Write-Verbose "Package is already loaded"
    }
}

if (-not $installed) {
    Write-Verbose "Download FreeSpire.PDF nuget package"
    # Install the package in currentuser scope to make sure no elavation is needed
    $null = Install-Package -Name FreeSpire.PDF -Source "http://www.nuget.org/api/v2" -SkipDependencies -Confirm:$false -Force -Scope CurrentUser
    $package = Get-Package -Name FreeSpire.PDF
}

if (-not $loaded) {
    Write-Verbose "Check the FreeSpire.PDF nuget package"
    # Load the package in memory and look for the right dll
    $zip = [System.IO.Compression.ZipFile]::Open($package.Source, "Read")
    $file = $zip.entries | Where-Object { $_.FullName -like "*/net6.0/Spire.Pdf.dll" }

    Write-Verbose "Load FreeSpire.PDF file $($file.FullName)"
    # Read the file to memory
    $reader = [System.IO.StreamReader]$file.Open()
    $memStream = [System.IO.MemoryStream]::new()
    $reader.BaseStream.CopyTo($memStream)
    [byte[]]$bytes = $memStream.ToArray()

    # Close the package and file
    $reader.Close()
    $zip.dispose()

    Write-Verbose "Load the FreeSpire.PDF nuget package"
    # Load the assmebly from memory
    $null = [System.Reflection.Assembly]::Load($bytes)
}

# ===================================================================
# ================== TELEMETRY ======================================
# ===================================================================

# Create env variables
$Env:EXTRACTPDFDATA_TELEMETRY_OPTIN = (-not $Evn:POWERSHELL_TELEMETRY_OPTOUT) # use the invert of default powershell telemetry setting

# Set up the telemetry
Initialize-THTelemetry -ModuleName "ExtractPDFData"
Set-THTelemetryConfiguration -ModuleName "ExtractPDFData" -OptInVariableName "EXTRACTPDFDATA_TELEMETRY_OPTIN" -StripPersonallyIdentifiableInformation $true -Confirm:$false
Add-THAppInsightsConnectionString -ModuleName "ExtractPDFData" -ConnectionString "InstrumentationKey=df9757a1-873b-41c6-b4a2-2b93d15c9fb1;IngestionEndpoint=https://westeurope-5.in.applicationinsights.azure.com/;LiveEndpoint=https://westeurope.livediagnostics.monitor.azure.com/"

# Create a message about the telemetry
Write-Information ("Telemetry for ExtractPDFData module is $(if([string] $Env:EXTRACTPDFDATA_TELEMETRY_OPTIN -in ("no","false","0")){"NOT "})enabled. Change the behavior by setting the value of " + '$Env:EXTRACTPDFDATA_TELEMETRY_OPTIN') -InformationAction Continue

# Send a metric for the installation of the module
Send-THEvent -ModuleName "ExtractPDFData" -EventName "Import Module ExtractPDFData"
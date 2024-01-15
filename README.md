# ExtractPDFData

![example workflow](https://github.com/autosysops/PowerShell_ExtractPDFData/actions/workflows/build.yml/badge.svg)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/ExtractPDFData.svg)](https://www.powershellgallery.com/packages/ExtractPDFData/)

PowerShell module to extract data from a PDF file. For now only supports extracting text with lay-out from the PDF file. Uses the FreeSpire.PDF assembly which is free for personal and commercial use.
Future features will be:

- Extract text without lay-out
- Extract images

## Installation

You can install the module from the [PSGallery](https://www.powershellgallery.com/packages/ExtractPDFData) by using the following command.

```PowerShell
Install-Module -Name ExtractPDFData
```

Or if you are using PowerShell 7.4 or higher you can use

```PowerShell
Install-PSResource -Name ExtractPDFData
```

## Usage

To use the module first import it.

```PowerShell
Import-Module -Name ExtractPDFData
```

You will receive a message about telemetry being enabled. After that you can use the command `Export-PDFDataTextWithLayout` to use the module.

Check out the Get-Help for more information on how to use the function.

## Credits

The module is using the [Telemetryhelper module](https://github.com/nyanhp/TelemetryHelper) to gather telemetry.
The module is made using the [PSModuleDevelopment module](https://github.com/PowershellFrameworkCollective/PSModuleDevelopment) to get a template for a module.
The module is using the [FreeSpire.PDF nuget package](https://www.nuget.org/packages/FreeSpire.PDF).

function Export-PDFDataTextWithLayout {
    <#
    .SYNOPSIS
        Extract text with lay-out from a PDF document.

    .DESCRIPTION
        Extract text with lay-out from a PDF document. The output will be a plain text document which tries to keep the text on the same place as in the normal document by using spaces to position it. Do note that all text is the same size so larger and smaller text could look wrong due to them being resized.

    .PARAMETER Path
        The path of the PDF file.

    .PARAMETER Page
        A page number or array of page numbers. When left empty all pages will be exported.

    .EXAMPLE
        Extract the text from all files.

        PS> Export-PDFDataTextWithLayout -Path .\file.pdf

    .EXAMPLE
        Extract page 1 and 2 from the file.

        PS> Export-PDFDataTextWithLayout -Path .\file.pdf -Page 1,2

    #>

    [CmdLetBinding()]
    [OutputType([System.Object[]])]

    Param (
        [Parameter(Mandatory = $true, Position = 1)]
        [String] $Path,

        [Parameter(Mandatory = $false, Position = 2)]
        [Int32[]] $Page
    )

    # Send telemetry
    Send-THEvent -ModuleName "ExtractPDFData" -EventName "Export-PDFDataTextWithLayout"

    # Load the document
    $document = [Spire.Pdf.PdfDocument]::new($path)

    # Create an output variable
    $convertedfile = @()

    # List all pages if not entered
    if ($null -eq $Page) {
        $Page = 1..($document.Pages.count)
    }

    # Convert every page
    $pageindex = 1
    $document.Pages | ForEach-Object {
        if ($pageindex -in $Page) {
            $convertedfile += $_.ExtractText()
        }
        $pageindex ++
    }

    return $convertedfile
}
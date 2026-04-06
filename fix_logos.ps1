# Read about.html content
$aboutPath = "c:\Users\DARK LORD\Desktop\Portfolio\about.html"
$aboutContent = Get-Content -Raw -Path $aboutPath -Encoding UTF8

# Extract the full base64 string
$target = 'src="data:image/png;base64,'
$startIndex = $aboutContent.IndexOf($target)
if ($startIndex -eq -1) {
    Write-Error "Could not find base64 string in about.html"
    exit 1
}
$startIndex += $target.Length
$endIndex = $aboutContent.IndexOf('"', $startIndex)
$fullBase64 = $aboutContent.Substring($startIndex, $endIndex - $startIndex)

Write-Host "Extracted full base64 string (Length: $($fullBase64.Length))"

# List of files to update
$filesToUpdate = @(
    "c:\Users\DARK LORD\Desktop\Portfolio\portfolio.html",
    "c:\Users\DARK LORD\Desktop\Portfolio\contact.html"
)

foreach ($file in $filesToUpdate) {
    if (Test-Path $file) {
        $content = Get-Content -Raw -Path $file -Encoding UTF8
        # Find the truncated base64 start
        $fileStart = $content.IndexOf($target)
        if ($fileStart -ne -1) {
            $fileStart += $target.Length
            $fileEnd = $content.IndexOf('"', $fileStart)
            
            # Replace the old base64 with the new full one
            $newContent = $content.Remove($fileStart, $fileEnd - $fileStart).Insert($fileStart, $fullBase64)
            Set-Content -Path $file -Value $newContent -Encoding UTF8
            Write-Host "Updated $file"
        } else {
            Write-Warning "Could not find base64 start in $file"
        }
    } else {
        Write-Error "File not found: $file"
    }
}

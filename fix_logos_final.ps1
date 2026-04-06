# Final Fix Script for Logo Signature Truncation
$aboutPath = "c:\Users\DARK LORD\Desktop\Portfolio\about.html"
$aboutContent = [System.IO.File]::ReadAllText($aboutPath)

# Find the logo-signature img tag. We look for the class and then the src.
$classTarget = 'class="logo-signature w-auto"'
$srcTarget = 'src="data:image/png;base64,'

$classPos = $aboutContent.IndexOf($classTarget)
if ($classPos -eq -1) {
    Write-Error "Could not find class 'logo-signature w-auto' in about.html"
    exit 1
}

# Search for the src attribute near the class
# Often it's right after or right before. We'll search in a range or just after.
$srcPos = $aboutContent.IndexOf($srcTarget, [Math]::Max(0, $classPos - 500))
if ($srcPos -eq -1 -or $srcPos -gt ($classPos + 500)) {
    Write-Error 'Could not find src="data... near the logo-signature class'
    exit 1
}

$startIndex = $srcPos + $srcTarget.Length
$endIndex = $aboutContent.IndexOf('"', $startIndex)
$fullBase64 = $aboutContent.Substring($startIndex, $endIndex - $startIndex)

Write-Host "Found signature base64! (Length: $($fullBase64.Length))"

# Update target files
$targets = @(
    "c:\Users\DARK LORD\Desktop\Portfolio\portfolio.html",
    "c:\Users\DARK LORD\Desktop\Portfolio\contact.html"
)

foreach ($targetFile in $targets) {
    if (Test-Path $targetFile) {
        $content = [System.IO.File]::ReadAllText($targetFile)
        $tPos = $content.IndexOf($srcTarget)
        if ($tPos -ne -1) {
            $tStart = $tPos + $srcTarget.Length
            $tEnd = $content.IndexOf('"', $tStart)
            $newContent = $content.Remove($tStart, $tEnd - $tStart).Insert($tStart, $fullBase64)
            [System.IO.File]::WriteAllText($targetFile, $newContent)
            Write-Host "Successfully updated $targetFile (Original size: $($content.Length), New size: $($newContent.Length))"
        } else {
            Write-Warning "Could not find signature src target in $targetFile"
        }
    } else {
        Write-Error "Target file not found: $targetFile"
    }
}

$files = '1 about.html', '2 about.html', '3 about.html'
foreach ($f in $files) {
    $c = Get-Content "$f" -Raw
    $open = ([regex]::Matches($c, '(?i)<div\b')).Count
    $close = ([regex]::Matches($c, '(?i)</div\b')).Count
    Write-Host "$f - div: $open, /div: $close"
}

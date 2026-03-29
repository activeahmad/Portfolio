$content = Get-Content '1.html' -Raw -Encoding UTF8
$bodyRegex = [regex]'(?is)<body[^>]*>(.*?)</body>'
$bodyMatch = $bodyRegex.Match($content)
Write-Output "Match success: $($bodyMatch.Success)"
if ($bodyMatch.Success) {
    Write-Output "Body length: $($bodyMatch.Groups[1].Value.Length)"
    Write-Output "Contains target: $($bodyMatch.Groups[1].Value.Contains('Digital Systems'))"
}

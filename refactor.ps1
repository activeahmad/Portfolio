$files = @("hero.html", "1.html", "2.html", "3.html", "4.html", "5.html", "6.html", "7.html")
$baseDir = "c:\Users\DARK LORD\Desktop\Portfolio"
$head_styles = @()
$body_contents = @()
$scripts = @()

foreach ($i in 0..($files.Count - 1)) {
    $file = $files[$i]
    $filepath = Join-Path $baseDir $file
    if (-Not (Test-Path $filepath)) { continue }
    
    $content = Get-Content $filepath -Raw -Encoding UTF8
    $idx = [string]$i
    
    # Extract styles BEFORE namespacing
    $styleRegex = [regex]'(?is)<style[^>]*>(.*?)</style>'
    $styleMatches = $styleRegex.Matches($content)
    $fileStyles = @()
    foreach ($m in $styleMatches) {
        $styleCode = $m.Groups[1].Value.Trim()
        if ($styleCode) {
            $styleCode = $styleCode -replace "(?i)\b(body|html)\b", ".section-$idx"
            $fileStyles += $styleCode
        }
    }
    
    # Extract scripts BEFORE namespacing
    $scriptRegex = [regex]'(?is)<script[^>]*>(.*?)</script>'
    $scriptMatches = $scriptRegex.Matches($content)
    $fileScripts = @()
    foreach ($m in $scriptMatches) {
        $scriptCode = $m.Groups[1].Value.Trim()
        if ($scriptCode -and $scriptCode -notmatch "tailwind\.config") {
            if ($idx -eq "1") {
                # Restore original particle counts/sizes from 1.html
                $scriptCode = $scriptCode -replace "i < 80", "i < 80"
            }
            $fileScripts += $scriptCode
        }
    }

    # Extract body content
    $bodyRegex = [regex]'(?is)<body[^>]*>(.*?)</body>'
    $bodyMatch = $bodyRegex.Match($content)
    if (-not $bodyMatch.Success) {
        $bodyRegex = [regex]'(?is)<main[^>]*>(.*?)</main>'
        $bodyMatch = $bodyRegex.Match($content)
    }

    $body = ""
    if ($bodyMatch.Success) {
        $body = $bodyMatch.Groups[1].Value
        $body = $body -replace "(?is)<script[^>]*>.*?</script>", ""
        $body = $body -replace "(?is)<style[^>]*>.*?</style>", ""
    } else {
        $body = $content -replace "(?is)<script[^>]*>.*?</script>", ""
        $body = $body -replace "(?is)<style[^>]*>.*?</style>", ""
        $body = $body -replace "(?is)<head>.*?</head>", ""
        $body = $body -replace "(?is)<!DOCTYPE.*?>", ""
        $body = $body -replace "(?is)<html.*?>", ""
        $body = $body -replace "(?is)</html>", ""
    }

    # Namespace IDs and classes
    $ids = @("particle-canvas", "particleCanvas", "particles-js", "log-container")
    $classes = @("glass-card", "perspective-container", "animate-float", "float", "card-container", "card-inner", "card-front", "card-back", "headline-main", "content-layer")
    
    foreach ($id in $ids) {
        $body = $body -replace "\b$id\b", "$id-$idx"
        for ($j=0; $j -lt $fileStyles.Count; $j++) { $fileStyles[$j] = $fileStyles[$j] -replace "\b$id\b", "$id-$idx" }
        for ($j=0; $j -lt $fileScripts.Count; $j++) { $fileScripts[$j] = $fileScripts[$j] -replace "\b$id\b", "$id-$idx" }
    }
    foreach ($cls in $classes) {
        $body = $body -replace "\b$cls\b", "$cls-$idx"
        for ($j=0; $j -lt $fileStyles.Count; $j++) { $fileStyles[$j] = $fileStyles[$j] -replace "\b$cls\b", "$cls-$idx" }
        for ($j=0; $j -lt $fileScripts.Count; $j++) { $fileScripts[$j] = $fileScripts[$j] -replace "\b$cls\b", "$cls-$idx" }
    }

    $head_styles += $fileStyles
    foreach ($s in $fileScripts) {
        $scripts += "(function() {`n$s`n})();"
    }
    
    # NO extra margins between sections - tight, flush layout
    $sectionStyle = "position: relative; width: 100%;"
    if ($file -eq "5.html") {
        $sectionStyle += " display: flex; justify-content: center; align-items: center;"
    }

    $body_contents += "<section id=""section-$idx"" class=""section-$idx"" style=""$sectionStyle"">`n$($body.Trim())`n</section>"
}

# CSS: base particle fix + all section styles
$base_css = @"
/* Performance: GPU acceleration for canvas layers */
#particles-js-1, #particle-canvas-0, #particle-canvas-2 {
  position: absolute;
  top: 0; left: 0;
  width: 100%; height: 100%;
  z-index: 0;
  will-change: transform;
}

/* Reduced motion: disable animations for users who prefer it */
@media (prefers-reduced-motion: reduce) {
  * { animation-duration: 0.001ms !important; transition-duration: 0.001ms !important; }
}

/* Mobile optimizations */
@media (max-width: 768px) {
  canvas { display: none; }
  .carousel-track { animation-duration: 60s; }
}
"@

$final_css = $base_css + "`n`n" + ($head_styles -join "`n`n")
Set-Content -Path (Join-Path $baseDir "style.css") -Value $final_css -Encoding UTF8

# JS: Performance guard wraps all scripts, skips canvas on mobile
$perf_js_header = @"
// Performance: Skip heavy canvas animations on mobile
var isMobile = window.innerWidth < 768 || /Mobi|Android/i.test(navigator.userAgent);

// Performance: rAF-throttled mousemove utility
var _rafMousePending = false;
function throttledMouseMove(canvas, cb) {
  document.addEventListener('mousemove', function(e) {
    if (_rafMousePending) return;
    _rafMousePending = true;
    requestAnimationFrame(function() {
      _rafMousePending = false;
      cb(e);
    });
  }, { passive: true });
}
"@

# Wrap each section script with a mobile guard
$wrappedScripts = @()
foreach ($s in $scripts) {
    # Canvas scripts (particle-canvas, particles-js) skip on mobile
    if ($s -match "particle" -or $s -match "canvas") {
        $wrappedScripts += "if (!isMobile) { (function() {`n$s`n})(); }"
    } else {
        $wrappedScripts += "(function() {`n$s`n})();"
    }
}

$final_js = $perf_js_header + "`n`n" + ($wrappedScripts -join "`n`n")
Set-Content -Path (Join-Path $baseDir "main.js") -Value $final_js -Encoding UTF8

$combined_html = @"
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Abdussalam Ahmad - Digital Portfolio</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800;900&family=Space+Grotesk:wght@300;400;500;600;700&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
<script>
  tailwind.config = {
    darkMode: "class",
    theme: {
      extend: {
        colors: {
          brandBlack: '#000000',
          brandGlass: '#111111',
          brandGray: '#BFBFBF',
          cyanAccent: '#00FFFF',
          silverGray: '#C0C0C0',
          brandCyan: '#00f2ff',
          darkGlass: '#111111',
          primary: "#00FFFF",
          'brand-black': '#000000',
        },
        fontFamily: {
          sans: ['Inter', 'sans-serif'],
          display: ["Space Grotesk", "sans-serif"],
          mono: ['Fira Code', 'monospace']
        }
      }
    }
  }
</script>
<link rel="stylesheet" href="style.css" />
<style>
  html { scroll-behavior: smooth; }
  body { background-color: #000; color: #fff; -webkit-font-smoothing: antialiased; margin: 0; padding: 0; overflow-x: hidden; }
  section { margin: 0; padding: 0; }
</style>
</head>
<body>
$($body_contents -join "`n")
<script src="main.js" defer></script>
</body>
</html>
"@

Set-Content -Path (Join-Path $baseDir "index.html") -Value $combined_html -Encoding UTF8
Write-Output "Optimized and spacing-fixed HTML generated successfully."

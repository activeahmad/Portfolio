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
    
    $content = $content -replace "\bparticle-canvas\b", "canvas-$idx"
    $content = $content -replace "\bparticleCanvas\b", "canvas-$idx"
    $content = $content -replace "\bparticles-js\b", "canvas-$idx"
    
    $classes = @("glass-card", "perspective-container", "animate-float", "float", "card-container", "card-inner", "card-front", "card-back")
    foreach ($cls in $classes) {
        $content = $content -replace "\.$cls", ".$cls-$idx"
        $content = $content -replace """$cls""", """$cls-$idx"""
        $content = $content -replace " $cls ", " $cls-$idx "
        $content = $content -replace " $cls""", " $cls-$idx"""
        $content = $content -replace """$cls ", """$cls-$idx """
        $content = $content -replace "'$cls'", "'$cls-$idx'"
    }

    # Extract styles
    $styleRegex = [regex]'(?is)<style[^>]*>(.*?)</style>'
    $styleMatches = $styleRegex.Matches($content)
    foreach ($m in $styleMatches) {
        $head_styles += $m.Groups[1].Value.Trim()
    }
    
    # Extract body
    $bodyRegex = [regex]'(?is)<body[^>]*>(.*?)</body>'
    $bodyMatch = $bodyRegex.Match($content)
    if ($bodyMatch.Success) {
        $body = $bodyMatch.Groups[1].Value
        
        $scriptRegex = [regex]'(?is)<script[^>]*>(.*?)</script>'
        $scriptMatches = $scriptRegex.Matches($body)
        foreach ($m in $scriptMatches) {
            $scriptCode = $m.Groups[1].Value.Trim()
            if ($scriptCode -and $scriptCode -notmatch "tailwind\.config") {
                $scripts += "(function() {`n$scriptCode`n})();"
            }
        }
        
        $body = $body -replace "(?is)<script[^>]*>.*?</script>", ""
        
        $sectionStyle = "position: relative; width: 100%;"
        if ($file -ne "hero.html") {
            $sectionStyle += " margin-top: 4rem; margin-bottom: 4rem;"
        }
        
        $body_contents += "<div class=""section-$idx"" style=""$sectionStyle"">`n$($body.Trim())`n</div>"
    }
}

$combined_html = @"
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Abdussalam Ahmad - Digital Portfolio</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/ScrollTrigger.min.js"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800;900&family=Space+Grotesk:wght@300;400;500;600;700&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
<link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />
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
          "background-light": "#f5f7f8",
          "background-dark": "#000000",
          "card-dark": "#111111",
          "accent-gray": "#BFBFBF",
          'brand-black': '#000000',
          'brand-gray': '#888888',
        },
        fontFamily: {
          sans: ['Inter', 'sans-serif'],
          display: ["Space Grotesk", "sans-serif"],
          mono: ['Fira Code', 'monospace']
        },
        animation: {
          'glow-pulse': 'glowPulse 3s infinite ease-in-out',
          'pulse-slow': 'pulse 4s cubic-bezier(0.4, 0, 0.6, 1) infinite',
          'gradient-slow': 'gradient 8s ease infinite',
          'fade-slide-up': 'fadeSlideUp 1s ease-out forwards',
        },
        keyframes: {
          glowPulse: {
            '0%, 100%': { boxShadow: '0 0 15px #00FFFF, 0 0 30px #00FFFF' },
            '50%': { boxShadow: '0 0 25px #00FFFF, 0 0 50px #00FFFF' },
          },
          gradient: {
            '0%, 100%': { 'background-position': '0% 50%' },
            '50%': { 'background-position': '100% 50%' },
          },
          fadeSlideUp: {
            '0%': { opacity: '0', transform: 'translateY(30px)' },
            '100%': { opacity: '1', transform: 'translateY(0)' },
          }
        }
      }
    }
  }
</script>
<style>
$($head_styles -join "`n")
</style>
</head>
<body class="font-sans text-white bg-black antialiased overflow-x-hidden">
$($body_contents -join "`n")
<script>
$($scripts -join "`n")
</script>
<script src="https://unpkg.com/aos@next/dist/aos.js"></script>
<script>
  AOS.init({
    duration: 800,
    once: true
  });
</script>
</body>
</html>
"@

Set-Content -Path (Join-Path $baseDir "home.html") -Value $combined_html -Encoding UTF8
Write-Output "Combined HTML generated successfully to home.html"

$index = Get-Content -Raw -Encoding UTF8 "index.html"
$about1 = Get-Content -Raw -Encoding UTF8 "1 about.html"
$about2 = Get-Content -Raw -Encoding UTF8 "2 about.html"
$about3 = Get-Content -Raw -Encoding UTF8 "3 about.html"

# Function to extract using regex
function Extract-Regex {
    param($content, $pattern)
    if ($content -match $pattern) {
        return $matches[1]
    }
    return ""
}

# Bodies from source files
$bodyPattern = '(?is)<body[^>]*>(.*?)</body>'
$body1 = Extract-Regex $about1 $bodyPattern
$body2 = Extract-Regex $about2 $bodyPattern
$body3 = Extract-Regex $about3 $bodyPattern

# Extract STYLES from each about file (Skip scripts to avoid duplicate execution)
function Get-Head-Assets {
    param($fileContent)
    $styleMatches = [regex]::Matches($fileContent, '(?is)<style[^>]*>.*?</style>') | ForEach-Object { $_.Value }
    return @($styleMatches)
}

$allAssets = @()
$allAssets += Get-Head-Assets $about1
$allAssets += Get-Head-Assets $about2
$allAssets += Get-Head-Assets $about3

# Deduplicate assets
$uniqueAssets = $allAssets | Select-Object -Unique

$combinedAssets = $uniqueAssets -join "`n"

# Extract Template Parts
$head = Extract-Regex $index '(?is)<head>(.*?)</head>'
$nav = Extract-Regex $index '(?is)(<nav.*?</nav>)'
$footer = Extract-Regex $index '(?is)(<!-- BEGIN: Footer Section -->.*?</footer[^>]*>)'
if ([string]::IsNullOrEmpty($footer)) {
    $footer = Extract-Regex $index '(?is)(<footer[^>]*>.*?</footer>)'
}

$html = @"
<!DOCTYPE html>
<html lang="en" class="dark scroll-smooth">
<head>
$head
<!-- Dynamically Included Assets -->
$combinedAssets
<style>
  /* Ensure Hero and Bio have solid black background to cover the Milestone fixed canvas */
  #hero-container, #bio-container {
    background-color: #000000;
    position: relative;
    z-index: 20; /* Keep these above the fixed canvas */
  }
  #milestone-container {
    position: relative;
    z-index: 10;
    background: #000;
  }
  .milestone-marker {
    height: 100vh;
    pointer-events: none;
    position: relative;
    z-index: 15;
  }
  #canvas-container-milestones {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100vh;
    z-index: 5;
    pointer-events: none;
    opacity: 0;
    display: block !important; /* Ensure it's not hidden by default display:none */
    transition: opacity 0.5s ease-in-out;
  }
  #milestone-container.active #canvas-container-milestones {
    opacity: 1;
  }
</style>
</head>
<body class="bg-black text-white antialiased selection:bg-cyan-400 selection:text-black">

<!-- Global Nav -->
<div id="nav-wrapper" style="position: sticky; top: 0; width: 100%; z-index: 100; background: rgba(0,0,0,0.8); backdrop-filter: blur(10px);">
$nav
</div>

<!-- Hero Section -->
<div id="hero-container">
$body1
</div>

<!-- Bio Section -->
<div id="bio-container">
$body2
</div>

<!-- Milestone Section -->
<div id="milestone-container">
$body3
</div>

<!-- Global Footer -->
<div id="footer-wrapper" style="position: relative; width: 100%; z-index: 100; background: #000;">
$footer
</div>

</body>
</html>
"@

Set-Content -Path "about.html" -Value $html -Encoding UTF8
Write-Output "Successfully created about.html with isolated namespaces and fixed stacking."

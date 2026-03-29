import re

def extract_head(content):
    match = re.search(r'(?is)<head>(.*?)</head>', content)
    return match.group(1) if match else ""

def extract_body(content):
    match = re.search(r'(?is)<body[^>]*>(.*?)</body>', content)
    return match.group(1) if match else ""

def extract_styles(content):
    matches = re.findall(r'(?is)<style[^>]*>(.*?)</style>', content)
    return "\n".join(matches)

def extract_scripts(content):
    matches = re.findall(r'(?is)<script[^>]*>(.*?)</script>', content)
    return "\n".join([m for m in matches if 'tailwind.config' not in m and 'cdn.tailwindcss.com' not in m])

def extract_nav(content):
    match = re.search(r'(?is)<nav.*?</nav>', content)
    return match.group(0) if match else ""

def extract_footer(content):
    match = re.search(r'(?is)<!-- BEGIN: Footer Section -->.*?</footer[^>]*>', content)
    if not match:
        match = re.search(r'(?is)<footer[^>]*>.*?</footer>', content)
    return match.group(0) if match else ""

def read_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        return f.read()

def main():
    try:
        idx_content = read_file('index.html')
        about1 = read_file('1 about.html')
        about2 = read_file('2 about.html')
        about3 = read_file('3 about.html')
    except Exception as e:
        print(f"Error reading files: {e}")
        return

    # Extract global header and footer
    nav_html = extract_nav(idx_content)
    footer_html = extract_footer(idx_content)

    # Extract sections
    body1 = extract_body(about1)
    # Remove scripts from bodies if we want to extract them
    body1_clean = re.sub(r'(?is)<script[^>]*>.*?</script>', '', body1)
    
    body2 = extract_body(about2)
    body2_clean = re.sub(r'(?is)<script[^>]*>.*?</script>', '', body2)
    
    body3 = extract_body(about3)
    # We shouldn't remove scripts from body3 because it might have data-purpose="three-js-logic" which we need.
    # Actually, let's keep scripts where they are, or extract them.
    # It's safer to keep body scripts inline.
    
    # Extract styles
    styles1 = extract_styles(about1)
    styles2 = extract_styles(about2)
    styles3 = extract_styles(about3)

    combined_styles = f"{styles1}\n{styles2}\n{styles3}"
    
    # We need to construct the document
    head_content = extract_head(idx_content)
    # Replace existing styles in head if any, or just append
    if '<style>' in head_content:
        # insert combined_styles before </style>
        pass # actually head_content doesn't have </style> wrapper, it's the inner content.
    
    # Combine everything
    html = f"""<!DOCTYPE html>
<html lang="en" class="dark">
<head>
{head_content}
<style>
{combined_styles}
</style>
</head>
<body>
<!-- Global Nav -->
<section id="section-0" class="section-0" style="position: relative; width: 100%;">
{nav_html}
</section>

<!-- Hero Section -->
{body1}

<!-- Story Section -->
{body2}

<!-- Milestone Section -->
{body3}

<!-- Global Footer -->
<section style="position: relative; width: 100%;">
{footer_html}
</section>

<script src="main.js" defer></script>
</body>
</html>
"""

    with open('about.html', 'w', encoding='utf-8') as f:
        f.write(html)
    print("Successfully created about.html")

if __name__ == '__main__':
    main()

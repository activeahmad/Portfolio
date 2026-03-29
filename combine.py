import os
import re

files = ['hero.html', '1.html', '2.html', '3.html', '4.html', '5.html', '6.html', '7.html']
out_file = 'index.html'
base_dir = r"c:\Users\DARK LORD\Desktop\Portfolio"

head_styles = []
body_contents = []
scripts = []

fonts = set()
fonts.add('<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800;900&family=Space+Grotesk:wght@300;400;500;600;700&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet"/>')
fonts.add('<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>')

def replace_word(text, word, new_word):
    # Replaces a word boundary
    return re.sub(r'\b' + re.escape(word) + r'\b', new_word, text)

for i, f in enumerate(files):
    filepath = os.path.join(base_dir, f)
    if not os.path.exists(filepath):
        continue
    with open(filepath, 'r', encoding='utf-8') as f_in:
        content = f_in.read()
        
        # Replace IDs and common collisions to make them unique
        idx = str(i)
        
        # Canvas IDs
        for cid in ['particle-canvas', 'particleCanvas', 'particles-js']:
            content = replace_word(content, cid, f'canvas-{idx}')
        
        # CSS Classes
        for cls in ['glass-card', 'perspective-container', 'animate-float', 'float', 'card-container', 'card-inner', 'card-front', 'card-back']:
            content = content.replace(f'.{cls}', f'.{cls}-{idx}')
            content = content.replace(f'"{cls}"', f'"{cls}-{idx}"')
            content = content.replace(f' {cls} ', f' {cls}-{idx} ')
            content = content.replace(f' {cls}"', f' {cls}-{idx}"')
            content = content.replace(f'"{cls} ', f'"{cls}-{idx} ')
            content = content.replace(f"'{cls}'", f"'{cls}-{idx}'")
        
        # Add spacing for sections
        section_style = "position: relative; width: 100%;"
        if f == 'hero.html':
            pass # Keep hero spacing natural
        else:
            section_style += " margin-top: 4rem; margin-bottom: 4rem;"
            
        # Extract styles
        style_matches = re.finditer(r'<style[^>]*>(.*?)</style>', content, re.DOTALL | re.IGNORECASE)
        for s in style_matches:
            head_styles.append(s.group(1).strip())
            
        # Extract body
        body_match = re.search(r'<body[^>]*>(.*?)</body>', content, re.DOTALL | re.IGNORECASE)
        if body_match:
            body = body_match.group(1)
            
            # Extract and remove scripts from body
            script_matches = re.finditer(r'<script[^>]*>(.*?)</script>', body, re.DOTALL | re.IGNORECASE)
            for s in script_matches:
                script_code = s.group(1).strip()
                if script_code:
                    scripts.append(f"(function() {{\n{script_code}\n}})();")
            
            body = re.sub(r'<script[^>]*>.*?</script>', '', body, flags=re.DOTALL | re.IGNORECASE)
            
            body_contents.append(f'<div class="section-{idx}" style="{section_style}">\n{body.strip()}\n</div>')

combined_html = f"""<!DOCTYPE html>
<html lang="en" class="dark">
<head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Abdussalam Ahmad - Digital Portfolio</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
{''.join(fonts)}
<script>
  tailwind.config = {{
    darkMode: "class",
    theme: {{
      extend: {{
        colors: {{
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
        }},
        fontFamily: {{
          sans: ['Inter', 'sans-serif'],
          display: ["Space Grotesk", "sans-serif"],
          mono: ['Fira Code', 'monospace']
        }},
        animation: {{
          'glow-pulse': 'glowPulse 3s infinite ease-in-out',
          'pulse-slow': 'pulse 4s cubic-bezier(0.4, 0, 0.6, 1) infinite',
          'gradient-slow': 'gradient 8s ease infinite',
          'fade-slide-up': 'fadeSlideUp 1s ease-out forwards',
        }},
        keyframes: {{
          glowPulse: {{
            '0%, 100%': {{ boxShadow: '0 0 15px #00FFFF, 0 0 30px #00FFFF' }},
            '50%': {{ boxShadow: '0 0 25px #00FFFF, 0 0 50px #00FFFF' }},
          }},
          gradient: {{
            '0%, 100%': {{ 'background-position': '0% 50%' }},
            '50%': {{ 'background-position': '100% 50%' }},
          }},
          fadeSlideUp: {{
            '0%': {{ opacity: '0', transform: 'translateY(30px)' }},
            '100%': {{ opacity: '1', transform: 'translateY(0)' }},
          }}
        }}
      }}
    }}
  }}
</script>
<style>
{''.join(head_styles)}
</style>
</head>
<body class="font-sans text-white bg-black antialiased overflow-x-hidden">
{''.join(body_contents)}
<script>
{''.join(scripts)}
</script>
</body>
</html>
"""

with open(os.path.join(base_dir, out_file), 'w', encoding='utf-8') as f_out:
    f_out.write(combined_html)
print("Combined HTML generated successfully.")

import re

with open("1.html", "r", encoding="utf-8") as f:
    content = f.read()

m = re.search(r'<body[^>]*>(.*?)</body>', content, re.DOTALL | re.IGNORECASE)
if m:
    print("Match found:")
    body = m.group(1)
    print("Length:", len(body))
    print("Contains 'digital systems':", "digital systems" in body.lower())
else:
    print("No match found.")

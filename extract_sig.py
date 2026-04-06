import sys
import os

try:
    with open(r'c:\Users\DARK LORD\Desktop\Portfolio\about.html', 'r', encoding='utf-8') as f:
        content = f.read()
        target = 'src="data:image/png;base64,'
        start = content.find(target)
        if start == -1:
            print("Base64 string not found in about.html")
            sys.exit(1)
        start += len(target)
        end = content.find('"', start)
        signature = content[start:end]
        
        with open(r'c:\Users\DARK LORD\Desktop\Portfolio\signature_full.txt', 'w', encoding='utf-8') as out:
            out.write(signature)
        print(f"Success! Extracted {len(signature)} characters to signature_full.txt")

except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)

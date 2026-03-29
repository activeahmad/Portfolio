
with open('2 about.html', 'r', encoding='utf-8') as f:
    for i, line in enumerate(f, 1):
        if 'ABOUT <span' in line:
            print(f"Line {i}: {line[:100]}")
        if '<main' in line:
            print(f"Line {i}: {line[:100]}")
        if '</body>' in line:
            print(f"Line {i}: {line[:100]}")

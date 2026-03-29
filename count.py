for f in ['1 about.html', '2 about.html', '3 about.html']: c = open(f, 'r', encoding='utf-8').read(); print(f'{f} - div: {c.count(chr(60)+\"div\")}, /div: {c.count(chr(60)+\"/div\")}')

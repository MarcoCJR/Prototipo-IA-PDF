from tika import parser # pip install tika

raw = parser.from_file('Automação PDF.pdf')
print(raw['content'])
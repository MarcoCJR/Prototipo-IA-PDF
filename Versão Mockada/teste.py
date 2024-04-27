from tika import parser # pip install tika

raw = parser.from_file('proposta-exemplo.docx')
print(raw['content'])
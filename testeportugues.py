from transformers import pipeline
from tika import parser # pip install tika

raw = parser.from_file('proposta-exemplo.docx')
formatado = raw['content']

context = formatado

model_name = 'pierreguillou/bert-base-cased-squad-v1.1-portuguese'
nlp = pipeline("question-answering", model=model_name)

question = "Qual o prazo de validade da proposta?"

result = nlp(question=question, context=context)

print(f"Answer: '{result['answer']}', score: {round(result['score'], 4)}, start: {result['start']}, end: {result['end']}")
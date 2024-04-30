from transformers import pipeline
from tika import parser # pip install tika
import mysql.connector

config = {
    'user': 'root',
    'password': '_Arc3usadmin7410',
    'host': 'localhost',
    'database': 'Fornecedores',
    'raise_on_warnings': True
}

try:
    cnx = mysql.connector.connect(**config)
    
    cursor = cnx.cursor()
    
    
    print("Conexão bem-sucedida!")
    
    raw = parser.from_file('proposta-exemplo.docx')
    formatado = raw['content']

    context = formatado

    model_name = 'pierreguillou/bert-base-cased-squad-v1.1-portuguese'
    nlp = pipeline("question-answering", model=model_name)

    question1 = "Qual o nome da empresa?"
    response1 = nlp(question=question1, context=formatado)
    print(f"{response1['answer']}")

    question2 = "Quais o endereço?"
    response2 = nlp(question=question2, context=formatado)
    print(f"{response2['answer']}")

    question3 = "Qual o CEP da empresa?"
    response3 = nlp(question=question3, context=formatado)
    print(f"{response3['answer']}")

    question4 = "Qual o email da empresa?"
    response4 = nlp(question=question4, context=formatado)
    print(f"{response4['answer']}")
        
    question5 = "Qual o telefone da empresa?"
    response5 = nlp(question=question5, context=formatado)
    print(f"{response5['answer']}")
    
    question6 = "Qual o banco da empresa?"
    response6 = nlp(question=question6, context=formatado)
    print(f"{response6['answer']}")
    
    query = "INSERT INTO Fornecedor (empresa, endereco, cep, email, telefone, banco) VALUES (%s, %s, %s, %s, %s, %s)"
    data = (
        response1['answer'],
        response2['answer'],
        response3['answer'],
        response4['answer'],
        response5['answer'],
        response6['answer']
    )
    
    cursor.execute(query, data)
    cnx.commit()
    
except mysql.connector.Error as err:
    print(f"Erro ao conectar: {err}")
finally:
    cursor.close()
    cnx.close()
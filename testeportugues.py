# Importações
import tkinter as tk
from tkinter import filedialog
from transformers import pipeline
from tika import parser
import mysql.connector

# Função para extrair informações do arquivo
def extrair_informacoes(arquivo):
    # Credenciais do banco
    config = {
        'user': 'root',
        'password': '_Arc3usadmin7410',
        'host': 'localhost',
        'database': 'Fornecedores',
        'raise_on_warnings': True
    }

    try:
        # Conexão com o banco de dados
        cnx = mysql.connector.connect(**config)
        cursor = cnx.cursor()
        print("Conexão bem-sucedida!")

        # Extração de texto do arquivo
        raw = parser.from_file(arquivo)
        formatado = raw['content']
        context = formatado

        # Modelo de linguagem para responder perguntas
        model_name = 'pierreguillou/bert-base-cased-squad-v1.1-portuguese'
        nlp = pipeline("question-answering", model=model_name)

        # Extração de informações da empresa
        question1 = "Qual o nome da empresa?"
        response1 = nlp(question=question1, context=formatado)

        question2 = "Quais o endereço?"
        response2 = nlp(question=question2, context=formatado)

        question3 = "Qual o CEP da empresa?"
        response3 = nlp(question=question3, context=formatado)

        question4 = "Qual o email da empresa?"
        response4 = nlp(question=question4, context=formatado)

        question5 = "Qual o telefone da empresa?"
        response5 = nlp(question=question5, context=formatado)

        question6 = "Qual o banco da empresa?"
        response6 = nlp(question=question6, context=formatado)

        # Extração de informações da proposta
        question7 = "Qual o item?"
        response7 = nlp(question=question7, context=formatado)

        question8 = "Qual a especificação?"
        response8 = nlp(question=question8, context=formatado)

        question9 = "Qual a unidade?"
        response9 = nlp(question=question9, context=formatado)

        question10 = "Qual a quantidade total?"
        response10 = nlp(question=question10, context=formatado)

        question11 = "Qual o valor total?"
        response11 = nlp(question=question11, context=formatado)

        # Inserção de dados no banco de dados
        query_fornecedor = "INSERT INTO Fornecedor (empresa, endereco, cep, email, telefone, banco) VALUES (%s, %s, %s, %s, %s, %s)"
        data_fornecedor = (
            response1['answer'],
            response2['answer'],
            response3['answer'],
            response4['answer'],
            response5['answer'],
            response6['answer']
        )
        cursor.execute(query_fornecedor, data_fornecedor)
        cnx.commit()

        id_fornecedor = cursor.lastrowid

        query_proposta = "INSERT INTO Proposta (fkFornecedor, item, especificacao, unidade, qtdTotal, valorTotal) VALUES (%s, %s, %s, %s, %s, %s)"
        data_proposta = (
            id_fornecedor,
            response7['answer'],
            response8['answer'],
            response9['answer'],
            response10['answer'],
            response11['answer']
        )
        cursor.execute(query_proposta, data_proposta)
        cnx.commit()

    except mysql.connector.Error as err:
        print(f"Erro ao conectar: {err}")

    finally:
        cursor.close()
        cnx.close()
    
# Interface gráfica
app = tk.Tk()
app.title("Extrator de Informações")

# Seção de seleção de arquivo
frame_selecao_arquivo = tk.Frame(app, borderwidth=10)
frame_selecao_arquivo.pack(padx=10, pady=10)

rotulo_arquivo = tk.Label(frame_selecao_arquivo, text="Caminho do Arquivo:")
rotulo_arquivo.grid(row=0, column=0, sticky=tk.W)

texto_arquivo = tk.Entry(frame_selecao_arquivo)
texto_arquivo.grid(row=0, column=1, padx=10)

# Botão para selecionar o arquivo
def selecionar_arquivo():
    try:
        arquivo = tk.filedialog.askopenfilename()
        if arquivo:
            texto_arquivo.delete(0, tk.END)
            texto_arquivo.insert(0, arquivo)
            label_status.config(text=f"Arquivo selecionado com sucesso!")
    except Exception as e:
        print(f"Erro ao selecionar arquivo: {e}")

botao_selecionar = tk.Button(frame_selecao_arquivo, text="Selecionar Arquivo", command=selecionar_arquivo)
botao_selecionar.grid(row=0, column=2, padx=10)

# Seção de status
frame_status = tk.Frame(app, borderwidth=10)
frame_status.pack(padx=10, pady=10)

label_status = tk.Label(frame_status, text="Aguardando arquivo...")
label_status.grid(row=0, column=0)

# Seção de resultados
# ... (Adicione aqui a seção para exibir os resultados da extração)

# Botão para processar o arquivo
botao_processar = tk.Button(app, text="Processar", command=lambda: extrair_informacoes(texto_arquivo.get()))
botao_processar.pack(pady=10)

app.mainloop()
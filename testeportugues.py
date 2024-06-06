import tkinter as tk
from tkinter import filedialog
from transformers import pipeline
from tika import parser
import mysql.connector
import os
import re

def formatar_valor(valor):
    # Remove o símbolo de moeda e os pontos de milhar, e substitui a vírgula pelo ponto decimal
    valor = valor.replace("R$", "").replace(".", "").replace(",", ".")
    return float(valor)

def extrair_informacoes(arquivo):
    print("Cheguei na config banco")
    config = {
        'user': 'root',
        'password': '_Arc3usadmin7410',
        'host': 'fornecedores.cnuo4ucey4lj.us-east-1.rds.amazonaws.com',
        'database': 'Fornecedores',
        'raise_on_warnings': True
    }

    cnx = mysql.connector.connect(**config)
    cursor = cnx.cursor()
    
    try:
        print("Cheguei na conexão")
        print("Conexão bem-sucedida!")
        print("Cheguei na extração")
        
        raw = parser.from_file(arquivo)
        formatado = raw['content']
        context = formatado

        print("Cheguei nas perguntas")
        model_name = 'pierreguillou/bert-base-cased-squad-v1.1-portuguese'
        nlp = pipeline("question-answering", model=model_name)

        questions = [
            "Qual o nome da empresa?",
            "Qual o endereço?",
            "Qual o CEP da empresa?",
            "Qual o CNPJ da empresa?",
            "Qual o e-mail?",
            "Qual o telefone da empresa?",
            "Qual o banco da empresa?",
            "Quanto tempo de experiência?",
            "Qual a data de entrega?",
            "Qual o valor total?"
        ]

        responses = [nlp(question=q, context=formatado) for q in questions]
        
        response_dict = {f"response{i+1}": responses[i]['answer'] for i in range(len(responses))}

        # Formatar o valor total para decimal
        valor_total_formatado = formatar_valor(response_dict['response10'])
        
        # Extrair o nome do arquivo do caminho completo
        nome_arquivo = os.path.basename(arquivo)

        # Extrair o número da solicitação do nome do arquivo
        match = re.search(r'\d+', nome_arquivo)
        id_solicitacao = int(match.group()) if match else None

        print("Cheguei no insert")
        
        query_fornecedor = "INSERT INTO Fornecedor (empresa, endereco, cep, cnpj, email, telefone, banco, anosExperiencia) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
        data_fornecedor = (
            response_dict['response1'],
            response_dict['response2'],
            response_dict['response3'],
            response_dict['response4'],
            response_dict['response5'],
            response_dict['response6'],
            response_dict['response7'],
            response_dict['response8']
        )
        cursor.execute(query_fornecedor, data_fornecedor)
        cnx.commit()

        id_fornecedor = cursor.lastrowid

        query_proposta = "INSERT INTO Proposta (fkFornecedor, fkSolicitacao, nome, dtEntrega, valorTotal, escolhido) VALUES (%s, %s, %s, %s, %s, False)"
        data_proposta = (
            id_fornecedor,
            id_solicitacao,
            nome_arquivo,
            response_dict['response9'],
            valor_total_formatado  # Usar o valor formatado
        )
        cursor.execute(query_proposta, data_proposta)
        cnx.commit()

    except mysql.connector.Error as err:
        print(f"Erro ao conectar: {err}")

    finally:
        cursor.close()
        cnx.close()
        print("Terminou")

print("Criei interface")
app = tk.Tk()
app.title("Extrator de Informações")

frame_selecao_arquivo = tk.Frame(app, borderwidth=10)
frame_selecao_arquivo.pack(padx=10, pady=10)

rotulo_arquivo = tk.Label(frame_selecao_arquivo, text="Caminho do Arquivo:")
rotulo_arquivo.grid(row=0, column=0, sticky=tk.W)

texto_arquivo = tk.Entry(frame_selecao_arquivo)
texto_arquivo.grid(row=0, column=1, padx=10)

def selecionar_arquivo():
    print("Cheguei na função criar arquivo")
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

frame_status = tk.Frame(app, borderwidth=10)
frame_status.pack(padx=10, pady=10)

label_status = tk.Label(frame_status, text="Aguardando arquivo...")
label_status.grid(row=0, column=0)

botao_processar = tk.Button(app, text="Processar", command=lambda: extrair_informacoes(texto_arquivo.get()))
botao_processar.pack(pady=10)

app.mainloop()
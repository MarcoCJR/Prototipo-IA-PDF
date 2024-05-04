import tkinter as tk
from tkinter import filedialog
from transformers import pipeline
from tika import parser
import mysql.connector


def extrair_informacoes(arquivo):
    # CREDENCIAIS DO BANCO
    config = {
        'user': 'root',
        'password': '_Arc3usadmin7410',
        'host': 'localhost',
        'database': 'Fornecedores',
        'raise_on_warnings': True
    }

    try:
        # Leitura do arquivo
        with open(arquivo, 'r', encoding='utf-8') as f:
            texto_arquivo = f.read()

        # Processamento do texto
        texto_formatado = remover_caracteres_especiais(texto_arquivo)
        context = texto_formatado.lower()

        # Modelo de perguntas e respostas
        model_name = 'pierreguillou/bert-base-cased-squad-v1.1-portuguese'
        nlp = pipeline("question-answering", model=model_name)

        # Extração das informações
        informacoes = extrair_informacoes_por_pergunta(nlp, context)

        # Conexão com o banco de dados
        with mysql.connector.connect(**config) as cnx:
            cursor = cnx.cursor()

            # Inserção dos dados na tabela Fornecedor
            query_fornecedor = "INSERT INTO Fornecedor (empresa, endereco, cep, email, telefone, banco) VALUES (%s, %s, %s, %s, %s, %s)"
            data_fornecedor = (
                informacoes['empresa'],
                informacoes['endereco'],
                informacoes['cep'],
                informacoes['email'],
                informacoes['telefone'],
                informacoes['banco'],
            )
            cursor.execute(query_fornecedor, data_fornecedor)
            cnx.commit()

            # Recuperação do ID do fornecedor
            id_fornecedor = cursor.lastrowid

            # Inserção dos dados na tabela Proposta
            query_proposta = "INSERT INTO Proposta (fkFornecedor, item, especificacao, unidade, qtdTotal, valorTotal) VALUES (%s, %s, %s, %s, %s, %s)"
            data_proposta = (
                id_fornecedor,
                informacoes['item'],
                informacoes['especificacao'],
                informacoes['unidade'],
                informacoes['qtdTotal'],
                informacoes['valorTotal'],
            )
            cursor.execute(query_proposta, data_proposta)
            cnx.commit()

    except Exception as e:
        print(f"Erro ao processar o arquivo: {e}")


# Função para remover caracteres especiais
def remover_caracteres_especiais(texto):
    # Implementação da função para remover caracteres indesejados do texto
    # (por exemplo, acentos, pontuação, caracteres especiais)
    pass


# Função para extrair informações por pergunta
def extrair_informacoes_por_pergunta(nlp, context):
    # Defina as perguntas que deseja extrair as informações
    perguntas = [
        "Qual o nome da empresa?",
        "Quais o endereço?",
        "Qual o CEP da empresa?",
        "Qual o email da empresa?",
        "Qual o telefone da empresa?",
        "Qual o banco da empresa?",
        "Qual o item?",
        "Qual a especificação?",
        "Qual a unidade?",
        "Qual a quantidade total?",
        "Qual o valor total?",
    ]

    # Inicialize um dicionário para armazenar as respostas
    respostas = {}

    # Extraia as respostas para cada pergunta
    for pergunta in perguntas:
        resposta = nlp(question=pergunta, context=context)
        respostas[pergunta] = resposta['answer']

    # Retorne o dicionário com as respostas extraídas
    return respostas


# Interface gráfica
app = tk.Tk()
app.title("Extrator de Informações")

# Seção de seleção de arquivo
frame_selecao_arquivo = tk.Frame(app, borderwidth=10)
frame_selecao_arquivo.pack(padx=10, pady=10)

rotulo_arquivo = tk.Label(frame_selecao_arquivo, text="Caminho do Arquivo:")
rotulo_arquivo.grid(row=0, column=0, sticky=tk.W)

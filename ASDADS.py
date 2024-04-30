import pdfplumber
import mysql.connector

pdf_path = "Proposta.pdf"

tabela_proposta = []
tabela_empresa = []

with pdfplumber.open(pdf_path) as pdf:
    for page_number, page in enumerate(pdf.pages, 1):
        table = page.extract_table()

        if page_number == 1:
            tabela_proposta.extend(table)
        elif page_number == 2:
            tabela_empresa.extend(table)

config = {
    'user': 'root',
    'password': 'Mpi29*1910',
    'host': 'localhost',
    'database': 'grupo7',
    'raise_on_warnings': True
}


def send_data(sql, values):
    conn = None
    cursor = None
    last_row_id = None

    print(sql)
    print(values)

    try:
        conn = mysql.connector.connect(**config)
        cursor = conn.cursor()

        cursor.execute(sql, values)

        conn.commit()

        last_row_id = cursor.lastrowid

        print(last_row_id)

    except mysql.connector.Error as err:
        print(f"Erro ao inserir dados no banco de dados! {err}")
        return None
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()
        return last_row_id



tabela_proposta = [linha[1] for linha in tabela_proposta]
sql_proposta = "INSERT INTO proposta (item, especificacao, unidade, qtdTotal, valorUnitario, valorTotal) VALUES (%s ,%s, %s, %s, %s, %s)"
id_proposta = send_data(sql_proposta, tabela_proposta)

if id_proposta is not None:
    tabela_empresa = [linha[1] for linha in tabela_empresa]
    sql_fornecedor = f"INSERT INTO fornecedor (fk_proposta, empresa, endereco, email, cep, celular, banco, nomeCompleto) VALUES ({id_proposta},%s,%s,%s,%s,%s,%s,%s)"
    send_data(sql_fornecedor, tabela_empresa)
else:
    print("Não foi possivel enfiar o dedo no cu")
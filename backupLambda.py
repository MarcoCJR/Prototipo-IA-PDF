import json
import boto3
import io
from io import StringIO
import csv
from fpdf import FPDF

s3_client = boto3.client('s3')

def generatePdf(text):
    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Arial", size=12)
    
    pdf.write(8, text)
    pdf_file_name = "test-pdf.pdf"
    pdf.output('/tmp/' + pdf_file_name, 'F')
    
    print("Renomeando pdf")
    return pdf_file_name

def lambda_handler(event, context):
    try:
        s3_Bucket_Name = event["Records"][0]["s3"]["bucket"]["name"]
        s3_File_Name = event["Records"][0]["s3"]["object"]["key"]
        
        object = s3_client.get_object(Bucket=s3_Bucket_Name, Key=s3_File_Name)
        data = object['Body'].read().decode('utf-8').splitlines()
        
        reader = csv.reader(data)
        headers = next(reader)
        delimiter = ','
        
        print(delimiter.join(headers))
        
        textFinal = []
        
        for i, line in enumerate(reader):
            for ii, i in enumerate(line):
                textFinal.append('{}: {}'.format(headers[ii], i))
                
        print('\n'.join(textFinal))
            
        pdf = generatePdf('\n'.join(textFinal))
        print("Criando incoming ")
        s3_client.upload_file("/tmp/" + pdf, "s3-lab05-sptech-marco", "incoming_pdf/" + pdf)

    except Exception as err:
        print(err)

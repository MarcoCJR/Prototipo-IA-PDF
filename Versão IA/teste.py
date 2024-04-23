from transformers import pipeline
import os

os.environ["CURL_CA_BUNDLE"]=""

img_path = "C:/Users/camposm/Documents/AI Faculdade/Prototipo-IA-PDF/Versão IA/contract.jpeg"

models_checkpoints = { "LayoutLMv1 🦉": "impira/layoutlm-document-qa",
    "LayoutLMv1 for Invoices": "impira/layoutlm-invoices",
    "Donut 🍩": "naver-clova-ix/donut-base-finetuned-docvqa",
}

pipe = pipeline("document-question-answering", model=models_checkpoints["LayoutLMv1 for Invoices"])

teste = pipe(image=img_path, question="what is the purchase amount?")

print(teste)
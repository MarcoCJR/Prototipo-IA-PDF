from transformers import pipeline

img_path = "C:/Users/rasmo/OneDrive/Documentos/Automação PDF/Automação PDF.pdf"

models_checkpoints = { "LayoutLMv1 🦉": "impira/layoutlm-document-qa",
    "LayoutLMv1 for Invoices": "impira/layoutlm-invoices",
    "Donut 🍩": "naver-clova-ix/donut-base-finetuned-docvqa",
}

pipe = pipeline("document-question-answering", model=models_checkpoints["LayoutLMv1 for Invoices"])

teste = pipe(image=img_path, question="qual o CNPJ?")

print(teste)
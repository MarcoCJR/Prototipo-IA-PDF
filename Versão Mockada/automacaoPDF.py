import pdfquery
import pandas as pd

#read the PDF
pdf = pdfquery.PDFQuery('Automação PDF.pdf')
pdf.load()


#convert the pdf to XML
pdf.tree.write('Automação PDF.xml', pretty_print = True)
pdf
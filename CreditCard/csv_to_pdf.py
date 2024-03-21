from fpdf import FPDF
import csv

# read the csv file
csv_file_path = 'CreditCard/credit_card.csv'
pdf_file_path = 'Pdf/credit_card.pdf'

# create a pdf object
pdf = FPDF()

# add a page
pdf.add_page()

# set the font
pdf.set_font("Arial", size=12)

# open the csv file
with open(csv_file_path, 'r') as file:
    reader = csv.reader(file)
    
    # for each row in the csv file print one row in the pdf file
    for row in reader:
        for item in row:
            pdf.cell(40, 10, str(item), border=1)
        pdf.ln()

# output the pdf file
pdf.output(pdf_file_path)
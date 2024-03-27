


# get data from the database (postgres) then put them in a format to be used to enhance a LLM with RAG



import psycopg2
from fpdf import FPDF

#connect to the DB


conn = psycopg2.connect(
    host="localhost",
    database="PFE",
    user="postgres",
    password="postgres")

print("-------------------------------------")
print("Connected to the database")
print("-------------------------------------")




# get the data from the database

cur = conn.cursor()
cur.execute("SELECT * FROM CreditCard")
rows = cur.fetchall()

print("-------------------------------------")
print("Data fetched from the database")
print("-------------------------------------")


# put the data in a list of lists

data = []
for row in rows:
    data.append(row)

print("-------------------------------------")
print("Data formatted")
print("-------------------------------------")


# close the connection to the database

cur.close()

conn.close()

print("-------------------------------------")
print("Connection closed")
print("-------------------------------------")


# create a pdf file and write the data in it



pdf = FPDF()

pdf.add_page()

pdf.set_font("Arial", size = 12)

for row in data:
    for item in row:
        pdf.cell(200, 10, str(item), 0, 1, 'C')

pdf.output("pdf/PFE.pdf")

print("-------------------------------------")
print("PDF created")
print("-------------------------------------")

































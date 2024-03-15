import pandas as pd
import psycopg2
import csv
import os

# connect to the database

conn = psycopg2.connect(
    host="localhost",
    database="PFE",
    user="postgres",
    password="postgres"
)

print("Database opened successfully")

# create a cursor
cur = conn.cursor()

# create the sql query
sql_query = "SELECT * FROM CreditCard"

# execute the sql query
cur.execute(sql_query)

# fetch the data
data = cur.fetchall()

# print the data
print("The data from the database is:")
for row in data:
    print(row)

#--------------------------------- create the csv files ---------------------------------#

# get the credit card informations using the credit card id

csv_file_path = 'csv/CreditCardID.csv'
os.makedirs(os.path.dirname(csv_file_path), exist_ok=True)  # Create the directory if it doesn't exist

with open(csv_file_path, 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["Prompt", "Response", "SQL Query"])

    for row in data:
        prompt = "What are the credit card informations of the card with the id of " + str(row[0]) + "?"
        response = "the credit card with the id of " + str(row[0]) + " is a " + row[1] + " with the number of " + row[2] + " and the expiration date of " + str(row[3]) + "/" + str(row[4]) + " and it was last modified on " + str(row[5])
        sql_query = "SELECT * FROM CreditCard WHERE CreditCardID = " + str(row[0])

        writer.writerow([prompt, response, sql_query])


# get the credit card informations using the credit card number

csv_file_path = 'csv/CreditCardNumber.csv'
os.makedirs(os.path.dirname(csv_file_path), exist_ok=True)  # Create the directory if it doesn't exist

with open(csv_file_path, 'a', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["Prompt", "Response", "SQL Query"])

    for row in data:
        prompt = "What are the credit card informations of the user with the number of " + row[2] + "?"
        response = "the credit card with the number of " + row[2] + " is a " + row[1] + " with the id of " + str(row[0]) + " and the expiration date of " + str(row[3]) + "/" + str(row[4]) + " and it was last modified on " + str(row[5])
        sql_query = "SELECT * FROM CreditCard WHERE CreditCardNumber = " + row[2]

        writer.writerow([prompt, response, sql_query])

# get the credit cards informations using the expiration date

csv_file_path = 'csv/CreditCardExpirationDate.csv'
os.makedirs(os.path.dirname(csv_file_path), exist_ok=True)  # Create the directory if it doesn't exist

with open(csv_file_path, 'a', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["Prompt", "Response", "SQL Query"])

    for row in data:
        prompt = "What are the credit card informations of the user with the expiration date of " + str(row[3]) + "/" + str(row[4]) + "?"
        response = "the credit card with the expiration date of " + str(row[3]) + "/" + str(row[4]) + " is a " + row[1] + " with the id of " + str(row[0]) + " and the number of " + row[2] + " and it was last modified on " + str(row[5])
        sql_query = "SELECT * FROM CreditCard WHERE ExpirationDate = " + str(row[3]) + "/" + str(row[4])

        writer.writerow([prompt, response, sql_query])

# get the credit cards informations using the last modification date

csv_file_path = 'csv/CreditCardLastModificationDate.csv'
os.makedirs(os.path.dirname(csv_file_path), exist_ok=True)  # Create the directory if it doesn't exist

with open(csv_file_path, 'a', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["Prompt", "Response", "SQL Query"])

    for row in data:
        prompt = "What are the credit card informations of the user with the last modification date of " + str(row[5]) + "?"
        response = "the credit card with the last modification date of " + str(row[5]) + " is a " + row[1] + " with the id of " + str(row[0]) + " and the number of " + row[2] + " and the expiration date of " + str(row[3]) + "/" + str(row[4])
        sql_query = "SELECT * FROM CreditCard WHERE LastModificationDate = " + str(row[5])

        writer.writerow([prompt, response, sql_query])

# close the connection
conn.close()
print("Connection closed successfully")

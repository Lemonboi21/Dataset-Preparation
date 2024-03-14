




"""
-- create the table for the CreditCard for postgressql
CREATE TABLE CreditCard (
    CreditCardID SERIAL PRIMARY KEY,
    CardType VARCHAR(255) NOT NULL,
    CardNumber VARCHAR(255) NOT NULL,
    ExpMonth INT NOT NULL,
    ExpYear INT NOT NULL,
    ModifiedDate DATE NOT NULL
);

-- insert data into the CreditCard table for postgressql
INSERT INTO CreditCard (CardType, CardNumber, ExpMonth, ExpYear, ModifiedDate) VALUES
('SuperiorCard', '33332664695310', 11, 2006, '2013-07-29'),
('Distinguish', '55552127249722', 8, 2005, '2013-12-05'),
('ColonialVoi...', '77778344838353', 7, 2006, '2014-01-14'),
('ColonialVoi...', '77774915718248', 7, 2006, '2013-05-20'),
('Vista', '55557132036181', 4, 2007, '2013-02-01'),
('Distinguish', '55553635401028', 9, 2007, '2014-04-10'),
('Distinguish', '33336081193101', 6, 2006, '2013-02-01'),
('SuperiorCard', '33336081193101', 7, 2013, '2013-06-30');



"""


# convert the data from the csv file to the postgresql database table that already exists

import csv
import psycopg2
import os

# connect to the database

conn = psycopg2.connect(
    host="localhost",
    database="PFE",
    user="postgres",
    password="postgres"
)

print("Database opened successfully")

# delete all rows in the CreditCard table before inserting the data from the csv file

cur = conn.cursor()
cur.execute("DELETE FROM CreditCard")
conn.commit()
cur.close()

print("All rows in the CreditCard table deleted successfully")

# read the csv file and insert the data into the table

csv_file_path = 'CreditCard/credit_card.csv'

with open(csv_file_path, 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        cur = conn.cursor()
        #1,SuperiorCard,33332664695310,11,2006,2013-07-29 00:00:00+02:00

        cur.execute("INSERT INTO CreditCard (CardType, CardNumber, ExpMonth, ExpYear, ModifiedDate) VALUES (%s, %s, %s, %s, %s)", (row[1], row[2], row[3], row[4], row[5]))
        conn.commit()
        
        
        cur.close()

print("Data inserted successfully")

# close the connection

conn.close()
















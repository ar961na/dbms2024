import csv
import sqlite3
import re

# Read the CSV file
with open('log (1).csv', 'r', newline='\n') as csvfile:
    reader = csv.reader(csvfile)
    data = [row for row in reader]

# Create a SQLite database (or connect to an existing one)
conn = sqlite3.connect('log.db')
cursor = conn.cursor()

# Create a table
cursor.execute('''CREATE TABLE IF NOT EXISTS LOG (
                    user_id TEXT,
                    time TEXT,
                    bet INTEGER DEFAULT NULL,
                    win INTEGER DEFAULT 0 NOT NULL )''')

# Insert data into the table
for row in data:
    cursor.execute('''INSERT INTO LOG (user_id, time, bet, win)
                      VALUES (?, ?, ?, ?)''', row)

# Commit changes and close the connection
conn.commit()
conn.close()

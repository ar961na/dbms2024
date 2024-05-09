import csv
import sqlite3

# Read the CSV file
with open('users (1).csv', 'r', newline='\n', encoding='koi8_r') as csvfile:
    data = []
    for row in csvfile:
        # Split each line based on whitespace
        parts = row.split()

        # Extract the values from the parts list
        it = 0
        if 'User' in parts[it]:
            user_id = parts[it]
            it += 1
        else:
            user_id = ''
        if len(parts) > it and ('@' in parts[it] or '.' in parts[it]):
            email = parts[it]
            it += 1
        else:
            email = ''
        if len(parts) > it:
            geo = ' '.join(parts[it:])   # Join remaining parts to capture the geo field
        else:
            geo = ''

        if user_id != '':
            data.append([user_id, email, geo])


# Create a SQLite database (or connect to an existing one)
conn = sqlite3.connect('log.db')
cursor = conn.cursor()

# Create a table
cursor.execute('''CREATE TABLE IF NOT EXISTS USERS (
                    user_id TEXT DEFAULT NULL,
                    email TEXT DEFAULT NULL,
                    geo TEXT DEFAULT NULL)''')

# Insert data into the table
for row in data:
    cursor.execute('''INSERT INTO USERS (user_id, email, geo)
                      VALUES (?, ?, ?)''', row)

# Commit changes and close the connection
conn.commit()
conn.close()

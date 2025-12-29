import mysql.connector
# creates and returns a live connection to MySQL database
def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="CPSC408!",
        auth_plugin='mysql_native_password',
        database="Showboxd"
    )

import sqlite3
from helper import helper

class db_operations():
    # constructor with connection path to DB
    def __init__(self, conn_path):
        self.connection = sqlite3.connect(conn_path)
        self.cursor = self.connection.cursor()
        print("connection made..")

    # function to simply execute a DDL or DML query.
    # commits query, returns no results. 
    # best used for insert/update/delete queries with no parameters
    def modify_query(self, query):
        self.cursor.execute(query)
        self.connection.commit()

    # function to simply execute a DDL or DML query with parameters
    # commits query, returns no results. 
    # best used for insert/update/delete queries with named placeholders
    def modify_query_params(self, query, dictionary):
        self.cursor.execute(query, dictionary)
        self.connection.commit()

    # function to simply execute a DQL query
    # does not commit, returns results
    # best used for select queries with no parameters
    def select_query(self, query):
        result = self.cursor.execute(query)
        return result.fetchall()
    
    # function to simply execute a DQL query with parameters
    # does not commit, returns results
    # best used for select queries with named placeholders
    def select_query_params(self, query, dictionary):
        result = self.cursor.execute(query, dictionary)
        return result.fetchall()

    # function to return the value of the first row's 
    # first attribute of some select query.
    # best used for querying a single aggregate select 
    # query with no parameters
    def single_record(self, query):
        self.cursor.execute(query)
        return self.cursor.fetchone()[0]
    
    # function to return the value of the first row's 
    # first attribute of some select query.
    # best used for querying a single aggregate select 
    # query with named placeholders
    def single_record_params(self, query, dictionary):
        self.cursor.execute(query, dictionary)
        return self.cursor.fetchone()[0]
    
    # function to return a single attribute for all records 
    # from some table.
    # best used for select statements with no parameters
    def single_attribute(self, query):
        self.cursor.execute(query)
        results = self.cursor.fetchall()
        results = [i[0] for i in results]
        results.remove(None)
        return results
    
    # function to return a single attribute for all records 
    # from some table.
    # best used for select statements with named placeholders
    def single_attribute_params(self, query, dictionary):
        self.cursor.execute(query,dictionary)
        results = self.cursor.fetchall()
        results = [i[0] for i in results]
        return results
    
    # function for bulk inserting records
    # best used for inserting many records with parameters
    def bulk_insert(self, query, data):
        self.cursor.executemany(query, data)
        self.connection.commit()
    
    # function that creates table songs in our database
    def create_songs_table(self):
        query = '''
        CREATE TABLE songs(
            songID VARCHAR(22) NOT NULL PRIMARY KEY,
            Name VARCHAR(20),
            Artist VARCHAR(20),
            Album VARCHAR(20),
            releaseDate DATETIME,
            Genre VARCHAR(20),
            Explicit BOOLEAN,
            Duration DOUBLE,
            Energy DOUBLE,
            Danceability DOUBLE,
            Acousticness DOUBLE,
            Liveness DOUBLE,
            Loudness DOUBLE
        );
        '''
        self.cursor.execute(query)
        print('Table Created')

    # function that returns if table has records
    def is_songs_empty(self):
        #query to get count of songs in table
        query = '''
        SELECT COUNT(*)
        FROM songs;
        '''
        #run query and return value
        result = self.single_record(query)
        return result == 0

    # function to populate songs table given some path
    # to a CSV containing records
    def populate_songs_table(self, filepath):
        if self.is_songs_empty():
            data = helper.data_cleaner(filepath)
            attribute_count = len(data[0])
            placeholders = ("?,"*attribute_count)[:-1]
            query = "INSERT INTO songs VALUES("+placeholders+")"
            self.bulk_insert(query, data)

    # destructor that closes connection with DB
    def destructor(self):
        self.cursor.close()
        self.connection.close()

    # function to insert new songs from CSV (with duplicate check)
    def insert_new_songs(self, filepath): # clean/load data from csv 
        data = helper.data_cleaner(filepath)
        print("Loading new songs...")
        count = 0 # keeps track of how many songs were successfully added
        for row in data: # loop through each song (row) in csv file
            songID = row[0] # unique identifer

            # BONUS 1: skip duplicates
            # query database to see if songID alr exists
            self.cursor.execute("SELECT COUNT(*) FROM songs WHERE songID = ?", (songID,))
            if self.cursor.fetchone()[0] > 0:
                continue # if song exists, skip 
            # if not duplicate, insert song record into table
            query = '''INSERT INTO songs VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)'''
            self.cursor.execute(query, row)
            count += 1 # increment num of successfully added songs
        self.connection.commit()
        print(f"{count} new songs added successfully!")

    # function to update song information by song name
    def update_song_by_name(self, song_name):
        # fetch records matching given song name
        query = "SELECT * FROM songs WHERE Name = ?"
        self.cursor.execute(query, (song_name,))
        record = self.cursor.fetchone()

        # if no song with that name exists inform user and exit
        if not record:
            print("Song not found.")
            return
        print("Current info:", record)

        # define what fields can be updated interactiely
        fields = ["Name", "Album", "Artist", "releaseDate", "Explicit"]
        print("You can update:", fields)
        field = input("Which field do you want to update? ")
        while field not in fields:
            print("Invalid field.")
            field = input("Try again: ")
        new_val = input(f"Enter new value for {field}: ") # get new value from user
        query = f"UPDATE songs SET {field} = ? WHERE Name = ?" # construct/execute update statement
        self.cursor.execute(query, (new_val, song_name))
        self.connection.commit()
        print("Update complete.")

    # BONUS 2: bulk update by album, artist, or genre
    def bulk_update_records(self):
        choice = input("Update songs by 'album', 'artist', or 'genre'? ").lower()
        if choice not in ["album", "artist", "genre"]:
            print("Invalid choice.")
            return
        
        # get target ground and new field/value info
        value = input(f"Enter {choice} name to update songs for: ")
        attr = input("Enter attribute to update (Name, Album, Artist, releaseDate, Explicit): ")
        new_val = input(f"Enter new value for {attr}: ")
        
        # build query dynamically to update all rows that match chosen album/artist/genre
        query = f"UPDATE songs SET {attr} = ? WHERE {choice.capitalize()} = ?"
        self.cursor.execute(query, (new_val, value))
        self.connection.commit()
        print("Bulk update complete.")

    # function to delete song by name
    def delete_song_by_name(self, song_name):
        # check if song exists in table
        self.cursor.execute("SELECT songID FROM songs WHERE Name = ?", (song_name,))
        record = self.cursor.fetchone()
        if not record:
            print("Song not found.")
            return
        
        # extract songID from fetched record
        songID = record[0]

        # execute delete statement to remove song
        self.cursor.execute("DELETE FROM songs WHERE songID = ?", (songID,))
        self.connection.commit()
        print(f"Song '{song_name}' deleted successfully.")

    # BONUS 3: delete all rows with NULL values
    def delete_null_rows(self):
        # delete statement that removes rows with missing critical info
        query = "DELETE FROM songs WHERE songID IS NULL OR Name IS NULL OR Artist IS NULL OR Album IS NULL OR Genre IS NULL"
        self.cursor.execute(query) # execute/commit deletion
        self.connection.commit()
        print("All rows with NULL values deleted.")

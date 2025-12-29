#imports
from helper import helper
from db_operations import db_operations

#global variables
db_ops = db_operations("playlist.db")

#functions
def startScreen():
    print("Welcome to your playlist!")
    #db_ops.create_songs_table()
    db_ops.populate_songs_table("songs.csv")

#show user menu options
def options():
    print('''Select from the following menu options: 
    1. Find songs by artist
    2. Find songs by genre
    3. Find songs by feature
    4. Load new songs
    5. Update song information
    6. Delete a song
    7. Bulk update songs
    8. Delete all songs with NULL values
    9. Exit''')
    return helper.get_choice([1,2,3,4,5,6,7,8,9])

#search for songs by artist
def search_by_artist():
    #get list of all artists in table
    query = '''
    SELECT DISTINCT Artist
    FROM songs;
    '''
    print("Artists in playlist: ")
    artists = db_ops.single_attribute(query)

    #show all artists, create dictionary of options, and let user choose
    choices = {}
    for i in range(len(artists)):
        print(i, artists[i])
        choices[i] = artists[i]
    index = helper.get_choice(choices.keys())

    #user can ask to see 1, 5, or all songs
    print("How many songs do you want returned for", choices[index]+"?")
    print("Enter 1, 5, or 0 for all songs")
    num = helper.get_choice([1,5,0])

    #print results
    query = '''SELECT DISTINCT name
    FROM songs
    WHERE Artist =:artist ORDER BY RANDOM()
    '''
    dictionary = {"artist":choices[index]}
    if num != 0:
        query +="LIMIT:lim"
        dictionary["lim"] = num
    results = db_ops.single_attribute_params(query, dictionary)
    helper.pretty_print(results)

#search songs by genre
def search_by_genre():
    #get list of genres
    query = '''
    SELECT DISTINCT Genre
    FROM songs;
    '''
    print("Genres in playlist:")
    genres = db_ops.single_attribute(query)

    #show genres in table and create dictionary
    choices = {}
    for i in range(len(genres)):
        print(i, genres[i])
        choices[i] = genres[i]
    index = helper.get_choice(choices.keys())

    #user can ask to see 1, 5, or all songs
    print("How many songs do you want returned for", choices[index]+"?")
    print("Enter 1, 5, or 0 for all songs")
    num = helper.get_choice([1,5,0])

    #print results
    query = '''SELECT DISTINCT name
    FROM songs
    WHERE Genre =:genre ORDER BY RANDOM()
    '''
    dictionary = {"genre":choices[index]}

    # add limit clause if user requested limited results
    if num != 0:
        query +="LIMIT:lim"
        dictionary["lim"] = num
    # fetch and print songs
    results = db_ops.single_attribute_params(query, dictionary)
    helper.pretty_print(results)

#search songs table by features
def search_by_feature():
    #features we want to search by
    features = ['Danceability', 'Liveness', 'Loudness']
    choices = {}
    #show features in table and create dictionary
    choices = {}
    for i in range(len(features)):
        print(i, features[i])
        choices[i] = features[i]
    index = helper.get_choice(choices.keys())

    #user can ask to see 1, 5, or all songs
    print("How many songs do you want returned for", choices[index]+"?")
    print("Enter 1, 5, or 0 for all songs")
    num = helper.get_choice([1,5,0])

    #what order does the user want this returned in?
    print("Do you want results sorted in asc or desc order?")
    order = input("ASC or DESC: ")

    #dynamically build SQL query to sort by chosen feature and order
    query = "SELECT DISTINCT name FROM songs ORDER BY "+choices[index]+" "+order
    dictionary = {}

    # add limit clause if user specified num of songs
    if num != 0:
        query +=" LIMIT:lim"
        dictionary["lim"] = num
    
    # execute query and show results
    results = db_ops.single_attribute_params(query, dictionary)
    helper.pretty_print(results)

def load_new_songs():
    filepath = input("Enter path to new songs file (e.g., songs_update.csv): ")
    db_ops.insert_new_songs(filepath)

def update_song_info():
    song_name = input("Enter the song name to update: ")
    db_ops.update_song_by_name(song_name)

def delete_song():
    song_name = input("Enter the song name to delete: ")
    db_ops.delete_song_by_name(song_name)

def bulk_update_bonus():
    db_ops.bulk_update_records()

def delete_nulls_bonus():
    db_ops.delete_null_rows()

#main method
startScreen() # initialize and load songs

#program loop
while True:
    user_choice = options()
    if user_choice == 1:
        search_by_artist()
    elif user_choice == 2:
        search_by_genre()
    elif user_choice == 3:
        search_by_feature()
    elif user_choice == 4:
        load_new_songs()
    elif user_choice == 5:
        update_song_info()
    elif user_choice == 6:
        delete_song()
    elif user_choice == 7:
        bulk_update_bonus()
    elif user_choice == 8:
        delete_nulls_bonus()
    elif user_choice == 9:
        print("Goodbye!")
        break

db_ops.destructor()
from db_connection import get_connection
from helper import helper
import csv

class Database:

    def __init__(self):
        # initialize db connection and cursor for queries
        self.conn = get_connection()
        self.cursor = self.conn.cursor()

    # check if a table is empty
    def table_empty(self, table_name):
        self.cursor.execute(f"select count(*) from {table_name}")
        return self.cursor.fetchone()[0] == 0

    # populate shows table from csv
    def populate_shows_table(self, filepath):
        if not self.table_empty("Shows"):
            print("shows table already populated. skipping.\n")
            return

        # read csv and skip header
        data = helper.data_cleaner(filepath)[1:]
        formatted = []

        for row in data:
            # validate row length
            if len(row) != 4:
                print("skipped invalid row:", row)
                continue
            title, year, desc, epcount = row
            formatted.append((title, year, desc, epcount))

        # insert multiple rows at once
        query = """
            insert into Shows (Title, ReleaseYear, Description, EpCount)
            values (%s, %s, %s, %s)
        """
        self.cursor.executemany(query, formatted)
        self.conn.commit()
        print("shows table populated.\n")

    # populate genre table from csv, remove duplicates
    def populate_genre_table(self, filepath):
        if not self.table_empty("Genre"):
            print("genre table already populated. skipping.\n")
            return

        data = helper.data_cleaner(filepath)[1:]  # skip header
        genres = set()

        for row in data:
            if len(row) != 1:
                print("skipped invalid genre row:", row)
                continue
            genre_name = row[0].strip()
            if genre_name:
                genres.add(genre_name)

        # convert set to list of tuples for insertion
        formatted = [(g,) for g in sorted(genres)]
        query = "insert into Genre (Name) values (%s)"
        self.cursor.executemany(query, formatted)
        self.conn.commit()
        print(f"genre table populated with {len(formatted)} genres.\n")

    # populate showgenre table from csv
    def populate_showgenre_table(self, filepath):
        if not self.table_empty("ShowGenre"):
            print("showgenre table already populated. skipping.\n")
            return

        data = helper.data_cleaner(filepath)[1:]  # skip header
        rows_to_insert = []

        for row in data:
            if len(row) != 2:
                print("skipped invalid showgenre row:", row)
                continue
            title, genre_name = row
            title = title.strip()
            genre_name = genre_name.strip()

            # get show id from title (case-insensitive)
            self.cursor.execute("select ShowID from Shows where lower(Title)=lower(%s)", (title,))
            show = self.cursor.fetchone()
            if not show:
                print(f"show not found: '{title}'")
                continue
            show_id = show[0]

            # get genre id from name (case-insensitive)
            self.cursor.execute("select GenreID from Genre where lower(Name)=lower(%s)", (genre_name,))
            genre = self.cursor.fetchone()
            if not genre:
                print(f"genre not found: '{genre_name}'")
                continue
            genre_id = genre[0]

            rows_to_insert.append((show_id, genre_id))

        # insert unique show-genre combinations
        query = "insert ignore into ShowGenre (ShowID, GenreID) values (%s, %s)"
        self.cursor.executemany(query, rows_to_insert)
        self.conn.commit()
        print(f"showgenre table populated with {len(rows_to_insert)} rows.\n")

    # get comma-separated genres for a show from view
    def get_genres_for_show(self, show_id):
        self.cursor.execute("select Genres from ShowWithGenres where ShowID=%s", (show_id,))
        row = self.cursor.fetchone()
        return row[0] if row else "no genres"

    # get user id from username
    def get_user_id(self, username):
        self.cursor.execute("select UserID from Users where Username=%s", (username,))
        row = self.cursor.fetchone()
        return row[0] if row else None

    # create new user, return False if username exists
    def create_user(self, username):
        if self.get_user_id(username):
            return False
        self.cursor.execute("insert into Users (Username) values (%s)", (username,))
        self.conn.commit()
        return True

    # get all shows for browsing
    def get_all_shows(self):
        self.cursor.execute("select ShowID, Title, ReleaseYear, EpCount, AverageRating from Shows order by Title")
        return self.cursor.fetchall()

    # get all genre names
    def get_all_genres(self):
        self.cursor.execute("select Name from Genre order by Name")
        return [r[0] for r in self.cursor.fetchall()]

    # get shows for a specific genre
    def get_shows_by_genre(self, genre_name):
        query = """
            select Shows.ShowID, Shows.Title, Shows.ReleaseYear, Shows.EpCount, Shows.AverageRating
            from Shows
            join ShowGenre on Shows.ShowID = ShowGenre.ShowID
            join Genre on Genre.GenreID = ShowGenre.GenreID
            where Genre.Name = %s
            order by Shows.Title
        """
        self.cursor.execute(query, (genre_name,))
        return self.cursor.fetchall()

    # get or create watchlist for user
    def get_watchlist(self, user_id):
        self.cursor.execute("select WatchlistID from Watchlist where UserID=%s", (user_id,))
        result = self.cursor.fetchone()
        if result:
            return result[0]
        # if watchlist does not exist, create it
        self.cursor.execute("insert into Watchlist (UserID) values (%s)", (user_id,))
        self.conn.commit()
        return self.cursor.lastrowid

    # search by title
    def search_show_by_title(self, query):
        like = f"%{query}%"
        self.cursor.execute("""
            SELECT ShowID, Title, ReleaseYear, EpCount, AverageRating
            FROM Shows
            WHERE Title LIKE %s
        """, (like,))
        return self.cursor.fetchall()

    # add show to user's watchlist
    def add_show_to_watchlist(self, user_id, title):
        title = title.strip()
        self.cursor.execute("select ShowID from Shows where lower(Title)=lower(%s)", (title,))
        row = self.cursor.fetchone()
        if not row:
            print("show not found")
            return
        show_id = row[0]

        watchlist_id = self.get_watchlist(user_id)

        # check if show already in watchlist
        self.cursor.execute("select * from WatchlistShows where WatchlistID=%s and ShowID=%s", (watchlist_id, show_id))
        if self.cursor.fetchone():
            print("already in watchlist")
            return

        # insert show with default status
        self.cursor.execute("insert into WatchlistShows (WatchlistID, ShowID, Status) values (%s, %s, 'Plan to Watch')", (watchlist_id, show_id))
        self.conn.commit()
        print("added to watchlist")

    # remove show from user's watchlist
    def remove_show_from_watchlist(self, user_id, title):
        title = title.strip()
        self.cursor.execute("select ShowID from Shows where lower(Title)=lower(%s)", (title,))
        row = self.cursor.fetchone()
        if not row:
            print("show not found")
            return
        show_id = row[0]

        watchlist_id = self.get_watchlist(user_id)

        # check if show exists in watchlist
        self.cursor.execute("select * from WatchlistShows where WatchlistID=%s and ShowID=%s", (watchlist_id, show_id))
        if not self.cursor.fetchone():
            print("not in watchlist")
            return

        # delete show from watchlist
        self.cursor.execute("delete from WatchlistShows where WatchlistID=%s and ShowID=%s", (watchlist_id, show_id))
        self.conn.commit()
        print("removed from watchlist")

    # print user's watchlist with status and rating
    def view_watchlist(self, user_id):
        watchlist_id = self.get_watchlist(user_id)
        self.cursor.execute("""
            select s.ShowID, s.Title, s.ReleaseYear, s.EpCount, ws.Status, s.AverageRating
            from WatchlistShows ws
            join Shows s on ws.ShowID = s.ShowID
            where ws.WatchlistID=%s
            order by s.Title
        """, (watchlist_id,))
        shows = self.cursor.fetchall()
        if not shows:
            print("watchlist is empty")
            return

        print("\n--- your watchlist ---")
        for sid, title, year, eps, status, avg in shows:
            genres = self.get_genres_for_show(sid)  # get genres for display
            rating = f"{round(avg,1)}" if avg else ""  # format average rating
            print(f"{title} ({year}) - {eps} eps - [{status}] {rating}")
            print(f"   genres: {genres}")

    #watchlist details 
    def get_watchlist_details(self, user_id):
        """Return list of dicts for all shows in user's watchlist"""
        watchlist_id = self.get_watchlist(user_id)
        self.cursor.execute("""
            SELECT s.ShowID, s.Title, s.ReleaseYear, s.EpCount, ws.Status, s.AverageRating
            FROM WatchlistShows ws
            JOIN Shows s ON ws.ShowID = s.ShowID
            WHERE ws.WatchlistID=%s
            ORDER BY s.Title
        """, (watchlist_id,))
        shows = self.cursor.fetchall()
        result = []
        for sid, title, year, eps, status, avg in shows:
            genres = self.get_genres_for_show(sid)
            result.append({
                "ShowID": sid,
                "Title": title,
                "Year": year,
                "Eps": eps,
                "Status": status,
                "Rating": round(avg,1) if avg else None,
                "Genres": genres
            })
        return result
    
    def rate_show_frontend(self, user_id, title, rating):
        self.cursor.execute(
            "SELECT ShowID FROM Shows WHERE LOWER(Title)=LOWER(%s)", (title.strip(),)
        )
        row = self.cursor.fetchone()
        if not row:
            return False
        show_id = row[0]
        self.cursor.execute("""
            INSERT INTO Ratings (UserID, ShowID, RatingValue)
            VALUES (%s, %s, %s)
            ON DUPLICATE KEY UPDATE RatingValue=VALUES(RatingValue)
        """, (user_id, show_id, rating))
        self.conn.commit()
        # update average rating after rating
        self.update_show_average_rating(show_id)
        return True

    # avg + update shows
    def update_show_average_rating(self, show_id):
        # get average rating from Ratings table
        self.cursor.execute("""
            SELECT AVG(RatingValue)
            FROM Ratings
            WHERE ShowID=%s
        """, (show_id,))
        avg = self.cursor.fetchone()[0]

        # update Shows table
        self.cursor.execute("""
            UPDATE Shows
            SET AverageRating=%s
            WHERE ShowID=%s
        """, (avg, show_id))
        self.conn.commit()

    #show status
    def change_show_status_frontend(self, user_id, title, new_status):
        # get show id by title
        self.cursor.execute(
            "SELECT ShowID FROM Shows WHERE LOWER(Title)=LOWER(%s)", (title.strip(),)
        )
        row = self.cursor.fetchone()
        if not row:
            return False  # show not found

        show_id = row[0]
        # get user's watchlist id
        watchlist_id = self.get_watchlist(user_id)

        # update status
        self.cursor.execute(
            "UPDATE WatchlistShows SET Status=%s WHERE WatchlistID=%s AND ShowID=%s",
            (new_status, watchlist_id, show_id)
        )
        self.conn.commit()
        return True


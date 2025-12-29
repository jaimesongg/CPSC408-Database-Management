from db_operations import Database

# printing helpers
def print_show_entry(title, year, eps, avg, genres):
    # display show info cleanly
    rating = f" - {round(avg,1)}" if avg else ""
    print(f"{title} ({year}) - {eps} eps{rating}")
    print(f"   genres: {genres}")

# browse shows
def browse_shows(db):
    # show all shows
    rows = db.get_all_shows()
    print("\n--- all shows ---")
    for show_id, title, year, eps, avg in rows:
        genres = db.get_genres_for_show(show_id)
        print_show_entry(title, year, eps, avg, genres)


def browse_by_genre(db):
    # list genres and show selection
    genres = db.get_all_genres()
    print("\n=== genres ===")
    for g in genres:
        print(f"- {g}")

    genre = input("\nenter genre name: ").strip()
    if genre not in genres:
        print("genre not found")
        return

    shows = db.get_shows_by_genre(genre)
    print(f"\n=== shows in genre: {genre} ===")
    for show_id, title, year, eps, avg in shows:
        genres = db.get_genres_for_show(show_id)
        print_show_entry(title, year, eps, avg, genres)



# search shows
def search_shows(db):
    # search by title
    query = input("enter part of a show title: ").strip()
    results = db.search_show_by_title(query)
    print("\n=== search results ===")

    if not results:
        print("no matching shows found")
        return

    for show_id, title, year, eps, avg in results:
        genres = db.get_genres_for_show(show_id)
        print_show_entry(title, year, eps, avg, genres)

# main menu
def main_menu(db, user_id):
    while True:
        print("\n=== main menu ===")
        print("1. browse all shows")
        print("2. browse by genre")
        print("3. search shows")
        print("4. view watchlist")
        print("5. add show to watchlist")
        print("6. remove show from watchlist")
        print("7. change show status")
        print("8. rate a show")
        print("9. avg rating by genre")
        print("10. highest rated show")
        print("11. export watchlist")
        print("12. logout")

        choice = input("enter choice: ").strip()

        if choice == "1":
            browse_shows(db)
        elif choice == "2":
            browse_by_genre(db)
        elif choice == "3":
            search_shows(db)
        elif choice == "4":
            db.view_watchlist(user_id)
        elif choice == "5":
            title = input("enter title to add: ").strip()
            db.add_show_to_watchlist(user_id, title)
        elif choice == "6":
            title = input("enter title to remove: ").strip()
            db.remove_show_from_watchlist(user_id, title)
        elif choice == "7":
            db.change_show_status(user_id)
        elif choice == "8":
            db.rate_show(user_id)
        elif choice == "9":
            rows = db.get_average_rating_by_genre()
            print("\navg rating by genre")
            for genre, avg in rows:
                avg_str = round(avg, 1) if avg else "no ratings"
                print(f"{genre}: {avg_str}")
        elif choice == "10":
            rows = db.get_highest_rated_show()
            print("\nhighest rated show")
            for title, avg in rows:
                print(f"{title} - {avg}")
        elif choice == "11":
            db.export_watchlist_to_csv(user_id)
        elif choice == "12":
            print("logging out...")
            break
        else:
            print("invalid choice")

# login / signup
def login_or_signup(db):
    print("=== welcome to showboxd ===")
    while True:
        print("\ndo you have an account?")
        print("1. yes, log me in")
        print("2. no, create account")

        choice = input("enter choice: ").strip()

        if choice == "1":
            username = input("enter username: ").strip()
            user_id = db.get_user_id(username)
            if user_id:
                print(f"welcome back, {username}!")
                return user_id
            else:
                print("username not found")
        elif choice == "2":
            username = input("choose username: ").strip()
            if db.create_user(username):
                print(f"account created! welcome, {username}!")
                return db.get_user_id(username)
            else:
                print("username already taken")
        else:
            print("invalid choice")

# main runner
def main():
    db = Database()

    # initialization
    from tables import create_tables
    create_tables()

    # populate tables
    db.populate_shows_table("shows.csv")
    db.populate_genre_table("genres.csv")
    db.populate_showgenre_table("show_genres.csv")

    # login or signup
    user_id = login_or_signup(db)

    # launch main menu
    main_menu(db, user_id)


if __name__ == "__main__":
    main()

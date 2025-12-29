import streamlit as st
from db_operations import Database

# session init
if "user_id" not in st.session_state:
    st.session_state.user_id = None
if "page" not in st.session_state:
    st.session_state.page = "login"  # pages: login, signup, menu

db = Database()

# helpers
def show_watchlist(user_id):
    # display watchlist with status change and rating inputs
    shows = db.get_watchlist_details(user_id)
    if not shows:
        st.info("your watchlist is empty")
        return

    for show in shows:
        st.write(f"**{show['Title']} ({show['Year']}) - {show['Eps']} eps - [{show['Status']}] {show['Rating']}**")
        st.write(f"genres: {show['Genres']}")
        col1, col2 = st.columns(2)
        with col1:
            # status change
            new_status = st.selectbox(f"change status for {show['Title']}", ["Plan to Watch", "Watched", "Like"], key=f"status_{show['ShowID']}")
            if st.button("update status", key=f"update_{show['ShowID']}"):
                db.change_show_status_frontend(user_id, show['Title'], new_status)
                st.success(f"status updated to {new_status}")
        with col2:
            # rating input
            rating_val = st.number_input(f"rate {show['Title']}", min_value=1.0, max_value=5.0, step=0.5, key=f"rating_{show['ShowID']}")
            if st.button("submit rating", key=f"rate_{show['ShowID']}"):
                db.rate_show_frontend(user_id, show['Title'], rating_val)
                st.success(f"rated {show['Title']} {rating_val}")

def browse_all_shows():
    # display all shows
    shows = db.get_all_shows()
    for show_id, title, year, eps, avg in shows:
        genres = db.get_genres_for_show(show_id)
        rating = f"{round(avg,1)}" if avg else ""
        st.write(f"**{title} ({year}) - {eps} eps {rating}**")
        st.write(f"genres: {genres}")

def browse_by_genre():
    # browse shows filtered by genre
    genres = db.get_all_genres()
    genre = st.selectbox("select genre", genres)
    shows = db.get_shows_by_genre(genre)
    st.write(f"### shows in genre: {genre}")
    for show_id, title, year, eps, avg in shows:
        genres_str = db.get_genres_for_show(show_id)
        rating = f"{round(avg,1)}" if avg else ""
        st.write(f"**{title} ({year}) - {eps} eps {rating}**")
        st.write(f"genres: {genres_str}")

def search_shows():
    # search shows by title input
    query = st.text_input("search shows by title")
    if query:
        results = db.search_show_by_title(query)
        if not results:
            st.info("no matching shows found")
        else:
            st.write(f"### search results for '{query}':")
            for show_id, title, year, eps, avg in results:
                genres_str = db.get_genres_for_show(show_id)
                rating = f"{round(avg,1)}" if avg else ""
                st.write(f"**{title} ({year}) - {eps} eps {rating}**")
                st.write(f"genres: {genres_str}")

def add_to_watchlist(user_id):
    # add show to watchlist
    title = st.text_input("enter title to add to watchlist")
    if st.button("add show"):
        db.add_show_to_watchlist(user_id, title)
        st.success(f"added {title} to watchlist")

def remove_from_watchlist(user_id):
    # remove show from watchlist
    title = st.text_input("enter title to remove from watchlist")
    if st.button("remove show"):
        db.remove_show_from_watchlist(user_id, title)
        st.success(f"removed {title} from watchlist")

def logout():
    # logout user
    st.session_state.user_id = None
    st.session_state.page = "login"
    st.success("logged out successfully")

# login page
def login():
    st.title("showboxd login")
    username = st.text_input("username")
    if st.button("login"):
        user_id = db.get_user_id(username)
        if user_id:
            st.session_state.user_id = user_id
            st.session_state.page = "menu"
            st.success(f"welcome back, {username}!")
        else:
            st.error("username not found. please sign up.")

    if st.button("go to sign up"):
        st.session_state.page = "signup"

# signup page
def signup():
    st.title("create account")
    username = st.text_input("choose a username")
    if st.button("sign up"):
        success = db.create_user(username)
        if success:
            st.success(f"account created! please log in, {username}.")
            st.session_state.page = "login"
        else:
            st.error("username already taken")

    if st.button("go to login"):
        st.session_state.page = "login"

# main menu sidebar
def main_menu():
    st.sidebar.title("showboxd menu")
    menu = st.sidebar.radio("select an option:", [
        "browse all shows",
        "browse by genre",
        "search shows",
        "view watchlist",
        "add to watchlist",
        "remove from watchlist",
        "logout"
    ])

    user_id = st.session_state.user_id

    if menu == "browse all shows":
        browse_all_shows()
    elif menu == "browse by genre":
        browse_by_genre()
    elif menu == "search shows":
        search_shows()
    elif menu == "view watchlist":
        show_watchlist(user_id)
    elif menu == "add to watchlist":
        add_to_watchlist(user_id)
    elif menu == "remove from watchlist":
        remove_from_watchlist(user_id)
    elif menu == "logout":
        logout()

# main runner
def main():
    # init tables once
    if "tables_initialized" not in st.session_state:
        from tables import create_tables
        create_tables()
        db.populate_shows_table("shows.csv")
        db.populate_genre_table("genres.csv")
        db.populate_showgenre_table("show_genres.csv")
        st.session_state.tables_initialized = True

    # route to page
    if st.session_state.page == "login":
        login()
    elif st.session_state.page == "signup":
        signup()
    elif st.session_state.page == "menu":
        main_menu()

if __name__ == "__main__":
    main()

from db_connection import get_connection

def create_tables():
    # get db connection and cursor
    conn = get_connection()
    cur = conn.cursor()

    # users table
    create_User = '''
        create table if not exists Users (
            UserID int auto_increment primary key,
            Username varchar(50) not null unique
        );
    '''

    # genre table
    create_Genre = '''
        create table if not exists Genre (
            GenreID int auto_increment primary key,
            Name varchar(50) not null
        );
    '''

    # shows table
    create_Shows = '''
        create table if not exists Shows (
            ShowID int auto_increment primary key,
            Title varchar(100) not null,
            ReleaseYear year,
            Description text,
            EpCount int,
            AverageRating decimal(3,1)
        );
    '''

    # showgenre table
    create_ShowGenre = '''
        create table if not exists ShowGenre (
            ShowID int,
            GenreID int,
            primary key (ShowID, GenreID),
            foreign key (ShowID) references Shows(ShowID),
            foreign key (GenreID) references Genre(GenreID)
        );
    '''

    # watchlist table
    create_Watchlist = '''
        create table if not exists Watchlist (
            WatchlistID int auto_increment primary key,
            UserID int unique,
            foreign key (UserID) references Users(UserID)
        );
    '''

    # watchlistshows table
    create_WatchlistShows = '''
        create table if not exists WatchlistShows (
            WatchlistID int,
            ShowID int,
            Status varchar(20)
                check (Status in ('Watched','Like','Plan to Watch')),
            primary key (WatchlistID, ShowID),
            foreign key (WatchlistID) references Watchlist(WatchlistID),
            foreign key (ShowID) references Shows(ShowID)
        );
    '''

    # ratings table
    create_Ratings = '''
        create table if not exists Ratings (
            RatingID int auto_increment primary key,
            UserID int,
            ShowID int,
            RatingValue decimal(2,1)
                check (RatingValue in (1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0)),
            constraint UC_User_Show unique (UserID, ShowID),
            foreign key (UserID) references Users(UserID),
            foreign key (ShowID) references Shows(ShowID)
        );
    '''

    # execute table creation
    cur.execute(create_User)
    cur.execute(create_Genre)
    cur.execute(create_Shows)
    cur.execute(create_ShowGenre)
    cur.execute(create_Watchlist)
    cur.execute(create_WatchlistShows)
    cur.execute(create_Ratings)

    # create view to combine shows with genres
    create_view = """
        create or replace view ShowWithGenres as
        select s.ShowID, s.Title,
            group_concat(g.Name separator ', ') as Genres
        from Shows s
        join ShowGenre sg on s.ShowID = sg.ShowID
        join Genre g on sg.GenreID = g.GenreID
        group by s.ShowID, s.Title;
    """
    cur.execute(create_view)

    # create indexes if not exists for performance

    # show title index
    cur.execute("""
        select count(*)
        from information_schema.statistics
        where table_schema = database()
        and table_name = 'Shows'
        and index_name = 'idx_show_title';
    """)
    if cur.fetchone()[0] == 0:
        cur.execute("create index idx_show_title on Shows (Title);")

    # genre name index
    cur.execute("""
        select count(*)
        from information_schema.statistics
        where table_schema = database()
        and table_name = 'Genre'
        and index_name = 'idx_genre_name';
    """)
    if cur.fetchone()[0] == 0:
        cur.execute("create index idx_genre_name on Genre (Name);")

    # showgenre composite index
    cur.execute("""
        select count(*)
        from information_schema.statistics
        where table_schema = database()
        and table_name = 'ShowGenre'
        and index_name = 'idx_sg';
    """)
    if cur.fetchone()[0] == 0:
        cur.execute("create index idx_sg on ShowGenre (ShowID, GenreID);")

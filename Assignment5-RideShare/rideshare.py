import mysql.connector
from datetime import datetime

try:
    # connect to MySQL
    db = mysql.connector.connect(
        host="localhost",
        user="root",       
        password="Jaime401081!", 
        database="rideshare_app"
)
    
    # checking if connection worked
    if db.is_connected():
        print("Successfully connected to MySQL database!")

except mysql.connector.Error as e:
    print("Error connecting to MySQL:", e)

# create cursor object
cursor = db.cursor(dictionary=True)

def create_account():
    role = input("Are you signing up as a rider or driver? ").lower()
    name = input("Enter your name: ")
    email = input("Enter your email: ")
    phone = input("Enter your phone number: ")
    password = input("Enter a password: ")

    # insert new rider/driver record into correct table
    if role == "rider":
        cursor.execute("INSERT INTO Rider (name, email, phone, password) VALUES (%s, %s, %s, %s)", 
                       (name, email, phone, password))
    elif role == "driver":
        cursor.execute("INSERT INTO Driver (name, email, phone, password) VALUES (%s, %s, %s, %s)", 
                       (name, email, phone, password))
    else:
        print("Invalid role.")
        return

    # save new record to database
    db.commit()
    print(f"{role.capitalize()} account created successfully!")

def login():
    role = input("Are you logging in as a rider or driver? ").lower()
    email = input("Email: ")
    password = input("Password: ")

    if role == "rider":
        cursor.execute("SELECT * FROM Rider WHERE email=%s AND password=%s", (email, password))
    elif role == "driver":
        cursor.execute("SELECT * FROM Driver WHERE email=%s AND password=%s", (email, password))
    else:
        print("Invalid role.")
        return None, None

    # fetch one matching record
    user = cursor.fetchone()
    if user:
        print(f"Welcome back, {user['name']}!")
        return role, user
    else:
        print("Invalid credentials.")
        return None, None

def driver_menu(driver):
    while True:
        print("\nDriver Menu:")
        print("1. View Rating")
        print("2. View Rides")
        print("3. Toggle Driver Mode (Active/Inactive)")
        print("4. Logout")

        choice = input("Choose an option: ")

        # show avg rating of all rides given
        if choice == "1":
            cursor.execute("SELECT AVG(rating) AS avg_rating FROM Ride WHERE driverID=%s AND rating IS NOT NULL", (driver['driverID'],))
            avg = cursor.fetchone()['avg_rating']
            print(f"Your average rating is: {avg if avg else 'No ratings yet'}")
        
        # show all rides driver has given
        elif choice == "2":
            cursor.execute("SELECT * FROM Ride WHERE driverID=%s", (driver['driverID'],))
            for ride in cursor.fetchall():
                print(ride)
        
        # toggle active status (accepting rides or not)
        elif choice == "3":
            new_status = not driver['isActive']
            cursor.execute("UPDATE Driver SET isActive=%s WHERE driverID=%s", (new_status, driver['driverID']))
            db.commit()
            driver['isActive'] = new_status
            print(f"Driver mode {'activated' if new_status else 'deactivated'}.")
        
        elif choice == "4": # logout
            break

def rider_menu(rider):
    while True:
        print("\nRider Menu:")
        print("1. View Rides")
        print("2. Find a Driver")
        print("3. Rate My Driver")
        print("4. Logout")

        choice = input("Choose an option: ")

        # show list of all rides this rider took
        if choice == "1":
            cursor.execute("SELECT * FROM Ride WHERE riderID=%s", (rider['riderID'],))
            for ride in cursor.fetchall():
                print(ride)

        # find available driver and create new ride
        elif choice == "2":
            cursor.execute("SELECT * FROM Driver WHERE isActive=TRUE LIMIT 1")
            driver = cursor.fetchone()
            if not driver:
                print("No active drivers available right now.")
                continue

            pickup = input("Enter pickup location: ")
            dropoff = input("Enter dropoff location: ")

            # create new ride record
            cursor.execute(
                "INSERT INTO Ride (riderID, driverID, pickup_location, dropoff_location, rideDate) VALUES (%s, %s, %s, %s, %s)",
                (rider['riderID'], driver['driverID'], pickup, dropoff, datetime.now())
            )
            db.commit()
            print(f"Ride created with Driver {driver['name']}!")

        # rate most recent ride
        elif choice == "3":
            cursor.execute("SELECT * FROM Ride WHERE riderID=%s ORDER BY rideDate DESC LIMIT 1", (rider['riderID'],))
            ride = cursor.fetchone()
            if not ride:
                print("No rides found to rate.")
                continue

            print(f"Most recent ride: {ride}")
            correct = input("Is this the correct ride? (y/n): ")
            if correct.lower() == 'n':
                ride_id = input("Enter rideID of the ride you want to rate: ")
                cursor.execute("SELECT * FROM Ride WHERE rideID=%s AND riderID=%s", (ride_id, rider['riderID']))
                ride = cursor.fetchone()
                if not ride:
                    print("Ride not found.")
                    continue
            
            # get rating input and update ride record
            rating = int(input("Enter rating (1-5): "))
            cursor.execute("UPDATE Ride SET rating=%s WHERE rideID=%s", (rating, ride['rideID']))
            db.commit()
            print("Rating submitted successfully!")

        elif choice == "4":
            break

def main():
    print("Welcome to the RideShare App!")
    while True:
        print("\n1. New User")
        print("2. Existing User")
        print("3. Exit")
        choice = input("Choose an option: ")

        # create new account
        if choice == "1":
            create_account()

        # log in to existing account
        elif choice == "2":
            role, user = login()
            if role == "rider":
                rider_menu(user)
            elif role == "driver":
                driver_menu(user)
        
        # exit app
        elif choice == "3":
            print("Goodbye!")
            break

# run main menu when scipt starts
main()

/* 
Transaction: action or series of actions that read from or write to a database
- actions are grouped together into one broader functionality in your system
- can include any combo of 
    - cascading UPDATE and INSERT statements
    - basic SELECT statements
    - conditional statements to route behavior
- each transaction must either be compltely executed or completely rejected
- there can now never be a point where only half our interior queries ran and then rest did not
*/

-- BASICALLY A TRANSACTION IS A GROUP OF SQL STATEMENTS THAT MUST SUCCEED TOGETHER OR FAIL TOGETHER

-- example: clinic where each visitor is assigned an exam room when they check in
-- create tables
Rooms(roomID(PK), isOccupied)
Visitors(visitorID(PK), roomID*)
-- when someone visits clinit we 1. find next unassigned room, 2. Set room to be occupied, 3. Create visitor record in that room
-- INTO allows us to store a variable in MySQL (user defined vars annotated with @ symbol)
SELCT MIN(roomID) INTO @room -- finds next unassigned room
FROM Rooms
WHERE isOccupied = FALSE;

UPDATE Rooms
SET isOccupied = TRUE -- sets room to be occupied
WHERE roomID = @room; 
-- smtg catastrophic occurs ------
INSERT INTO Visitor(roomID) -- add visitor assigned to room
VALUES(@room);

-- if queries cannot continue execution, then a room is set as occupied but never actually occupied by any visitor
 -- if continue, numbr of rooms grow in records but never actually assigned to anyone
-- = storage leak: memory taken by system but never used 

-- how to fix?
-- group these steps into a transaction
    -- either commit changes made by transaction after it completes all queries
    -- or rollback changes made in case of only some queries completing

-- when considering capabilities of transactions in any RDBMS, look for ACID properties
-- a transaction must be: Atomic, Consistent, Isolated, Durable
    -- Atomicity: if either all operations of a transaction are executed or none of them are. transactions are unsplittable
    -- Consistency: takes database from one consistent state to another consistent state
        -- database allowed to be inconsistent in between beginnning and end, it only matters that result is consistent
    -- Isolation: if actions are independent of actions of other transactions
        -- if 2 transactions on one table are executing concurrently, actions of one must not impact the actions of the other
    -- Durability: once executed, all actions performed by transaction are persistent
        -- once transaction completes, results must be written to non-volatile memory

-- EASY WAY TO THINK ABOUT IT:
-- Atomicity: No partial transactions
-- Consistency: Databases make sense before and after
-- Isolation: No transactions affect each other
-- Durability: Changes persist

-- different tactics to enfore ACID properties
    -- Atomicity/Consistency: commit/rollback to be able to confirm or deny a transaction's results should be written
    -- Isolation: locks to be able to enfore that data if only accessible by one transaction at a time, even if many transactions are asking for some resource
    -- Durability: logs to ensure that all changes we recorded doing are actually reflected in our system

-- TRANSACTIONS IN SQL ---------------------------------
-- ex: u need to insert a new record into a table
SELECT MAX(aID)+1 iNTO @id
FROM account;

INSERT INTO account VALUES
    (@id, 'C', '123');

-- if there is possibility that system might crash during execution of these individual queries, we can define them as transaction
-- define transations by running START TRANSACTION query before any queries we want grouped
--  we then run COMMIT query to complete transaction
START TRANSACTION

SELECT MAX(aID)+1 iNTO @id
FROM account;

INSERT INTO account VALUES
    (@id, 'C', '123');

COMMIT;

-- rollback: if you get through part of a transaction and decide that you want to scrap all chnages made, you can run rollback command and return system to state it was in before you started
-- commit: signals successful end of transaction
    -- changes made by transaction can now be saved
    -- changed made now visible to other transactions

START TRANSACTION
SELECT MAX(aID)+1 iNTO @id
FROM account;
INSERT INTO account VALUES
    (@id, 'C', '123');
ROLLBACK;

-- can also use savepoints to allow us to partially roll back a transaction to last safe sport
START TRANSACTION
SELECT MAX(aID)+1 iNTO @id
FROM account;

SAVEPOINT account_savepoint;

INSERT INTO account VALUES
    (@id, 'C', '123');
ROLLBACK TO account_savepoint;
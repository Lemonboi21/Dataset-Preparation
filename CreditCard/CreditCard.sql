


-- Table name: CreditCard
-- Table structure: CreditCardID , CardType , CardNumber , ExpMonth , ExpYear , ModifiedDate
-- Types for each column: CreditCardID (int) , CardType (nvarchar) , CardNumber (nvarchar) , ExpMonth (int) , ExpYear (int) , ModifiedDate (datetime)

-- data sample :
    -- CreditCardID , CardType , CardNumber , ExpMonth , ExpYear , ModifiedDate
    -- 1 , SuperiorCard , 33332664695310 , 11 , 2006 , 2013-07-29
    -- 2 , Distinguish , 55552127249722 , 8 , 2005 , 2013-12-05
    -- 3 , ColonialVoi... , 77778344838353 , 7 , 2006 , 2014-01-14
    -- 4 , ColonialVoi... , 77774915718248 , 7 , 2006 , 2013-05-20
    -- 5 , Vista , 55557132036181 , 4 , 2007 , 2013-02-01
    -- 6 , Distinguish , 55553635401028 , 9 , 2007 , 2014-04-10
    -- 7 , Distinguish , 33336081193101 , 6 , 2006 , 2013-02-01
    -- 8 , SuperiorCard , 33336081193101 , 7 , 2013-06-30

-- create the table for the CreditCard for postgressql
CREATE TABLE CreditCard (
    CreditCardID SERIAL PRIMARY KEY,
    CardType VARCHAR(255) NOT NULL,
    CardNumber VARCHAR(255) NOT NULL,
    ExpMonth INT NOT NULL,
    ExpYear INT NOT NULL,
    ModifiedDate DATE NOT NULL
);

-- insert data into the CreditCard table for postgressql
INSERT INTO CreditCard (CardType, CardNumber, ExpMonth, ExpYear, ModifiedDate) VALUES
('SuperiorCard', '33332664695310', 11, 2006, '2013-07-29'),
('Distinguish', '55552127249722', 8, 2005, '2013-12-05'),
('ColonialVoi...', '77778344838353', 7, 2006, '2014-01-14'),
('ColonialVoi...', '77774915718248', 7, 2006, '2013-05-20'),
('Vista', '55557132036181', 4, 2007, '2013-02-01'),
('Distinguish', '55553635401028', 9, 2007, '2014-04-10'),
('Distinguish', '33336081193101', 6, 2006, '2013-02-01'),
('SuperiorCard', '33336081193101', 7, 2013, '2013-06-30');



-- table name: PersonCreditCard
-- table structure: BusinessEntityID , CreditCardID , ModifiedDate
-- Types for each column: BusinessEntityID (int) , CreditCardID (int) , ModifiedDate (datetime)


-- extracting the requests that can be made to the CreditCard table


-- simple select statements 

    -- Get all data from the CreditCard table
    SELECT * 
    FROM CreditCard;

    -- Get information for a credit card with ID 33332664695310
    SELECT * 
    FROM CreditCard 
    WHERE CreditCardID = 33332664695310;

    -- Retrieve all cards with CardType 'SuperiorCard'
    SELECT * 
    FROM CreditCard 
    WHERE CardType = 'SuperiorCard';

    -- Find cards expiring in April, May, or June of the current or next year
    SELECT * 
    FROM CreditCard 
    WHERE (ExpMonth >= 4 AND ExpYear = 2024) 
    OR (ExpMonth <= 6 AND ExpYear = 2025);

    -- Get cards updated within the last 7 days 
    SELECT * 
    FROM CreditCard 
    WHERE ModifiedDate >= DATEADD(day, -7, GETDATE());

    -- Count the total number of credit cards
    SELECT COUNT(*) AS TotalCards 
    FROM CreditCard;

    -- Get all distinct card types
    SELECT DISTINCT CardType 
    FROM CreditCard;

    -- Find cards expiring this month 
    SELECT * 
    FROM CreditCard 
    WHERE ExpMonth = MONTH(GETDATE()) AND ExpYear = YEAR(GETDATE());

    -- Retrieve cards with card numbers ending in a specific digit
    SELECT * 
    FROM CreditCard 
    WHERE RIGHT(CardNumber, 1) = '0';

    -- List cards ordered by expiry date (ascending)
    SELECT * 
    FROM CreditCard 
    ORDER BY ExpYear, ExpMonth;

    -- Get the top 5 most recently modified cards
    SELECT TOP 5 * 
    FROM CreditCard 
    ORDER BY ModifiedDate DESC;

    -- Check if a specific card ID exists
    SELECT TOP 1 1 
    FROM CreditCard 
    WHERE CreditCardID = 33332664695310;  -- Returns 1 if exists, 0 otherwise

    -- Find cards with card numbers containing a specific sequence
    SELECT * 
    FROM CreditCard 
    WHERE CardNumber LIKE '%266%';

    -- Retrieve cards issued in a specific year 
    SELECT * 
    FROM CreditCard 
    WHERE YEAR(GETDATE()) - ExpYear = 1;

    -- Get cards with card types not equal to a specific type (e.g., "Mastercard")
    SELECT * 
    FROM CreditCard 
    WHERE CardType <> 'SuperiorCard';

------------------------------------------------------------------------------------------------------------------------

-- using group by

    -- 1. Group cards by type and count occurrences
    SELECT CardType, COUNT(*) AS CardCount 
    FROM CreditCard 
    GROUP BY CardType;

    -- 2. Find the total number of cards expiring in each month 
    SELECT ExpMonth, COUNT(*) AS ExpiringThisMonth FROM CreditCard
    WHERE ExpYear = YEAR(GETDATE())
    GROUP BY ExpMonth;

    -- 3. Calculate the total number of cards issued per year (assuming issuance year exists)
    SELECT YEAR(GETDATE()) - ExpYear AS IssuedYear, COUNT(*) AS CardsIssued 
    FROM CreditCard 
    GROUP BY YEAR(GETDATE()) - ExpYear;

    -- 4. Group cards by expiry year and find the most common card type for each year
    SELECT ExpYear, CardType, COUNT(*) AS CardTypeCount
    FROM CreditCard
    GROUP BY ExpYear, CardType
    ORDER BY ExpYear, CardTypeCount DESC;

    -- 5. Find the average expiry year for each card type
    SELECT CardType, AVG(ExpYear) AS AvgExpYearByType FROM CreditCard
    GROUP BY CardType;

    -- 6. Group cards by the first digit of the card number and count occurrences
    SELECT LEFT(CardNumber, 1) AS FirstDigit, COUNT(*) AS CardCount FROM CreditCard
    GROUP BY LEFT(CardNumber, 1);

    -- 7. Identify the number of cards modified in each day of the last week
    SELECT DATEPART(WEEKDAY, ModifiedDate) AS DayOfWeek, COUNT(*) AS CardsModified
    FROM CreditCard
    WHERE ModifiedDate >= DATEADD(day, -7, GETDATE())
    GROUP BY DATEPART(WEEKDAY, ModifiedDate);  

    -- 8. Group cards by card type and find the card with the latest expiry date for each type
    SELECT CardType, MAX(ExpYear) AS MaxExpYear, MAX(ExpMonth) AS MaxExpMonth
    FROM CreditCard
    GROUP BY CardType;

    -- 9. Find the total number of cards with expiry dates within a specific range (e.g., next 6 months) grouped by card type
    SELECT CardType, COUNT(*) AS CardsExpiringSoon
    FROM CreditCard
    WHERE (ExpMonth >= MONTH(GETDATE()) AND ExpYear = YEAR(GETDATE())) 
    OR (ExpMonth <= ADD_MONTHS(MONTH(GETDATE()), 6) AND ExpYear = YEAR(GETDATE()) + 
    CASE WHEN MONTH(GETDATE()) = 12 THEN 1 ELSE 0 END)
    GROUP BY CardType;

    -- 10. Group cards by the length of the card number and count occurrences (assuming variable length)
    SELECT LEN(CardNumber) AS CardNumberLength, COUNT(*) AS CardCount
    FROM CreditCard
    GROUP BY LEN(CardNumber);

------------------------------------------------------------------------------------------------------------------------

-- using aggregate functions

    -- 1. Find the earliest expiry date among all cards
    SELECT MIN(ExpYear) AS EarliestExpYear, MIN(ExpMonth) AS EarliestExpMonth
    FROM CreditCard;

    -- 2. Calculate the average expiry year and month for all cards
    SELECT AVG(ExpYear) AS AvgExpYear, AVG(ExpMonth) AS AvgExpMonth
    FROM CreditCard;

    -- 3. Find the latest modification date among all cards
    SELECT MAX(ModifiedDate) AS LatestModifiedDate
    FROM CreditCard;

    -- 4. Calculate the total number of cards expiring in the current year
    SELECT COUNT(*) AS ExpiringThisYear
    FROM CreditCard
    WHERE ExpYear = YEAR(GETDATE());

    -- 5. Find the card with the latest expiry date
    SELECT MAX(ExpYear) AS LatestExpYear, MAX(ExpMonth) AS LatestExpMonth
    FROM CreditCard;

    -- 6. Calculate the average card number length
    SELECT AVG(LEN(CardNumber)) AS AvgCardNumberLength
    FROM CreditCard;

    -- 7. Find the total number of cards modified in the last 30 days
    SELECT COUNT(*) AS CardsModifiedLast30Days
    FROM CreditCard
    WHERE ModifiedDate >= DATEADD(day, -30, GETDATE());

    -- 8. Calculate the sum of expiry years for all cards
    SELECT SUM(ExpYear) AS TotalExpYears
    FROM CreditCard;

    -- 9. Find the card with the earliest expiry date
    SELECT MIN(ExpYear) AS EarliestExpYear, MIN(ExpMonth) AS EarliestExpMonth
    FROM CreditCard;

    -- 10. Calculate the total number of cards with even-length card numbers
    SELECT COUNT(*) AS EvenLengthCardCount
    FROM CreditCard
    WHERE LEN(CardNumber) % 2 = 0;

------------------------------------------------------------------------------------------------------------------------

-- using subqueries

    -- 1. Find cards with the highest expiry year
    SELECT * 
    FROM CreditCard 
    WHERE ExpYear = (SELECT MAX(ExpYear) FROM CreditCard);

    -- 2. Retrieve cards with the earliest expiry date
    SELECT * 
    FROM CreditCard 
    WHERE ExpYear = (SELECT MIN(ExpYear) FROM CreditCard) 
    AND ExpMonth = (SELECT MIN(ExpMonth) FROM CreditCard WHERE ExpYear = (SELECT MIN(ExpYear) FROM CreditCard));

    -- 3. Find cards with the most recent modification date
    SELECT * 
    FROM CreditCard 
    WHERE ModifiedDate = (SELECT MAX(ModifiedDate) FROM CreditCard);

    -- 4. Retrieve cards with the earliest modification date
    SELECT * 
    FROM CreditCard 
    WHERE ModifiedDate = (SELECT MIN(ModifiedDate) FROM CreditCard);

    -- 5. Find cards with the highest card number length
    SELECT * 
    FROM CreditCard 
    WHERE LEN(CardNumber) = (SELECT MAX(LEN(CardNumber)) FROM CreditCard);

    -- 6. Retrieve cards with the shortest card number length
    SELECT * 
    FROM CreditCard 
    WHERE LEN(CardNumber) = (SELECT MIN(LEN(CardNumber)) FROM CreditCard);

    -- 7. Find cards with the most recent expiry date
    SELECT * 
    FROM CreditCard 
    WHERE ExpYear = (SELECT MAX(ExpYear) FROM CreditCard) 
    AND ExpMonth = (SELECT MAX(ExpMonth) FROM CreditCard WHERE ExpYear = (SELECT MAX(ExpYear) FROM CreditCard));

    -- 8. Retrieve cards with the earliest expiry date
    SELECT * 
    FROM CreditCard 
    WHERE ExpYear = (SELECT MIN(ExpYear) FROM CreditCard) 
    AND ExpMonth = (SELECT MIN(ExpMonth) FROM CreditCard WHERE ExpYear = (SELECT MIN(ExpYear) FROM CreditCard));

    -- 9. Find cards with the highest number of digits in the card number
    SELECT * 
    FROM CreditCard 
    WHERE LEN(CardNumber) = (SELECT MAX(LEN(CardNumber)) FROM CreditCard);

    -- 10. Retrieve cards with the lowest number of digits in the card number
    SELECT * 
    FROM CreditCard 
    WHERE LEN(CardNumber) = (SELECT MIN(LEN(CardNumber)) FROM CreditCard);

------------------------------------------------------------------------------------------------------------------------

-- using conditional statements

    -- 1. Retrieve cards with expiry dates in the past
    SELECT * 
    FROM CreditCard 
    WHERE (ExpYear < YEAR(GETDATE())) 
    OR (ExpYear = YEAR(GETDATE()) AND ExpMonth < MONTH(GETDATE()));

    -- 2. Find cards with expiry dates in the future
    SELECT * 
    FROM CreditCard 
    WHERE (ExpYear > YEAR(GETDATE())) 
    OR (ExpYear = YEAR(GETDATE()) AND ExpMonth > MONTH(GETDATE()));

    -- 3. Retrieve cards with even-length card numbers
    SELECT * 
    FROM CreditCard 
    WHERE LEN(CardNumber) % 2 = 0;

    -- 4. Find cards with odd-length card numbers
    SELECT * 
    FROM CreditCard 
    WHERE LEN(CardNumber) % 2 <> 0;

    -- 5. Retrieve cards with card numbers containing a specific sequence
    SELECT * 
    FROM CreditCard 
    WHERE CardNumber LIKE '%266%';

    -- 6. Find cards with card numbers not ending in a specific digit
    SELECT * 
    FROM CreditCard 
    WHERE RIGHT(CardNumber, 1) <> '0';

    -- 7. Retrieve cards with card types equal to a specific type (e.g., "Mastercard")
    SELECT * 
    FROM CreditCard 
    WHERE CardType = 'SuperiorCard';

    -- 8. Find cards with card types not equal to a specific type (e.g., "Mastercard")
    SELECT * 
    FROM CreditCard 
    WHERE CardType <> 'SuperiorCard';

    -- 9. Retrieve cards with card numbers starting with a specific digit
    SELECT * 
    FROM CreditCard 
    WHERE LEFT(CardNumber, 1) = '4';

    -- 10. Find cards with card numbers not starting with a specific digit
    SELECT * 
    FROM CreditCard 
    WHERE LEFT(CardNumber, 1) <> '4';

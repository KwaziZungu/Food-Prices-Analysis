-- ZUNGU KWAZI --
-- Edited Using MySQL Workbench v8.0 --
-- FOOD PRICES DATA --

USE activities; -- My database

-- "food_prices" table contains all the data in our dataset
SELECT * FROM food_prices;
DESCRIBE food_prices;



													-- CLEANING --
-- Changing the form of the date to be YYYY-MM or MM-YYYY
ALTER TABLE food_prices
	ADD Date DATE;
UPDATE food_prices
	SET Date = STR_TO_DATE(CONCAT(Year, "-", LPAD(Month, 2, "0")), "%Y-%m" );  -- LPAD insures that the month always has 2 characters



													-- VIEWS --
-- View For Max & Min prices for each product in each country
CREATE VIEW max_min_prices AS
	SELECT Country,FoodItem,MAX(PriceinUSD) AS HighestPrice, MIN(PriceinUSD) as LowestPrice, AVG(PriceinUSD) as AveragePrice 
		FROM food_prices
			GROUP BY FoodItem,Country;
            
SELECT * FROM max_min_prices;
DROP VIEW max_min_prices; -- If necessary

-- Unit of measurement for each item
CREATE VIEW units_used AS
	SELECT FoodItem, UnitofMeasurement 
		FROM food_prices
			GROUP BY UnitofMeasurement;

SELECT * FROM units_used;
DROP VIEW units_used;

-- Records of items with high quality vs those with medium quality
CREATE VIEW QualityCount AS
	SELECT Country, Quality, COUNT(*) AS CountRecords
		FROM food_prices
			GROUP BY Country, Quality;
            
SELECT * FROM QualityCount;
DROP VIEW QualityCount;



													-- STORED PROCEDURES --
DELIMITER //
	-- When necessary or if they already exist:
    DROP PROCEDURE IF EXISTS MOST_EXP//
    DROP PROCEDURE IF EXISTS LEAST_EXP//

	-- Finds the highest price recorded of each item & on which date for which country
	CREATE PROCEDURE MOST_EXP(item TEXT)
    BEGIN 
		SELECT Date, Country, PriceinUSD FROM food_prices 
			WHERE PriceinUSD = (
				SELECT MAX(PriceinUSD) FROM food_prices WHERE FoodItem = item
				);
	END //
    
    -- Finds the lowest price recorded of each item & on which date for which country
	CREATE PROCEDURE LEAST_EXP(item TEXT)
    BEGIN 
		SELECT Date, Country, PriceinUSD FROM food_prices 
			WHERE PriceinUSD = (
				SELECT MIN(PriceinUSD) FROM food_prices WHERE FoodItem = item
				);
	END //

DELIMITER ;



													-- QUERIES --
-- Total number of records for this data
SELECT COUNT(FoodItem) 
	FROM food_prices
		WHERE Quality != "High";

-- When was each product the most expensive ?
CALL MOST_EXP("Bread");  -- For Bread
CALL MOST_EXP("Milk"); -- For Milk
CALL MOST_EXP("Eggs"); -- For Eggs
CALL MOST_EXP("Potatoes"); -- For Potatoes

-- When did the minimun price occur for each product occur?
CALL LEAST_EXP("Bread"); -- For Bread
CALL LEAST_EXP("Milk"); -- For Milk
CALL LEAST_EXP("Eggs"); -- For Eggs
CALL LEAST_EXP("Potatoes"); -- For Potatoes

-- How many records where food items were unavailable?
SELECT COUNT(FoodItem)
	FROM food_prices
		WHERE Availability != 1;

-- Which products were unavailable? When & Where?
SELECT FoodItem, Country, Date, Availability 
	FROM food_prices
		WHERE Availability != 1;  
        
-- How Many records had food items that were not of high quality?
SELECT COUNT(FoodItem) 
	FROM food_prices
		WHERE Quality != "High";
        
-- Show those records
SELECT FoodItem, Country, Date, Quality
	FROM food_prices
		WHERE Quality != "High"; 

    


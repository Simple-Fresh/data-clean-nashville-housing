# data-clean-nashville-housing
Description: Numerous manipulations performed to standardize and clean Nashville Housing data, making it more usable.

Motivation: Taking raw housing data and implementing data cleaning methods with SQL to manipulate it into readily usable formats

Functionality: The program applies necessary data type changes, utilizes aliases with a self-join to populate address data into NULL values in address field. It then uses 2 methods (SUBSTRING, PARSENAME) to split property address data to create much more usable data (street address, city, state) out of full address data. The program also uses a CTE to create a temporary result set that removes duplicate addresses by partitioning by fields determined to be unique indentifiers.  Lastly, the program drops unused columns to remove excess, unusable data.

Tech Used: Microsoft SQL Management Server Studio 2022 (local instance connection)

How-To: 1. Establish local server connection in SSMS and create a new database 2. Download the associated .xlsx dataset ('Nashville Housing Data for Data Cleaning') 3. Import dataset into database in SSMS (If error is encountered, launch Import Wizard from SSMS folder in Start Menu; issue pertains to 32-bit vs 64-bit) 4. Check Top 1000 rows to ensure datasets loaded in properly 5. Download the .sql file 'Nashville_Housing_Data_Cleaning.sql' 6. Run queries one at a time. 7. Conduct your own data exploration, cleaning, and other manipulations

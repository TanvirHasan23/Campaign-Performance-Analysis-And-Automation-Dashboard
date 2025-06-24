# Database Name
CREATE DATABASE campaign_analysis;
USE campaign_analysis;

# Schema
CREATE TABLE campaign_performance (
    `Month` DATE,
    `Campaign_Name` VARCHAR(255),
    `Leads` INT,
    `Gross_Accepted` INT,
    `Duplicated` INT,
    `Errors` INT,
    `Gross_Profit` DECIMAL(10, 2),
    `Gross_Margin` DECIMAL(10, 4),
    `Gross_Cost` DECIMAL(10, 2),
    `Gross_Revenue` DECIMAL(10, 2),
    `Gross_Avg_Cost` DECIMAL(10, 2),
    `Gross_Avg_Revenue` DECIMAL(10, 2),
    `Net_Accepted` INT,
    `Net_Profit` DECIMAL(10, 2),
    `Net_Margin` DECIMAL(10, 4),
    `Net_Cost` DECIMAL(10, 2),
    `Net_Revenue` DECIMAL(10, 2),
    `Net_Avg_Cost` DECIMAL(10, 2),
    `Net_Avg_Revenue` DECIMAL(10, 2),
    `Pings_Accepted` INT,
    `Pings_Failed` INT,
    `Total_Pings` INT,
    `Ping_Post_Ratio` DECIMAL(10, 3),
    `Ping_Avg_Bid` DECIMAL(10, 3)
);


LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Analysis2_Lead Prosper_Report_MTT(1-7)_Mar2024 to Jan2025.csv'
INTO TABLE campaign_performance
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select*from campaign_performance

## 1. Total gross profit by campaign
SELECT 
    Campaign_Name,
    SUM(Gross_Profit) AS Total_Gross_Profit
FROM campaign_performance
GROUP BY Campaign_Name
ORDER BY Total_Gross_Profit DESC;

## 2. Lead Conversion Rate
SELECT 
    Campaign_Name,
    (SUM(Gross_Accepted) / SUM(Leads)) * 100 AS Conversion_Rate
FROM campaign_performance
GROUP BY Campaign_Name
ORDER BY Conversion_Rate DESC;

## 3. Ping success rate
SELECT 
    Campaign_Name,
    (SUM(Pings_Accepted) / SUM(Total_Pings)) * 100 AS Ping_Success_Rate
FROM campaign_performance
GROUP BY Campaign_Name
ORDER BY Ping_Success_Rate DESC;

## 4. Error rate
SELECT 
    Campaign_Name,
    (SUM(Errors) / SUM(Leads)) * 100 AS Error_Rate
FROM campaign_performance
GROUP BY Campaign_Name
ORDER BY Error_Rate DESC;

## 5. Gross profit by month
SELECT 
    MONTHNAME(Month) AS Month_Name,
    SUM(Gross_Profit) AS Total_Gross_Profit
FROM campaign_performance
GROUP BY MONTHNAME(Month), MONTH(Month)
ORDER BY MONTH(Month);

## 6. Ping Average Bid vs. Conversion
SELECT 
    Campaign_Name,
    AVG(Ping_Avg_Bid) AS Avg_Ping_Bid,
    (SUM(Gross_Accepted) / SUM(Leads)) * 100 AS Conversion_Rate
FROM campaign_performance
GROUP BY Campaign_Name
ORDER BY Avg_Ping_Bid DESC;

## 7. Gross profit margin
SELECT 
    Campaign_Name,
    AVG(Gross_Margin) * 100 AS Avg_Gross_Profit_Margin
FROM campaign_performance
GROUP BY Campaign_Name
ORDER BY Avg_Gross_Profit_Margin DESC;

## 8. Net profit margin
SELECT 
    Campaign_Name,
    AVG(Net_Margin) * 100 AS Avg_Net_Profit_Margin
FROM campaign_performance
GROUP BY Campaign_Name
ORDER BY Avg_Net_Profit_Margin DESC;

## 9. Highest Performing Campaigns (Top 5)
SELECT 
    Campaign_Name,
    SUM(Gross_Profit) AS Total_Gross_Profit
FROM campaign_performance
GROUP BY Campaign_Name
ORDER BY Total_Gross_Profit DESC
LIMIT 5;

## 10. Lowest performing campaign (bottom 5)
SELECT 
    Campaign_Name,
    SUM(Gross_Profit) AS Total_Gross_Profit
FROM campaign_performance
GROUP BY Campaign_Name
ORDER BY Total_Gross_Profit ASC
LIMIT 5;


## 11. Months with the highest and lowest gross profit
SELECT 
    MONTHNAME(Month) AS Month_Name,
    SUM(Gross_Profit) AS Total_Gross_Profit
FROM campaign_performance
GROUP BY MONTHNAME(Month), MONTH(Month)
ORDER BY Total_Gross_Profit DESC
LIMIT 3; -- Month with the highest profit

## 12. Month with the lowest profit
SELECT 
    MONTHNAME(Month) AS Month_Name,
    SUM(Gross_Profit) AS Total_Gross_Profit
FROM campaign_performance
GROUP BY MONTHNAME(Month), MONTH(Month)
ORDER BY Total_Gross_Profit ASC
LIMIT 3; -- Month with the lowest profit

## 13. Total leads and expected rate by month
SELECT 
    MONTHNAME(Month) AS Month_Name,
    SUM(Leads) AS Total_Leads,
    SUM(Gross_Accepted) AS Total_Accepted,
    (SUM(Gross_Accepted) / SUM(Leads)) * 100 AS Acceptance_Rate
FROM campaign_performance
GROUP BY MONTHNAME(Month), MONTH(Month)
ORDER BY MONTH(Month);


## 14. Monthly Ping Success Rate
SELECT 
    MONTHNAME(Month) AS Month_Name,
    (SUM(Pings_Accepted) / SUM(Total_Pings)) * 100 AS Ping_Success_Rate
FROM campaign_performance
GROUP BY MONTHNAME(Month), MONTH(Month)
ORDER BY MONTH(Month);



### Campaign Best Master Table
CREATE TABLE campaign_best_master (
    Campaign_Name VARCHAR(255) PRIMARY KEY,
    Total_Gross_Profit DECIMAL(10,2),
    Conversion_Rate DECIMAL(10,2),
    Ping_Success_Rate DECIMAL(10,2),
    Error_Rate DECIMAL(10,2),
    Avg_Gross_Profit_Margin DECIMAL(10,2),
    Avg_Net_Profit_Margin DECIMAL(10,2)
);


### Monthly Best Master Table
CREATE TABLE monthly_best_master (
    Month_Name VARCHAR(20) PRIMARY KEY,
    Total_Gross_Profit DECIMAL(10,2),
    Highest_Gross_Profit DECIMAL(10,2),
    Lowest_Gross_Profit DECIMAL(10,2),
    Total_Leads INT,
    Total_Accepted INT,
    Acceptance_Rate DECIMAL(10,2),
    Ping_Success_Rate DECIMAL(10,2)
);



### --Using FLOAT or DECIMAL(10,2) type
ALTER TABLE campaign_best_master 
MODIFY COLUMN Conversion_Rate DECIMAL(10,2),
MODIFY COLUMN Ping_Success_Rate DECIMAL(10,2),
MODIFY COLUMN Error_Rate DECIMAL(10,2),
MODIFY COLUMN Avg_Gross_Profit_Margin DECIMAL(10,2),
MODIFY COLUMN Avg_Net_Profit_Margin DECIMAL(10,2);


### --Updating the Campaign Best Master Table
REPLACE INTO campaign_best_master 
    (Campaign_Name, Total_Gross_Profit, Conversion_Rate, Ping_Success_Rate, Error_Rate, Avg_Gross_Profit_Margin, Avg_Net_Profit_Margin)
SELECT 
    Campaign_Name,
    SUM(Gross_Profit) AS Total_Gross_Profit,
    COALESCE(ROUND((SUM(Gross_Accepted) / NULLIF(SUM(Leads), 0)) * 100, 2), 0) AS Conversion_Rate,
    COALESCE(ROUND((SUM(Pings_Accepted) / NULLIF(SUM(Total_Pings), 0)) * 100, 2), 0) AS Ping_Success_Rate,
    COALESCE(ROUND((SUM(Errors) / NULLIF(SUM(Leads), 0)) * 100, 2), 0) AS Error_Rate,
    COALESCE(ROUND(AVG(Gross_Margin) * 100, 2), 0) AS Avg_Gross_Profit_Margin,
    COALESCE(ROUND(AVG(Net_Margin) * 100, 2), 0) AS Avg_Net_Profit_Margin
FROM campaign_performance
GROUP BY Campaign_Name;



### --Updating the monthly_best_master 
REPLACE INTO monthly_best_master 
    (Month_Name, Total_Gross_Profit, Highest_Gross_Profit, Lowest_Gross_Profit, Total_Leads, Total_Accepted, Acceptance_Rate, Ping_Success_Rate)
SELECT 
    MONTHNAME(Month) AS Month_Name,
    SUM(Gross_Profit) AS Total_Gross_Profit,
    MAX(Gross_Profit) AS Highest_Gross_Profit,
    MIN(Gross_Profit) AS Lowest_Gross_Profit,
    SUM(Leads) AS Total_Leads,
    SUM(Gross_Accepted) AS Total_Accepted,
    COALESCE(ROUND((SUM(Gross_Accepted) / NULLIF(SUM(Leads), 0)) * 100, 2), 0) AS Acceptance_Rate,
    COALESCE(ROUND((SUM(Pings_Accepted) / NULLIF(SUM(Total_Pings), 0)) * 100, 2), 0) AS Ping_Success_Rate
FROM campaign_performance
GROUP BY MONTHNAME(Month), MONTH(Month)
ORDER BY MONTH(Month);


###  Stored Procedure
DELIMITER //
CREATE PROCEDURE update_campaign_master()
BEGIN
    -- Update campaign_best_master
    REPLACE INTO campaign_best_master 
        (Campaign_Name, Total_Gross_Profit, Conversion_Rate, Ping_Success_Rate, Error_Rate, Avg_Gross_Profit_Margin, Avg_Net_Profit_Margin)
    SELECT 
        Campaign_Name,
        SUM(Gross_Profit) AS Total_Gross_Profit,
        COALESCE(ROUND((SUM(Gross_Accepted) / NULLIF(SUM(Leads), 0)) * 100, 2), 0) AS Conversion_Rate,
        COALESCE(ROUND((SUM(Pings_Accepted) / NULLIF(SUM(Total_Pings), 0)) * 100, 2), 0) AS Ping_Success_Rate,
        COALESCE(ROUND((SUM(Errors) / NULLIF(SUM(Leads), 0)) * 100, 2), 0) AS Error_Rate,
        COALESCE(ROUND(AVG(Gross_Margin) * 100, 2), 0) AS Avg_Gross_Profit_Margin,
        COALESCE(ROUND(AVG(Net_Margin) * 100, 2), 0) AS Avg_Net_Profit_Margin
    FROM campaign_performance
    GROUP BY Campaign_Name;
    
    -- Update monthly_best_master
    REPLACE INTO monthly_best_master 
        (Month_Name, Total_Gross_Profit, Highest_Gross_Profit, Lowest_Gross_Profit, Total_Leads, Total_Accepted, Acceptance_Rate, Ping_Success_Rate)
    SELECT 
        MONTHNAME(Month) AS Month_Name,
        SUM(Gross_Profit) AS Total_Gross_Profit,
        MAX(Gross_Profit) AS Highest_Gross_Profit,
        MIN(Gross_Profit) AS Lowest_Gross_Profit,
        SUM(Leads) AS Total_Leads,
        SUM(Gross_Accepted) AS Total_Accepted,
        COALESCE(ROUND((SUM(Gross_Accepted) / NULLIF(SUM(Leads), 0)) * 100, 2), 0) AS Acceptance_Rate,
        COALESCE(ROUND((SUM(Pings_Accepted) / NULLIF(SUM(Total_Pings), 0)) * 100, 2), 0) AS Ping_Success_Rate
    FROM campaign_performance
    GROUP BY MONTHNAME(Month), MONTH(Month)
    ORDER BY MONTH(Month);
END //
DELIMITER ;


### From now on, whenever new data is loaded into the campaign_performance table, simply run the following command to update the data:
-- CALL update_campaign_master();

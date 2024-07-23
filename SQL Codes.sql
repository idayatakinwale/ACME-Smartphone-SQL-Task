select * from smartphone

-----------DATASET CLEANING AND DATA MANIPULATION

---CHANGING DATA TYPES
ALTER TABLE smartphone
ALTER COLUMN model VARCHAR(100)

ALTER TABLE smartphone
ALTER COLUMN price INTEGER

ALTER TABLE smartphone
ALTER COLUMN rating INTEGER

UPDATE smartphone
SET has_5g = CASE
	WHEN has_5g= 'true' THEN 1
	WHEN has_5g = 'false' THEN 0
END;

ALTER TABLE smartphone
ALTER COLUMN has_5g bit

UPDATE smartphone
SET has_nfc = CASE
	WHEN has_nfc= 'true' THEN 1
	WHEN has_nfc = 'false' THEN 0
END;

ALTER TABLE smartphone
ALTER COLUMN has_nfc bit

UPDATE smartphone
SET has_ir_blaster = CASE
	WHEN has_ir_blaster= 'true' THEN 1
	WHEN has_ir_blaster = 'false' THEN 0
END;

ALTER TABLE smartphone
ALTER COLUMN has_ir_blaster bit

ALTER TABLE smartphone
ALTER COLUMN processor_speed FLOAT

ALTER TABLE smartphone
ALTER COLUMN battery_capacity INT

ALTER TABLE smartphone
ALTER COLUMN fast_charging INT

ALTER TABLE smartphone
ALTER COLUMN ram_capacity INT

ALTER TABLE smartphone
ALTER COLUMN internal_memory INT

ALTER TABLE smartphone
ALTER COLUMN refresh_rate INT

update smartphone
set num_front_cameras = NULL
where num_front_cameras = 'Missing'

ALTER TABLE smartphone
ALTER COLUMN num_rear_cameras INT

ALTER TABLE smartphone
ALTER COLUMN num_front_cameras INT

update smartphone
set primary_camera_rear = 0
where primary_camera_rear = 'kaios'

ALTER TABLE smartphone
ALTER COLUMN primary_camera_rear FLOAT

update smartphone
set primary_camera_front = 0
where primary_camera_front = 'main'

ALTER TABLE smartphone
ALTER COLUMN primary_camera_front FLOAT

-- Updating the RESOLUTION column to remove question marks
UPDATE Smartphone
SET resolution = REPLACE(resolution, '?', '');

-- Updating the extended_memory column to remove question marks
UPDATE Smartphone
SET extended_memory = REPLACE(extended_memory, '?', '');

-----REPLACING NULL VALUES
select avg(rating)
from smartphone

update smartphone
set rating = 78
where rating IS NULL

-- Replace null values in PROCESSOR_NAME with 'Unknown Processor'
UPDATE Smartphone
SET processor_name = 'Unknown Processor'
WHERE processor_name IS NULL;

-- Replace null values in PROCESSOR_BRAND with 'Unknown Brand'
UPDATE Smartphone
SET processor_brand = 'Unknown Brand'
WHERE processor_brand IS NULL;

-- Replace null values in num_cores with 'Unknown Core'
UPDATE Smartphone
SET num_cores = 'Unknown Core'
WHERE num_cores IS NULL;

-- Replace null values in processor_speed with the mean value
SELECT AVG(processor_speed) AS avg_processor_speed
FROM Smartphone
where processor_speed IS  NOT NULL

UPDATE Smartphone
SET processor_speed = (SELECT AVG(processor_speed) FROM Smartphone WHERE processor_speed IS NOT NULL)
WHERE processor_speed IS NULL;

-- Replace null values in battery_capacity with the mean value
SELECT AVG(battery_capacity) AS avg_battery_capacity
FROM Smartphone
where battery_capacity IS  NOT NULL

UPDATE smartphone
set battery_capacity = (SELECT AVG(battery_capacity)
						FROM Smartphone
						where battery_capacity IS  NOT NULL)
where battery_capacity IS NULL

-- Replace null values in internal_memory with the mean value
SELECT AVG(internal_memory)
FROM Smartphone
where internal_memory IS  NOT NULL

UPDATE smartphone
set internal_memory = (SELECT AVG(internal_memory)
						FROM Smartphone
						where internal_memory IS  NOT NULL)
where internal_memory IS NULL

-- Replace null value in resolution with the most frequent value
SELECT TOP 1 resolution
FROM Smartphone
WHERE resolution IS NOT NULL
GROUP BY resolution
ORDER BY COUNT(*) DESC;

UPDATE Smartphone
SET resolution = (
    SELECT TOP 1 resolution
    FROM Smartphone
    WHERE resolution IS NOT NULL
    GROUP BY resolution
    ORDER BY COUNT(*) DESC
)
WHERE resolution IS NULL;

-- Replace null value in num_front_cameras with the most frequent value
SELECT TOP 1 num_front_cameras
FROM Smartphone
WHERE num_front_cameras IS NOT NULL
GROUP BY num_front_cameras
ORDER BY COUNT(*) DESC;

UPDATE Smartphone
SET num_front_cameras = (
    SELECT TOP 1 num_front_cameras
    FROM Smartphone
    WHERE num_front_cameras IS NOT NULL
    GROUP BY num_front_cameras
    ORDER BY COUNT(*) DESC
)
WHERE num_front_cameras IS NULL;

-- Replace missing values in os with 'Not Specified'
UPDATE Smartphone
SET os = 'Not Specified'
WHERE os IS NULL;

select primary_camera_rear
from smartphone
where primary_camera_rear is null


-- Replace missing values in primary_camera_front with the most frequent value
UPDATE Smartphone
SET primary_camera_front = (
    SELECT TOP 1 primary_camera_front
    FROM Smartphone
    WHERE primary_camera_front IS NOT NULL
    GROUP BY primary_camera_front
    ORDER BY COUNT(*) DESC
)
WHERE primary_camera_front IS NULL;

------DATA ANALYSIS

---Average price by brand

SELECT brand_name, AVG(price) AS Avg_price
FROM Smartphone
GROUP BY brand_name
ORDER BY Avg_price DESC

---Correlation Analysis between price and processor_speed

WITH Stats AS (
    SELECT 
        COUNT(*) AS n,
        SUM(CAST(price AS FLOAT)) AS sum_x,
        SUM(CAST(processor_speed AS FLOAT)) AS sum_y,
        SUM(CAST(price AS FLOAT) * CAST(processor_speed AS FLOAT)) AS sum_xy,
        SUM(CAST(price AS FLOAT) * CAST(price AS FLOAT)) AS sum_xx,
        SUM(CAST(processor_speed AS FLOAT) * CAST(processor_speed AS FLOAT)) AS sum_yy
    FROM 
        smartphone
    WHERE 
        price IS NOT NULL AND processor_speed IS NOT NULL
)
SELECT 
    (n * sum_xy - sum_x * sum_y) / 
    (SQRT(n * sum_xx - sum_x * sum_x) * SQRT(n * sum_yy - sum_y * sum_y)) AS correlation
FROM 
    Stats;

---Correlation Analysis between price and internal memory

-- Calculate the mean of price and internal_memory
WITH MeanValues AS (
    SELECT 
        AVG(CAST(price AS FLOAT)) AS mean_price,
        AVG(CAST(internal_memory AS FLOAT)) AS mean_internal_memory
    FROM 
        smartphone
),
-- Calculate the numerator and denominators for the correlation formula
CorrelationComponents AS (
    SELECT 
        SUM((CAST(price AS FLOAT) - mv.mean_price) * (CAST(internal_memory AS FLOAT) - mv.mean_internal_memory)) AS numerator,
        SQRT(SUM(POWER(CAST(price AS FLOAT) - mv.mean_price, 2))) AS denominator_price,
        SQRT(SUM(POWER(CAST(internal_memory AS FLOAT) - mv.mean_internal_memory, 2))) AS denominator_internal_memory
    FROM 
        smartphone,
        MeanValues mv
)
-- Calculate the Pearson correlation coefficient
SELECT 
    numerator / (denominator_price * denominator_internal_memory) AS correlation_coefficient
FROM 
    CorrelationComponents;

	----Analysis of Product performance and features

---Which brand offers the highest average battery capacity?
SELECT brand_name, AVG(battery_capacity) AS avg_battery_capacity
FROM Smartphone
GROUP BY brand_name
ORDER BY avg_battery_capacity DESC;

---Which brand has the highest number of phones with fast charging capability?
SELECT brand_name, COUNT(*) AS count_fast_charging
FROM Smartphone
WHERE fast_charging > 0
GROUP BY brand_name
ORDER BY count_fast_charging DESC;

---What are the most common screen resolutions?
SELECT resolution, COUNT(*) AS count
FROM Smartphone
GROUP BY resolution
ORDER BY count DESC;

	--------Pricing and Value Analysis

---Which brand has the highest price-to-performance ratio (price vs. processor speed)?
SELECT brand_name, AVG(price / processor_speed) AS price_per_ghz
FROM Smartphone
GROUP BY brand_name
ORDER BY price_per_ghz DESC;

---How do prices vary between phones with and without 5G capability?
SELECT has_5g, AVG(price) AS avg_price
FROM Smartphone
GROUP BY has_5g;

---Which features (e.g., 5G, NFC, IR blaster) are most common in high-end phones (e.g., price > average price)?
SELECT AVG(price) AS avg_price INTO #TempAvgPrice FROM Smartphone;

SELECT 
    has_5g,
    has_nfc,
    has_ir_blaster,
    COUNT(*) AS count
FROM Smartphone
WHERE price > (SELECT avg_price FROM #TempAvgPrice)
GROUP BY has_5g, has_nfc, has_ir_blaster
ORDER BY count DESC;


	-----Performance Analysis

----Which processors are most commonly used in high-performance phones(e.g., processor speed > average speed)?
SELECT AVG(processor_speed) AS avg_processor_speed INTO #TempAvgProcessorSpeed 
FROM Smartphone;

SELECT 
    processor_name,
    COUNT(*) AS count
FROM Smartphone
WHERE processor_speed > (SELECT avg_processor_speed FROM #TempAvgProcessorSpeed)
GROUP BY processor_name
ORDER BY count DESC;

---What is the average battery capacity of phones with fast charging compared to those without?
SELECT 
    CASE 
        WHEN fast_charging > 0 THEN 'Fast Charging'
        ELSE 'No Fast Charging'
    END AS charging_type,
    AVG(battery_capacity) AS avg_battery_capacity
FROM Smartphone
GROUP BY CASE 
             WHEN fast_charging > 0 THEN 'Fast Charging'
             ELSE 'No Fast Charging'
         END;


















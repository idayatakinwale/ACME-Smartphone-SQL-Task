  # Smartphone Specification Analysis

  ### Project Overview
 
This project focuses on analyzing a dataset of smartphone specifications to derive valuable insights regarding the relationship between various features and the pricing of smartphones. The dataset comprises multiple columns detailing aspects such as the brand name, model, price, rating, connectivity features (5G, NFC, IR blaster), processor details (name, brand, number of cores, speed), battery capacity, fast-charging capability, memory (RAM and internal storage), display specifications (refresh rate, resolution), camera details (number of front and rear cameras, resolution), and operating system.

### Data Source

The primary dataset used for this analysis is the "smartphone_cleaned_v2.csv" file, containing detailed information about the features of different phone brands.

### Tools Used

- Microsoft Excel
- Microsoft SQL Server


### Data Cleaning/Preparation

In the initial data preparation phase, the following tasks were performed:
1. Data loading and Inspection
2. Data type Conversion
3. Handling missing data
4. Fixing structural errors e.g. strange names and typos.


### Exploratory Data Analysis

This involved exploring the smartphone data to answer key questions using sql server, such as:

- Which brand offers the highest average battery capacity?

```sql
SELECT brand_name, AVG(battery_capacity) AS avg_battery_capacity
FROM Smartphone
GROUP BY brand_name
ORDER BY avg_battery_capacity DESC;
```
  
- Which brand has the highest number of phones with fast charging capability?

```sql
SELECT brand_name, COUNT(*) AS count_fast_charging
FROM Smartphone
WHERE fast_charging > 0
GROUP BY brand_name
ORDER BY count_fast_charging DESC;
```

- What are the most common screen resolutions?

```sql
SELECT resolution, COUNT(*) AS count
FROM Smartphone
GROUP BY resolution
ORDER BY count DESC;
```

- How do prices vary between phones with and without 5G capability?

```sql
SELECT has_5g, AVG(price) AS avg_price
FROM Smartphone
GROUP BY has_5g;
```

- Which features (e.g., 5G, NFC, IR blaster) are most common in high-end phones (e.g., price > average price)?

```sql
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
```

- Which processors are most commonly used in high-performance phones(e.g., processor speed > average speed)?

```sql
SELECT AVG(processor_speed) AS avg_processor_speed INTO #TempAvgProcessorSpeed 
FROM Smartphone;

SELECT 
    processor_name,
    COUNT(*) AS count
FROM Smartphone
WHERE processor_speed > (SELECT avg_processor_speed FROM #TempAvgProcessorSpeed)
GROUP BY processor_name
ORDER BY count DESC;
```

- What is the average battery capacity of phones with fast charging compared to those without?

```sql
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
```

- Which brand has the highest price-to-performance ratio (price vs. processor speed)?

```sql
SELECT brand_name, AVG(price / processor_speed) AS price_per_ghz
FROM Smartphone
GROUP BY brand_name
ORDER BY price_per_ghz DESC;
```



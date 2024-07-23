  # Smartphone Specification Analysis

  ## Table of Contents

  - [Project Overview](#project-overview)
  - [Data Source](#data-source)
  - [Tools Used](#tools-used)
  - [Data Cleaning/Preparation](#data-cleaning/preparation)
  - [Exploratory Data Analysis](#exploratory-data-analysis)
  - [Results/Findings](#results/findings)
  - [Recommendations](#recommendations)

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
3. Handling missing data e.g. replacing null values with the average or modal values as appropriate.
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

### Results/Findings

The analysis results are summarized as follows:
1. The most expensive phone brand is **Vertu** with an average price of 650k Rupees, while the cheapest is **Lyf** with an average price of 3,940 Rupees.
2. Phones with 5g capability are generally more expensive than those without 5g. Also, the 5g and NFC were found to be the most common connectivity features in high end phones.
3. **Xiaomi** is the brand that has the highest number of phones with fast-charging capability (121 phones), followed by **samsung** (108 phones).
4. The **Doogee** brand offers the highest average battery capacity (14000mAh), while the **CAT** (Caterpillar Inc.) brand offers the lowest (2000mAh).
5. The processors most commonly used in high-performance phones are Snapdragon8+ Gen1, Snapdragon8 Gen2 and Bionic A15.
6. The correlation coefficient between the *price* and *processor_speed* gave **0.45**. This value indicates a moderate positive correlation between the variables, which suggests that as the processor speed of a smartphone increases, its price tends to increase as well, although the relationship is not very strong.
7. A correlation coefficient of **0.557** between the *price* and *internal_memory* also indicates a moderate positive correlation, suggesting that there is noticeable relationship between the two variables. This means that smartphones with larger internal memory generally tend to be priced higher.

### Recommendations

Based on the insights gained from these analyses, the following recommendations can be considered:
- **Product Development**: Focus on developing phones with high-demand features like 5G, fast charging, and high-resolution screens.
- **Pricing Strategy**: Adjust pricing strategies based on the price-to-performance ratio, ensuring competitive pricing for high-end features.
- **Marketing Strategy**: Target marketing campaigns towards regions or segments that show higher interest in specific features.
- **Inventory Management**: Stock more phones from brands with higher sales or in high demand based on features.
- **Customer Preferences**: Highlight popular features in marketing materials to attract more customers.
- Based on the correlation analysis, the following actions are recommended:
 1. Focus on developing models with higher internal memory if targeting a higher price segment.
 2. Balance internal memory with other high-demand features (e.g., brand, processor, camera quality, build quality, etc.) to optimize the value proposition.
 3. Marketing strategies could highlight the relationship between faster processors/higher internal memory and higher prices to target consumers looking for high-performance smartphones.

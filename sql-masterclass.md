### Cryptocurrency Trading

Aim: To complete the the SQL MasterClass course from datawithdanny.com using MySQL

*P.S. The original repo has a few things that need to be fixed and this repo will attempt to do so. As an example; The original MySQL `transactions` table is missing `txn_date` column. This is added via a query as explained below.*


* Added the where clause to 3rd question to filter out BTC transactions as stated by the question.
```
FROM trading.transactions
+ WHERE ticker = 'BTC'
GROUP BY txn_year, txn_type
ORDER BY txn_year, txn_type;
```
* fixed question 6 query result in step2.md

```
| mentor_count  |
| ------------- |
|      11       |
```

*  line 226 correction on ticker. Ticker set to 'ETH' previously was 'BTC'

```
SUM(
    CASE
+     WHEN ticker = 'ETH' AND txn_type = 'SELL' THEN quantity
      ELSE 0
    END
```



Quickstart: Install the database onto your local mysql installation. ( For more installation options, please refer to https://github.com/DataWithDanny/sql-masterclass#accessing-the-data )

`mysql -u <username> -p < /path/to/trading-schema-and-data-mysql.sql`

or
```
mysql -u <username> -p

source /path/to/trading-schema-and-data-mysql.sql
```
The results of the import are:

```
Query OK, 1 row affected (2.99 sec)        
                                           
Query OK, 0 rows affected (7.93 sec)       
                                           
Query OK, 14 rows affected (2.10 sec)      
Records: 14  Duplicates: 0  Warnings: 0    
                                           
Query OK, 0 rows affected (1.46 sec)       
                                           
Query OK, 3404 rows affected (1.47 sec)    
Records: 3404  Duplicates: 0  Warnings: 0  
                                           
Query OK, 0 rows affected (0.51 sec)       
                                           
Query OK, 19245 rows affected (2.46 sec)   
Records: 19245  Duplicates: 0  Warnings: 0 
                                           
```

The Entity Relation Diagram of the 'trading' database ( https://dbdiagram.io/embed/608d07e4b29a09603d12edbd ):

<img src="trading-erd.jpg"></img>

The structure of the database:

```
mysql> select database();                                      
+------------+                                                 
| database() |                                                 
+------------+                                                 
| trading    |                                                 
+------------+                                                 
1 row in set (0.00 sec)                                        
                                                               
mysql> show tables;                                            
+-------------------+                                          
| Tables_in_trading |                                          
+-------------------+                                          
| members           |                                          
| prices            |                                          
| transactions      |                                          
+-------------------+                                          
3 rows in set (0.10 sec)                                       
                                                               
mysql> describe members;                                       
+------------+-------------+------+-----+---------+-------+    
| Field      | Type        | Null | Key | Default | Extra |    
+------------+-------------+------+-----+---------+-------+    
| member_id  | varchar(6)  | YES  |     | NULL    |       |    
| first_name | varchar(7)  | YES  |     | NULL    |       |    
| region     | varchar(13) | YES  |     | NULL    |       |    
+------------+-------------+------+-----+---------+-------+    
3 rows in set (0.34 sec)                                       
                                                               
mysql> describe prices;                                        
+-------------+------------+------+-----+---------+-------+    
| Field       | Type       | Null | Key | Default | Extra |    
+-------------+------------+------+-----+---------+-------+    
| ticker      | varchar(3) | YES  |     | NULL    |       |    
| market_date | date       | YES  |     | NULL    |       |    
| price       | float      | YES  |     | NULL    |       |    
| open        | float      | YES  |     | NULL    |       |    
| high        | float      | YES  |     | NULL    |       |    
| low         | float      | YES  |     | NULL    |       |    
| volume      | varchar(7) | YES  |     | NULL    |       |    
| change      | varchar(7) | YES  |     | NULL    |       |    
+-------------+------------+------+-----+---------+-------+    
8 rows in set (0.06 sec)                                       
                                                               
mysql> describe transactions;                                  
+----------------+------------+------+-----+---------+-------+ 
| Field          | Type       | Null | Key | Default | Extra | 
+----------------+------------+------+-----+---------+-------+ 
| txn_id         | int        | YES  |     | NULL    |       | 
| member_id      | varchar(6) | YES  |     | NULL    |       | 
| ticker         | varchar(3) | YES  |     | NULL    |       | 
| txn_time       | timestamp  | YES  |     | NULL    |       | 
| txn_type       | varchar(4) | YES  |     | NULL    |       | 
| quantity       | float      | YES  |     | NULL    |       | 
| percentage_fee | float      | YES  |     | NULL    |       | 
+----------------+------------+------+-----+---------+-------+ 
7 rows in set (0.00 sec)                                       
                                                               
mysql>                                                         
                                                               
```


**Q.> My transactions table is missing the txn_date column, I am using the schema provided**

https://www.studytonight.com/post/update-a-column-with-a-substring-from-another-column-in-mysql

For MySQL, you can execute the following statements to get the job done.

1. Create a new column `txn_date` of type DATE.
```sql
ALTER TABLE transactions
ADD COLUMN txn_date DATE AFTER ticker;
```
2. Copy over the date part of `txn_time` to `txn_date`
```sql
UPDATE transactions txn_date
SET txn_date = date(txn_time);
```

3. Check if the transaction is done.

```sql
mysql> describe transactions;                                 
+----------------+------------+------+-----+---------+-------+
| Field          | Type       | Null | Key | Default | Extra |
+----------------+------------+------+-----+---------+-------+
| txn_id         | int        | YES  |     | NULL    |       |
| member_id      | varchar(6) | YES  |     | NULL    |       |
| ticker         | varchar(3) | YES  |     | NULL    |       |
| txn_date       | date       | YES  |     | NULL    |       |
| txn_time       | timestamp  | YES  |     | NULL    |       |
| txn_type       | varchar(4) | YES  |     | NULL    |       |
| quantity       | float      | YES  |     | NULL    |       |
| percentage_fee | float      | YES  |     | NULL    |       |
+----------------+------------+------+-----+---------+-------+
8 rows in set (0.00 sec)                                      
                                                              
mysql> select txn_id from transactions where txn_date is null;
Empty set (0.03 sec)                                          

mysql> select txn_id,txn_date,txn_time from transactions limit 20;
+--------+------------+---------------------+                     
| txn_id | txn_date   | txn_time            |                     
+--------+------------+---------------------+                     
|      1 | 2017-01-01 | 2017-01-01 06:22:20 |                     
|      2 | 2017-01-01 | 2017-01-01 06:40:49 |                     
|      3 | 2017-01-01 | 2017-01-01 07:13:52 |                     
|      4 | 2017-01-01 | 2017-01-01 10:04:32 |                     
|      5 | 2017-01-01 | 2017-01-01 11:00:14 |                     
|      6 | 2017-01-01 | 2017-01-01 12:03:33 |                     
|      7 | 2017-01-01 | 2017-01-01 13:23:06 |                     
|      8 | 2017-01-01 | 2017-01-01 16:15:42 |                     
|      9 | 2017-01-01 | 2017-01-01 16:23:17 |                     
|     10 | 2017-01-01 | 2017-01-01 17:39:11 |                     
|     11 | 2017-01-01 | 2017-01-01 22:08:30 |                     
|     12 | 2017-01-01 | 2017-01-01 22:19:47 |                     
|     13 | 2017-01-01 | 2017-01-01 22:44:57 |                     
|     14 | 2017-01-02 | 2017-01-02 00:36:35 |                     
|     15 | 2017-01-02 | 2017-01-02 01:32:37 |                     
|     16 | 2017-01-02 | 2017-01-02 04:48:50 |                     
|     17 | 2017-01-02 | 2017-01-02 05:47:53 |                     
|     18 | 2017-01-02 | 2017-01-02 08:23:56 |                     
|     19 | 2017-01-02 | 2017-01-02 08:36:55 |                     
|     20 | 2017-01-02 | 2017-01-02 09:55:27 |                     
+--------+------------+---------------------+                     
20 rows in set (0.00 sec)                                         
```
## Our Crypto Case Study

### Step 1: Database Introduction

For this SQL Simplified course we focus on our Cryptocurrency Trading SQL Case Study!

In our fictitious (but realistic) case study - my team of trusted data mentors from the Data With Danny team have been dabbling in the crypto markets since 2017.

fw:1 Who are the members of the cryptocurrency trading group?

```
mysql> select * from members;
+-----------+------------+---------------+
| member_id | first_name | region        |
+-----------+------------+---------------+
| c4ca42    | Danny      | Australia     |
| c81e72    | Vipul      | United States |
| eccbc8    | Charlie    | United States |
| a87ff6    | Nandita    | United States |
| e4da3b    | Rowan      | United States |
| 167909    | Ayush      | United States |
| 8f14e4    | Alex       | United States |
| c9f0f8    | Abe        | United States |
| 45c48c    | Ben        | Australia     |
| d3d944    | Enoch      | Africa        |
| 6512bd    | Vikram     | India         |
| c20ad4    | Leah       | Asia          |
| c51ce4    | Pavan      | Australia     |
| aab323    | Sonia      | Australia     |
+-----------+------------+---------------+
14 rows in set (0.09 sec)
```

fw: There are 14 members in DWD team.


fw:2 how many transactions has each member done?


1st try gave error:
-------------------

```
mysql> select t.member_id,m.first_name, count(t.member_id) from transactions as t join members as m on t.member_i
d=m.member_id group by m.member_id;                                                                              
ERROR 1055 (42000): Expression #2 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'tra
ding.m.first_name' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with s
ql_mode=only_full_group_by    
```

2nd attempt:
------------

fw: Need to figure out grouping across joins!

```
mysql> select t.member_id,m.first_name, count(t.member_id) as no_of_txn from transactions as t join members as m on t.member_id=m.member_id group by t.member_id,m.first_name order by no_of_txn desc;                           
+-----------+------------+-----------+
| member_id | first_name | no_of_txn |
+-----------+------------+-----------+
| c4ca42    | Danny      |      2159 |
| c51ce4    | Pavan      |      1965 |
| c9f0f8    | Abe        |      1847 |
| 8f14e4    | Alex       |      1648 |
| 45c48c    | Ben        |      1575 |
| d3d944    | Enoch      |      1526 |
| c81e72    | Vipul      |      1271 |
| 167909    | Ayush      |      1264 |
| c20ad4    | Leah       |      1239 |
| eccbc8    | Charlie    |      1095 |
| aab323    | Sonia      |      1082 |
| e4da3b    | Rowan      |      1001 |
| a87ff6    | Nandita    |       801 |
| 6512bd    | Vikram     |       772 |
+-----------+------------+-----------+                                                                 
14 rows in set (0.08 sec)                                                                                       
```

Our main purpose for this case study is to analyse the performance of the DWD mentors over time.

### Step 2 - Exploring The Members Data

**Q**
**A**



**Q01** Show only the top 5 rows from the `trading.members` table

**A01**

```
mysql> select * from trading.members limit 5;
+-----------+------------+---------------+   
| member_id | first_name | region        |   
+-----------+------------+---------------+   
| c4ca42    | Danny      | Australia     |   
| c81e72    | Vipul      | United States |   
| eccbc8    | Charlie    | United States |   
| a87ff6    | Nandita    | United States |   
| e4da3b    | Rowan      | United States |   
+-----------+------------+---------------+   
5 rows in set (0.38 sec)                     
```

**Q02** Sort all the rows in the table by `first_name` in alphabetical order and show the top 3 rows

**A02**

```
mysql> select * from trading.members order by first_name asc limit 3;
+-----------+------------+---------------+
| member_id | first_name | region        |
+-----------+------------+---------------+
| c9f0f8    | Abe        | United States |
| 8f14e4    | Alex       | United States |
| 167909    | Ayush      | United States |
+-----------+------------+---------------+
3 rows in set (0.00 sec)
```

**Q03** Which records from `trading.members` are from the United States region?

**A03** 

```
mysql> select * from trading.members where region = 'United States';
+-----------+------------+---------------+
| member_id | first_name | region        |
+-----------+------------+---------------+
| c81e72    | Vipul      | United States |
| eccbc8    | Charlie    | United States |
| a87ff6    | Nandita    | United States |
| e4da3b    | Rowan      | United States |
| 167909    | Ayush      | United States |
| 8f14e4    | Alex       | United States |
| c9f0f8    | Abe        | United States |
+-----------+------------+---------------+
7 rows in set (0.15 sec)
```


**Q04** Select only the member_id and first_name columns for members who are not from Australia

**A04**

```
mysql> select member_id,first_name from trading.members where region != 'Australia';
+-----------+------------+
| member_id | first_name |
+-----------+------------+
| c81e72    | Vipul      |
| eccbc8    | Charlie    |
| a87ff6    | Nandita    |
| e4da3b    | Rowan      |
| 167909    | Ayush      |
| 8f14e4    | Alex       |
| c9f0f8    | Abe        |
| d3d944    | Enoch      |
| 6512bd    | Vikram     |
| c20ad4    | Leah       |
+-----------+------------+
10 rows in set (0.01 sec)
```

**Q05** Return the unique `region` values from the `trading.members` table and sort the output by reverse alphabetical order

**A05**

```
mysql> select distinct region from trading.members order by region desc;
+---------------+
| region        |
+---------------+
| United States |
| India         |
| Australia     |
| Asia          |
| Africa        |
+---------------+
5 rows in set (0.16 sec)  
```


**Q06** How many mentors are there from Australia or the United States?

**A06** 


```
mysql> select count(member_id) from trading.members where region in ('Australia','United States');
+------------------+
| count(member_id) |
+------------------+
|               11 |
+------------------+
1 row in set (0.04 sec)
```

**Q07** How many mentors are not from Australia or the United States?

**A07**

```
mysql> select count(member_id) from trading.members where region not in ('Australia','United States'); 
+------------------+                                                                                   
| count(member_id)          
+------------------+                                                                                   
|                3          
+------------------+                                                                                   
1 row in set (0.00 sec)                                                                                
```

**Q08** How many mentors are there per region? Sort the output by regions with the most mentors to the least

**A08**

```
mysql> select region, count(member_id) as mentor_count from trading.members group by region order by mentor_count desc;

+---------------+--------------+                                                                       
| region        | mentor_count       
+---------------+--------------+                                                                       
| United States |            7       
| Australia     |            4       
| Africa        |            1       
| India         |            1       
| Asia          |            1       
+---------------+--------------+                                                                       
5 rows in set (0.00 sec)                                                                                        


```


**Q09** How many US mentors and non US mentors are there?

**A09**

fw: my attempt after tryingn to understand the CASE keyword.

Here error as `count(mentor_region)` is improper as the proper counting field name is `region` and `mentor_region` is just an alias.
```
mysql> select case when region != 'United States' then 'non-US' else region end as mentor_region,count(mentor_region) as mentor_count from members group by mentor_region;
ERROR 1054 (42S22): Unknown column 'mentor_region' in 'field list'
```

Here the error is that we have used an aggregate function `count()` but we have not used an aggregate operator like `GROUP BY`.


```
mysql> select case when region <> 'United States' then 'nonUSA' else region end as mr,count(r
egion) as mc from members;                                                                   
ERROR 1140 (42000): In aggregated query without GROUP BY, expression #1 of SELECT list contai
ns nonaggregated column 'trading.members.region'; this is incompatible with sql_mode=only_ful
l_group_by     
```

Here we have grouped by `region` and not by the new clustered region defined by `CASE` clause i.e. `mr`. So we get a grouping by the underlying field i.e. `region` and not by the new filtered field `mr`.

```                                                                              
mysql> select case when region <> 'United States' then 'nonUSA' else region end as mr,count(r
egion) as mc from members group by region;                                                   
+---------------+----+                                                                       
| mr            | mc |                                                                       
+---------------+----+                                                                       
| nonUSA        |  4 |                                                                       
| United States |  7 |                                                                       
| nonUSA        |  1 |                                                                       
| nonUSA        |  1 |                                                                       
| nonUSA        |  1 |                                                                       
+---------------+----+                                                                       
5 rows in set (0.00 sec)                                                                     
```

Now is the proper result. Here we have properly grouped by the filtered `CASE` result & 

```
mysql> select case when region != 'United States' then 'non-US' else region end as mentor_region,count(region) as mentor_count from members group by mentor_region;
+---------------+--------------+
| mentor_region | mentor_count |
+---------------+--------------+
| non-US        |            7 |
| United States |            7 |
+---------------+--------------+
2 rows in set (0.10 sec)

mysql>

```
**Official Answer**
```
SELECT
  CASE
    WHEN region != 'United States' THEN 'Non US'
    ELSE region
  END AS mentor_region,
  COUNT(*) AS mentor_count
FROM trading.members
GROUP BY mentor_region
ORDER BY mentor_count DESC;

```

**Q10** How many mentors have a first name starting with a letter before 'E'

**A10**
```
mysql> select count(first_name) from trading.members where first_name < 'E';
+-------------------+
| count(first_name) |
+-------------------+
|                 6 |
+-------------------+
1 row in set (0.00 sec)
```

Official Answer:

```
SELECT COUNT(*) AS mentor_count
FROM trading.members
WHERE LEFT(first_name, 1) < 'E';
```

**Q**

**A**


**Appendix**

* In practice, use `SELECT *` sparingly!

* `LIMIT` is implemented as `TOP` in some database flavours.

* In BigQuery using `LIMIT` on a large database will not avoid high bill as BQ scans the total number of rows first and then limits the data with `LIMIT`!

* Best practice is to always apply WHERE filters on specific partitions to narrow down the amount of data that must be scanned - reducing your query costs and speeding up your query execution!

* `!=` or `<>` for "not equals" You might have noticed in questions 4 and 9 there are two different methods for showing "not equals" You can use both `!=` or `<>` in WHERE filters to exclude records.

### Step 3 - Daily Prices

Our next dataset to explore will be the `trading.prices` table which contains the daily price and volume data for the 2 cryptocurrency tickers: `ETH` and `BTC` (Ethereum and Bitcoin!)

```
mysql> SELECT * FROM trading.prices WHERE ticker = 'BTC' LIMIT 5;                  
+--------+-------------+---------+---------+---------+---------+--------+--------+ 
| ticker | market_date | price   | open    | high    | low     | volume | change | 
+--------+-------------+---------+---------+---------+---------+--------+--------+ 
| BTC    | 2021-08-29  |   48255 | 48899.7 | 49621.7 | 48101.9 | 40.96K | -1.31% | 
| BTC    | 2021-08-28  | 48897.1 | 49062.8 | 49289.4 | 48428.5 | 36.73K | -0.34% | 
| BTC    | 2021-08-27  | 49064.3 | 46830.2 |   49142 | 46371.5 | 62.47K | 4.77%  | 
| BTC    | 2021-08-26  | 46831.6 | 48994.4 | 49347.8 | 46360.4 | 73.79K | -4.41% | 
| BTC    | 2021-08-25  | 48994.5 | 47707.4 | 49230.2 | 47163.3 | 63.54K | 2.68%  | 
+--------+-------------+---------+---------+---------+---------+--------+--------+ 
5 rows in set (0.13 sec)                                                           
                                                                                   
mysql> SELECT * FROM trading.prices WHERE ticker = 'ETH' LIMIT 5;                  
+--------+-------------+---------+---------+---------+---------+---------+--------+
| ticker | market_date | price   | open    | high    | low     | volume  | change |
+--------+-------------+---------+---------+---------+---------+---------+--------+
| ETH    | 2021-08-29  | 3177.84 | 3243.96 | 3282.21 | 3162.79 | 582.04K | -2.04% |
| ETH    | 2021-08-28  |  3243.9 | 3273.78 | 3284.58 | 3212.24 | 466.21K | -0.91% |
| ETH    | 2021-08-27  | 3273.58 | 3093.78 | 3279.93 | 3063.37 | 839.54K | 5.82%  |
| ETH    | 2021-08-26  | 3093.54 | 3228.03 | 3249.62 | 3057.48 | 118.44K | -4.17% |
| ETH    | 2021-08-25  | 3228.15 | 3172.12 | 3247.43 |  3080.7 | 923.13K | 1.73%  |
+--------+-------------+---------+---------+---------+---------+---------+--------+
5 rows in set (0.00 sec)                                                           
```

**Data Dictionary of `prices`**

Column Name | Description
----- | ---- | -----------
ticker | one of either BTC or ETH
market_date | the date for each record
price | closing price at end of day
open | the opening price
high | the highest price for that day
low | the lowest price for that day
volume | the total volume traded
change | % change price in price


**Q00** 

**A00**


**Q01** How many total records do we have in the `trading.prices` table?

**A01**

```
mysql> select count(ticker) from trading.prices;
+---------------+
| count(ticker) |
+---------------+
|          3404 |
+---------------+
1 row in set (0.00 sec)
```


**Q02** How many records are there per ticker value?

**A02**
```
mysql> select ticker, count(ticker) from trading.prices group by ticker; 
+--------+---------------+                                               
| ticker | count(ticker) |                                               
+--------+---------------+                                               
| ETH    |          1702 |                                               
| BTC    |          1702 |                                               
+--------+---------------+                                               
2 rows in set (0.01 sec)                                                 
```
**Q03** What is the minimum and maximum `market_date` values?

**A03**
```
mysql> select min(market_date),max(market_date) from trading.prices;
+------------------+------------------+
| min(market_date) | max(market_date) |
+------------------+------------------+
| 2017-01-01       | 2021-08-29       |
+------------------+------------------+
1 row in set (0.01 sec)
```

**Q04** Are there differences in the minimum and maximum market_date values for each ticker?

**A04**
```
mysql> select ticker,min(market_date),max(market_date) from trading.prices group by ticker;
+--------+------------------+------------------+
| ticker | min(market_date) | max(market_date) |
+--------+------------------+------------------+
| ETH    | 2017-01-01       | 2021-08-29       |
| BTC    | 2017-01-01       | 2021-08-29       |
+--------+------------------+------------------+
2 rows in set (0.01 sec)
```



**Q05** What is the average of the price column for Bitcoin records during the year 2020?

**A05**
```
mysql> select avg(price) from prices where year(market_date)=2020 and ticker='BTC';
+--------------------+
| avg(price)         |
+--------------------+
| 11111.631151543288 |
+--------------------+
1 row in set (0.01 sec)
```

pgsql Official Answer

```
SELECT
  AVG(price)
FROM trading.prices
WHERE ticker = 'BTC'
  AND market_date BETWEEN '2020-01-01' AND '2020-12-31';
```

**Q06** What is the monthly average of the price column for Ethereum in 2020? Sort the output in chronological order and also round the average price value to 2 decimal places

**A06**
```
mysql> select month(market_date),round(avg(price),2) as rp from prices where year(market_date)=2020 and ticker='ETH' group by year(market_date),month(market_date) order by month(market_date) asc;
+--------------------+--------+
| month(market_date) | rp     |
+--------------------+--------+
|                  1 | 156.65 |
|                  2 | 238.76 |
|                  3 | 160.18 |
|                  4 | 171.29 |
|                  5 | 207.45 |
|                  6 | 235.92 |
|                  7 | 259.57 |
|                  8 | 401.73 |
|                  9 | 367.77 |
|                 10 | 375.79 |
|                 11 | 486.73 |
|                 12 | 622.35 |
+--------------------+--------+
12 rows in set (0.01 sec)
```
Another variation, more proper answer, without adding the year to the group by.

```
mysql> select month(market_date),round(avg(price),2) as rp from prices where year(market_date)=2020 and ticker='ETH' group by month(market_date) order by month(market_date) asc;
+--------------------+--------+
| month(market_date) | rp     |
+--------------------+--------+
|                  1 | 156.65 |
|                  2 | 238.76 |
|                  3 | 160.18 |
|                  4 | 171.29 |
|                  5 | 207.45 |
|                  6 | 235.92 |
|                  7 | 259.57 |
|                  8 | 401.73 |
|                  9 | 367.77 |
|                 10 | 375.79 |
|                 11 | 486.73 |
|                 12 | 622.35 |
+--------------------+--------+
12 rows in set (0.01 sec)

```
pgsql Proper Answer

```
SELECT
  DATE_TRUNC('MON', market_date) AS month_start,
  -- need to cast approx. floats to exact numeric types for round!
  ROUND(AVG(price)::NUMERIC, 2) AS average_eth_price
FROM trading.prices
WHERE EXTRACT(YEAR FROM market_date) = 2020
  AND ticker = 'ETH'
GROUP BY month_start
ORDER BY month_start;
```



**Q07** Are there any duplicate `market_date` values for any ticker value in our table?

```
mysql> select ticker, count(distinct market_date), count(market_date) from prices group by ticker;
+--------+-----------------------------+--------------------+
| ticker | count(distinct market_date) | count(market_date) |
+--------+-----------------------------+--------------------+
| BTC    |                        1702 |               1702 |
| ETH    |                        1702 |               1702 |
+--------+-----------------------------+--------------------+
2 rows in set (0.01 sec)

```
**A07**

**Q08** How many days from the `trading.prices` table exist where the high price of Bitcoin is over $30,000?

**A08**
```
mysql> select count(market_date) from prices where ticker= 'BTC' and high > 30000;
+--------------------+
| count(market_date) |
+--------------------+
|                240 |
+--------------------+
1 row in set (0.00 sec)

```

**Q09** How many "breakout" days were there in 2020 where the `price` column is greater than the `open` column for each ticker?

**A09** 
Also misunderstood the question. Wrong answer.

```
mysql> select count(case when price > open then 1 else 0 end) from prices where year(market_date) = 2020;
+-------------------------------------------------+
| count(case when price > open then 1 else 0 end) |
+-------------------------------------------------+
|                                             732 |
+-------------------------------------------------+
1 row in set (0.00 sec)

```

Inside COUNT() the case statement should not end with `as <name>`.

```
mysql> select ticker, count(case when price > open then 1 else 0 end as po)  from prices where year(market_date)=2020 group by ticker;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'po)
from prices where year(market_date)=2020 group by ticker' at line 1
```
**There is a big difference between SUM and COUNT. 1 0 0 gives 3 for count & 1 for sum. 1 NULL NULL gives 1 for count & 1 for sum.**


```
mysql> select ticker, count(case when price > open then 1 else 0 end) from prices where year(market_date)=2020 group by ticker;
+--------+-------------------------------------------------+
| ticker | count(case when price > open then 1 else 0 end) |
+--------+-------------------------------------------------+
| ETH    |                                             366 |
| BTC    |                                             366 |
+--------+-------------------------------------------------+
2 rows in set (0.00 sec)

mysql> select ticker, count(case when price > open then 1 else NULL end) from prices where year(market_date)=2020 group by ticker;
+--------+----------------------------------------------------+
| ticker | count(case when price > open then 1 else NULL end) |
+--------+----------------------------------------------------+
| ETH    |                                                200 |
| BTC    |                                                207 |
+--------+----------------------------------------------------+
2 rows in set (0.00 sec)

mysql> select ticker, sum(case when price > open then 1 else 0 end) from prices where year(market_date)=2020 group by ticker;
+--------+-----------------------------------------------+
| ticker | sum(case when price > open then 1 else 0 end) |
+--------+-----------------------------------------------+
| ETH    |                                           200 |
| BTC    |                                           207 |
+--------+-----------------------------------------------+
2 rows in set (0.00 sec)
```

Official Answer:
```
SELECT
  ticker,
  SUM(CASE WHEN price > open THEN 1 ELSE 0 END) AS breakout_days
FROM trading.prices
WHERE DATE_TRUNC('YEAR', market_date) = '2020-01-01'
GROUP BY ticker;
```


**Q10** How many "non_breakout" days were there in 2020 where the `price` column is less than the `open` column for each ticker?

**A10**

Wrong Understanding of situations of count/sum 1/0

```
mysql> select count(case when price < open then 1 else 0 end) from prices where year(market_date) = 2020;
+-------------------------------------------------+
| count(case when price < open then 1 else 0 end) |
+-------------------------------------------------+
|                                             732 |
+-------------------------------------------------+
1 row in set (0.01 sec)

```

Correct answer

```
mysql> select ticker, sum(case when price < open then 1 else 0 end) from prices where year(market_date)=2020 group by ticker;
+--------+-----------------------------------------------+
| ticker | sum(case when price < open then 1 else 0 end) |
+--------+-----------------------------------------------+
| ETH    |                                           166 |
| BTC    |                                           159 |
+--------+-----------------------------------------------+
2 rows in set (0.00 sec)
```

Official Answer:
```
SELECT
  ticker,
  SUM(CASE WHEN price < open THEN 1 ELSE 0 END) AS non_breakout_days
FROM trading.prices
-- this another way to specify the year
WHERE market_date >= '2020-01-01' AND market_date <= '2020-12-31'
GROUP BY ticker;
```


**Q11** What percentage of days in 2020 were breakout days vs non-breakout days? Round the percentages to 2 decimal places

**A11**
```
mysql> select round(sum(case when price > open then 1 else 0 end)/count(market_date)*100,2) as bo, round(sum(case when price < open then 1 else 0 end)/count(market_date)*100,2) as nbo from prices where year(market_date)=2020;
+-------+-------+
| bo    | nbo   |
+-------+-------+
| 55.60 | 44.40 |
+-------+-------+
1 row in set (0.00 sec)

```

Separated values

```
mysql> select ticker,round(sum(case when price > open then 1 else 0 end)/count(market_date)*100,2) as bo, round(sum(case when price < open then 1 else 0 end)/count(market_date)*100,2) as nbo from prices where year(market_date)=2020 group by ticker;
+--------+-------+-------+
| ticker | bo    | nbo   |
+--------+-------+-------+
| ETH    | 54.64 | 45.36 |
| BTC    | 56.56 | 43.44 |
+--------+-------+-------+
2 rows in set (0.01 sec)
```

```
mysql> select ticker,round(sum(case when price > open then 1 else 0 end)/count(market_date),2) as bo, round(sum(case when price < open then 1 else 0 end)/count(market_date),2) as nbo from prices where year(market_date)=2020 group by ticker;
+--------+------+------+
| ticker | bo   | nbo  |
+--------+------+------+
| ETH    | 0.55 | 0.45 |
| BTC    | 0.57 | 0.43 |
+--------+------+------+
2 rows in set (0.00 sec)
```

Official Answer:

```
SELECT
  ticker,
  ROUND(
    SUM(CASE WHEN price > open THEN 1 ELSE 0 END)
      / COUNT(*)::NUMERIC,
    2
  ) AS breakout_percentage,
  ROUND(
    SUM(CASE WHEN price < open THEN 1 ELSE 0 END)
      / COUNT(*)::NUMERIC,
    2
  ) AS non_breakout_percentage
FROM trading.prices
WHERE market_date >= '2020-01-01' AND market_date <= '2020-12-31'
GROUP BY ticker;

```

**Q0**

**A0**


### Appendix

**Date Manipulations**

We use a variety of date manipulations in questions 5, 6, 9 and 11 to filter the trading.prices for 2020 values only.

These are all valid methods to qualify DATE or TIMESTAMP values within a range using a WHERE filter:
```
    market_date BETWEEN '2020-01-01' AND '2020-12-31'
    EXTRACT(YEAR FROM market_date) = 2020
    DATE_TRUNC('YEAR', market_date) = '2020-01-01'
    market_date >= '2020-01-01' AND market_date <= '2020-12-31'
```
The only additional thing to note is that DATE_TRUNC returns a TIMESTAMP data type which can be cast back to a regular DATE using the ::DATE notation when used in a SELECT query.

**BETWEEN Boundaries**

An additional note for question 5 - the boundaries for the BETWEEN clause must be earlier-date-first AND later-date-second

See what happens when you reverse the order of the DATE boundaries using the query below - does it match your expectation?
Click here to see the "wrong" code!


```
SELECT
  AVG(price)
FROM trading.prices
WHERE ticker = 'BTC'
  AND market_date BETWEEN '2020-12-31' AND '2020-01-01';
```

**Rounding Floats/Doubles**

In PostgreSQL - we cannot apply the ROUND function directly to approximate FLOAT or DOUBLE PRECISION data types.

Instead we will need to cast any outputs from functions such as AVG to an exact NUMERIC data type before we can use it with other approximation functions such as ROUND

In question 6 - if we were to remove our ::NUMERIC from our query - we would run into this error:

ERROR:  function round(double precision, integer) does not exist
LINE 3:   ROUND(AVG(price), 2) AS average_eth_price
          ^
HINT:  No function matches the given name and argument types. You might need to add explicit type casts.

You can try this yourself by running the below code snippet with the ::NUMERIC removed:
Click here to see the "wrong" code!

```
SELECT
  DATE_TRUNC('MON', market_date) AS month_start,
  ROUND(AVG(price), 2) AS average_eth_price
FROM trading.prices
WHERE EXTRACT(YEAR FROM market_date) = 2020
GROUP BY month_start
ORDER BY month_start;
```

**Integer Floor Division**

In question 5 - when dividing values in SQL it is very important to consider the data types of the numerator (the number on top) and the denominator (the number on the bottom)

When there is an INTEGER / INTEGER as there is in this case - SQL will default to FLOOR division in this case!

You can try running the same query as the solution to question 5 above - but this time remove the 2 instances of ::NUMERIC and the decimal place rounding to see what happens!

This is a super common error found in SQL queries and we usually recommend casting either the numerator or the denominator as a NUMERIC type using the shorthand ::NUMERIC syntax to ensure that you will avoid the dreaded integer floor division!
Click here to see the "wrong" code!

```
SELECT
  ticker,
  SUM(CASE WHEN price > open THEN 1 ELSE 0 END) / COUNT(*) AS breakout_percentage,
  SUM(CASE WHEN price < open THEN 1 ELSE 0 END) / COUNT(*) AS non_breakout_percentage
FROM trading.prices
WHERE market_date >= '2019-01-01' AND market_date <= '2019-12-31'
GROUP BY ticker;

```

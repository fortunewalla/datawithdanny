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

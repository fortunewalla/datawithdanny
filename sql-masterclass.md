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
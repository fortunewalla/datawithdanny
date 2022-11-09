### datawithdanny

Aim: To complete the the SQL MasterClass course from datawithdanny.com

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

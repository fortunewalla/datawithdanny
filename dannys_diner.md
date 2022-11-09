### Danny's Diner

*Q. How to use this document? A. Read through it line by line.*

**Setup:**

Quickstart: Install the database onto your local mysql installation. ( For more installation options, please refer to https://8weeksqlchallenge.com/case-study-1/ )

`mysql -u <username> -p < /path/to/dannys_diner-schema-and-data-mysql.sql`

or
```
mysql -u <username> -p

source /path/to/dannys_diner-schema-and-data-mysql.sql
```
The results of the import are:

```
Query OK, 0 rows affected (0.05 sec)

Query OK, 1 row affected (0.06 sec)

Query OK, 0 rows affected (0.44 sec)

Query OK, 15 rows affected (0.50 sec)
Records: 15  Duplicates: 0  Warnings: 0

Query OK, 0 rows affected (0.59 sec)

Query OK, 3 rows affected (0.14 sec)
Records: 3  Duplicates: 0  Warnings: 0

Query OK, 0 rows affected (0.17 sec)

Query OK, 2 rows affected (0.10 sec)
Records: 2  Duplicates: 0  Warnings: 0
```

**The structure of the database:**

```
mysql> select database();
+--------------+
| database()   |
+--------------+
| dannys_diner |
+--------------+
1 row in set (0.00 sec)

mysql> show tables;
+------------------------+
| Tables_in_dannys_diner |
+------------------------+
| members                |
| menu                   |
| sales                  |
+------------------------+
3 rows in set (0.00 sec)

mysql> describe members;
+-------------+------------+------+-----+---------+-------+
| Field       | Type       | Null | Key | Default | Extra |
+-------------+------------+------+-----+---------+-------+
| customer_id | varchar(1) | YES  |     | NULL    |       |
| join_date   | date       | YES  |     | NULL    |       |
+-------------+------------+------+-----+---------+-------+
2 rows in set (0.00 sec)

mysql> describe menu;
+--------------+------------+------+-----+---------+-------+
| Field        | Type       | Null | Key | Default | Extra |
+--------------+------------+------+-----+---------+-------+
| product_id   | int        | YES  |     | NULL    |       |
| product_name | varchar(5) | YES  |     | NULL    |       |
| price        | int        | YES  |     | NULL    |       |
+--------------+------------+------+-----+---------+-------+
3 rows in set (0.00 sec)

mysql> describe sales;
+-------------+------------+------+-----+---------+-------+
| Field       | Type       | Null | Key | Default | Extra |
+-------------+------------+------+-----+---------+-------+
| customer_id | varchar(1) | YES  |     | NULL    |       |
| order_date  | date       | YES  |     | NULL    |       |
| product_id  | int        | YES  |     | NULL    |       |
+-------------+------------+------+-----+---------+-------+
3 rows in set (0.00 sec)

```

**Database Explanation**

Danny's Diner is a little restaurant that sells 3 foods: sushi, curry and ramen. They have captured some data from their few months of operation.

Problem Statement

They want answers about customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. This will help deliver a better and more personalised experience for loyal customers.

They plan on using these insights to decide whether they should expand the existing customer loyalty program. Additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

Only a sample of overall customer data is provided due to privacy issues. 

1. The `sales` table captures all `customer_id` level purchases with an corresponding `order_date` and `product_id` information for when and what menu items were ordered.

2. The `menu` table maps the `product_id` to the actual `product_name` and `price` of each menu item.

3. The `members` table captures the `join_date` when a `customer_id` joined the beta version of the Danny’s Diner loyalty program.


**The Entity Relation Diagram:**

( https://dbdiagram.io/embed/608d07e4b29a09603d12edbd ):

<img src="dannys_diner-erd.jpg"></img>

**Case Study Questions**

1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

```sql
-- Example Query:
SELECT
  	product_id,
    product_name,
    price
FROM dannys_diner.menu
ORDER BY price DESC
LIMIT 5;
```

**(Bonus Questions) Creating datasets:**

Join All The Things:

Recreate the following table output using the available data:
```
customer_id 	order_date 	product_name 	price 	member
A 	2021-01-01 	curry 	15 	N
A 	2021-01-01 	sushi 	10 	N
A 	2021-01-07 	curry 	15 	Y
A 	2021-01-10 	ramen 	12 	Y
A 	2021-01-11 	ramen 	12 	Y
A 	2021-01-11 	ramen 	12 	Y
B 	2021-01-01 	curry 	15 	N
B 	2021-01-02 	curry 	15 	N
B 	2021-01-04 	sushi 	10 	N
B 	2021-01-11 	sushi 	10 	Y
B 	2021-01-16 	ramen 	12 	Y
B 	2021-02-01 	ramen 	12 	Y
C 	2021-01-01 	ramen 	12 	N
C 	2021-01-01 	ramen 	12 	N
C 	2021-01-07 	ramen 	12 	N
```

Rank All The Things:

They also require information about the ranking of customer products, but not the ranking for non-member purchases so they expects null ranking values for the records when customers are not yet part of the loyalty program.

```
customer_id 	order_date 	product_name 	price 	member 	ranking
A 	2021-01-01 	curry 	15 	N 	null
A 	2021-01-01 	sushi 	10 	N 	null
A 	2021-01-07 	curry 	15 	Y 	1
A 	2021-01-10 	ramen 	12 	Y 	2
A 	2021-01-11 	ramen 	12 	Y 	3
A 	2021-01-11 	ramen 	12 	Y 	3
B 	2021-01-01 	curry 	15 	N 	null
B 	2021-01-02 	curry 	15 	N 	null
B 	2021-01-04 	sushi 	10 	N 	null
B 	2021-01-11 	sushi 	10 	Y 	1
B 	2021-01-16 	ramen 	12 	Y 	2
B 	2021-02-01 	ramen 	12 	Y 	3
C 	2021-01-01 	ramen 	12 	N 	null
C 	2021-01-01 	ramen 	12 	N 	null
C 	2021-01-07 	ramen 	12 	N 	null
```

SQL topics relevant to the Danny’s Diner case study: Common Table Expressions, Group By Aggregates, Window Functions for ranking, Table Joins
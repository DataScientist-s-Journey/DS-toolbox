# -- sqlite
.tables
.header on
.timer on
.mode columns


# -- MySQL
show databases;
use sakila;
show tables;
describe customer;
show columns from customer;


# Queries

# show 3 columns from table customer where store_id = 2
select first_name, last_name, email from customer where store_id = 2;


select title, rental_rate
from film
where rental_rate = .99
;


# Take info from 2 tables
select c.customer_id, c.first_name, c.last_name, a.address 
from customer as c, address as a
where c.address_id = a.address_id 
limit 10;

# Take info from 3 tables
select a.address, ci.city, co.country
from address a, city ci, country co
where a.city_id=ci.city_id and ci.country_id=co.country_id and co.country = 'Paraguay';

# Take info from 4 tables
select f.title, k.name, l.name 
from film f, category k, language l, film_category fk 
where f.film_id=fk.film_id and fk.category_id=k.category_id and f.language_id=l.language_id 
limit 10;

# Take info from 4 tables and sord it
select f.title, k.name, l.name 
from film f, category k, language l, film_category fk 
where f.film_id=fk.film_id 
and fk.category_id=k.category_id 
and f.language_id=l.language_id 
order by 1 
limit 100;

# -- Group by
# -- Group by + Count Function
#How many time a movie has been rented (sakila db)
select f.title, count(r.rental_id)
from film f, rental r, inventory i
where r.inventory_id = i.inventory_id and i.film_id = f.film_id
group by 1
limit 10;

# -- Group by + Count Function + Order by
#How Many Times Each Movie Has Been Rented Out
select f.title, count(r.rental_id)
from film f, rental r, inventory i
where r.inventory_id = i.inventory_id and i.film_id=f.film_id
group by f.title
order by 2 desc
limit 10;

select f.title, count(r.rental_id) as "Rented Num", count(r.rental_id) * any_value(f.rental_rate) as Revenue
from film f, rental r, inventory i
where f.film_id = i.film_id and i.inventory_id = r.inventory_id
group by f.title
order by Revenue
limit 5;

select f.title, count(r.rental_id) as "Rented Num", count(r.rental_id) * any_value(f.rental_rate) as Revenue
from film f, rental r, inventory i
where f.film_id = i.film_id and i.inventory_id = r.inventory_id
group by f.title
order by Revenue desc, 1
limit 5;

#revenue per video titlLe
SELECT
f.title, count(r.rental_id) * any_value(f.rental_rate) as Revenue
FROM
film f, rental r, inventory i
WHERE
f.film_id=i.film_id
AND i.inventory_id=r.inventory_id
GROUP BY
1
;

SELECT f.title, count(r.rental_id) * any_value(f.rental_rate) as Revenue
FROM film f, rental r, inventory i
WHERE f.film_id=i.film_id AND i.inventory_id=r.inventory_id
GROUP BY 1
order by 2 desc
limit 5;

# SUM Function

# What customers has paid us the most money
select p.customer_id, sum(p.amount)
from payment p
group by 1
order by 2 desc
limit 5;


select c.email, sum(p.amount)
from payment p, customer c
where p.customer_id=c.customer_id
group by 1
order by 2 desc
limit 5;

# -- What store has historically brought the most revenue?
select sum(p.amount), s.store_id 
from payment p, staff s 
where p.staff_id = s.staff_id 
group by 2 
order by 1 desc 
limit 5;

select s.store_id, sum(p.amount) from payment p, staff s where p.staff_id = s.staff_id group by 1 order by 2 desc limit 5;

# -- How many rentals we have each month?
select left(r.rental_date, 7), count(*) from rental r group by 1 order by 1;

select concat(year(r.rental_date),"/",month(r.rental_date)) as Month, count(*) from rental r group by 1 order by 1;
select concat(year(r.rental_date),"/",month(r.rental_date)) as Month, count(r.rental_id) from rental r group by 1 order by 1;
select left(r.rental_date, 7), min(r.rental_date), max(r.rental_date) from rental r group by 1 limit 5;

select f.title, max(r.rental_date), min(r.rental_date)
from film f, inventory i, rental r 
where f.film_id=i.film_id and i.inventory_id=r.inventory_id
group by 1 order by 2 desc limit 5;

select p.customer_id, sum(p.amount) from payment p group by 1 order by 2 limit 5;

select r.customer_id, max(r.rental_date) from rental r group by 1 order by 2 desc, 1 limit 5;

select concat(c.first_name," ", c.last_name), max(r.rental_date) from rental r, customer c where c.customer_id = r.customer_id group by 1 order by 2 desc, 1 limit 5;

select concat(c.first_name," ", c.last_name) name, max(r.rental_date) "last date" from rental r, customer c group by 1 order by 2 desc, 1 limit 5;

select Left(p.payment_date, 7) month, sum(p.amount) Revenue from payment p group by 1 order by 1;

select concat(c.first_name," ", c.last_name) name, max(r.rental_date) "last date" 
from rental r, customer c where r.customer_id = c.customer_id and year(r.rental_date) < 2006 
group by 1 order by 2, 1 limit 5;


select concat(c.first_name," ", c.last_name) name, max(r.rental_date) "last date" 
from rental r, customer c where r.customer_id = c.customer_id and r.rental_date < '20050823'  
group by 1 order by 2, 1;

select concat(c.first_name," ", c.last_name) name, any_value(c.email), max(r.rental_date) "last date" 
from rental r, customer c where r.customer_id = c.customer_id and year(r.rental_date) < 2006 group by 1 order by 2, 1;

select left(r.rental_date) month, count(r.rental_id) rentals, count(r.customer_id) renters, count(r.rental_id)/count(r.customer_id) rentals_per_renter
from rental r group by 1 order by 1 limit 10;

# -- Count + Distinct
select left(r.rental_date, 7) month, count(r.rental_id) rentals, count(distinct r.customer_id) renters, count(r.rental_id)/count(distinct r.customer_id) rentals_per_renter
from rental r group by 1 order by 1 limit 10;

# -- The number of distinct films rented each month
select left(r.rental_date, 7) month, count(distinct i.film_id)
from rental r, inventory i where r.inventory_id=i.inventory_id
group by 1 order by 1 limit 5;

select left(r.rental_date, 7) month, count(distinct i.film_id), count(i.film_id)/count(distinct i.film_id)
from rental r, inventory i where r.inventory_id=i.inventory_id
group by 1 order by 1 limit 5;

# -- in() Function
# -- Rented Movies per Category
select k.name, count(r.rental_id) from category k, inventory i, film_category fk, rental r
where k.category_id=fk.category_id and r.inventory_id=i.inventory_id and fk.film_id=i.film_id group by 1;

select k.name category, count(r.rental_id) rented_samples_per_category, count(distinct i.film_id) movies_rented 
from category k, inventory i, film_category fk, rental r  
where k.category_id=fk.category_id and r.inventory_id=i.inventory_id and fk.film_id=i.film_id and k.name in("Comedy","Sports", "Family") 
group by 1;

SELECT
c.name as category, count(r.rental_id) as num_rentals
FROM
rental r, inventory i, film f, film_category fc, category c
WHERE
r.inventory_id=i.inventory_id
AND i.film_id=f.film_id
AND f.film_id=fc.film_id
AND fc.category_id=c.category_id
AND c.name in ("Comedy", "Sports", "Family")
GROUP BY 1;

# -- +----------+-------------+
# -- | category | num_rentals |
# -- +----------+-------------+
# -- | Comedy   |         941 |
# -- | Family   |        1096 |
# -- | Sports   |        1179 |
# -- +----------+-------------+
# -- 3 rows in set (0.01 sec)

SELECT c.name as category, count(r.rental_id) as num_rentals 
FROM rental r, inventory i, film f, film_category fc, category c 
WHERE r.inventory_id=i.inventory_id AND i.film_id=f.film_id AND f.film_id=fc.film_id AND fc.category_id=c.category_id 
AND c.name not in ("Comedy", "Sports", "Family") 
GROUP BY 1;

# -- comparison operators (<,>,=,<=,>=,!=,<>)

SELECT
c.name as category, count(r.rental_id) as num_rentals
FROM
rental r, inventory i, film f, film_category fc, category c
WHERE
r.inventory_id=i.inventory_id
AND i.film_id=f.film_id
AND f.film_id=fc.film_id
AND fc.category_id=c.category_id
AND c.name != "Comedy"
GROUP BY 1;

SELECT
c.name as category, count(r.rental_id) as num_rentals
FROM
rental r, inventory i, film f, film_category fc, category c
WHERE
r.inventory_id=i.inventory_id
AND i.film_id=f.film_id
AND f.film_id=fc.film_id
AND fc.category_id=c.category_id
AND c.name <> "Family"
GROUP BY 1;

# -- Having 
# -- Having is like where but is applied like a filter after obtain the output
# -- Other difference is that where don't allow you to use functions
select 
    r.customer_id, count(r.rental_id)
from 
    rental r
group by 1
having
    count(r.rental_id)<20
order by 2 limit 5;

select r.customer_id, concat(c.first_name," ", c.last_name), count(r.rental_id)
from rental r, customer c where c.customer_id=r.customer_id 
group by 1 having count(r.rental_id)<20 order by 3 limit 5;

# -- +-------------+---------------------------------------+--------------------+
# -- | customer_id | concat(c.first_name," ", c.last_name) | count(r.rental_id) |
# -- +-------------+---------------------------------------+--------------------+
# -- |         318 | BRIAN WYMAN                           |                 12 |
# -- |          61 | KATHERINE RIVERA                      |                 14 |
# -- |         110 | TIFFANY JORDAN                        |                 14 |
# -- |         281 | LEONA OBRIEN                          |                 14 |
# -- |         136 | ANITA MORALES                         |                 15 |
# -- +-------------+---------------------------------------+--------------------+
# -- 5 rows in set (0.02 sec)

# -- How much revenue has one single store made over PG-13 and R-Rated films?
# -- = > < >= <= <> !=
# -- select 
# -- PG-13 and R-Rated in film.rating Revenue Store_id
# -- MySQL
# -- https://dev.mysql.com/doc/refman/8.0/en/system-schema.html#system-schema-data-dictionary-tables
# -- SELECT COLUMN_NAME,TABLE_NAME AS 'TableName' FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME LIKE '%film%';
# -- Oracle
# -- select * from all_columns where column_name like '%nome%'

# -- select f.rating, sum(p.amount) from film f, payment p, inventory i, rental r
# -- where f.film_id = i.film_id and i.inventory_id = r.inventory_id and r.rental_id=p.rental_id
# -- group by f.rating limit 5;

# -- select f.rating, sum(p.amount), i.store_id from film f, payment p, inventory i, rental r
# -- where f.film_id = i.film_id and i.inventory_id = r.inventory_id and r.rental_id=p.rental_id
# -- group by f.rating, i.store_id order by i.store_id limit 10;

select f.rating, sum(p.amount), i.store_id from film f, payment p, inventory i, rental r
where f.film_id = i.film_id and i.inventory_id = r.inventory_id and r.rental_id=p.rental_id and f.rating in ("PG-13", "R")
group by f.rating, i.store_id order by i.store_id limit 10;

# -- +--------+---------------+----------+
# -- | rating | sum(p.amount) | store_id |
# -- +--------+---------------+----------+
# -- | PG-13  |       8091.51 |        1 |
# -- | R      |       6514.62 |        1 |
# -- | PG-13  |       7167.65 |        2 |
# -- | R      |       6755.57 |        2 |
# -- +--------+---------------+----------+
# -- 4 rows in set (0.04 sec)

# -- #revenue for store 1 where film is rated R or PG-13
# -- SELECT
# -- i. store_id as Store, f. rating as movie_rating, sum(p.
# -- amount) as store_revenue
# -- FROM
# -- film f, payment p, inventory i, rental
# -- WHERE I
# -- p. rental_id = r. rental_id
# -- AND r.invento ry_id = i.invento ry_id
# -- AND i.film_id = f. film_id
# -- AND i.Sto re_id = 1
# -- AND f. rating in( 'R', 'PG-13')
# -- GROUP BY 1, 2
# -- ORDER BY 3 desc

select f.rating, sum(p.amount), i.store_id from film f, payment p, inventory i, rental r where f.film_id = i.film_id and i.inventory_id = r.inventory_id and r.rental_id=p.rental_id and f.rating in ("PG-13", "R") and r.rental_date between '2005-06-08' and '2005-07-19' group by f.rating, i.store_id order by i.store_id limit 5;

+--------+---------------+----------+
| rating | sum(p.amount) | store_id |
+--------+---------------+----------+
| PG-13  |       2946.32 |        1 |
| R      |       2283.51 |        1 |
| PG-13  |       2547.74 |        2 |
| R      |       2467.96 |        2 |
+--------+---------------+----------+
4 rows in set (0.04 sec)

# -- select r.customer_id, count(distinct r.rental_id) from rental r group by 1 limit 5;

select rpc.customer_id, rpc.rentals, sum(p.amount) 
from 
(select r.customer_id, count(distinct r.rental_id) rentals from rental r group by 1) as rpc,
 payment p
where p.customer_id = rpc.customer_id group by 1 limit 5;

+-------------+---------+---------------+
| customer_id | rentals | sum(p.amount) |
+-------------+---------+---------------+
|           1 |      32 |        118.68 |
|           2 |      27 |        128.73 |
|           3 |      26 |        135.74 |
|           4 |      22 |         81.78 |
|           5 |      38 |        144.62 |
+-------------+---------+---------------+
5 rows in set (0.04 sec)

select rpc.customer_id, rpc.rentals, sum(p.amount) from (select r.customer_id, count(distinct r.rental_id) rentals from rental r group by 1) as
rpc, payment p where p.customer_id = rpc.customer_id and rpc.rentals>20 group by 1 limit 5;


select rpc.rentals, count(distinct rpc.customer_id), sum(p.amount) from (select r.customer_id, count(distinct r.rental_id) rentals from rental r group by 1) as rpc, payment p where p.customer_id = rpc.customer_id and rpc.rentals>20 group by 1 limit 5;

+---------+---------------------------------+---------------+
| rentals | count(distinct rpc.customer_id) | sum(p.amount) |
+---------+---------------------------------+---------------+
|      21 |                              28 |       2442.11 |
|      22 |                              35 |       3288.30 |
|      23 |                              45 |       4325.65 |
|      24 |                              36 |       3575.36 |
|      25 |                              50 |       5223.49 |
+---------+---------------------------------+---------------+
5 rows in set (0.02 sec)

select rpc.customer_id, rpc.rentals, sum(p.amount) from (select r.customer_id, count(distinct r.rental_id) rentals from rental r group by 1) as rpc, payment p where p.customer_id = rpc.customer_id and rpc.rentals>20 group by 1 order by 3 desc limit 5;
+-------------+---------+---------------+
| customer_id | rentals | sum(p.amount) |
+-------------+---------+---------------+
|         526 |      45 |        221.55 |
|         148 |      46 |        216.54 |
|         144 |      42 |        195.58 |
|         178 |      39 |        194.61 |
|         137 |      39 |        194.61 |
+-------------+---------+---------------+
5 rows in set (0.03 sec)

# -- Temporary Table
create temporary table rpc as
SELECT
r.customer_id,
count(distinct r.rental_id) as num_rentals
FROM
rental r
GROUP BY 1;

SELECT
sum(p.amount) as total_rev
FROM
rpc,
payment p
WHERE
rpc.customer_id=p.customer_id
AND rpc.num_rentals>20;

+-----------+
| total_rev |
+-----------+
|  63157.64 |
+-----------+
1 row in set (0.03 sec)

select c.customer_id, a.phone from customer c left join address a on c.address_id = a.address_id where c.active = 1 order by 2 desc limit 5;

select c.*, a.phone from customer c left join address a on c.address_id = a.address_id where c.active = 1 order by 2 desc limit 5;



create temporary table activeUsers as
select
    c.*,
    a.phone
from
    customer c
        join address a on c.address_id = a.address_id
where
    c.active = 1
group by 1;

select r.customer_id, count(distinct r.rental_id) rentals, max(r.rental_date) from rental r group by 1 having rentals >= 30 limit 5;


create temporary table rewardedUsers
select r.customer_id, count(distinct r.rental_id) rentals, max(r.rental_date) from rental r group by 1 having rentals >= 30;

select a.customer_id, a.email, a.first_name from activeUsers a inner join rewardedUsers r on a.customer_id = r.customer_id limit 5;

select a.customer_id, a.email, a.phone from activeUsers a right join rewardedUsers r on a.customer_id = r.customer_id limit 5;


select a.customer_id, a.email, a.phone, a.active from activeUsers a right join rewardedUsers r on a.customer_id = r.customer_id order by 3 desc limit 5;

select c.customer_id, c.email, ad.phone, c.active
from activeUsers a right join rewardedUsers r on a.customer_id = r.customer_id, customer c, address adwhere a.customer_id=c.customer_id order by 4 limit 5;


drop temporary table if exists activeUsers;
create temporary table activeUsers as
select
    c.*,
    a.phone
from
    customer c
        join address a on c.address_id = a.address_id
where
    c.active = 1
group by 1;


drop temporary table if exists rewardUsers;
create temporary table rewardUsers
select r.customer_id, count(distinct r.rental_id) rentals, max(r.rental_date) from rental r group by 1 having rentals >= 30;

# -- Brain
# -- reward users AND ACTIVE users using the J0IN function
select a.customer_id, a.email, a.first_name from activeUsers a inner join rewardedUsers r on a.customer_id = r.customer_id limit 5;

# -- All reward users information
select r.customer_id, c.email, a.phone, c.active
from customer c inner join rewardedUsers r on c.customer_id = r.customer_id left join activeUsers a on a.customer_id=c.customer_id order by 4 limit 5;

select r.customer_id, c.email, a.phone, c.active
       from customer c inner join rewardedUsers r on c.customer_id = r.customer_id left join activeUsers a on a.customer_id=c.customer_id order by 4 limit 5;
+-------------+----------------------------------+-------+--------+
| customer_id | email                            | phone | active |
+-------------+----------------------------------+-------+--------+
|         368 | HARRY.ARCE@sakilacustomer.org    | NULL  |      0 |
|         406 | NATHAN.RUNYON@sakilacustomer.org | NULL  |      0 |
|         241 | HEIDI.LARSON@sakilacustomer.org  | NULL  |      0 |
|         446 | THEODORE.CULP@sakilacustomer.org | NULL  |      0 |
|          64 | JUDITH.COX@sakilacustomer.org    | NULL  |      0 |
+-------------+----------------------------------+-------+--------+
5 rows in set (0.01 sec)

# -- Cohort Analysis
select
    p.customer_id,
    left(min(p.payment_date), 7) as cohort
from
    payment p
group by 1;


# -- Monthly Revenue by Cohort
select
    c.cohort,
    left(p.payment_date, 7) as month_of_revenue,
    sum(p.amount) as revenue_in_month
from
    (
        select
            p.customer_id,
            left(min(p.payment_date), 7) as cohort
        from
            payment p
        group by 1
    ) c
    join payment p
        on c.customer_id = p.customer_id
group by
    1, 2
order by
    1, 2;

# -- extract dates
select
    c.cohort,
    extract(year_month from p.payment_date) as month_of_revenue,
    sum(p.amount) as revenue_in_month
from
    (
        select
            p.customer_id,
            extract(year_month from min(p.payment_date)) as cohort
        from
            payment p
        group by 1
    ) c
    join payment p
        on c.customer_id = p.customer_id
group by
    1, 2
order by
    1, 2;

# -- substractiong dates period_date
select
    c.cohort,
    period_diff(extract(year_month from p.payment_date), c.cohort) as rel_month_of_revenue,
    sum(p.amount) as revenue_in_month
from
    (
        select
            p.customer_id,
            extract(year_month from min(p.payment_date)) as cohort
        from
            payment p
        group by 1
    ) c
    join payment p
        on c.customer_id = p.customer_id
group by
    1, 2
order by
    1, 2;




select

from

where

group by

order by

having

limit 
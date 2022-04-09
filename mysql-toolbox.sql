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

#How many time a movie has been rented (sakila db)
select f.title, count(r.rental_id)
from film f, rental r, inventory i
where r.inventory_id = i.inventory_id and i.film_id = f.film_id
group by 1
limit 10;

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

select left(r.rental_date, 7) month, count(r.rental_id) rentals, count(distinct r.customer_id) renters, count(r.rental_id)/count(distinct r.customer_id) rentals_per_renter
from rental r group by 1 order by 1 limit 10;

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
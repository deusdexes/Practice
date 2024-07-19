/*Задание 1. Напишите SQL-запрос, который выводит всю информацию о фильмах со специальным атрибутом (поле special_features) равным “Behind the Scenes”.*/

select 
*
from film f
where special_features = '{"Behind the Scenes"}';

/* Задание 2. Напишите ещё 2 варианта поиска фильмов с атрибутом “Behind the Scenes”, используя другие функции или операторы языка SQL для поиска значения в массиве.*/

select 
*
from film f
where 'Behind the Scenes' = any (special_features);   
/*Задание 3. Для каждого покупателя посчитайте, сколько он брал в аренду фильмов со специальным атрибутом “Behind the Scenes”.
Обязательное условие для выполнения задания: используйте запрос из задания 1, помещённый в CTE.*/

with customers_films as 
(
select distinct  
r.customer_id as IDпокупателя,
count(f.film_id) over (partition by r.customer_id ) as films_count
from film f 
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
where special_features = '{"Behind the Scenes"}'
order by r.customer_id
)
select 
*
from customers_films
;

/*Задание 4. Для каждого покупателя посчитайте, сколько он брал в аренду фильмов со специальным атрибутом “Behind the Scenes”.
Обязательное условие для выполнения задания: используйте запрос из задания 1, помещённый в подзапрос, который необходимо использовать для решения задания.*/

select distinct 
r.customer_id as IDпокупателя,
count(f.film_id) over (partition by r.customer_id ) as films_count
from film f 
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
where f.film_id in (select f2.film_id from film f2 where f2.special_features = '{"Behind the Scenes"}') 
order by r.customer_id;

/*Задание 5. Создайте материализованное представление с запросом из предыдущего задания и напишите запрос для обновления материализованного представления*/

create materialized view Specialview as 
select distinct 
r.customer_id as IDпокупателя,
count(f.film_id) over (partition by r.customer_id ) as films_count
from film f 
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
where f.film_id in (select f2.film_id from film f2 where f2.special_features = '{"Behind the Scenes"}') 
order by r.customer_id 

refresh materialized view Specialiew 

select
*
from Specialiew


/*Задание 6. С помощью explain analyze проведите анализ скорости выполнения запросов из предыдущих заданий и ответьте на вопросы:
с каким оператором или функцией языка SQL, используемыми при выполнении домашнего задания, поиск значения в массиве происходит быстрее;
какой вариант вычислений работает быстрее: с использованием CTE или с использованием подзапроса.*/
explain analyze --planning time ~ 0.3s execution time ~ 2.7s
with customers_films as 
(
select distinct  
r.customer_id as IDпокупателя,
count(f.film_id) over (partition by r.customer_id ) as films_count
from film f 
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
where special_features = '{"Behind the Scenes"}'
order by r.customer_id
)
select 
*
from customers_films
;
explain analyze -- planning time ~0.45s execution time ~2.8s
select distinct 
r.customer_id as IDпокупателя,
count(f.film_id) over (partition by r.customer_id ) as films_count
from film f 
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
where f.film_id in (select f2.film_id from film f2 where f2.special_features = '{"Behind the Scenes"}') 
order by r.customer_id;
create materialized view Specialiew as 
select distinct 
r.customer_id as IDпокупателя,
count(f.film_id) over (partition by r.customer_id ) as films_count
from film f 
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
where f.film_id in (select f2.film_id from film f2 where f2.special_features = '{"Behind the Scenes"}') 
order by r.customer_id 
refresh materialized view Specialiew 
explain analyze -- planning time ~0.07s execution time ~0.04s
select
*
from Specialiew

/*Задание 7. Используя оконную функцию, выведите для каждого сотрудника сведения о первой его продаже.*/

with rental_info as(
select distinct 
r.staff_id as IDПродавца,
first_value(rental_date) over (partition by r.staff_id order by r.rental_date) as first_rental
from rental r 
)
select 
*
from rental
inner join rental_info on rental_info.first_rental = rental.rental_date


/*Задание 8. Для каждого магазина определите и выведите одним SQL-запросом следующие аналитические показатели:
•	день, в который арендовали больше всего фильмов (в формате год-месяц-день);
•	количество фильмов, взятых в аренду в этот день;
•	день, в который продали фильмов на наименьшую сумму (в формате год-месяц-день);
•	сумму продажи в этот день.*/

with shops_ranking as (
select distinct
date(r.rental_date) as day_rental_date,
count (r.rental_id) over (partition by date(r.rental_date)) as day_film_count,
sum (p.amount) over (partition by date(r.rental_date)) as day_amount_sum
from store s 
inner join inventory i on i.store_id = s.store_id
inner join rental r on r.inventory_id = i.inventory_id
inner join payment p on p.rental_id = r.rental_id
), min_max as (
select
max(day_film_count) as max_rent,
min(day_amount_sum) as min_amount
from shops_ranking
)
select 
*
from shops_ranking sr
join min_max mm on mm.min_amount = sr.day_amount_sum or mm.max_rent = sr.day_film_count
order by day_rental_date


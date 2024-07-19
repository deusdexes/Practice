/*Задание 1. Выведите для каждого покупателя его адрес, город и страну проживания.*/
select first_name, last_name, address.address, city.city, country.country   from customer   
left join address  on address.address_id = customer.address_id 
left join city on city.city_id = address.city_id
left join country  on country.country_id = city.country_id;

/*Задание 2. С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.
•	Доработайте запрос и выведите только те магазины, у которых количество покупателей больше 300. Для решения 
используйте фильтрацию по сгруппированным строкам с функцией агрегации. 
•	Доработайте запрос, добавив в него информацию о городе магазина, фамилии и имени продавца, который работает в нём. */
select distinct store_id as магазин, count(store_id) as количество_покупателей  from customer c  
group by store_id
order by store_id;

select distinct store_id as магазин, count(store_id) as количество_покупателей  from customer c  
group by store_id
having count(store_id) > 300
order by store_id;

select distinct customer.store_id as магазин, count(customer.store_id) as количество_покупателей, 
staff.first_name as Имя_продавца,staff.last_name as Фамилия_продавца, city.city as Город  from customer   
left join store on store.store_id = customer.store_id 
left join staff   on store.store_id = staff.store_id 
left join address  on address.address_id = store.address_id 
left join city  ON city.city_id = address.city_id 
group by customer.store_id, staff.first_name, staff.last_name, city.city
having count(customer.store_id) > 300
order by customer.store_id;

/*Задание 3. Выведите топ-5 покупателей, которые взяли в аренду за всё время наибольшее количество фильмов.*/
select count(payment_id) as Количество_аренд, customer_id as Покупатель from payment p
group by customer_id 
order by count(payment_id) desc limit 5; 

/*Задание 4. Посчитайте для каждого покупателя 4 аналитических показателя:
•	количество взятых в аренду фильмов;
•	общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа);
•	минимальное значение платежа за аренду фильма;
•	максимальное значение платежа за аренду фильма.*/
select count(rental_id) as Количество_аренд, customer_id as Покупатель,
round(sum(amount)) as общ_стоим_платеж, max(amount) as макс_знач_платежа, min(amount) мин_знач_платежа 
from payment p 
group by customer_id 
order by count(rental_id);

/*Задание 5. Используя данные из таблицы городов, составьте одним запросом 
всевозможные пары городов так, чтобы в результате не было пар с одинаковыми
 названиями городов. Для решения необходимо использовать декартово произведение.*/
select c.city , c2.city from city c  left join city c2 on c.city != c2.city; 

/*Задание 6. Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date) и
дате возврата (поле return_date), вычислите для каждого покупателя среднее количество дней,
за которые он возвращает фильмы*/
select customer_id as Покупатель, round(avg(date(return_date)-date(rental_date)),2) as Средняя_разница_в_днях from rental r
group by customer_id
order by customer_id ;

/*Задание 7. Посчитайте для каждого фильма, сколько раз его брали в аренду,
а также общую стоимость аренды фильма за всё время*/
select f.title as Название_фильма, count(r.rental_id) as Сколько_раз_брали_в_аренду,sum(coalesce(p.amount,0)) 
as Общая_стоимость_аренды from rental r
left join inventory i on i.inventory_id = r.inventory_id
left join film f on f.film_id = i.film_id
left join payment p on p.rental_id = r.rental_id
group by f.film_id
order by f.film_id ; —Группируем по ID потому что могут быть разные фильмы с одним названием и их сгруппирует.

--Задание 8. Доработайте запрос из предыдущего задания и выведите с помощью него фильмы, которые ни разу не брали в аренду.
select f.title as Название_фильма, count(r.rental_id) as Сколько_раз_брали_в_аренду 
from rental r
right join inventory i on i.inventory_id = r.inventory_id
right join film f on f.film_id = i.film_id
group by f.film_id
having count(r.rental_id) = 0
order by f.film_id ;


select f.title as Название_фильма, count(r.rental_id) as Сколько_раз_брали_в_аренду
from film f
left join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
group by f.film_id
having count(r.rental_id) = 0
order by f.film_id;

/*Задание 9. Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку «Премия».
 Если количество продаж превышает 7 300, то значение в колонке будет «Да», иначе должно быть значение «Нет».*/

select  s.staff_id as продавец, count(p.payment_id), (case when count(p.payment_id) >7300 then 'да' else 'нет' end) as премия 
from payment p 
left join staff s on s.staff_id  = p.staff_id 
group by s.staff_id
order by s.staff_id;


 




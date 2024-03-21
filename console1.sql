-- 1. Покажите фамилию и имя клиентов из города Прага ?
SELECT LastName, FirstName
from customers
where City = 'Prague';

-- 2. Покажите фамилию и имя клиентов у которых имя начинается букву M ? Содержит символ "ch"?
SELECT LastName, FirstName
from customers
where FirstName like 'M%';

SELECT LastName, FirstName
from customers
where FirstName like '%ch%';

SELECT LastName, FirstName
from customers
where FirstName like 'M%ch%';

-- 3. Покажите название и размер музыкальных треков в Мегабайтах ?
SELECT Name, bytes / (1024 * 1024) as Megabytes
from tracks;

-- 4. Покажите фамилию и имя сотрудников кампании нанятых в 2002 году из города Калгари ?
SELECT LastName, FirstName
from employees
where date(HireDate, 'start of year') = date('2002-01-01') and City = 'Calgary';

-- 5. Покажите фамилию и имя сотрудников кампании нанятых в возрасте 40 лет и выше?
SELECT LastName, FirstName
from employees
where HireDate - BirthDate >= 40;

-- 6. Покажите покупателей-американцев без факса ?
SELECT *
from customers
where Country = 'USA' and Fax is null;

-- 7. Покажите канадские города в которые сделаны продажи в августе и сентябре месяце?
SELECT ShipCity
from sales
where ShipCountry = 'Canada' and (strftime('%m', SalesDate) = '08' or strftime('%m', SalesDate) = '09');

-- 8. Покажите почтовые адреса клиентов из домена gmail.com ?
SELECT Email
from customers
where Email like '%@gmail.com';

-- 9. Покажите сотрудников которые работают в кампании уже 18 лет и более ?
SELECT *
from employees
where date('now') - HireDate >= 18;

-- 10. Покажите в алфавитном порядке все должности в кампании ?
SELECT Title
from employees
ORDER BY Title;

-- 11. Покажите в алфавитном порядке Фамилию, Имя и год рождения покупателей ?
SELECT LastName, FirstName, strftime('%Y', date('now')) - Age as BirthYear
from customers
ORDER BY LastName, FirstName, BirthYear;

-- 12. Сколько секунд длится самая короткая песня ?
SELECT Milliseconds / (1000) as Seconds
from tracks
order by Seconds limit 1;

-- 13. Покажите название и длительность в секундах самой короткой песни ?
SELECT Name, Milliseconds / (1000) as Seconds
from tracks
order by Seconds limit 1;

-- 14. Покажите средний возраст клиента для каждой страны ?
SELECT Country, avg(Age)
from customers
group by Country;

-- 15. Покажите Фамилии работников нанятых в октябре?
SELECT LastName
from employees
where strftime('%m', HireDate) = '10';

-- 16. Покажите фамилию самого старого по стажу сотрудника в кампании ?
SELECT LastName
from employees
order by HireDate limit 1;
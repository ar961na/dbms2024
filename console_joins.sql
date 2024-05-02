-- 1. Посчитайте общую сумму продаж в США в 1 квартале 2012 года?
SELECT s.ShipCountry, SUM(si.UnitPrice * si.Quantity) AS TotalSum
FROM sales AS s
         JOIN sales_items AS si ON s.SalesId = si.SalesId
WHERE s.SalesDate >= DATE('2012-01-01')
  AND s.SalesDate < DATE('2012-04-01')
  AND s.ShipCountry = 'USA';

SELECT s.ShipCountry,
       SUM(IFNULL((SELECT SUM(si.UnitPrice * si.Quantity)
                   FROM sales_items AS si
                   WHERE si.SalesId = s.SalesId
                     AND s.SalesDate >= DATE('2012-01-01')
                     AND s.SalesDate < DATE('2012-04-01')), 0)) As TotalSum
FROM sales AS s
WHERE s.ShipCountry = 'USA';

-- 2. Покажите имена клиентов, которых нет среди работников.
SELECT DISTINCT c.FirstName
FROM customers AS c
WHERE c.FirstName NOT IN
      (SELECT e.FirstName
       FROM employees AS e)
ORDER BY c.FirstName;

SELECT DISTINCT c.FirstName
FROM customers AS c
         JOIN employees AS e on c.SupportRepId = e.EmployeeId
WHERE c.FirstName != e.FirstName
ORDER BY c.FirstName;

SELECT c.FirstName
FROM customers AS c
EXCEPT
SELECT e.FirstName
from employees AS e
ORDER BY FirstName;

-- 3. Теоретический вопрос. Вернут ли данные запросы одинаковый результат?
-- ДА, вернут одинаковый результат. Потому что в этих запросах нет разницы между ON и WHERE;

-- 4. Посчитайте количество треков в каждом альбоме. В результате должно быть: имя альбома и кол-во треков.
SELECT a.Title          AS TitleAlbum,
       COUNT(t.TrackId) AS TracksCount
FROM albums AS a
         JOIN tracks t ON a.AlbumId = t.AlbumId
GROUP BY TitleAlbum;

SELECT a.Title                       AS TitleAlbum,
       (SELECT COUNT(*)
        FROM tracks AS t
        WHERE t.AlbumId = a.AlbumID) AS TracksCount
FROM albums as a;

-- 5. Покажите фамилию и имя покупателей немцев сделавших заказы в 2009 году, товары которых были отгружены в город Берлин.
SELECT DISTINCT c.LastName, c.FirstName
FROM customers AS c
         JOIN sales s ON c.CustomerId = s.CustomerId
WHERE ShipCity = 'Berlin'
  AND c.Country = 'Germany'
  AND STRFTIME('%Y', SalesDate) = '2009';

-- 6. Покажите фамилии клиентов которые купили больше 30 музыкальных треков.
SELECT c.LastName, SUM(si.Quantity) AS SalesCount
FROM customers AS c
         JOIN sales AS s ON c.CustomerId = s.CustomerId
         JOIN sales_items AS si ON s.SalesId = si.SalesId
GROUP BY c.LastName
HAVING SalesCount > 30;

SELECT c.LastName,
       (SELECT sum(Quantity)
        FROM sales_items AS si
        WHERE si.SalesId in
              (SELECT SalesId
               FROM sales as s
               WHERE s.CustomerId = c.CustomerId)) AS SalesCount
FROM customers AS c
WHERE SalesCount > 30
ORDER BY c.CustomerId;

-- 7. В базе есть таблица музыкальных треков и жанров. Какова средняя стоимость музыкального трека в каждом жанре?
SELECT g.Name,
       (SELECT AVG(t.UnitPrice)
        FROM tracks AS t
        WHERE t.GenreId = g.GenreId) AS AvgPrice
FROM genres AS g
ORDER BY g.Name;

SELECT g.Name, AVG(t.UnitPrice)
FROM genres AS g
         JOIN tracks AS t ON g.GenreId = t.GenreId
GROUP BY g.Name
ORDER BY g.Name;

-- 8. В базе есть таблица музыкальных треков и жанров. Покажите жанры, у которых средняя стоимость одного трека больше 1-го.
SELECT g.Name
FROM genres AS g
         JOIN tracks AS t ON g.GenreId = t.GenreId
GROUP BY g.Name
HAVING AVG(t.UnitPrice) > 1;
create view v_cities as 
select distinct icao, city, country from of_airports
where icao !='\N'
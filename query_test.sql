with prep as
(
select replace(area, 'm²', '')::numeric as area, replace(replace(price,'€', ''),'.','')::numeric as price from bonn_test
where area not in ('Nordrhein-Westfalen/Bonn', '660 €')
),
calc as
(
select area, price, price/area as priceqm from prep
)
select avg(priceqm) from calc
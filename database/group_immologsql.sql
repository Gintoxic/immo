select qtype, region, importdate, count(*) from immolog
group by qtype, region, importdate
order by  qtype, region, importdate
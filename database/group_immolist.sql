select qtype, region, importdate, count(*) from immolist
group by qtype, region, importdate
order by  qtype, region, importdate
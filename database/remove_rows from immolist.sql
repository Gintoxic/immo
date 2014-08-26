delete from immolist where id in (select id  from (select  i.*, row_number() over (partition by id) as rn from immolist i) i where rn=2)


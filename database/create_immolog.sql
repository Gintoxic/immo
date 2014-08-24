create table immolog as 
(select distinct on (id, importdate) id, region, importdate from immolist)


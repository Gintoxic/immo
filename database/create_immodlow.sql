create table immodlow as 
select distinct on (id, importdate) id, cwid, privateoffer,title, address, district, city, zip, attribs, importdate, region  from immolist


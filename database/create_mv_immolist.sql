--create materialized view mv_immolist as
with prep1 as
(
select i.*,string_to_array(address, ',') as addr_arr ,
string_to_array(attribs,';') as attrib_arr
from immolist i
), 
prep2 as
(select p.*, substr(array_dims(addr_arr),4,1)::integer as addr_len  from prep1 p)

select p.*, trim(addr_arr[addr_len]) as a1, trim(addr_arr[addr_len-1]) as a2, trim(addr_arr[addr_len-2]) as a3
--replace(replace(attrib_arr[1], ' €', ''),'.','')::numeric as price
--replace(replace(attrib_arr[2], ' m²', ''),'.','')::numeric area,
--replace(replace(attrib_arr[3], ' Zi.', ''),',','.')::numeric rooms

from prep2 p
where attrib_arr[1]='25 m²'


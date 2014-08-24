with prep1 as
(
select id, address,string_to_array(address, ',') as addr_arr from immolist
), 
prep2 as
(select p.*, substr(array_dims(addr_arr),4,1)::integer as len from prep1 p)

select id,address, trim(addr_arr[len]) as a1, trim(addr_arr[len-1]) as a2, trim(addr_arr[len-2]) as a3 from prep2
limit 100

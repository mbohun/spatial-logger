begin;
update layers set scale = '0.01 degree (~1km)' where type = 'Environmental';
commit;

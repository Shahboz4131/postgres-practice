create or replace function fac(x int) returns int language plpgsql as $$
	declare 
		numb int := x;
		new int := 1;
	begin 
		 for counter in 1..numb loop
			new := counter * new;
		   end loop;
		   raise info '%', new;
		   return 1;
	end; 

$$;



create or replace function fakt(x int) returns int language plpgsql as $$
	declare 
		new int := 1;
	begin 
		 for counter in 1..x loop
			new := counter * new;
		   end loop;
		   raise info '%', new;
		   return 1;
	end; 

$$;




select
	m.name,
	array_agg(distinct u.name) as user,	
	count(c.movie_id) as comments,
	array_agg(c.content)
from
	comments as c
join
	movies as m on m.movie_id = c.movie_id
join 
	users as u on u.user_id = c.user_id
group by
	m.name
;		

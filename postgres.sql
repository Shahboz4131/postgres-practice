do 
$$

	declare 
		i int := 0;

	begin

		loop 
		if i = 10 then 
			exit;
			end if;
		raise info 'a';
		i := i + 1;
		end loop;

	end;

$$;



create or replace function name(in x int) returns varchar language plpgsql as	
$$
	declare
		movie movies%rowtype;

	begin

		select 
			*
		from 
			movies
		into 
			movie
		where 
			movie_id = x;

		if found then 
			return movie.name;
		else 
			return (select name from movies where movie_id = (select max(movie_id) from movies));

		end if; 

		raise info '%', movie.name;
		
		
	end;

$$;
		


do 
$$
	declare 
		q text := 'select * from';
		t text := 'movies';
		r record;

	begin

	for r in execute q || ' ' || t loop

		raise info '%', r.name;

	end loop;

	end;
$$;


create or replace function get_middle(name varchar) language plpgsql as

$$
	
	declare 
		q text := 'select * from';
		r record;

		begin
		
		return (execute q || name into r);

		end;
$$;





select *
from generate_series(1, 10);


select extract(year from table1.year)
from generate_series(
	'1994-01-13 00:00'::timestamp,
	'2021-01-13 00:00'::timestamp,
	'1 year'
	) as table1(year);





insert into users(user_id, name)
select t.n, 'User' || t.n
from generate_series(4, 100000) as t(n)
;





select get_users(100, 'even'); -- odd

-- Abdulloh 1
-- Said 3
-- Ali 5
-- Vali 6
-- Sher 7




create or replace function get_users(x int, y varchar) returns void language plpgsql as 	
$$
	declare 
		r record;
		i int := 0;
		n int;
	begin
		x = x * 2;
		for r in (select * from users) loop
			exit when i = x;
			i = i + 1;	
			n := i % 2;
				if y = 'even' and n = 0 then
					raise info '%', r.name;	
				end if;
				if y = 'odd' and n = 1 then 
						raise info '%', r.name;	
				end if; 
		end loop; 
	end;
$$;
			




create or replace function get_middle(in x varchar) returns void language plpgsql as
$$
	declare 
		q text := 'select * from';
		r record;
		y record;
		n int := 0;
		i int := 0;
		j int :=;
		d int;

	begin
	for r in execute q || ' ' || x loop
		i = i + 1;
		n := i % 2;
		d := i / 2;
	end loop;
	for y in execute q || ' ' || x loop
		j := j + 1;
		if n = 0 and j = d then
			raise info '%', y.name;
		end if;

		if n = 1 and j = d + 1 then
			raise info '%', y.name;
		end if; 
 	end loop;
	end;
$$;
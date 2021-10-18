
create table users (
	user_id serial not null primary key,
	username varchar(24) not null,
	firstname varchar(24) not null,
	lastname  varchar(24) not null,
	password varchar(128) not null 
);


create or replace  function users_trigger_pass() returns trigger language plpgsql as
$$
	begin 
			select * from users where new.username = username and new.firstname = firstname and new.lastname = lastname;

			if not found then
				return new;
			else
				update users set password = crypt(new.password, gen_salt('bf')) where user_id = new.user_id;
				return null;
			end if;

	end;
$$
;

create trigger users_trigge_password
before insert on users 
for each row execute procedure users_trigger_pass();

create trigger users_trigge_password
after insert on users 
for each row execute procedure users_trigger_pass();

insert into users(username, firstname, lastname, password) values('Javlon1', 'Shahboz', 'Jo''rabekov', 'vva');	

insert into orders(table_id) values (5);
insert into order_details(quantity, order_id, product_id) values (2, 1, 6);


select 
   p.name,
   sum(od.quantity) as all,
   count(od.product_id) as tables
from order_details as od 
join products as p on od.product_id = p.product_id
group by p.name
;


select 
   p.name,
   sum(od.quantity) as quantity,
   (select p.name from products as p join type_register as tr on tr.type_register_id = p.type_register_id where tr.type_register_id = 6 limit 1) as ichimlik,
   (select sum(od.quantity) from products as p join order_details as od on od.product_id = p.product_id join type_register as tr on tr.type_register_id = p.type_register_id where tr.type_register_id = 6 limit 1) as i_quantity
from order_details as od 
join orders as o on o.order_id = od.order_id
join products as p on od.product_id = p.product_id
group by od.product_id, p.name
order by od.product_id asc
limit 1
;


select 
    (select To_Char("created_at", 'Day')) as day,
    count(o.order_id) as quantity 

from orders as o
group by (select To_Char("created_at", 'Day'))
order by count(o.order_id) desc
limit 1
;


select 
    (select To_Char("created_at", 'Day')) as day,
    count(o.order_id) as orders,
    sum(od.quantity) as quantity
from orders as o
join order_details as od on od.order_id = o.order_id
group by (select To_Char("created_at", 'Day')) 
order by count(o.order_id) desc
;


select
	(select sum((select closed_at::timestamp) - (select created_at::timestamp))/count(order_id))
from orders;




create or replace function stake(x int) returns void language plpgsql as 
$$
	declare 
		cost_food int;
		food_name varchar;
		cost_water int;
		water_name varchar;
		amount int;
	begin 

		for  cost_food  in (select
					p.price 
				from products as p
				join type_register as tr on tr.type_register_id = p.type_register_id
				where (tr.type_register_id = 1) or (tr.type_register_id = 2) or (tr.type_register_id = 4)
				order by p.price desc
				;
		) loop

		if (x::int - cost_food) > 0 then 
		amount := x::int - cost_food;
	 	raise info 'Ovqat % narx %', food_name, cost_food; 
		end if; 

		end loop;

		select
			p.name into food_name
		from products as p
		join type_register as tr on tr.type_register_id = p.type_register_id
		where (tr.type_register_id = 1) or (tr.type_register_id = 2) or (tr.type_register_id = 4)
		order by p.price desc
		limit 1;
		
			

		select
			p.price into cost_water
		from products as p
		join type_register as tr on tr.type_register_id = p.type_register_id
		where (tr.type_register_id = 11) or (tr.type_register_id = 12) 
		order by p.price desc
		limit 1;

		select
			p.name into water_name 
		from products as p
		join type_register as tr on tr.type_register_id = p.type_register_id
		where (tr.type_register_id = 11) or (tr.type_register_id = 12) 
		order by p.price desc
		limit 1;
		if (amount - cost_water) > 0 then
			amount := amount - cost_water;
	 		raise info 'ichimlik % narx %', water_name, cost_water; 
	 		end if;
	end;
$$;


do
$$
declare
    f record;
begin
    for f in select title, length 
	       from film 
	       order by length desc, title
	       limit 10 
    loop 
	raise notice '%(% mins)', f.title, f.length;
    end loop;
end;
$$

select 
	p.name,
	tr.type_register_id
from products as p
join type_register as tr on tr.type_register_id = p.type_register_id
join types as t on t.type_id = tr.type_id
; 


select 
	p.name
from products as p
;
insert into products (name, price, type_register_id) values('Moxito', 11000, 12);

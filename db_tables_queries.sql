
create table components (
	component_id serial not null primary key,
	name varchar(32) not null
);

insert into components(name) values ('Go''sht'), ('Sabzi'), ('Guruch'), ('Piyoz'), ('Kartoshka'), ('Karam');
insert into components(name) values ('Yog'''), ('Pishloq');
insert into components(name) values ('Tuz'), ('Mosh');

comment on table components is 'Xom ashyolar';

create table categories (
	category_id serial not null primary key,
	name varchar(64) not null
);

comment on table categories is 'Kategoriyalar';

create table types (
	type_id serial not null primary key,
	name varchar(24) not null
);

comment on table types is 'Maxsulot turlari';

create table type_register (
	type_register_id serial not null primary key,
	category_id int not null references categories(category_id),
	type_id int not null references types(type_id)
);

comment on table type_register is 'Qaysi kategoriyada qanday turdagi maxsulotlar borligi';

create table tables (
	table_id serial not null primary key,
	number int2 not null
);

insert into tables(name) values (1), (2), (3), (4), (5);

comment on table tables is 'Stollar';

create table products (
	product_id serial not null primary key,
	name varchar(64) not null,
	price decimal(16, 2) not null,
	type_register_id int not null references type_register(type_register_id)
);

insert into products (name, price, type_register_id) values('Osh', 20000, 4), ('Qozon kabob', 35000, 4), ('Moshxo''rda', 18000, 5), ('Go''ja', 13000, 5), ('Coca-Cola', 9000, 8), ('Ko''k choy', 4000, 6);
insert into products (name, price, type_register_id) values('Choy')

comment on table products is 'Tayyor maxsulotlar';

create table ingredients (
	ingredient_id serial not null primary key,
	product_id int not null references products(product_id),
	component_id int not null references components(component_id),
	weight int2 not null
);

insert into ingredients(product_id, component_id, weight) values (1, 1, 300), (1, 2, 700), (1, 3, 700); 
insert into ingredients(product_id, component_id, weight) values (3, 4, 150), (3, 7, 200);
insert into ingredients(product_id, component_id, weight) values (3, 10, 250);
comment on table ingredients is 'Retseptlar';

create table orders (
	order_id serial not null primary key,
	table_id int not null references tables(table_id),
	created_at timestamp with time zone default current_timestamp,
	closed_at timestamp with time zone default null
);

insert into orders (table_id) values (1, 3, 4);

comment on table orders is 'Buyurtmalar';

create table order_details (
	order_detail_id serial not null primary key,
	quantity int2 default 1,
	order_id int not null references orders (order_id),
	product_id int not null references products(product_id)
);

insert into order_details(quantity, order_id, product_id) values (3, 1, 1);
insert into order_details(order_id, product_id) values (1, 6);

comment on table order_details is 'Buyurtma tafsilotlari';




select 
 	sum(od.quantity) as orders
from order_details as od
where od.product_id = 1
;


select 
	o.order_id,
	p.name
from order_details as od
join orders as o on ((select extract(day from o.created_at)) = (select extract(day from (select current_timestamp )))) and od.product_id = 1
join products as p on p.product_id = od.product_id
limit 1;





select 
	od.quantity,
	p.name
from order_details as od
join orders as o on ((select extract(day from o.created_at)) = (select extract(day from (select current_timestamp )))) and od.product_id = 3
join products as p on p.product_id = od.product_id
limit 1;



select 
	o.order_id,
	p.name
from order_details as od
join orders as o on ((select extract(day from o.created_at)) = 5) and od.product_id = 3
join products as p on p.product_id = od.product_id
limit 1;





select 
	od.quantity,
	p.name
from order_details as od
join orders as o on ((select extract(day from o.created_at)) = 5) and od.product_id = 1
join products as p on p.product_id = od.product_id
limit 1;


select 
	array_agg(p.name)
from order_details as od 
join products as p on p.product_id = od.product_id and  
join orders as o on o.order_id = od.order_id
group by o.order_id
; 

select 
	array_agg(p.name)
from order_details as od  
join products as p on  p.product_id = od.product_id
join orders as o on o.order_id = od.order_id 
where od.order_id  in (select od.order_id from order_details as od where p.product_id = 1)

;



select 
 	p.name
from order_details as od 
join products as p on od.product_id = p.product_id
where od.order_id in (select od.order_id from order_details as od where od.product_id = 1) ;

select 
   p.name,
   sum(od.quantity) as all,
   count(od.product_id) as tables
from order_details as od 
join products as p on od.product_id = p.product_id and p.product_id != 1
where od.order_id in (select od.order_id from order_details as od where od.product_id = 1)
group by p.name, od.product_id
order by od.product_id 
limit 1
;

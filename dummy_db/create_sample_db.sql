create database company;
create user 'springuser'@'localhost' identified by 'prueba123'; -- Creates the user
grant all on company.* to 'springuser'@'localhost'; 
use company;
create table employed(id int not null primary key auto_increment, name varchar(60) not null, 
apellido1 varchar(100) not null, edad int(2) not null, telefono varchar(10) not null, 
direccion varchar(200))AUTO_INCREMENT=1 
DEFAULT CHARSET=utf8;



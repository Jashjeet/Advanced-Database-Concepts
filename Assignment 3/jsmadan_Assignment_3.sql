--\i C:/Users/jashj/OneDrive/'Semester 2'/'Advanced Database Concepts'/'Assignment 3'/'jsmadan_Assignment_3.sql'


-- Creating database
CREATE DATABASE assignment3jashjeet;

--Connecting database 
\c assignment3jashjeet; 


--Table Creation Statements
create table cites(bookno int, citedbookno int);
create table book(bookno int, title text, price int);
create table student(sid int, sname text);
create table major(sid int, major text);
create table buys(sid int, bookno int);


-- Data for the student relation.
INSERT INTO student VALUES(1001,'Jean')
,(1002,'Maria')
,(1003,'Anna')
,(1004,'Chin')
,(1005,'John')
,(1006,'Ryan')
,(1007,'Catherine')
,(1008,'Emma')
,(1009,'Jan')
,(1010,'Linda')
,(1011,'Nick')
,(1012,'Eric')
,(1013,'Lisa')
,(1014,'Filip')
,(1015,'Dirk')
,(1016,'Mary')
,(1017,'Ellen')
,(1020,'Ahmed');

-- Data for the book relation.
INSERT INTO book VALUES(2001,'Databases',40),
(2002,'OperatingSystems',25),
(2003,'Networks',20),
(2004,'AI',45),
(2005,'DiscreteMathematics',20),
(2006,'SQL',25),
(2007,'ProgrammingLanguages',15),
(2008,'DataScience',50),
(2009,'Calculus',10),
(2010,'Philosophy',25),
(2012,'Geometry',80),
(2013,'RealAnalysis',35),
(2011,'Anthropology',50),
(3000,'MachineLearning',40);


-- Data for the buys relation.

INSERT INTO buys VALUES(1001,2002),
(1001,2007),
(1001,2009),
(1001,2011),
(1001,2013),
(1002,2001),
(1002,2002),
(1002,2007),
(1002,2011),
(1002,2012),
(1002,2013),
(1003,2002),
(1003,2007),
(1003,2011),
(1003,2012),
(1003,2013),
(1004,2006),
(1004,2007),
(1004,2008),
(1004,2011),
(1004,2012),
(1004,2013),
(1005,2007),
(1005,2011),
(1005,2012),
(1005,2013),
(1006,2006),
(1006,2007),
(1006,2008),
(1006,2011),
(1006,2012),
(1006,2013),
(1007,2001),
(1007,2002),
(1007,2003),
(1007,2007),
(1007,2008),
(1007,2009),
(1007,2010),
(1007,2011),
(1007,2012),
(1007,2013),
(1008,2007),
(1008,2011),
(1008,2012),
(1008,2013),
(1009,2001),
(1009,2002),
(1009,2011),
(1009,2012),
(1009,2013),
(1010,2001),
(1010,2002),
(1010,2003),
(1010,2011),
(1010,2012),
(1010,2013),
(1011,2002),
(1011,2011),
(1011,2012),
(1012,2011),
(1012,2012),
(1013,2001),
(1013,2011),
(1013,2012),
(1014,2008),
(1014,2011),
(1014,2012),
(1017,2001),
(1017,2002),
(1017,2003),
(1017,2008),
(1017,2012),
(1020,2012);

-- Data for the cites relation.
INSERT INTO cites VALUES(2012,2001)
,(2008,2011)
,(2008,2012)
,(2001,2002)
,(2001,2007)
,(2002,2003)
,(2003,2001)
,(2003,2004)
,(2003,2002)
,(2012,2005);


-- Data for the major relation.

INSERT INTO major VALUES(1001,'Math')
,(1001,'Physics')
,(1002,'CS')
,(1002,'Math')
,(1003,'Math')
,(1004,'CS')
,(1006,'CS')
,(1007,'CS')
,(1007,'Physics')
,(1008,'Physics')
,(1009,'Biology')
,(1010,'Biology')
,(1011,'CS')
,(1011,'Math')
,(1012,'CS')
,(1013,'CS')
,(1013,'Psychology')
,(1014,'Theater')
,(1017,'Anthropology');







-- Additional Data for relations for Assignment 3.




insert into student values (1021, 'Kris');

insert into major values (1021, 'CS'), (1021, 'Math');

insert into book values
   (4001, 'LinearAlgebra', 30),
   (4002, 'MeasureTheory', 75),
   (4003, 'OptimizationTheory', 30);


insert into buys values 
   (1001,3000),
   (1001,2004),
   (1021, 2001),
   (1021, 2002),
   (1021, 2003),
   (1021, 2004),
   (1021, 2005),
   (1021, 2006),
   (1021, 2007),
   (1021, 2008),
   (1021, 2009),
   (1021, 2010),
   (1021, 2011),
   (1021, 4003),
   (1021, 4001),
   (1021, 4002),
   (1015, 2001),
   (1015, 2002),
   (1016, 2001),
   (1016, 2002),
   (1015, 2004),
   (1015, 2008),
   (1015, 2012),
   (1015, 2011),
   (1015, 3000),
   (1016, 2004),
   (1016, 2008),
   (1016, 2012),
   (1016, 2011),
   (1016, 3000),
   (1002, 4003),
   (1011, 4003),
   (1015, 4003),
   (1015, 4001),
   (1015, 4002),
   (1016, 4001),
   (1016, 4002);























\qecho 'Question 1'
--creating tables
create table A(a int);
create table B(b int);
--inserting values
INSERT INTO A VALUES (1),(2),(3);
INSERT INTO B VALUES (1),(3);



\qecho 'Part (a)'
select not exists(Select * from A EXCEPT select * from B) empty_a_minus_b,
	   not exists(Select * from B EXCEPT select * from A) empty_b_minus_a,
	   not exists(Select * from B INTERSECT select * from A) empty_a_intersection_b;


\qecho 'Part (b)'
select not exists(Select * from A where a not in (select * from B)) empty_a_minus_b,
	   not exists(Select * from B where b not in (select * from A)) empty_b_minus_a,
	   not exists(Select * from A where a in (select * from B)) empty_a_intersection_b;

drop table A;
drop table B;



\qecho 'Question 2'
--creating tables
create table P(p boolean);
create table Q(q boolean);
create table R(r boolean);
--inserting values
INSERT INTO P VALUES (True),(False),(NULL);
INSERT INTO Q VALUES (True),(False),(NULL);
INSERT INTO R VALUES (True),(False),(NULL);

select p,q,r,not(not p or q) or not r as value from P,Q,R;


drop table P;
drop table Q;
drop table R;




\qecho 'Question 3'
--creating tables
create table Point(p INTEGER , x FLOAT , y FLOAT);
--inserting values
INSERT INTO Point VALUES (1,0,0),(2,0,1),(3,1,0);
INSERT INTO Point VALUES (4,2,2),(5,0,2),(6,2,0);


\qecho 'Part (a)'
select p1.p,p2.p
from point p1, point p2
where p1.p<>p2.p
and sqrt((p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y)) <=all (
select sqrt((p3.x-p4.x)*(p3.x-p4.x)+(p3.y-p4.y)*(p3.y-p4.y)) as min_dist
from point p3, point p4
where p3.p<>p4.p
	and p3.p=p1.p);

\qecho 'Part (b)'
select distinct p1.p,p2.p,p3.p
from point p1, point p2, point p3
where p1.p<>p2.p and p1.p<>p3.p and p2.p<>p3.p
and (p1.y-p2.y)*(p1.x-p3.x)=(p1.y-p3.y)*(p1.x-p2.x)
and (p2.y-p3.y)*(p1.x-p3.x)=(p1.y-p3.y)*(p2.x-p3.x)
and (p1.y-p2.y)*(p2.x-p3.x)=(p2.y-p3.y)*(p1.x-p2.x);

Drop table Point;



\qecho 'Question 4'

--creating tables
create table R(A INTEGER , B INTEGER , C INTEGER);
--inserting values
INSERT INTO R VALUES (1,0,0),
					 (2,0,1),
					 (3,1,0),
					 (4,0,0),
					 (5,0,1),
					 (6,1,0);
					 
					 
\qecho 'Part (a)'
select not exists (select r1.a from R r1 
except all
select distinct r2.a from R r2 where r2.a is not null) A_primary_key;

\qecho 'Part (b)'
\qecho 'Printing table R to verify'

select * from R;
--instance 1
\qecho 'Instance of R which has A as primary key'
select not exists (select r1.a from R r1 
except all
select distinct r2.a from R r2 where r2.a is not null) A_primary_key;


--instance 2
INSERT INTO R VALUES (1,0,0),
					 (null,0,1);
\qecho 'Printing table R to verify'

select * from R;

\qecho 'Instance of R which does not have A as primary key'
select not exists (select r1.a from R r1 
except all
select distinct r2.a from R r2 where r2.a is not null) A_primary_key;

Drop table R;

\qecho 'Question 5'
--creating tables
create table M(ROW INTEGER , COLMN INTEGER , VALUE INTEGER);
--inserting values
INSERT INTO M VALUES (1,1,1),(1,2,2),(1,3,3),(2,1,1),(2,2,-3),(2,3,5),(3,1,4),(3,2,0),(3,3,-2);


select q1.row,q2.colmn,sum(q1.value*q2.value) as value
from (select m1.row,m2.colmn,sum(m1.value*m2.value) as value
from M m1, M m2
where m1.colmn=m2.row
group by m1.row,m2.colmn)q1,
(select m1.row,m2.colmn,sum(m1.value*m2.value) as value
from M m1, M m2
where m1.colmn=m2.row
group by m1.row,m2.colmn)q2
where q1.colmn=q2.row
group by q1.row,q2.colmn
order by q1.row,q2.colmn;



Drop table M;


\qecho 'Question 6'
--creating tables
create table A(x INTEGER);
--inserting values
INSERT INTO A VALUES (1),(2),(3),(10),(20),(30),(4),(5),(6);

select x%4 as remainder_value, count(true) as mod4_group_count
from A
group by x%4;

drop table A;



\qecho 'Question 7'
--creating tables
create table A(x INTEGER);
--inserting values
INSERT INTO A VALUES (1),(2),(3),(10),(20),(30),(4),(5),(6),(1),(2),(3);


select x from A
group by x;

drop table A;




\qecho 'Question 8 (a)'
select bo.bookno, bo.title
from major m, buys bu, book bo
where m.sid=bu.sid and
bu.bookno=bo.bookno
and bo.price<40
and m.major='CS'
group by bo.bookno, bo.title
having count(true)<3;

\qecho 'Question 8 (b)'
select bu.sid,s.sname, count(bo.price) numberofbooksbought
from buys bu, book bo, student s
where bu.bookno=bo.bookno
and bu.sid=s.sid
group by bu.sid,s.sname
having sum(bo.price)<200;


\qecho 'Question 8 (c)'
select bu.sid,s.sname
from buys bu, book bo, student s
where bu.bookno=bo.bookno
and bu.sid=s.sid
group by bu.sid, s.sname
having sum(bo.price) >= all
(select max(q1.total) from (select bu.sid,sum(bo.price) as total
from buys bu, book bo
where bu.bookno=bo.bookno
group by bu.sid)q1);




\qecho 'Question 8 (d)'
select m.major,sum(bo.price) totalpriceofbooksbought
from major m, buys bu, book bo
where m.sid=bu.sid
and bo.bookno=bu.bookno
group by m.major;




\qecho 'Question 8 (e)'
select q1.bookno b1,q2.bookno b2 from
(select b.bookno, count(true)
from buys b, major m
where b.sid=m.sid
and m.major='CS'
group by b.bookno)q1,
(select b.bookno, count(true)
from buys b, major m
where b.sid=m.sid
and m.major='CS'
group by b.bookno)q2
where q1.bookno<>q2.bookno
and q1.count=q2.count;






\qecho 'Question 9'
create or replace view bookAtLeast50_A as
select b.bookno,b.title,b.price from book b where b.price>=50;

create function  booksBoughtByStudent_B (s integer) 
returns table(bookno integer) as
$$
select b.bookno
from buys b
where b.sid=s
;
$$ language sql;


select * from student s
where exists((select A.bookno
			  from bookAtLeast50_A A)
			 except
			 select B.bookno from booksBoughtByStudent_B(s.sid) B);

drop view bookAtLeast50_A;
drop function booksBoughtByStudent_B;






\qecho 'Question 10'
create function  studentsWhoBoughtBook_A (bo integer) 
returns table(sid integer) as
$$
select b.sid
from buys b
where b.bookno=bo
;
$$ language sql;


create view cs_or_math_sid_B as
select distinct m.sid from major m 
where m.major in ('CS','Math');



select b.bookno,b.title from book b
where exists(select studentsWhoBoughtBook_A(b.bookno)
			except
			select Bb.sid from cs_or_math_sid_B Bb);
			
			
drop function studentsWhoBoughtBook_A;

drop view cs_or_math_sid_B;









\qecho 'Question 11'
create or replace function  booksBoughtByStudent_A (s integer) 
returns table(bookno integer) as
$$
select b.bookno
from buys b
where b.sid=s
;
$$ language sql;


create or replace view leastExpensiveBook as (select b.bookno from book
b where b.price = (select min(b1.price) from book b1));


select * from student s
where not exists(select A.bookno from booksBoughtByStudent_A(s.sid) A
				intersect
				select B.bookno from leastExpensiveBook B);
				
				
drop function booksBoughtByStudent_A;

drop view leastExpensiveBook;
				









\qecho 'Question 12'
create or replace function sidsCSBookBought (b integer)
returns table(sid integer) as
$$
select bu.sid
from buys bu, major m
where bu.sid=m.sid
and m.major='CS'
and bu.bookno=b;
$$
language sql;


select distinct b1.bookno, b2.bookno from book b1, book b2
where b1.bookno<>b2.bookno
and not exists(select A.sid from sidsCSBookBought(b1.bookno) A
				except
				select B.sid from sidsCSBookBought(b2.bookno) B)
and not exists(select A.sid from sidsCSBookBought(b2.bookno) A
				except
				select B.sid from sidsCSBookBought(b1.bookno) B);
				
drop function sidsCSBookBought;		








\qecho 'Question 13'
create or replace function  booksBoughtByStudent (s integer) 
returns table(bookno integer) as
$$
select b.bookno
from buys b
where b.sid=s
;
$$ language sql;

create or replace view bookLessThan50 as
select b.bookno,b.title,b.price from book b where b.price<50;


select s.sid,s.sname from student s, major m
where s.sid=m.sid and m.major='CS' and
(select count(1) from (select A.bookno from booksBoughtByStudent(s.sid) A
		   intersect
		   select B.bookno from bookLessThan50 B) q)<4;
		   
		   
drop function booksBoughtByStudent;

drop view bookLessThan50;	





\qecho 'Question 14'	
create or replace function  studentsWhoBoughtBook (bo integer) 
returns table(sid integer) as
$$
select b.sid
from buys b
where b.bookno=bo
;
$$ language sql;

create or replace view csStudent as 
select m.sid from major m
where m.major='CS';


select b.bookno, b.title from book b
where (select count(1) from (select A.sid from studentsWhoBoughtBook(b.bookno) A
	  intersect
	  select B.sid from csStudent B)q)%2=1;


drop function studentsWhoBoughtBook;
drop view csStudent;




\qecho 'Question 15'	
create or replace view allBooks as
select b.bookno,b.title,b.price from book b;

create or replace function  booksBoughtByStudent (s integer) 
returns table(bookno integer) as
$$
select b.bookno
from buys b
where b.sid=s
;
$$ language sql;


select s.sid,s.sname from student s
where (select count(1) from (select A.bookno from allBooks A
		   except
		   select B.bookno from booksBoughtByStudent(s.sid) B) q)=3;
		   
drop view allBooks;
drop function booksBoughtByStudent;




\qecho 'Question 16'
create or replace function sidsBookBought (b integer)
returns table(sid integer) as
$$
select bu.sid
from buys bu
where bu.bookno=b;
$$
language sql;


select distinct b1.bookno, b2.bookno from book b1, book b2
where b1.bookno<>b2.bookno
and not exists(select A.sid from sidsBookBought(b1.bookno) A
				except
				select B.sid from sidsBookBought(b2.bookno) B);
				
drop function sidsBookBought;	







--Connect to default database
\c postgres;


--Drop database which you created
DROP DATABASE assignment3jashjeet;
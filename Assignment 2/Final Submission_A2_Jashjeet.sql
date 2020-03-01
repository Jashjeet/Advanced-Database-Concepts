--\i C:/Users/jashj/OneDrive/'Semester 2'/'Advanced Database Concepts'/'Assignment 2'/'Final Submission_A2_Jashjeet.sql'


-- Creating database
CREATE DATABASE assignment2jashjeet;

--Connecting database 
\c assignment2jashjeet; 


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















--simple join between tables and required conditions
\qecho 'Question 1 (a)'
select distinct s.sid, s.sname
from student s, major m, buys bu, book bo
where s.sid=m.sid and  s.sid=bu.sid and m.major='CS'
and bu.bookno=bo.bookno and bo.price>10;



--where condition uses IN predicate to select sid
\qecho 'Question 1 (b)'
select distinct s.sid, s.sname from student s where 
s.sid in (select m.sid from major m
where m.major in ('CS'))
and s.sid in (select bu.sid from buys bu
where bu.bookno in (select bo.bookno from book bo
where bo.price>10));



--nested where condition uses SOME predicate to join sid from student to sid in buys and sid in book 
\qecho 'Question 1 (c)'
select distinct s.sid, s.sname from student s where 
s.sid = some (select m.sid from major m
where m.major = 'CS')
and s.sid = some (select bu.sid from buys bu
where bu.bookno = some (select bo.bookno from book bo
where bo.price>10));


--where condition uses EXISTS predicate to select sid if there is one of the specified condition
\qecho 'Question 1 (d)'
select distinct s.sid, s.sname from student s where 
exists (select 1 from major m
where m.major = 'CS' and m.sid=s.sid)
and exists (select 1 from buys bu
where bu.sid=s.sid and exists (select 1 from book bo
where bu.bookno = bo.bookno and bo.price>10));





--simple join between tables and conditions
\qecho 'Question 2 (a)'
select distinct b1.* from book b1
except
select bu.bookno,b2.title,b2.price
from buys bu, major m, book b2
where bu.sid=m.sid and m.major = 'Math'
and b2.bookno=bu.bookno;


--where condition uses IN predicate to select bookno
\qecho 'Question 2 (b)'
select distinct bo.* FROM book bo
where bo.bookno not in
(select bu.bookno from buys bu where bu.sid in 
(select m.sid from major m where m.major in ('Math')));


--nested where condition uses ALL predicate to join bookno from book to bookno in buys and sid in major 
\qecho 'Question 2 (c)'
select bo.* FROM book bo
where bo.bookno <> all
(select distinct bu.bookno from buys bu where bu.sid = some 
(select m.sid from major m where m.major = 'Math'));


--where condition uses NOT EXISTS predicate to select if there is one bookno in buys and sid from buys in major
\qecho 'Question 2 (d)'
select bo.* FROM book bo
where not exists 
(select distinct 1 from buys bu where bo.bookno = bu.bookno and 
 exists
(select 1 from major m where bu.sid = m.sid and m.major = 'Math'));



--simple join between tables and conditions using = and <>
\qecho 'Question 3 (a)'
select distinct b.* FROM cites c1, cites c2, book b, book b1, book b2
where b.bookno=c1.bookno
and c1.bookno=c2.bookno
and c1.citedbookno<>c2.citedbookno
and (b1.bookno=c1.citedbookno and b1.price<60)
and (b2.bookno=c2.citedbookno and b2.price<60);


--where condition uses IN predicate to select bookno from cites table
\qecho 'Question 3 (b)'
select * from book b where b.bookno in (
select distinct c1.bookno from cites c1, cites c2
where c1.bookno=c2.bookno and c1.citedbookno <> c2.citedbookno
and c1.citedbookno in (select b1.bookno from book b1 where b1.price<60)
and c2.citedbookno in (select b2.bookno from book b2 where b2.price<60));


--where condition uses EXISTS predicate to select bookno from cites table and check in book table
\qecho 'Question 3 (c)'
select * from book b where b.bookno in (
select distinct c1.bookno from cites c1, cites c2
where c1.bookno=c2.bookno and c1.citedbookno <> c2.citedbookno
and  exists (select 1 from book b1 where b1.price<60 and c1.citedbookno=b1.bookno)
and  exists (select 1 from book b2 where b2.price<60 and c2.citedbookno=b2.bookno));



--the first query select all those pairs where any book  if greater than any other book and the second removes from the second highest
\qecho 'Question 4 (a)'
select distinct bu1.sid, s.sname, bo1.title, bo1.price
from buys bu1, book bo1, buys bu2, book bo2, student s
where bu1.sid=s.sid and
bu1.bookno=bo1.bookno
and bu2.bookno=bo2.bookno
and bu1.sid=bu2.sid
and bo1.price>=bo2.price
except
select distinct bu1.sid, s.sname, bo1.title, bo1.price
from buys bu1, book bo1, buys bu2, book bo2, student s
where bu1.sid=s.sid and
bu1.bookno=bo1.bookno
and bu2.bookno=bo2.bookno
and bu1.sid=bu2.sid
and bo1.price<bo2.price;


--used >=ALL for comparing prices of each book
\qecho 'Question 4 (b)'
select distinct s.sid,s.sname,bo.title,bo.price from buys bu, book bo, student s
where bu.sid=s.sid and bu.bookno=bo.bookno and
bo.price >= all (select bo2.price from buys bu2,book bo2 where
				bu2.bookno=bo2.bookno and bu2.sid=bu.sid);
				


--selected students who bought mare than 2 books which each cost more than 20 and subtracted from the original set				
\qecho 'Question 5'				
select s.sid, s.sname from student s where s.sid not in
(select b1.sid from buys b1, buys b2
where b1.sid=b2.sid
and b1.bookno in (select bo.bookno from book bo where bo.price>20)
and b2.bookno in (select bo.bookno from book bo where bo.price>20)
and b1.bookno<>b2.bookno);



--compared prices three times which gave highest, second highest and third highest and subtracted third highest from second highest
\qecho 'Question 6'		
select distinct b2.* from book b1, book b2, book b3
where b1.price>b2.price and b2.price>b3.price
and b2.bookno not in (
select b3.bookno from book b1, book b2, book b3
where b1.price>b2.price and b2.price>b3.price);



--selected books which cite the most expensive books and then used NOT IN to filter out those records
\qecho 'Question 7'	
select distinct bo.* from cites c, book bo
where c.bookno = bo.bookno and c.citedbookno not in (
select b.bookno from book b where b.bookno in (
select b1.bookno from book b1, book b2
where b1.price>b2.price)
and b.bookno not in (
select b2.bookno from book b1, book b2
where b1.price>b2.price));


--first filter those students who has more than 2 majors by using NOT IN and then NOT EXISTS to check every single book for price less than 40
\qecho 'Question 8'	
select s.* from major m, student s
where m.sid not in (
	select m1.sid from major m1, major m2
where m1.sid=m2.sid
and m1.major<>m2.major)
and not exists (select 1 from buys bu , book bo
where bu.bookno=bo.bookno
and bo.price<40
and bu.sid=m.sid)
and m.sid=s.sid;


--using double NOT EXISTS we do not want any book that does NOT EXISTS in any of the students who took both CS and Math
\qecho 'Question 9'	
select bo.bookno,bo.title from book bo
where not exists 
(select * from major m1, major m2 
where m1.sid = m2.sid and m1.major = 'CS' and m2.major = 'Math' 
and not exists
(select * from buys bu where bu.bookno = bo.bookno and bu.sid=m1.sid));



--we filter out if a student has bought a book > 70 and not bought a book < 30 from all students
\qecho 'Question 10'	
select * from student s where
s.sid in (select distinct bu.sid from buys bu, book bo
where bu.bookno =bo.bookno and ((bo.price >=70 and exists
(select * from buys bu1, book bo1  where
bu1.bookno =bo1.bookno
and bo1.price<30
and bu1.sid=bu.sid))
or (bo.price<70 and not exists 
	(select * from buys bu2, book bo2  where
bu2.bookno =bo2.bookno
and bo2.price>70
and bu2.sid=bu.sid)))) or s.sid not in (select b.sid from buys b);



--first we find students having common major then EXISTS if any book is different between them by using NOT IN
\qecho 'Question 11'	
select distinct m1.sid,m2.sid
 from major m1, major m2
 where m1.major = m2.major and m1.sid<>m2.sid
 and (exists
 (select * from buys b1
 where b1.sid=m1.sid and b1.bookno not in (select b2.bookno from buys b2
						where b2.sid=m2.sid)) or exists
  (select * from buys b3
 where b3.sid=m2.sid and b3.bookno not in (select b4.bookno from buys b4
						where b4.sid=m1.sid)));





--from all combinations we exclude using EXCEPT those tuples such that if s1 buys b1 then s2 buys b2
\qecho 'Question 12'	
select count(1) from (
select s1.sid,b1.bookno,s2.sid,b2.bookno
from student s1, book b1, student s2, book b2
except
select * from buys bu1, buys bu2) as cc;




--first we filtered those students who bought two books and then using NOT IN we discarded those books which where greater than 30
\qecho 'Question 13'	
--creating view
create view bookAtLeast30 as
select b.bookno,b.title,b.price from book b where b.price>=30;

--sql query
select * from student s
where s.sid not in
(select distinct b1.sid
from buys b1, buys b2
where b1.sid=b2.sid
and b1.bookno<>b2.bookno
and b1.bookno not in
(select b30.bookno from bookAtLeast30 b30)
and b2.bookno not in
(select b30.bookno from bookAtLeast30 b30));

--dropping view
drop view bookAtLeast30;




\qecho 'Question 14'

--with query, so no need to drop the view after query execution
with bookAtLeast30 as (select b.bookno,b.title,b.price 
			from book b where b.price>=30)
select * from student s
where s.sid not in
(select distinct b1.sid
from buys b1, buys b2
where b1.sid=b2.sid
and b1.bookno<>b2.bookno
and b1.bookno not in
(select b30.bookno from bookAtLeast30 b30)
and b2.bookno not in
(select b30.bookno from bookAtLeast30 b30));




\qecho 'Question 15'

--creating parameterized view, i.e., function which takes input as bookno and returns all the books cited by it in the form of a table

create function  citesBooks (b integer) 
returns table(bookno integer,
			 title text,
			 price integer) as
$$
select bo.bookno, bo.title, bo.price from
book bo, cites c
where bo.bookno=c.citedbookno
and c.bookno=b
;
$$ language sql;



\qecho 'Part A'
--first we check if a book cites the book with bookno 2001 and then use EXISTS to check if it also cites a book whose price<50
select b.bookno,b.title from
book b, cites c
where b.bookno=c.bookno
and c.citedbookno=2001
and exists (
	select 1 from citesBooks(b.bookno) cb
	where cb.price<50);



\qecho 'Part B'
--using EXISTS we find if there is a different book cited by a book
select distinct b.bookno, b.title from cites c1, book b
where c1.bookno=b.bookno
and exists
(select * from citesBooks(c1.bookno) cb
where c1.citedbookno<>cb.bookno);




--Connect to default database
\c postgres;


--Drop database which you created
DROP DATABASE assignment2jashjeet;
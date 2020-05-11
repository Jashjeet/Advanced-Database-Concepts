--\i C:/Users/jashj/OneDrive/'Semester 2'/'Advanced Database Concepts'/'Assignment 6'/'jsmadan_Assignment_6.sql'


-- Creating database
CREATE DATABASE assignment6jashjeet;

--Connecting database 
\c assignment6jashjeet; 



create table cites(bookno int, citedbookno int);
create table book(bookno int, title text, price int);
create table student(sid int, sname text);
create table major(sid int, major text);
create table buys(sid int, bookno int);


-- Data for the student relation.
INSERT INTO student VALUES(1001,'Jean');
INSERT INTO student VALUES(1002,'Maria');
INSERT INTO student VALUES(1003,'Anna');
INSERT INTO student VALUES(1004,'Chin');
INSERT INTO student VALUES(1005,'John');
INSERT INTO student VALUES(1006,'Ryan');
INSERT INTO student VALUES(1007,'Catherine');
INSERT INTO student VALUES(1008,'Emma');
INSERT INTO student VALUES(1009,'Jan');
INSERT INTO student VALUES(1010,'Linda');
INSERT INTO student VALUES(1011,'Nick');
INSERT INTO student VALUES(1012,'Eric');
INSERT INTO student VALUES(1013,'Lisa');
INSERT INTO student VALUES(1014,'Filip');
INSERT INTO student VALUES(1015,'Dirk');
INSERT INTO student VALUES(1016,'Mary');
INSERT INTO student VALUES(1017,'Ellen');
INSERT INTO student VALUES(1020,'Ahmed');

-- Data for the book relation.
INSERT INTO book VALUES(2001,'Databases',40);
INSERT INTO book VALUES(2002,'OperatingSystems',25);
INSERT INTO book VALUES(2003,'Networks',20);
INSERT INTO book VALUES(2004,'AI',45);
INSERT INTO book VALUES(2005,'DiscreteMathematics',20);
INSERT INTO book VALUES(2006,'SQL',25);
INSERT INTO book VALUES(2007,'ProgrammingLanguages',15);
INSERT INTO book VALUES(2008,'DataScience',50);
INSERT INTO book VALUES(2009,'Calculus',10);
INSERT INTO book VALUES(2010,'Philosophy',25);
INSERT INTO book VALUES(2012,'Geometry',80);
INSERT INTO book VALUES(2013,'RealAnalysis',35);
INSERT INTO book VALUES(2011,'Anthropology',50);
INSERT INTO book VALUES(3000,'MachineLearning',40);


-- Data for the buys relation.

INSERT INTO buys VALUES(1001,2002);
INSERT INTO buys VALUES(1001,2007);
INSERT INTO buys VALUES(1001,2009);
INSERT INTO buys VALUES(1001,2011);
INSERT INTO buys VALUES(1001,2013);
INSERT INTO buys VALUES(1002,2001);
INSERT INTO buys VALUES(1002,2002);
INSERT INTO buys VALUES(1002,2007);
INSERT INTO buys VALUES(1002,2011);
INSERT INTO buys VALUES(1002,2012);
INSERT INTO buys VALUES(1002,2013);
INSERT INTO buys VALUES(1003,2002);
INSERT INTO buys VALUES(1003,2007);
INSERT INTO buys VALUES(1003,2011);
INSERT INTO buys VALUES(1003,2012);
INSERT INTO buys VALUES(1003,2013);
INSERT INTO buys VALUES(1004,2006);
INSERT INTO buys VALUES(1004,2007);
INSERT INTO buys VALUES(1004,2008);
INSERT INTO buys VALUES(1004,2011);
INSERT INTO buys VALUES(1004,2012);
INSERT INTO buys VALUES(1004,2013);
INSERT INTO buys VALUES(1005,2007);
INSERT INTO buys VALUES(1005,2011);
INSERT INTO buys VALUES(1005,2012);
INSERT INTO buys VALUES(1005,2013);
INSERT INTO buys VALUES(1006,2006);
INSERT INTO buys VALUES(1006,2007);
INSERT INTO buys VALUES(1006,2008);
INSERT INTO buys VALUES(1006,2011);
INSERT INTO buys VALUES(1006,2012);
INSERT INTO buys VALUES(1006,2013);
INSERT INTO buys VALUES(1007,2001);
INSERT INTO buys VALUES(1007,2002);
INSERT INTO buys VALUES(1007,2003);
INSERT INTO buys VALUES(1007,2007);
INSERT INTO buys VALUES(1007,2008);
INSERT INTO buys VALUES(1007,2009);
INSERT INTO buys VALUES(1007,2010);
INSERT INTO buys VALUES(1007,2011);
INSERT INTO buys VALUES(1007,2012);
INSERT INTO buys VALUES(1007,2013);
INSERT INTO buys VALUES(1008,2007);
INSERT INTO buys VALUES(1008,2011);
INSERT INTO buys VALUES(1008,2012);
INSERT INTO buys VALUES(1008,2013);
INSERT INTO buys VALUES(1009,2001);
INSERT INTO buys VALUES(1009,2002);
INSERT INTO buys VALUES(1009,2011);
INSERT INTO buys VALUES(1009,2012);
INSERT INTO buys VALUES(1009,2013);
INSERT INTO buys VALUES(1010,2001);
INSERT INTO buys VALUES(1010,2002);
INSERT INTO buys VALUES(1010,2003);
INSERT INTO buys VALUES(1010,2011);
INSERT INTO buys VALUES(1010,2012);
INSERT INTO buys VALUES(1010,2013);
INSERT INTO buys VALUES(1011,2002);
INSERT INTO buys VALUES(1011,2011);
INSERT INTO buys VALUES(1011,2012);
INSERT INTO buys VALUES(1012,2011);
INSERT INTO buys VALUES(1012,2012);
INSERT INTO buys VALUES(1013,2001);
INSERT INTO buys VALUES(1013,2011);
INSERT INTO buys VALUES(1013,2012);
INSERT INTO buys VALUES(1014,2008);
INSERT INTO buys VALUES(1014,2011);
INSERT INTO buys VALUES(1014,2012);
INSERT INTO buys VALUES(1017,2001);
INSERT INTO buys VALUES(1017,2002);
INSERT INTO buys VALUES(1017,2003);
INSERT INTO buys VALUES(1017,2008);
INSERT INTO buys VALUES(1017,2012);
INSERT INTO buys VALUES(1020,2012);

-- Data for the cites relation.
INSERT INTO cites VALUES(2012,2001);
INSERT INTO cites VALUES(2008,2011);
INSERT INTO cites VALUES(2008,2012);
INSERT INTO cites VALUES(2001,2002);
INSERT INTO cites VALUES(2001,2007);
INSERT INTO cites VALUES(2002,2003);
INSERT INTO cites VALUES(2003,2001);
INSERT INTO cites VALUES(2003,2004);
INSERT INTO cites VALUES(2003,2002);
INSERT INTO cites VALUES(2012,2005);


-- Data for the major relation.

INSERT INTO major VALUES(1001,'Math');
INSERT INTO major VALUES(1001,'Physics');
INSERT INTO major VALUES(1002,'CS');
INSERT INTO major VALUES(1002,'Math');
INSERT INTO major VALUES(1003,'Math');
INSERT INTO major VALUES(1004,'CS');
INSERT INTO major VALUES(1006,'CS');
INSERT INTO major VALUES(1007,'CS');
INSERT INTO major VALUES(1007,'Physics');
INSERT INTO major VALUES(1008,'Physics');
INSERT INTO major VALUES(1009,'Biology');
INSERT INTO major VALUES(1010,'Biology');
INSERT INTO major VALUES(1011,'CS');
INSERT INTO major VALUES(1011,'Math');
INSERT INTO major VALUES(1012,'CS');
INSERT INTO major VALUES(1013,'CS');
INSERT INTO major VALUES(1013,'Psychology');
INSERT INTO major VALUES(1014,'Theater');
INSERT INTO major VALUES(1017,'Anthropology');









\qecho 'Part 2'

create or replace function makerandomR(m integer, n integer, l integer)
returns void as
$$
declare i integer; j integer;
begin
drop table if exists Ra; drop table if exists Rb;
drop table if exists R;
create table Ra(a int); create table Rb(b int);
create table R(a int, b int);
for i in 1..m loop insert into Ra values(i); end loop;
for j in 1..n loop insert into Rb values(j); end loop;
insert into R select * from Ra a, Rb b order by random() limit(l);
end;
$$ LANGUAGE plpgsql;










create or replace function makerandomS(n integer, l integer)
returns void as
$$
declare i integer;
begin
drop table if exists Sb;
drop table if exists S;
create table Sb(b int);
create table S(b int);
for i in 1..n loop insert into Sb values(i); end loop;
insert into S select * from Sb order by random() limit (l);
end;
$$ LANGUAGE plpgsql;


select makerandomR(500,500,10000);
select makerandomS(500,10000);



\qecho 'Question 7'


\qecho 'Non Optimized query'
\qecho 'Query 3'

explain analyze
select distinct r1.a
from R r1, R r2, R r3
where r1.b = r2.a and r2.b = r3.a;


\qecho 'Optimized query'
\qecho 'Query 4'

explain analyze
select distinct r1.a
from R r1 natural join 
(select distinct r2.a as b from R r2 natural join
(select distinct r3.a as b from R r3) r3) r2;





\qecho 'Question 8'


\qecho 'Non Optimized query'
\qecho 'Query 5'

explain analyze
select ra.a
from Ra ra
where not exists (select r.b
from R r
where r.a = ra.a and
r.b not in (select s.b from S s));



\qecho 'Optimized query'
\qecho 'Query 6'

explain analyze
select * from Ra ra
except
select * from Ra ra natural join
(select q1.a from 
(select r1.a,r1.b from R r1
except 
select r2.a,s1.b from R r2 natural join S s1) q1) q2;



\qecho 'Question 9'


\qecho 'Non Optimized query'
\qecho 'Query 7'

explain analyze
select ra.a
from Ra ra
where not exists (select s.b
from S s
where s.b not in (select r.b
from R r
where r.a = ra.a));


\qecho 'Optimized query'
\qecho 'Query 8'

explain analyze
select ra.a
from Ra ra
except 
select q.a from 
(select ra.a,s.b
from S s cross join Ra ra
except 
select ra.a,s.b
from S s natural join R r natural join Ra ra)q;







\qecho 'Question 10'
\qecho 'Query 9'


explain analyze
with  NestedR as (select  r.a, array_agg(r.b order by 1) as Bs
from    R r
group by (r.a)),
SetS as (select array(select s.b from S s order by 1) as Bs)
select r.a
from   NestedR r, SetS s
where  r.Bs <@ s.Bs
union
(select ra.a
 from Ra ra
 except
 select r.a
 from   R r);



\qecho 'Question 11'

\qecho 'Query 10'

explain analyze
with NestedR as (select r.a, array_agg(r.b order by 1) as Bs
from R r
group by (r.a)),
SetS as (select array(select s.b from S s order by 1) as Bs)
select r.a
from NestedR r, SetS s
where s.Bs <@ r.Bs;





\qecho 'Question 12 (a)'

create or replace function setintersection(A anyarray, B anyarray) returns anyarray as
$$
with
Aset as (select UNNEST(A)),
Bset as (select UNNEST(B))
select array( (select * from Aset) intersect (select * from Bset) order by 1);
$$ language sql;



\qecho 'Question 12 (b)'

create or replace function setdifference(A anyarray, B anyarray) returns anyarray as
$$
with
Aset as (select UNNEST(A)),
Bset as (select UNNEST(B))
select array( (select * from Aset) except (select * from Bset) order by 1);
$$ language sql;





\qecho 'Question 13'

create or replace view student_books as
select s.sid, array(select t.bookno
from buys t
where t.sid = s.sid order by bookno) as books
from student s order by sid;

select * from student_books;

\qecho 'Question 13 (a)'

create or replace view book_students as
select b.bookno, array(select t.sid
from buys t
where t.bookno = b.bookno order by sid) as students
from book b order by bookno;

select * from book_students;


\qecho 'Question 13 (b)'

create or replace view book_citedbooks as
select b.bookno, array(select c.citedbookno
from cites c
where c.bookno = b.bookno order by citedbookno) as citedbooks
from book b order by bookno;

select * from book_citedbooks;



\qecho 'Question 13 (c)'

create or replace view book_citingbooks as
select b.bookno, array(select c.bookno
from cites c
where c.citedbookno = b.bookno order by bookno) as citingbooks
from book b order by bookno;

select * from book_citingbooks;


\qecho 'Question 13 (d)'

create or replace view major_students as
select m.major,array_agg(m.sid) as students
from major m
group by (m.major);

select * from major_students;




\qecho 'Question 13 (e)'

create or replace view student_majors as
select s.sid, array(select m.major
from major m
where m.sid=s.sid order by major) as majors
from student s order by sid;

select * from student_majors;




\qecho 'Question 14'

create or replace function isIn(x anyelement, S anyarray)
returns boolean as
$$
select x = SOME(S);
$$ language sql;





\qecho 'Question 14 (a)'

select distinct b.bookno, b.title 
from book_citedbooks cb, book b1, book b2, book b3, book b
where b1.bookno=some(cb.citedbooks)
and b2.bookno=some(cb.citedbooks)
and b3.bookno=some(cb.citedbooks)
and b1.price<50
and b2.price<50
and b3.price<50
and b1.bookno<>b2.bookno and b1.bookno<>b3.bookno and b3.bookno<>b2.bookno
and cb.bookno=b.bookno;



\qecho 'Question 14 (b)'

select b.bookno, b.title
from major_students ms, book_students bs, book b
where major='CS'
and not (ms.students && bs.students) 
and b.bookno=bs.bookno;




\qecho 'Question 14 (c)'

select sb.sid from student_books sb
where (select array_agg(b.bookno) as booksGreaterThan50
from book b
where b.price>=50)<@books;





\qecho 'Question 14 (d)'

select distinct bookno 
from book_students bs, major_students ms
where ms.major='CS'
and exists (select unnest(bs.students) except select unnest(ms.students) );




\qecho 'Question 14 (e)'

select distinct b.bookno,b.title
from book_students bs , book b
where bs.bookno=b.bookno
and exists ( select unnest(bs.students) except
select sb.sid
from student_books sb
where (select array_agg(b.bookno) as booksGreaterThan45
from book b
where b.price>45)<@books );





\qecho 'Question 14 (f)'

select s.sid, b.bookno
from student s, book b, student_books sb, book_citingbooks bc
where s.sid=sb.sid
and b.bookno=bc.bookno
and not (sb.books<@bc.citingbooks);



\qecho 'Question 14 (g)'

select b1.bookno,b2.bookno
from book b1, book b2, book_students bs1, book_students bs2
where b1.bookno=bs1.bookno
and b2.bookno=bs2.bookno
and bs1.students<@bs2.students
and bs2.students<@bs1.students;





\qecho 'Question 14 (h)'

select b1.bookno,b2.bookno
from book b1, book b2, book_students bs1, book_students bs2
where b1.bookno=bs1.bookno
and b2.bookno=bs2.bookno
and cardinality(bs1.students)=cardinality(bs2.students);




\qecho 'Question 14 (i)'

select sb.sid
from student_books sb
where cardinality(sb.books)=(select count(1) from book b)-4;



\qecho 'Question 14 (j)'

select sb1.sid
from student_books sb1
where cardinality(sb1.books)<= (
select sum(cardinality(books)) sumOfBooks
from student_books sb, major_students ms
where ms.major='Psychology'
and sb.sid=some(ms.students));


--Connect to default database
\c postgres;


--Drop database which you created
DROP DATABASE assignment6jashjeet;
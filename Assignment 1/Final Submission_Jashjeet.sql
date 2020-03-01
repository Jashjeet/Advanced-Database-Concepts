--\i C:/Users/jashj/OneDrive/'Semester 2'/'Advanced Database Concepts'/'Assignment 1'/'Final Submission_Jashjeet.sql'

-- Creating database
CREATE DATABASE assignment1jashjeet;

--Connecting database 
\c assignment1jashjeet; 

--Table Creation Statements
CREATE TABLE sailor
(
    sid integer NOT NULL,
    sname text,
    rating integer,
    CONSTRAINT sailor_pk PRIMARY KEY (sid)
);



CREATE TABLE boat
(
    bid integer NOT NULL,
    bname text,
    color text,
    CONSTRAINT boat_pk PRIMARY KEY (bid)
);


CREATE TABLE reserves
(
    sid integer,
    bid integer,
    day text ,
    CONSTRAINT boat_bid_fk FOREIGN KEY (bid)
        REFERENCES boat (bid) ,
    CONSTRAINT sailor_sid_fk FOREIGN KEY (sid)
        REFERENCES sailor (sid) 
);

--Populating Tables
INSERT INTO sailor VALUES(22,   'Dustin',       7)
, (29,   'Brutus',       1)
, (31,   'Lubber',       8)
, (32,   'Andy',         8)
, (58,   'Rusty',        10)
, (64,   'Horatio',      7)
, (71,   'Zorba',        10)
, (75,   'David',        8)
, (74,   'Horatio',      9)
, (85,   'Art',          3)
, (95,   'Bob',          3);

INSERT INTO boat VALUES(101,	'Interlake',	'blue')
,(102,	'Sunset',	'red')
,(103,	'Clipper',	'green')
,(104,	'Marine',	'red')
,(105,    'Indianapolis',     'blue');


INSERT INTO reserves VALUES(22,	101,	'Monday')
,(22,	102,	'Tuesday')
,(22,	103,	'Wednesday')
,(22,	105,	'Wednesday')
,(31,	102,	'Thursday')
,(31,	103,	'Friday')
,(31, 104,	'Saturday')
,(64,	101,	'Sunday')
,(64,	102,	'Monday')
,(74,	102,	'Saturday');

--Sample queries

\qecho 'Question 1 Part 1 Sailor'

SELECT * from sailor;

\qecho 'Question 1 Part 1 Boat'

SELECT * from boat;

\qecho 'Question 1 Part 1 Reserves'

SELECT * from reserves;




\qecho 'Question 1 Part 2'


\qecho 'Error, violates referential integrity'
\qecho 'delete from sailor s where s.sid=74;'
delete from sailor s where s.sid=74;
\qecho 'Successful, first delete from child table, and then from parent table'
\qecho 'delete from reserves r where r.sid=74;'
\qecho 'delete from sailor s where s.sid=74;'
delete from reserves r where r.sid=74;
delete from sailor s where s.sid=74;

\qecho 'Error, violates unique constraint'
\qecho 'insert into boat values (101,	'Sample',	'white');'
insert into boat values (101,	'Sample',	'white');
\qecho 'Successful, after changing the primary key value in insertion'
\qecho 'insert into boat values (108,	'Sample',	'white');'
insert into boat values (108,	'Sample',	'white');

\qecho 'Error, violates foreign key constraint'
\qecho 'INSERT INTO reserves VALUES(25,	102,	'Monday');'
INSERT INTO reserves VALUES(25,	102,	'Monday');
\qecho 'Successful, after inserting into parent table (sailor) first, we can insert into child table (reserves)'
\qecho 'insert into sailor values (25,	'New',	100);'
\qecho 'INSERT INTO reserves VALUES(25,	102,	'Monday');'
insert into sailor values (25,	'New',	100);
INSERT INTO reserves VALUES(25,	102,	'Monday');

\qecho 'Error, violates foreign key constraint'
\qecho 'INSERT INTO reserves VALUES(25,	110,	'Monday');'
INSERT INTO reserves VALUES(25,	110,	'Monday');
\qecho 'Successful, after inserting into parent table (boat) first, we can insert into child table (reserves)'
\qecho 'insert into boat values (110,	'New Boat',	'Yellow');'
\qecho 'INSERT INTO reserves VALUES(25,	110,	'Monday');'
insert into boat values (110,	'New Boat',	'Yellow');
INSERT INTO reserves VALUES(25,	110,	'Monday');

\qecho 'Error, violates referential integrity (foreign key to parent table sailor)'
\qecho 'INSERT INTO reserves VALUES(44,	103,	'Monday');'
INSERT INTO reserves VALUES(44,	103,	'Monday');
\qecho 'Successful, after dropping the foreign key'
\qecho 'alter table reserves drop constraint sailor_sid_fk;'
\qecho 'INSERT INTO reserves VALUES(44,	103,	'Monday');'
alter table reserves drop constraint sailor_sid_fk;
INSERT INTO reserves VALUES(44,	103,	'Monday');

\qecho 'Error, insert or update on table reserves violates foreign key constraint boat_bid_fk'
\qecho 'INSERT INTO reserves VALUES(44,	115,	'Monday');'
INSERT INTO reserves VALUES(44,	115,	'Monday');
\qecho 'Successful, after dropping foreign key constraint boat_bid_fk'
\qecho 'alter table reserves drop constraint boat_bid_fk;'
\qecho 'INSERT INTO reserves VALUES(44,	115,	'Monday');'
alter table reserves drop constraint boat_bid_fk;
INSERT INTO reserves VALUES(44,	115,	'Monday');

\qecho 'Error, duplicate key value violates unique constraint sailor_pk'
\qecho 'insert into sailor values (22,	'Jashjeet',	100);'
insert into sailor values (22,	'Jashjeet',	100);
\qecho 'Successful, after dropping primary key, duplicate insertion of sid is possible'
\qecho 'alter table sailor drop constraint sailor_pk;'
\qecho 'insert into sailor values (22,	'Jashjeet',	100);'
alter table sailor drop constraint sailor_pk;
insert into sailor values (22,	'Jashjeet',	100);





\qecho 'Dropping and Recreating Tables'

drop table reserves;

drop table sailor;

drop table boat;




CREATE TABLE sailor
(
    sid integer NOT NULL,
    sname text,
    rating integer,
    CONSTRAINT sailor_pk PRIMARY KEY (sid)
);



CREATE TABLE boat
(
    bid integer NOT NULL,
    bname text,
    color text,
    CONSTRAINT boat_pk PRIMARY KEY (bid)
);


CREATE TABLE reserves
(
    sid integer,
    bid integer,
    day text ,
    CONSTRAINT boat_bid_fk FOREIGN KEY (bid)
        REFERENCES boat (bid) ,
    CONSTRAINT sailor_sid_fk FOREIGN KEY (sid)
        REFERENCES sailor (sid) 
);

--Populating Tables
INSERT INTO sailor VALUES(22,   'Dustin',       7)
, (29,   'Brutus',       1)
, (31,   'Lubber',       8)
, (32,   'Andy',         8)
, (58,   'Rusty',        10)
, (64,   'Horatio',      7)
, (71,   'Zorba',        10)
, (75,   'David',        8)
, (74,   'Horatio',      9)
, (85,   'Art',          3)
, (95,   'Bob',          3);

INSERT INTO boat VALUES(101,	'Interlake',	'blue')
,(102,	'Sunset',	'red')
,(103,	'Clipper',	'green')
,(104,	'Marine',	'red')
,(105,    'Indianapolis',     'blue');


INSERT INTO reserves VALUES(22,	101,	'Monday')
,(22,	102,	'Tuesday')
,(22,	103,	'Wednesday')
,(22,	105,	'Wednesday')
,(31,	102,	'Thursday')
,(31,	103,	'Friday')
,(31, 104,	'Saturday')
,(64,	101,	'Sunday')
,(64,	102,	'Monday')
,(74,	102,	'Saturday');







\qecho 'Question 2.1'
select s.sid,s.rating from sailor s;


\qecho 'Question 2.2'
select * from sailor s
where (s.rating>=2 and s.rating<8) or 
(s.rating>10 and s.rating<=11);

\qecho 'Question 2.3'
select distinct b.* 
from sailor s, reserves r, boat b
where s.sid=r.sid and r.bid=b.bid and 
b.color<>'red' and s.rating>7;


\qecho 'Question 2.4'
select b.bid,b.bname from boat b where b.bid in
(select distinct r.bid
from reserves r 
where r.day in ('Saturday','Sunday'))
and b.bid not in
(select distinct r.bid
from reserves r 
where r.day in ('Tuesday'));


\qecho 'Question 2.5'
select distinct r.sid from reserves r, boat b
where r.bid=b.bid and b.color = 'red'
and r.sid in
(select r1.sid from reserves r1, boat b1
where r1.bid=b1.bid and b1.color = 'green');


\qecho 'Question 2.6'
select distinct s.sid, s.sname from reserves r1, reserves r2, sailor s
where r1.sid=r2.sid and r1.bid<>r2.bid and r1.sid=s.sid;


\qecho 'Question 2.7'
select distinct r1.sid,r2.sid from reserves r1, reserves r2
where r1.sid<>r2.sid and r1.bid=r2.bid;


\qecho 'Question 2.8'
select distinct s.sid from sailor s
where s.sid not in
(select r.sid from reserves r
where r.day in ('Monday','Tuesday'));


\qecho 'Question 2.9'
select r.sid,b.bid from reserves r, sailor s, boat b
where s.sid=r.sid and b.bid=r.bid
and s.rating>6 and b.color<>'red';


\qecho 'Question 2.10'
select b.bid from boat b
where b.bid not in
(select r1.bid from reserves r1, reserves r2
where r1.bid=r2.bid and r1.sid<>r2.sid);


\qecho 'Question 2.11'
select s.sid from sailor s
where s.sid not in 
(select r1.sid from reserves r1, reserves r2, reserves r3
where r1.sid=r2.sid and r1.sid=r3.sid
and r1.bid<>r2.bid and r1.bid<>r3.bid and r2.bid<>r3.bid);










--Connect to default database
\c postgres;






--Drop database which you created
DROP DATABASE assignment1jashjeet;
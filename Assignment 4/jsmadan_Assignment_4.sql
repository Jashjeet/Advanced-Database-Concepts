--\i C:/Users/jashj/OneDrive/'Semester 2'/'Advanced Database Concepts'/'Assignment 4'/'jsmadan_Assignment_4.sql'


-- Creating database
CREATE DATABASE assignment4jashjeet;

--Connecting database 
\c assignment4jashjeet; 


--Table Creation Statements
/*
create table Student(sid integer,sname text,primary key(sid));
create table Course(cno int,cname text,total integer,max int,primary key(cno));
create table Prerequisite(cno integer,prereq integer,foreign key(cno) references Course(cno),foreign key(prereq) references Course(cno));
create table HasTaken(sid integer,cno integer,foreign key(sid) references Student(sid),foreign key(cno) references Course(cno));
create table Enroll(sid integer,cno integer,foreign key(sid) references Student(sid),foreign key(cno) references Course(cno));
create table Waitlist(sid integer,cno integer,position integer ,foreign key(sid) references Student(sid),foreign key(cno) references Course(cno));
*/

create table Student(sid integer,sname text, major text);
create table Course(cno int,cname text,total integer,max int);
create table Prerequisite(cno integer,prereq integer);
create table HasTaken(sid integer,cno integer);
create table Enroll(sid integer,cno integer);
create table Waitlist(sid integer,cno integer,pos integer);

-- Data insertion for relation.
INSERT INTO Course values (201,'Programming',0,3),
(202,'Calculus',0,3),
(203,'Probability',0,3),
(204,'AI',0,2),
(301,'DiscreteMathematics',0,2),
(302,'OS',0,2),
(303,'Databases',0,2),
(401,'DataScience',0,2),
(402,'Networks',0,2),
(403,'Philosophy',1,2);

INSERT INTO Prerequisite values(301,201),
(301,202),
(302,201),
(302,202),
(302,203),
(401,301),
(401,204),
(402,302);

INSERT INTO Student values(1,'Jean','CS'),
(2,'Eric','Math'),
(3,'Ahmed','Math'),
(4,'Qin','Math'),
(5,'Filip','CS'),
(6,'Pam','Math'),
(7,'Lisa','CS');

INSERT INTO Hastaken values(1,201),
(1,202),
(1,301),
(2,201),
(2,202),
(3,201),
(4,201),
(4,202),
(4,203),
(4,204),
(5,201),
(5,202),
(5,301),
(5,204);
;


insert into enroll values(2,403);


\qecho 'Question 1'
\qecho 'Part (a)'
--creating Triggers


/* Constraint verification */

--Student
CREATE OR REPLACE FUNCTION check_Student_pkey_constraint_fn() RETURNS trigger AS
$$
BEGIN
 IF NEW.sid IN (SELECT sid FROM Student) THEN
    RAISE EXCEPTION 'sid already exist';
 END IF;
 IF NEW.sid is null THEN
    RAISE EXCEPTION 'sid is null';
 END IF;
 RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER check_Student_pkey_constraint_trg
 BEFORE INSERT
 ON Student 
 FOR EACH ROW
 EXECUTE PROCEDURE check_Student_pkey_constraint_fn();


insert into student values (1001,'sumeet','DS');

insert into student values (null,'sumeet','DS');




--Course
CREATE OR REPLACE FUNCTION check_Course_pkey_constraint_fn() RETURNS trigger AS
$$
BEGIN
 IF NEW.cno IN (SELECT cno FROM Course) THEN
    RAISE EXCEPTION 'course no. already exist';
 END IF;
 IF NEW.cno is null THEN
    RAISE EXCEPTION 'course no. is null';
 END IF;
 RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER check_Course_pkey_constraint_trg
 BEFORE INSERT
 ON Course 
 FOR EACH ROW
 EXECUTE PROCEDURE check_Course_pkey_constraint_fn();


insert into course values (3000, 'Statistics', 30,30);

insert into course values (null, 'Statistics', 30,30);

\qecho 'Part (b)'
----------------------------

--Error while inserting in Prerequisite table as records do not exist in Course table

CREATE OR REPLACE FUNCTION check_Prerequisite_fkey_constraint_fn() RETURNS trigger AS
$$
BEGIN
 IF NEW.cno not IN (SELECT cno FROM Course) THEN
    RAISE EXCEPTION 'course no. does not exist in Course';
 END IF;
 IF NEW.prereq not IN (SELECT cno FROM Course) THEN
    RAISE EXCEPTION 'prereq no. does not exist in Course';
 END IF;
 RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER check_Prerequisite_fkey_constraint_trg
 BEFORE INSERT
 ON Prerequisite 
 FOR EACH ROW
 EXECUTE PROCEDURE check_Prerequisite_fkey_constraint_fn();

--foreign key referential integrity constraint gets voilated as 205 does not exist in course
insert into prerequisite  values(205,302);



-----------------------------------------------------------------


--Error while inserting in HasTaken table as records do not exist in Course table or Student table


CREATE OR REPLACE FUNCTION check_HasTaken_fkey_constraint_fn() RETURNS trigger AS
$$
BEGIN
 IF NEW.cno not IN (SELECT cno FROM Course) THEN
    RAISE EXCEPTION 'course no. does not exist in Course';
 END IF;
 IF NEW.sid not IN (SELECT sid FROM Student) THEN
    RAISE EXCEPTION 'sid does not exist in Student';
 END IF;
 RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER check_HasTaken_fkey_constraint_trg
 BEFORE INSERT
 ON HasTaken 
 FOR EACH ROW
 EXECUTE PROCEDURE check_HasTaken_fkey_constraint_fn();


--foreign key referential integrity constraint gets voilated as sid=99 and cno =205 does not exist in student and course respectively
insert into hastaken  values(99,205);

--------------------------------------------------------------------

--Error while inserting in Enroll table as records do not exist in Course table or Student table


CREATE OR REPLACE FUNCTION check_Enroll_fkey_constraint_fn() RETURNS trigger AS
$$
BEGIN
 IF NEW.cno not IN (SELECT cno FROM Course) THEN
    RAISE EXCEPTION 'course no. does not exist in Course';
 END IF;
 IF NEW.sid not IN (SELECT sid FROM Student) THEN
    RAISE EXCEPTION 'sid does not exist in Student';
 END IF;
 RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER check_Enroll_fkey_constraint_trg
 BEFORE INSERT
 ON Enroll 
 FOR EACH ROW
 EXECUTE PROCEDURE check_Enroll_fkey_constraint_fn();
 
 --foreign key referential integrity constraint gets voilated as sid=99 and cno =205 does not exist in student and course respectively
insert into enroll values(99,205);
 
 ---------------------------------------------------------------------------

--Error while inserting in Waitlist table as records do not exist in Course table or Student table



CREATE OR REPLACE FUNCTION check_Waitlist_fkey_constraint_fn() RETURNS trigger AS
$$
BEGIN
 IF NEW.cno not IN (SELECT cno FROM Course) THEN
    RAISE EXCEPTION 'course no. does not exist in Course';
 END IF;
 IF NEW.sid not IN (SELECT sid FROM Student) THEN
    RAISE EXCEPTION 'sid does not exist in Student';
 END IF;
 RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER check_Waitlist_fkey_constraint_trg
 BEFORE INSERT
 ON Waitlist 
 FOR EACH ROW
 EXECUTE PROCEDURE check_Waitlist_fkey_constraint_fn();
 
  --foreign key referential integrity constraint gets voilated as sid=99 and cno =205 does not exist in student and course respectively
insert into waitlist values(99,205,1);
 
-----------------------------------------------------------------------------


--cascade delete
-- To delete a record from Student table, first we need to delete all the records from child tables, Enroll, and Waitlist
--Then we will delete from the parent table Student


 
 
CREATE OR REPLACE FUNCTION delete_cascade_Student_fn() RETURNS trigger AS
$$
BEGIN
IF OLD.sid IN (SELECT sid FROM Enroll) THEN
    DELETE from Enroll p where p.sid=OLD.sid;
 END IF;
IF OLD.sid IN (SELECT sid FROM Waitlist) THEN
    DELETE from Waitlist p where p.sid=OLD.sid;
 END IF;
 RETURN OLD;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER delete_cascade_Student_trg
 BEFORE DELETE
 ON Student 
 FOR EACH ROW
 EXECUTE PROCEDURE delete_cascade_Student_fn();
 
 
 delete from student where sid=1;
 
 
 \qecho 'now sid =1 will not be reflected in child tables containing sid as foreign key'
 \qecho 'enroll table'
 table enroll;
 
 \qecho 'hastaken table'
 table hastaken;
 
 \qecho 'waitlist table'
 table waitlist;
 
-----------------------------------------------------------------------------------------------------
--Cascade delete
-- To delete a record from Course table, first we need to delete all the records from child tables, Prerequisite, Enroll, and Waitlist
--Then we will delete from the parent table Course

CREATE OR REPLACE FUNCTION delete_cascade_Course_fn() RETURNS trigger AS
$$
BEGIN
 IF OLD.cno IN (SELECT cno FROM Prerequisite) THEN
    DELETE from Prerequisite p where p.cno=OLD.cno;
 END IF;
 IF OLD.cno IN (SELECT prereq FROM Prerequisite) THEN
    DELETE from Prerequisite p where p.prereq=OLD.cno;
 END IF;
 IF OLD.cno IN (SELECT cno FROM Enroll) THEN
    DELETE from Enroll p where p.cno=OLD.cno;
 END IF;
 IF OLD.cno IN (SELECT cno FROM Waitlist) THEN
    DELETE from Waitlist p where p.cno=OLD.cno;
 END IF;
 RETURN OLD;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER delete_cascade_Course_trg
 BEFORE DELETE
 ON Course 
 FOR EACH ROW
 EXECUTE PROCEDURE delete_cascade_Course_fn();
 
 delete from course where cno=201;
 
 \qecho 'now cno =201 will not be reflected in child tables containing cno as foreign key'
 \qecho 'enroll table'
 table enroll;
 
 \qecho 'hastaken table is exception as it is a historical table'
 table hastaken;
 
 \qecho 'waitlist table'
 table waitlist;
 
 \qecho 'prerequisite table'
 
 table prerequisite;
 
 
\qecho 'Part (c)'




CREATE OR REPLACE FUNCTION delete_HasTaken_notallowed_fn() RETURNS trigger AS
$$
BEGIN
 RAISE EXCEPTION 'Deletion not allowed in HasTaken table';
 RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER delete_HasTaken_notallowed_trg
 BEFORE DELETE
 ON HasTaken 
 FOR EACH ROW
 EXECUTE PROCEDURE delete_HasTaken_notallowed_fn();
 
 
 
 
CREATE OR REPLACE FUNCTION update_HasTaken_notallowed_fn() RETURNS trigger AS
$$
BEGIN
 RAISE EXCEPTION 'Updation not allowed in HasTaken table';
 RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER update_HasTaken_notallowed_trg
 BEFORE UPDATE
 ON HasTaken 
 FOR EACH ROW
 EXECUTE PROCEDURE update_HasTaken_notallowed_fn();
 
 
 \qecho 'hastaken update or delete will not take place'
 
 update hastaken set cno=201 where sid=1; 
 delete from hastaken where sid=1;


create table boolean_insert_Enroll(flag_value boolean);
 
insert into boolean_insert_Enroll values (False);
 



CREATE OR REPLACE FUNCTION flag_value_insert_Enroll_fn() RETURNS trigger AS
$$
BEGIN
update boolean_insert_Enroll 
set flag_value=True
where flag_value=False;
 RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';




CREATE TRIGGER flag_value_insert_Enroll_trg
 BEFORE INSERT
 ON Enroll 
 EXECUTE PROCEDURE flag_value_insert_Enroll_fn();








 
CREATE OR REPLACE FUNCTION insert_HasTaken_notallowed_Enrollment_fn() RETURNS trigger AS
$$
BEGIN
if (select flag_value from boolean_insert_Enroll a where a.flag_value=True) THEN
 RAISE EXCEPTION 'Insertion in HasTaken not allowed because Enrollment is in progress';
 END IF;
 RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER insert_HasTaken_notallowed_Enrollment_trg
 BEFORE INSERT
 ON HasTaken 
 FOR EACH ROW
 EXECUTE PROCEDURE insert_HasTaken_notallowed_Enrollment_fn();

\qecho 'After enrollment begins' 
 insert into enroll values (2,203);

\qecho 'No insert on hastaken allowed'
insert into  hastaken values(1,203);


 
\qecho 'Part (d)'






CREATE OR REPLACE FUNCTION delete_Prerequisite_notallowed_fn() RETURNS trigger AS
$$
BEGIN
 RAISE EXCEPTION 'Deletion not allowed in Prerequisite table';
 RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER delete_Prerequisite_notallowed_trg
 BEFORE DELETE
 ON Prerequisite 
 FOR EACH ROW
 EXECUTE PROCEDURE delete_Prerequisite_notallowed_fn();









CREATE OR REPLACE FUNCTION delete_Course_notallowed_fn() RETURNS trigger AS
$$
BEGIN
 RAISE EXCEPTION 'Deletion not allowed in Course table';
 RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER delete_Course_notallowed_trg
 BEFORE DELETE
 ON Course 
 FOR EACH ROW
 EXECUTE PROCEDURE delete_Course_notallowed_fn();
 
 
 
 
CREATE OR REPLACE FUNCTION update_Prerequisite_notallowed_fn() RETURNS trigger AS
$$
BEGIN
 RAISE EXCEPTION 'Updation not allowed in Prerequisite table';
 RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER update_Prerequisite_notallowed_trg
 BEFORE UPDATE
 ON Prerequisite 
 FOR EACH ROW
 EXECUTE PROCEDURE update_Prerequisite_notallowed_fn();
 


delete from boolean_insert_Enroll;
 
insert into boolean_insert_Enroll values (False);

\qecho 'After enrollment begins'
insert into enroll values (1,403);


\qecho 'Prerequisite cannot be updated'

insert into prerequisite values (402, 202);




CREATE OR REPLACE FUNCTION insert_Prereq_notallowed_Enrollment_fn() RETURNS trigger AS
$$
BEGIN
if (select flag_value from boolean_insert_Enroll a where a.flag_value=True) THEN
 RAISE EXCEPTION 'Insertion in Prerequisite not allowed because Enrollment is in progress';
 END IF;
 RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER insert_Prereq_notallowed_Enrollment_trg
 BEFORE INSERT
 ON Prerequisite 
 FOR EACH ROW
 EXECUTE PROCEDURE insert_Prereq_notallowed_Enrollment_fn();
 
 
 
 
 
CREATE OR REPLACE FUNCTION insert_Course_notallowed_Enrollment_fn() RETURNS trigger AS
$$
BEGIN
if (select flag_value from boolean_insert_Enroll a where a.flag_value=True) THEN
 RAISE EXCEPTION 'Insertion in Course not allowed because Enrollment is in progress';
 END IF;
 RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER insert_Course_notallowed_Enrollment_trg
 BEFORE INSERT
 ON Course 
 FOR EACH ROW
 EXECUTE PROCEDURE insert_Course_notallowed_Enrollment_fn();

\qecho 'As enrollment has begun , new course cannot be added now'
insert into course values (501,'Zoology',0,12);

\qecho 'For part 2 we will drop all the tables and reinitialize with previous inserted values'

drop table Student,Course,Prerequisite,HasTaken,Enroll,Waitlist;

create table Student(sid integer,sname text, major text);
create table Course(cno int,cname text,total integer,max int);
create table Prerequisite(cno integer,prereq integer);
create table HasTaken(sid integer,cno integer);
create table Enroll(sid integer,cno integer);
create table Waitlist(sid integer,cno integer,pos integer);

-- Data insertion for relation.
INSERT INTO Course values (201,'Programming',0,3),
(202,'Calculus',0,3),
(203,'Probability',0,3),
(204,'AI',0,2),
(301,'DiscreteMathematics',0,2),
(302,'OS',0,2),
(303,'Databases',0,2),
(401,'DataScience',0,2),
(402,'Networks',0,2),
(403,'Philosophy',1,2);

INSERT INTO Prerequisite values(301,201),
(301,202),
(302,201),
(302,202),
(302,203),
(401,301),
(401,204),
(402,302);

INSERT INTO Student values(1,'Jean','CS'),
(2,'Eric','Math'),
(3,'Ahmed','Math'),
(4,'Qin','Math'),
(5,'Filip','CS'),
(6,'Pam','Math'),
(7,'Lisa','CS');

INSERT INTO Hastaken values(1,201),
(1,202),
(1,301),
(2,201),
(2,202),
(3,201),
(4,201),
(4,202),
(4,203),
(4,204),
(5,201),
(5,202),
(5,301),
(5,204);



insert into enroll values(2,403);

\qecho 'Question 2'
create or replace function chk_on_Enroll_before_ins_fn()
returns trigger as
$$
declare
temp_val integer;
begin
if exists(select p.prereq from Prerequisite p
		  where p.cno=new.cno
		  except
		  select h.cno from hastaken h 
		  where h.sid=new.sid) then
raise exception 'Not all prerequisites met';
end if;


if exists(select 1 from Course c
		  where c.total=c.max
		 and c.cno=new.cno) then
temp_val=(select count(1) from waitlist w where w.cno=new.cno);

insert into waitlist values(new.sid,new.cno,(temp_val+1));

raise notice 'Maximum Enrollment reached. Placed in Waitlist';

else

update Course
set total=total+1
where cno=new.cno
and total<max;

end if;
return new;
end;
$$ language 'plpgsql';

create trigger chk_on_Enroll_before_ins_trg
before insert on Enroll
for each row
execute procedure chk_on_Enroll_before_ins_fn();

create or replace function chk_on_Enroll_bef_del_fn()
returns trigger as
$$
begin

update Course
set total=total-1
where cno=new.cno;


end;
$$ language 'plpgsql';

create trigger chk_on_Enroll_bef_del_trg
before delete on Enroll
for each row
execute procedure chk_on_Enroll_bef_del_fn();



create or replace function chk_on_Enroll_aft_del_fn()
returns trigger as
$$
begin
if exists(select 1 from waitlist w
		  where w.cno=old.cno) then

insert into Enroll values ((select w.sid from waitlist w
						where w.cno=old.cno
						and w.pos=1),old.cno);

delete from waitlist w where w.cno=old.cno and w.pos=1;
end if;
return null;
end;
$$ language 'plpgsql';

create trigger chk_on_Enroll_aft_del_trg
after delete on Enroll
for each row
execute procedure chk_on_Enroll_aft_del_fn();


select * from waitlist;


create or replace function chk_on_Waitlist_aft_del_fn()
returns trigger as
$$
begin

update waitlist
set pos=pos-1
where cno=old.cno
and pos>old.pos;

return null;
end;
$$ language 'plpgsql';

create trigger chk_on_Waitlist_aft_del_trg
after delete on Waitlist
for each row
execute procedure chk_on_Waitlist_aft_del_fn();

\qecho 'sid=1 cannot take cno=302 as it has not take prerequisite course no 201'
insert into enroll values(1,302);

\qecho 'sid=1 can take course 403 as it has no prerequisite'
insert into enroll values(1,403);

\qecho 'After this insertion for course no 403 , total=max hence next enrollments will be pushed to waitlist'
insert into enroll values(2,403);
insert into enroll values (3,403);

\qecho 'Now sid 2 and 3 are in waitlist with position 1 and 2 respectively'
table waitlist;

\qecho 'If sid=2 drops the course , sid=3 will rise to position 1 in waitlist'
delete from waitlist where sid=2 and cno=403;

table waitlist;




\qecho 'Question 3'








create table probability_table(n_value integer, t_value integer, E_T float(5), V_T float(5));
create or replace view temp_view as select pt.n_value as nv, pt.t_value as tv from probability_table pt;


insert into probability_table values (1,1,1,1);
--drop table probability_table;

create or replace function probability_table_fn()
returns trigger as
$$
declare
et numeric;
vt numeric;

begin
if new.nv=1 then
et=new.tv;
vt=0;
else
et=(select pd.e_t+(new.tv-pd.e_t)/new.nv from probability_table pd );
vt=(select sqrt(((new.nv-1)*pd.v_t*pd.v_t + (new.tv-et)*(new.tv-pd.e_t))/new.nv) from probability_table pd );
end if;

update probability_table
set n_value=new.nv,
t_value=new.tv,
e_t=et,
v_t=vt;

return null;
end;
$$ language 'plpgsql';


create trigger probability_table_trg
instead of insert on temp_view
for each row
execute procedure probability_table_fn();


--drop trigger probability_table_trg on temp_view;





create or replace function runExperiment(n int)
returns record
as
$$
declare
i int;
d1 integer;
d2 integer;
d3 integer;
t integer;
begin
-- code to initialize the experiment;
for i in 1..n loop
d1:=floor(random()*6)+1;
d2:=floor(random()*6)+1;
d3:=floor(random()*6)+1;
t=d1+d2+d3;

-- code to call a trigger on

insert into temp_view values(i,t);
-- throw (floor(random()*6)+1, floor(random()*6)+1, floor(random()*6)+1);

end loop;
return ((select n_value from probability_table),(select e_t from probability_table),(select v_t from probability_table));-- (approximation for E(T), approximation for V(T));
end;
$$ language plpgsql;


select runExperiment(10);
select runExperiment(100);
select runExperiment(1000);
select runExperiment(10000);


--select * from probability_table;





--Connect to default database
\c postgres;


--Drop database which you created
DROP DATABASE assignment4jashjeet;
--\i C:/Users/jashj/OneDrive/'Semester 2'/'Advanced Database Concepts'/'Assignment 7'/'jsmadan_Assignment_7.sql'


-- Creating database
CREATE DATABASE assignment7jashjeet;

--Connecting database 
\c assignment7jashjeet; 


create table enroll(sid text, cno text, grade text);

insert into enroll values 
     ('s100','c200', 'A'),
     ('s100','c201', 'B'),
     ('s100','c202', 'A'),
     ('s101','c200', 'B'),
     ('s101','c201', 'A'),
     ('s102','c200', 'B'),
     ('s103','c201', 'A'),
     ('s101','c202', 'A'),
     ('s101','c301', 'C'),
     ('s101','c302', 'A'),
     ('s102','c202', 'A'),
     ('s102','c301', 'B'),
     ('s102','c302', 'A'),
     ('s104','c201', 'D');


create table course(cno text, cname text, dept text);

insert into course values ('c200','PL','CS'),
('c201','Calculus','Math'),
('c202','Dbs','CS'),
('c301','AI','CS'),
('c302','Logic','Philosophy');



create table student(sid  text, sname  text,  major  text, byear int);
insert into student values('s100','Eric','CS',1987),
('s101','Nick','Math',1990),
('s102','Chris','Biology',1976),
('s103','Dinska','CS',1977),
('s104','Zanna','Math',2000);


CREATE TABLE major (sid text, major text);
INSERT INTO major VALUES ('s100','French'),
('s100','Theater'),
('s100', 'CS'),
('s102', 'CS'),
('s103', 'CS'),
('s103', 'French'),
('s104',  'Dance'),
('s105',  'CS');



\qecho 'Question 1'

\qecho 'Part (a)'

-- creating relation R(a,b,c)
DROP TABLE IF EXISTS R;
create table R (A int, B int, C int);
insert into R values (1,2,3), (4,5,6), (1,2,4), (5,6,7), (8,9,10);

select * from R;


--creating mapper function
CREATE OR REPLACE FUNCTION mapper(KeyIn text, ValueIn jsonb)
RETURNS TABLE (KeyOut jsonb, ValueOut jsonb) AS
$$
SELECT jsonb_build_object('A',ValueIn->'A', 'B', ValueIn->'B'),
		   jsonb_build_object('A',ValueIn->'A', 'B', ValueIn->'B');
$$ LANGUAGE SQL;

--creating reducer function
CREATE OR REPLACE FUNCTION reducer(KeyIn jsonb, ValuesIn jsonb[])
RETURNS TABLE(KeyOut jsonb, ValueOut jsonb) AS
$$
	SELECT KeyIn->'A' as Rkey, KeyIn->'B' as Bkey
$$ LANGUAGE SQL;


WITH
temp_R as (select 'R' as Key, jsonb_build_object('A', r.A, 'B', r.B, 'C', r.C) as Value
                        from   R r),

Map_Phase AS (
    SELECT m.KeyOut, m.ValueOut 
    FROM   temp_R r, LATERAL(SELECT KeyOut, ValueOut FROM mapper(r.key, r.value)) m
),
Group_Phase AS (
    SELECT KeyOut, array_agg(Valueout) as ValueOut
    FROM   Map_Phase
    GROUP  BY (KeyOut)
),
Reduce_Phase AS (
    SELECT r.KeyOut,r.ValueOut
    FROM   Group_Phase gp, LATERAL(SELECT * FROM reducer(gp.KeyOut, gp.ValueOut)) r
)
SELECT keyout as A, valueout as B FROM Reduce_Phase order by 1;

drop table R;

drop function mapper,reducer;




\qecho 'Question 1'

\qecho 'Part (b)'


create table R(A int); create table S(A int);

insert into R values (1),(2),(3),(4);
insert into S values (2),(4),(5);

CREATE or replace FUNCTION mapper(KeyIn int, ValueIn text)
RETURNS TABLE (k jsonb,v jsonb) AS
$$
select jsonb_build_object('Key', KeyIn) as key, jsonb_build_object('Value',ValueIn);
$$ LANGUAGE SQL;


CREATE or replace FUNCTION reducer(KeyIn jsonb, ValueIn jsonb[])
RETURNS TABLE (keyOut jsonb,valueOut Boolean) AS
$$
select KeyIn, (select ValueIn=array['{"Value": "R"}']::jsonb[] as tv)
$$ LANGUAGE SQL;


with
map_phase as (select m.* from R r,lateral mapper(r.a,'R') m
		   union
		   select m.* from S s,lateral mapper(s.a,'S') m),
		   
		   
group_phase as (select m.k as key,array_agg(m.v) as value from map_phase m group by m.k order by 1),


reducer_phase as (select q.*
from group_phase gp,reducer(gp.key,gp.value) q)

select rp.keyout->'Key' R_minus_s from reducer_phase rp where rp.valueout=true;

drop table r,s;
drop function mapper, reducer;





\qecho 'Question 1'

\qecho 'Part (c)'
--help taken from Sumeet

create table r(a int, b int);
create table s(b int, c int);

INSERT INTO r VALUES(1007,2009),
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
(1010,2011);

INSERT INTO s VALUES(2011,2002),
(2011,2007),
(2011,2009),
(2015,2002);




CREATE or replace FUNCTION mapper(KeyIn jsonb, ValueIn text)
RETURNS TABLE (KeyOut jsonb, ValueOut jsonb) AS
$$
select KeyIn as key, jsonb_build_object('Table',ValueIn);
$$ LANGUAGE SQL;


CREATE or replace FUNCTION reducer(KeyIn jsonb, ValueIn jsonb[])
RETURNS TABLE(KeyOut jsonb, ValueOut jsonb[]) AS
$$
SELECT KeyIn,array(select distinct unnest(reducer.ValueIn) order by 1);
$$ LANGUAGE SQL;




with
jr as (select jsonb_build_object('a', A,'b',B) as rval from   r),
js as (select jsonb_build_object('b', B,'c',C) as sval from   s),
mapper_phase as (select jsonb_build_object('a',jr.rval->'a','b',q1.KeyOut) as k,q1.ValueOut from jr, 
			lateral(select m.KeyOut, m.ValueOut from mapper(jr.rval->'b','r'::text) m) q1
		   union
		   select jsonb_build_object('b',q1.KeyOut,'c',js.sval->'c')as k,q1.ValueOut from js, 
			lateral(select m.KeyOut, m.ValueOut from mapper(js.sval->'b','s'::text) m) q1),

grouper_phase as (select m1.k,array_agg(array[m1.ValueOut,t1.ValueOut]) as v from mapper_phase m1, 
			lateral(select m2.ValueOut from mapper_phase m2 where m1.k->'b'=m2.k->'b' and m1.k<>m2.k)t1
		   group by m1.k),
		  		  
reducer_phase as (select *--g.k->'a' as a, g.k->'b' as b
			from grouper_phase gp
			, reducer(gp.k,gp.v) r
			where r.valueout=array['{"Table": "r"}','{"Table": "s"}']::jsonb[]
			and gp.k->'a' is not null and gp.k->'b' is not null)
		select rp.k->'a' a,rp.k->'b' b from reducer_phase rp;



drop table r,s;
drop function mapper, reducer;




\qecho 'Question 1'

\qecho 'Part (d)'


create table R(A int); 
create table S(A int); 
create table T(A int);

insert into R values (1),(2),(3),(4);
insert into S values (2),(3),(5);
insert into T values (1),(6);


CREATE or replace FUNCTION mapper(KeyIn int, ValueIn text)
RETURNS TABLE (keyOut jsonb,valueOut jsonb) AS
$$
select jsonb_build_object('a', KeyIn) as key, jsonb_build_object('rel',ValueIn);
$$ LANGUAGE SQL;


CREATE or replace FUNCTION reducer(keyin jsonb,valuein jsonb[])
RETURNS TABLE(keyout jsonb, valueout Boolean) AS
$$
SELECT keyin->'a',(select valuein=array['{"rel": "r"}']::jsonb[] as tv);
$$ LANGUAGE SQL;


with 
map_phase as (select q1.* from r, lateral(select m.keyOut, m.valueOut from mapper(r.a,'r') m) q1
		   union
		   select q1.* from s, lateral(select m.keyOut, m.valueOut from mapper(s.a,'s') m) q1
		   union
		   select q1.* from t, lateral(select m.keyOut, m.valueOut from mapper(t.a,'t') m) q1),
group_phase as (select m.keyOut as k,array_agg(m.valueOut) as v from map_phase m group by 1),
reducer_phase as (select r.* from group_phase gp,reducer(gp.k,gp.v) r)
				  
select rp.keyout as a from reducer_phase rp where rp.valueout=true;



drop table r,s,t;
drop function mapper, reducer;






\qecho 'Question 2'

create table r(a int, b int);

INSERT INTO r VALUES(1007,2009),
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



CREATE FUNCTION mapper(KeyIn int, ValueIn int)
RETURNS TABLE (KeyOut int, ValueOut jsonb) AS
$$
SELECT KeyIn,jsonb_build_object('b',ValueIn)
$$ LANGUAGE SQL;


CREATE FUNCTION reducer(KeyIn integer, ValueIn jsonb[])
RETURNS TABLE (KeyOut integer, ValueOut jsonb) AS
$$
SELECT KeyIn,jsonb_build_object('Array',ValueIn,'Cardinality',(select cardinality(ValueIn)))
$$ LANGUAGE SQL;



with
map_phase as(select q.keyout,q.valueout from R r, lateral(select * from mapper(r.a,r.b)) q),

group_phase as(select mp.keyout,
			   array_agg(mp.valueout->'b') as Bs
		from map_phase mp
		group by mp.keyout),
		
reduce_phase as(select jsonb_build_object('a',q.keyout,'array_agg', q.valueout->'Array',
								  'cardinality',q.valueout->'Cardinality')	as json_obj	--q.*
					from group_phase gp, lateral(select m.* from reducer(gp.keyout,gp.bs) m)q)
					
	select * from reduce_phase	rp
where (rp.json_obj->'cardinality')::text::numeric>=2;

drop function mapper,reducer;
drop table r;





\qecho 'Question 3'

\qecho 'Part (a)'



create table R(k text, v int);
create table S(k text, w int);

insert into R values ('a', 1),
                     ('a', 2),
                     ('b', 1),
                     ('c', 3);


insert into S values ('a', 1),
                     ('a', 3),
                     ('c', 2),
                     ('d', 1),
                     ('d', 4);




create or replace view cogroup as
(WITH  Kvalues AS (SELECT r.K FROM R r 
                  UNION 
                  SELECT s.K FROM S s),
      R_K AS (SELECT r.K, ARRAY_AGG(r.V) AS RV_values
              FROM   R r
              GROUP BY (r.K)
              UNION 
              SELECT k.K, '{}' AS RV_values 
              FROM   Kvalues k
              WHERE  k.K NOT IN (SELECT r.K FROM R r)),
      S_K AS (SELECT s.K, ARRAY_AGG(s.W) AS SW_values
              FROM   S s
              GROUP BY (K)
              UNION 
              SELECT k.K, '{}' AS SW_values 
              FROM   Kvalues k
              WHERE  k.K NOT IN (SELECT s.K FROM S s)) 

SELECT  K, RV_values, SW_values
FROM    R_K NATURAL JOIN S_K);



select c.k,(c.rv_values,c.sw_values) from cogroup c;




\qecho 'Part (b)'

select c.k,unnest(c.RV_values)
from cogroup c
where c.RV_values<>'{}' and c.SW_values<>'{}';


\qecho 'Part (c)'

select c1.k as rk,c2.k as sk
from cogroup c1 , cogroup c2
where c1.rv_values<@c2.sw_values
and c1.rv_values<>'{}'
order by 1,2;


drop view cogroup;
drop table r,s;


\qecho 'Question 4'



create table a(a int);
create table b(b int);

insert into a values(1),(2),(3),(4),(5);
insert into b values(4),(5),(6),(7),(8);

table a;
table b;

create or replace view ab_cogroup as
with
A_kv as (select a1.a as k,a2.a as v from a a1 natural join a a2),
B_kv as (select b1.b as k,b2.b as v from b b1 natural join b b2),
Kvalues as (select k from A_kv 
			union 
			select k from B_kv),
A_K as (select k,array_agg(v) as AV_values from A_kv group by k
		  union
		  select k,'{}' as a_values from Kvalues where k not in (select k from A_kv)),
B_K as (select k,array_agg(v) as BV_values from B_kv group by k
		  union
		  select k,'{}' as av from Kvalues where k not in (select k from B_kv))		  
select * from A_K natural join B_K;



select c.k,(c.av_values,c.bv_values)
from AB_cogroup c;



\qecho 'Part (a)'

-- using pure sql to verify result
table a
intersect
table b;

-- using cogroups
select c.k
from AB_cogroup c
where c.av_values=c.bv_values;




\qecho 'Part (b)'

-- using pure sql to verify result
table a union table b
except(table a intersect table b);

-- using cogroups
select k from ab_cogroup
where av_values='{}'
union
select k from ab_cogroup
where bv_values='{}';







drop view ab_cogroup;
drop table a,b;


\qecho 'Question 5'

\qecho 'Part (a)'




--given and copied

CREATE TYPE studentType AS (sid text);

CREATE TYPE gradeStudentsType AS (grade text, student studentType[]);

CREATE TABLE courseGrades(cno text, gradeInfo gradeStudentsType[]);

insert into courseGrades
with e as (select cno, grade, array_agg(row(sid)::studentType) as students
           from enroll
           group by (cno, grade)
	   order by 1,2),

     f as (select cno, array_agg(row(grade, students)::gradeStudentsType) as gradeInfo
           from e
           group by (cno))

select * from f order by cno;


select * from courseGrades;





\qecho 'Part (b)'

CREATE TYPE courseType as (cno text);
CREATE TYPE gradeCoursesType AS (grade text, courses courseType[]);

CREATE TABLE studentGrades as
with e as
(select s.sid,gi.grade, array_agg(row(cg.cno)::courseType) as courses
from courseGrades cg,
		unnest(cg.gradeinfo) gi,
				unnest(gi.student) s
group by s.sid, gi.grade
order by 1,2),

f as
(
select sid,array_agg(row(grade, courses)::gradeCoursesType) as gradeInfo
	from e
	group by sid
)
				
select * from f;


select * from studentGrades sg;



\qecho 'Part (c)'

create table jcourseGrades as
with e as  (select cno, grade,
                   array_to_json(array_agg(jsonb_build_object('sid',sid))) as students
            from   enroll
            group by(cno,grade) order by 1,2),

     f as   (select jsonb_build_object('cno', cno, 'gradeInfo', 
       array_to_json(array_agg(jsonb_build_object('grade', grade, 'students', students)))) as studentInfo
             from   e
             group by (cno))
     select  studentInfo from f;

select * from jcourseGrades;



\qecho 'Part (d)'


create table jstudentGrades as
with
e as
(select s->'sid' as sid
	   ,g->'grade' as grade
	   ,array_to_json(array_agg(json_build_object('courses',cg.studentInfo -> 'cno'))) as courses
from jcourseGrades cg,
		jsonb_array_elements(cg.studentInfo -> 'gradeInfo') g,
			jsonb_array_elements(g -> 'students') s
group by(sid,grade)),

f as (select jsonb_build_object('sid', sid, 'gradeInfo', 
       array_to_json(array_agg(jsonb_build_object('grade', grade, 'courses', courses)))) as studentInfo
from e
group by(sid))
select * from f;

select * from jstudentGrades;




\qecho 'Part (e)'

with E as
(select s.sid,s.sname,c.dept
		,array_to_json(array_agg(jsonb_build_object('cno',c.cno,'cname',c.cname))) as courseInfo
            FROM student s, enroll e, course c
			WHERE s.sid=e.sid
			and	e.cno=c.cno
			and s.sid IN (SELECT sid
              			  FROM   major m
              			  WHERE  major = 'CS')
			group by (s.sid,s.sname,c.dept) order by 1,3),
			
F as (select jsonb_build_object('sid',e.sid,'sname',e.sname,'deptInfo', 
								array_to_json(array_agg(jsonb_build_object('dept', dept, 'courseInfo', courseInfo)))) as enrollInfo
             from   e
			 group by (e.sid,e.sname))
			 

			select * from f;



--Connect to default database
\c postgres;


--Drop database which you created
DROP DATABASE assignment7jashjeet;

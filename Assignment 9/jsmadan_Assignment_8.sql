--\i C:/Users/jashj/OneDrive/'Semester 2'/'Advanced Database Concepts'/'Assignment 8'/'jsmadan_Assignment_8.sql'


-- Creating database
CREATE DATABASE assignment8jashjeet;

--Connecting database 
\c assignment8jashjeet; 



\qecho 'Question 1'


drop table if exists tree;
create table Tree(parent int, child int);
insert into tree values (1,2), (1,3), (1,4), (2,5), (2,6), (3,7), (5,8), (7,9), (9,10);


create table anc(a int, d int, distance int);



create or replace function new_ANC_pairs()
returns table (A integer, D integer, distance integer) AS
$$
   (select A, Child, distance+1
    from   ANC JOIN tree ON D = Parent)
   except
   (select  A, D, distance
    from    ANC);
$$ LANGUAGE SQL;


create or replace function Ancestor_Descendant()
returns void as $$
begin
   drop table if exists ANC;   
   create table ANC(A integer, D integer, distance integer);
   
   insert into ANC select parent,child,1 distance from tree;
   
   while exists(select * from new_ANC_pairs()) 
   loop
        insert into ANC select * from new_ANC_pairs();
   end loop;
end;
$$ language plpgsql;



select Ancestor_Descendant();


create table t as
select a v1, d v2, distance from ANC
union
select d,a,distance from anc;



create or replace function distance(m int, n int) 
returns int as
$$
begin
if exists(select 1 from t where v1 = m and v2 = n) then
      return (select distance from t where v1 = m and v2 = n);
    else
      return
	  (select min(t1.distance+t2.distance)
from t t1, t t2
where t1.v2=t2.v1
	   and t1.v1<>t2.v2
	  and t1.v1=m and t2.v2=n);
end if;
end;
$$ language 'plpgsql';


create view v as
select parent vertex
from tree
union
select child 
from tree;


SELECT v1.vertex AS v1, v2.vertex as v2, distance(v1.vertex, v2.vertex) as distance
FROM   V v1, V v2 
WHERE  v1.vertex != v2.vertex ORDER BY 3,1,2;



drop view v;
drop table Tree,t,anc;
drop function distance, Ancestor_Descendant, new_ANC_pairs;















\qecho 'Question 2'

drop table if exists graph;
create table Graph(source int, target int);
insert into graph values (1,2), (1,3), (1,4), (3,4), (2,5), (3,5), (5,4), (3,6), (4,6);


CREATE TABLE tc (
  source       INTEGER,
  target       INTEGER,
  distance     INTEGER
); 




create or replace function new_TC_pairs()
returns table (source integer, target integer, distance integer) AS
$$
(select   TC.source, graph.target, distance+1
 from     TC JOIN graph ON (TC.target = graph.source))
except
(select   source, target,distance
 from     TC);
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION TC ()
RETURNS VOID AS $$
BEGIN
   delete from tc;
   insert into tc select source,target,0 distance from graph;
   WHILE exists(select * from new_TC_pairs()) 
   LOOP
        insert into tc select * from new_TC_pairs();
   END LOOP;
END;
$$ LANGUAGE plpgsql;



select tc();




drop table if exists result;

CREATE TABLE result(
  i       INTEGER,
  vertex       INTEGER
); 




CREATE OR REPLACE FUNCTION topologicalSort()
RETURNS table(i int, vertex int) AS $$
BEGIN

    insert into result select distinct 1 i, t2.source
	from tc t1 right join tc t2 on (t1.target=t2.source)
	WHERE t1.source IS NULL;
	
	
--help taken from Harsha	
    insert into result 
	with tc1 as 
	(select source, target, max(distance) as distance from tc group by 1,2 order by 3) 
	
      select row_number() over ()+1,target from tc1 where source = (select r.vertex from result r);
    return query (select * from result);
END;
$$ LANGUAGE plpgsql;

select *
from topologicalSort();


drop function topologicalSort,tc,new_TC_pairs;
drop table tc,result,graph;










\qecho 'Question 3'



CREATE TABLE IF NOT EXISTS partSubPart(pid INTEGER, sid INTEGER, quantity INTEGER);
DELETE FROM partSubPart;
INSERT INTO partSubPart VALUES
(   1,   2,        4),
(   1,   3,        1),
(   3,   4,        1),
(   3,   5,        2),
(   3,   6,        3),
(   6,   7,        2),
(   6,   8,        3);


CREATE TABLE IF NOT EXISTS basicPart(pid INTEGER, weight INTEGER);
DELETE FROM basicPart;
INSERT INTO basicPart VALUES
(   2,      5),
(   4,     50),
(   5,      3),
(   7,      6),
(   8,     10);

select * from partsubpart;

select * from basicPart;


create table anc(pid int, sid int, quantity int);


create or replace function new_ANC_pairs()
returns table (pid integer, sid integer, quantity integer) AS
$$
   (select anc.pid, sp.sid, anc.quantity*sp.quantity
    from   ANC JOIN partsubpart sp ON anc.sid = sp.pid)
	except
   (select  pid, sid, quantity
    from    ANC);
$$ LANGUAGE SQL;



create or replace function aggregatedWeight(p integer)
returns integer as $$

BEGIN
   delete from anc;

   insert into anc select p.pid,p.sid,p.quantity from partSubPart p;
   
    while exists(select * from new_anc_pairs())
	
	loop
	insert into anc select * from new_anc_pairs();
	end loop;
	
	
	
	return (with q as
	(select b.pid, 0 sid, 1 quantity,b.weight
			from basicpart b
			union
			select a.pid,a.sid,a.quantity,b.weight
			from anc a join basicPart b on (a.sid = b.pid))
	select sum(quantity*weight) from q where q.pid = p);


END;
$$ LANGUAGE plpgsql;



--select aggregatedWeight(1);

select distinct pid, AggregatedWeight(pid)
from   (select pid from partSubPart union select pid from basicPart) q order by 1;


drop table partSubPart,basicPart,anc;
drop function new_ANC_pairs,aggregatedWeight;




\qecho 'Question 4'


drop table if exists documents;
create table documents (doc text, words text[]);

insert into documents values ('d1', '{"A","B","C"}');
insert into documents values ('d2', '{"B","C","D"}');
insert into documents values ('d3', '{"A","E"}');
insert into documents values ('d4', '{"B","B","A","D"}');
insert into documents values ('d5', '{"E","F"}');
insert into documents values ('d6', '{"A","D","G"}');
insert into documents values ('d7', '{"C","B","A"}');
insert into documents values ('d8', '{"B","A"}');

drop view if exists unique_words;

create view unique_words as
(select distinct unnest(d.words) as word
        from   documents d);


-- taken from https://stackoverflow.com/questions/11997037/how-to-write-combinatorics-function-in-postgres
CREATE OR REPLACE FUNCTION combinations(anyarray) RETURNS SETOF anyarray AS $$
WITH RECURSIVE
    items AS (
            SELECT row_number() OVER (ORDER BY item) AS rownum, item
            FROM (SELECT unnest($1) AS item) unnested
    ),
    q AS (
            SELECT 1 AS i, $1[1:0] arr
            UNION ALL
            SELECT (i+1), CASE x
                    WHEN 1 THEN array_append(q.arr,(SELECT item FROM items WHERE rownum = i))
                    ELSE q.arr END
            FROM generate_series(0,1) x CROSS JOIN q WHERE i <= array_upper($1,1)
    )
SELECT q.arr AS mods
FROM q WHERE i = array_upper($1,1)+1;
$$ LANGUAGE 'sql';



drop table if exists all_combinations;

create table all_combinations as
select combinations(array_agg(word)) from unique_words;

drop function if exists frequentsets;

CREATE OR REPLACE FUNCTION frequentSets(t int)
RETURNS table(result1 text[]) AS $$

declare i record;
begin


drop table if exists result;
create table result(sets text[], threshold int);


for i in (select * from all_combinations)
loop

insert into result
select i.combinations,count(1)
from documents d
where i.combinations<@ d.words;

end loop;
  return query (select r.sets from result r where threshold >= t);
end;
$$ LANGUAGE plpgsql;



select frequentsets(1);
select frequentSets(2);
select frequentSets(3);
select frequentSets(4);
select frequentSets(5);
select frequentSets(6);
select frequentSets(7);


drop view unique_words;
drop table documents,all_combinations,result;
drop function combinations,frequentsets;








\qecho 'Question 5'



drop table if exists points;
CREATE TABLE Points (PId INTEGER, X FLOAT, Y FLOAT);


INSERT INTO Points VALUES
(   1 , 0 , 0),
(   2 , 2 , 0),
(   3 , 4 , 0),
(   4 , 6 , 0),
(   5 , 0 , 2),
(   6 , 2 , 2),
(   7 , 4 , 2),
(   8 , 6 , 2),
(   9 , 0 , 4),
(  10 , 2 , 4),
(  11 , 4 , 4),
(  12 , 6 , 4),
(  13 , 0 , 6),
(  14 , 2 , 6),
(  15 , 4 , 6),
(  16 , 6 , 6),
(  17 , 1 , 1),
(  18 , 5 , 1),
(  19 , 1 , 5),
(  20 , 5 , 5);


select * from points;


drop function if exists kmeans;
CREATE OR REPLACE FUNCTION kmeans (k int)
RETURNS table(cluster int, x float, y float) AS $$
declare i integer;
BEGIN

drop table if exists centroids;
create table centroids as
select * from points
order by random() limit k;

drop table if exists clusters;
create table clusters(point int,cluster int,px float, py float);

for j in 1..1000
loop
for i in select pt.pid from points pt
loop
insert into clusters
select pt_pid,c_pid,px,py from (select p.pid as pt_pid, c.pid as c_pid, p.x px, p.y py, sqrt(power(p.x-c.x, 2) + power(p.y - c.y,2))
, min(sqrt(power(p.x-c.x, 2) + power(p.y - c.y,2))) over(partition by p.pid)
from points p , centroids c
where p.pid=i)q
where sqrt=min
limit 1;

end loop;

drop table if exists centroids;
create table centroids as
select c.cluster as pid,sum(px)/count(1) as x,sum(py)/count(1) as y
from clusters c
group by c.cluster;

end loop;
return query(select * from centroids);

end;

$$ LANGUAGE plpgsql;



select * from kmeans(4);



drop table Points, centroids, clusters;
drop function kmeans;

--Connect to default database
\c postgres;


--Drop database which you created
DROP DATABASE assignment8jashjeet;

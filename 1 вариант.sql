--Вариант 1.
--курсоры

-- 1)Явный курсор, показывающий название картины, название музея и адрес музея.
DECLARE
-- объявление курсора
CURSOR show_kartini IS
  select "КАРТИНЫ"."НАЗВАНИЕ" as "НАЗВАНИЕ_КАРТИНЫ",  "МУЗЕИ"."НАЗВАНИЕ" as "НАЗВАНИЕ_МУЗЕЯ", "МУЗЕИ"."ГОРОД" as "ГОРОД","МУЗЕИ"."СТРАНА" as "СТРАНА"
  from "АВТОРЫ" "АВТОРЫ","КАРТИНЫ" "КАРТИНЫ","МУЗЕИ" "МУЗЕИ" 
  where "КАРТИНЫ"."АВТОР"="АВТОРЫ"."КОД_АВТОРА" 
  and "МУЗЕИ"."КОД_МУЗЕЯ"="КАРТИНЫ"."МУЗЕЙ";
BEGIN
-- открытие курсора
  FOR m IN show_kartini LOOP
	dbms_output.put_line(to_char(show_kartini %ROWCOUNT)||' '||m."НАЗВАНИЕ_КАРТИНЫ"||' '|| m."НАЗВАНИЕ_МУЗЕЯ"||' '|| m."ГОРОД" ||' '|| m."СТРАНА");
	END LOOP;
END;

-- 2)Явный курсор, показывающий список картин указанного автора (параметр) в различных музеях
DECLARE
avtor number := 5; --параметр, задающий автора
-- объявление курсора
CURSOR show_kartini IS
  select "АВТОРЫ"."ИМЯ" as "ИМЯ", "АВТОРЫ"."ФАМИЛИЯ" as "ФАМИЛИЯ", "КАРТИНЫ"."НАЗВАНИЕ" as "НАЗВАНИЕ_КАРТИНЫ", "МУЗЕИ"."НАЗВАНИЕ" as "НАЗВАНИЕ_МУЗЕЯ", "МУЗЕИ"."ГОРОД" as "ГОРОД","МУЗЕИ"."СТРАНА" as "СТРАНА"
  from "АВТОРЫ" "АВТОРЫ","КАРТИНЫ" "КАРТИНЫ","МУЗЕИ" "МУЗЕИ" 
  where "КАРТИНЫ"."АВТОР"="АВТОРЫ"."КОД_АВТОРА" 
  and "МУЗЕИ"."КОД_МУЗЕЯ"="КАРТИНЫ"."МУЗЕЙ" and "АВТОРЫ"."КОД_АВТОРА"= avtor;
BEGIN
-- открытие курсора
  FOR m IN show_kartini LOOP
	dbms_output.put_line(to_char(show_kartini %ROWCOUNT)||' Картина автора '||m."ИМЯ"||' '||m."ФАМИЛИЯ"||' '||m."НАЗВАНИЕ_КАРТИНЫ"||' в '|| m."НАЗВАНИЕ_МУЗЕЯ");
	END LOOP;
END;

-- 3)Неявный курсор, возвращающий количество картин указанного автора (параметр). Если картин автора не найдено, то вывести сообщение «Картин такого автора нет в базе данных»
DECLARE
avtor number(2) := 3;
m number(2);
BEGIN
  select count(*) into m from "КАРТИНЫ" where "КАРТИНЫ"."АВТОР"=avtor ;
  IF m=0 then
    dbms_output.put_line('Картин такого автора нет в базе данных');
  ELSE 
    dbms_output.put_line('Количество картин '||m); 
  END IF;    
END;

-- 4)Неявный курсор, переносящий указанную картину (параметр) в указанный музей (параметр)
DECLARE
kartina "КАРТИНЫ"."КОД_КАРТИНЫ"%Type := 1; 
muzei "КАРТИНЫ"."МУЗЕЙ"%Type := 2;
m number;
BEGIN
  Select count(*) into m from "КАРТИНЫ" where "КОД_КАРТИНЫ" = kartina; 
  Update "КАРТИНЫ" Set "МУЗЕЙ" = muzei where "КОД_КАРТИНЫ" = kartina;
    dbms_output.put_line('Картина ' || kartina || ' перенесана в музей ' || muzei);
END;

--Процедуры с исключениями

--1)Процедура, показывающий название картины, название музея и адрес музея
CREATE OR REPLACE PROCEDURE show_kartini -- создание процедуры
AS
-- объявление курсора
CURSOR show_kartini IS
  select "КАРТИНЫ"."НАЗВАНИЕ" as "НАЗВАНИЕ_КАРТИНЫ",  "МУЗЕИ"."НАЗВАНИЕ" as "НАЗВАНИЕ_МУЗЕЯ", "МУЗЕИ"."ГОРОД" as "ГОРОД","МУЗЕИ"."СТРАНА" as "СТРАНА"
  from "АВТОРЫ" "АВТОРЫ","КАРТИНЫ" "КАРТИНЫ","МУЗЕИ" "МУЗЕИ" 
  where "КАРТИНЫ"."АВТОР"="АВТОРЫ"."КОД_АВТОРА" 
  and "МУЗЕИ"."КОД_МУЗЕЯ"="КАРТИНЫ"."МУЗЕЙ";
	net_kartin exception;
BEGIN
-- открытие курсора
  FOR m IN show_kartini LOOP
	dbms_output.put_line(to_char(show_kartini %ROWCOUNT)||' '||m."НАЗВАНИЕ_КАРТИНЫ"||' '|| m."НАЗВАНИЕ_МУЗЕЯ"||' '|| m."ГОРОД" ||' '|| m."СТРАНА");
	END LOOP;
	IF show_kartini%ROWCOUNT=0 then
    RAISE net_kartin;
  END IF;
EXCEPTION 
WHEN net_kartin then dbms_output.put_line('Нет картин в таблице');
WHEN OTHERS then
  dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;

--Вызов процедуры
BEGIN
show_kartini;
END;

--2)Процедура, показывающая список картин указанного автора (параметр) в различных музеях
CREATE OR REPLACE PROCEDURE show_kartini(avtor number) -- создание процедуры
AS
-- объявление курсора
CURSOR show_kartini IS
  select "КАРТИНЫ"."НАЗВАНИЕ" as "НАЗВАНИЕ_КАРТИНЫ",  "МУЗЕИ"."НАЗВАНИЕ" as "НАЗВАНИЕ_МУЗЕЯ", "МУЗЕИ"."ГОРОД" as "ГОРОД","МУЗЕИ"."СТРАНА" as "СТРАНА"
  from "АВТОРЫ" "АВТОРЫ","КАРТИНЫ" "КАРТИНЫ","МУЗЕИ" "МУЗЕИ" 
  where "КАРТИНЫ"."АВТОР"="АВТОРЫ"."КОД_АВТОРА" 
  and "МУЗЕИ"."КОД_МУЗЕЯ"="КАРТИНЫ"."МУЗЕЙ" and "АВТОРЫ"."КОД_АВТОРА"= avtor;
	net_kartin exception;
BEGIN
-- открытие курсора
  FOR m IN show_kartini LOOP
	dbms_output.put_line(to_char(show_kartini %ROWCOUNT)||' '||m."НАЗВАНИЕ_КАРТИНЫ"||' '|| m."НАЗВАНИЕ_МУЗЕЯ"||' '|| m."ГОРОД" ||' '|| m."СТРАНА");
	END LOOP;
	IF show_kartini%ROWCOUNT=0 then
    RAISE net_kartin;
  END IF;
EXCEPTION 
WHEN net_kartin then dbms_output.put_line('Нет картин в таблице');
WHEN OTHERS then
  dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;

--Вызов процедуры
BEGIN
show_kartini(3);
END;

--3)Процедура, возвращающий количество картин указанного автора (параметр). Если картин автора не найдено, то вывести сообщение «Картин такого автора нет в базе данных»
CREATE OR REPLACE PROCEDURE show_kartini(avtor number) -- создание процедуры
AS
m number(2);
net_kartin exception;
BEGIN
  select count(*) into m from "КАРТИНЫ" where "КАРТИНЫ"."АВТОР"=avtor ;
  IF m=0 then
    RAISE net_kartin;
  ELSE 
    dbms_output.put_line('Количество картин '||m); 
  END IF;
EXCEPTION 
WHEN net_kartin then dbms_output.put_line('Нет картин указанного автора в таблице');
WHEN OTHERS then
  dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;

--Вызов процедуры
BEGIN
show_kartini(2);
END;

--4)Процедура, переносящий указанную картину (параметр) в указанный музей (параметр)
CREATE OR REPLACE PROCEDURE show_kartini(kartina number, muzei number) -- создание процедуры
AS
m number(2);
net_kartin exception;
BEGIN
  Select count(*) into m from "КАРТИНЫ" where "КОД_КАРТИНЫ" = kartina;
  IF m>0 then 
    RAISE net_kartin;
  END IF; 
  Update "КАРТИНЫ" Set "МУЗЕЙ" = muzei where "КОД_КАРТИНЫ" = kartina;
    dbms_output.put_line('Картина ' || kartina || ' перенесана в музей ' || muzei);
EXCEPTION 
WHEN net_kartin then dbms_output.put_line('Нет картин указанного автора в таблице');
WHEN OTHERS then
  dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;

--Вызов процедуры
BEGIN
show_kartini(3,4);
END;

--Функция возвращающую дату рождения автора по его коду.
Create or replace FUNCTION get_dr(id number)
RETURN "АВТОРЫ"."ДАТА_РОЖДЕНИЯ"%Type
AS
Sdata "АВТОРЫ"."ДАТА_РОЖДЕНИЯ"%Type;
BEGIN
  SELECT "ДАТА_РОЖДЕНИЯ" INTO Sdata FROM "АВТОРЫ" where КОД_АВТОРА=id;
      RETURN Sdata;
Exception -- обработка системных исключений неявного курсора
    WHEN NO_DATA_FOUND THEN RETURN 'Автор не найден';
END;

SELECT get_dr(1) FROM DUAL;

--Пакеты.

create or replace package Kartini_ as
qq number(4):=0;
Procedure Update_kartina(kartina number, muzei number);
Procedure show_kartini; 
FUNCTION get_dr(id number)
RETURN "АВТОРЫ"."ДАТА_РОЖДЕНИЯ"%Type;
CURSOR show_kartini IS
  select "КАРТИНЫ"."НАЗВАНИЕ" as "НАЗВАНИЕ_КАРТИНЫ",  "МУЗЕИ"."НАЗВАНИЕ" as "НАЗВАНИЕ_МУЗЕЯ", "МУЗЕИ"."ГОРОД" as "ГОРОД","МУЗЕИ"."СТРАНА" as "СТРАНА"
  from "АВТОРЫ" "АВТОРЫ","КАРТИНЫ" "КАРТИНЫ","МУЗЕИ" "МУЗЕИ" 
  where "КАРТИНЫ"."АВТОР"="АВТОРЫ"."КОД_АВТОРА" 
  and "МУЗЕИ"."КОД_МУЗЕЯ"="КАРТИНЫ"."МУЗЕЙ";
end;
---------------------------
create or replace package body Kartini_ as
--процедура, изменяющая музей для картины
Procedure Update_kartina (kartina number, muzei number) as
m number(2);
net_kartin exception;
BEGIN
  Select count(*) into m from "КАРТИНЫ" where "КОД_КАРТИНЫ" = kartina;
  IF m>0 then 
    RAISE net_kartin;
  END IF; 
  Update "КАРТИНЫ" Set "МУЗЕЙ" = muzei where "КОД_КАРТИНЫ" = kartina;
    dbms_output.put_line('Картина ' || kartina || ' перенесана в музей ' || muzei);
EXCEPTION 
WHEN net_kartin then dbms_output.put_line('Нет картин указанного автора в таблице');
WHEN OTHERS then
  dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;
--Процедура, показывающий название картины, название музея и адрес музея
CREATE OR REPLACE PROCEDURE show_kartini -- создание процедуры
AS
CURSOR show_kartini IS
  select "КАРТИНЫ"."НАЗВАНИЕ" as "НАЗВАНИЕ_КАРТИНЫ",  "МУЗЕИ"."НАЗВАНИЕ" as "НАЗВАНИЕ_МУЗЕЯ", "МУЗЕИ"."ГОРОД" as "ГОРОД","МУЗЕИ"."СТРАНА" as "СТРАНА"
  from "АВТОРЫ" "АВТОРЫ","КАРТИНЫ" "КАРТИНЫ","МУЗЕИ" "МУЗЕИ" 
  where "КАРТИНЫ"."АВТОР"="АВТОРЫ"."КОД_АВТОРА" 
  and "МУЗЕИ"."КОД_МУЗЕЯ"="КАРТИНЫ"."МУЗЕЙ";
BEGIN
  FOR m IN show_kartini LOOP
	dbms_output.put_line(to_char(show_kartini %ROWCOUNT)||' '||m."НАЗВАНИЕ_КАРТИНЫ"||' '|| m."НАЗВАНИЕ_МУЗЕЯ"||' '|| m."ГОРОД" ||' '|| m."СТРАНА");
	END LOOP;
END;
-- функция, возвращающая дату рождения автора по его коду.
FUNCTION get_dr(id number)
RETURN "АВТОРЫ"."ДАТА_РОЖДЕНИЯ"%Type
AS
Sdata "АВТОРЫ"."ДАТА_РОЖДЕНИЯ"%Type;
BEGIN
  SELECT "ДАТА_РОЖДЕНИЯ" INTO Sdata FROM "АВТОРЫ" where КОД_АВТОРА=id;
      RETURN Sdata;
Exception -- обработка системных исключений неявного курсора
    WHEN NO_DATA_FOUND THEN RETURN 'Автор не найден';
END;

END Kartini_;

--Табличные триггеры

Create table ARCHIV
(id number,
User_Name varchar2(100),
Action varchar2(10),
DATA_A Date,
Count_Rows number);

CREATE SEQUENCE ARCHIV_seq
  START WITH  1  INCREMENT BY 1	NOCACHE;

create or replace TRIGGER Stud_Archive
AFTER INSERT or UPDATE or DELETE ON АВТОРЫ
FOR EACH ROW
BEGIN
Kartini_.qq:=Kartini_.qq+1; 
END;

create or replace TRIGGER Add_Archive
AFTER INSERT or UPDATE or DELETE ON АВТОРЫ
DECLARE
act VARCHAR2(25);
dat date;
usernm VARCHAR2(25);
crows NUMBER(5);
BEGIN
usernm:= apex_util.get_username(apex_util.get_current_user_id);
IF INSERTING THEN
act:='Insert';
elsif UPDATING then
act:='Update';
else
act:='Delete';
END IF;
Select sysdate into dat from dual;
INSERT INTO ARCHIV(id,User_Name,Action,DATA_A,Count_Rows) VALUES (ARCHIV_seq.nextval,usernm,act,dat,Kartini_.qq);
Kartini_.qq:=0;
END;

create package Kartini_ as
    qq number(4):=0;
end;
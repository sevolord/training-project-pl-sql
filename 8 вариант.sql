/*Вариант 8.
1.	Загрузить скрипт создания БД  «издания_авторы.sql». Схема БД представлена на рисунке 2.  
 
2.	Написать код и скомпилировать следующие курсоры PL/SQL:
1)	Явный курсор, показывающий название, издательство, дату выпуска и для всех изданий*/
DECLARE
CURSOR showizd IS
select "ИЗДАНИЯ".* from "ИЗДАНИЯ";
 BEGIN
    FOR m IN showizd LOOP
	dbms_output.put_line(to_char(showizd%ROWCOUNT)||' '||m.НАЗВАНИЕ||' '|| m.ИЗДАТЕЛЬСТВО||' '|| m.ДАТА_ВЫПУСКА);
	END LOOP;
END;
--2)	Явный курсор, показывающий название, издательство, дату выпуска для всех книг указанного автора (параметр).
DECLARE
kod_avtora number := 1; -- параметр
CURSOR showizdanie IS
select "ИЗДАНИЯ"."НАЗВАНИЕ" as "НАЗВАНИЕ",
    "ИЗДАНИЯ"."ИЗДАТЕЛЬСТВО" as "ИЗДАТЕЛЬСТВО",
    "ИЗДАНИЯ"."ДАТА_ВЫПУСКА" as "ДАТА_ВЫПУСКА" 
 from "АВТОРЫ" "АВТОРЫ",
    "ИЗДАНИЯ_АВТОРЫ" "ИЗДАНИЯ_АВТОРЫ",
    "ИЗДАНИЯ" "ИЗДАНИЯ" 
 where "ИЗДАНИЯ"."КОД_ИЗДАНИЯ"="ИЗДАНИЯ_АВТОРЫ"."КОД_ИЗДАНИЯ"
    and "ИЗДАНИЯ_АВТОРЫ"."КОД_АВТОРА"="АВТОРЫ"."КОД_АВТОРА"
    and "АВТОРЫ"."КОД_АВТОРА" = kod_avtora;
BEGIN
    FOR m IN showizdanie LOOP
	dbms_output.put_line(to_char(showizdanie%ROWCOUNT)||' '||m.НАЗВАНИЕ||' '|| m.ИЗДАТЕЛЬСТВО||' '|| m.ДАТА_ВЫПУСКА);
	END LOOP;
END;
--3)	Неявный курсор, возвращающий количество изданий в базе данных.
DECLARE
num number(2);
BEGIN
    select count(*) into num from "ИЗДАНИЯ";
        dbms_output.put_line('Количество изданий ='||' '||num);
END;
--4)	Неявный курсор, изменяющий стоимость указанного издания (параметр) на новую (параметр)
DECLARE
nomer_izdania "ИЗДАНИЯ"."КОД_ИЗДАНИЯ"%Type := 1; 
novaya_stoimost "ИЗДАНИЯ"."СТОИМОСТЬ"%Type := 100500;
magic number;
BEGIN
    Select count(*) into magic from "ИЗДАНИЯ" where "КОД_ИЗДАНИЯ" =nomer_izdania; -- В переменную magic будет помещено 0- если издание не найдена или 1, если издание есть в БД
    Update "ИЗДАНИЯ" Set "СТОИМОСТЬ" = novaya_stoimost where "КОД_ИЗДАНИЯ" = novaya_stoimost;
        dbms_output.put_line('Издание под номером ' || nomer_izdania || ' теперь стоит ' || novaya_stoimost);
END;

/*
Практическая работа по темам «Процедуры» и «Исключения» .
В качестве индивидуальных заданий по теме Процедуры необходимо переделать индивидуальные задания по теме «Курсоры»  в процедуры. В процедурах должны быть обработаны системные и пользовательские исключения.
*/
--Процедура № 1 
CREATE OR REPLACE PROCEDURE procedura 
AS
    CURSOR showizd IS
    select "ИЗДАНИЯ".* from "ИЗДАНИЯ" ;
    net_izdniy exception;
BEGIN 
    FOR m IN showizd LOOP
	dbms_output.put_line(to_char(showizd%ROWCOUNT)||' '||m.НАЗВАНИЕ||' '|| m.ИЗДАТЕЛЬСТВО||' '|| m.ДАТА_ВЫПУСКА);
	END LOOP;
    IF showizd%ROWCOUNT=0 then
        RAISE net_izdniy;
    END IF;
EXCEPTION 
WHEN net_izdniy then dbms_output.put_line('Нет изданий для отображения');
WHEN OTHERS then
    dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;

--Процедура № 2 
CREATE OR REPLACE PROCEDURE procedura(kod_avtora number := 1)
AS
    CURSOR showizdanie IS
    select "ИЗДАНИЯ"."НАЗВАНИЕ" as "НАЗВАНИЕ",
    "ИЗДАНИЯ"."ИЗДАТЕЛЬСТВО" as "ИЗДАТЕЛЬСТВО",
    "ИЗДАНИЯ"."ДАТА_ВЫПУСКА" as "ДАТА_ВЫПУСКА" 
    from "АВТОРЫ" "АВТОРЫ",
    "ИЗДАНИЯ_АВТОРЫ" "ИЗДАНИЯ_АВТОРЫ",
    "ИЗДАНИЯ" "ИЗДАНИЯ" 
    where "ИЗДАНИЯ"."КОД_ИЗДАНИЯ"="ИЗДАНИЯ_АВТОРЫ"."КОД_ИЗДАНИЯ"
    and "ИЗДАНИЯ_АВТОРЫ"."КОД_АВТОРА"="АВТОРЫ"."КОД_АВТОРА"
    and "АВТОРЫ"."КОД_АВТОРА" = kod_avtora;
    net_izdaniy exception;
BEGIN 
    FOR m IN showizdanie LOOP
	dbms_output.put_line(to_char(showizdanie%ROWCOUNT)||' '||m.НАЗВАНИЕ||' '|| m.ИЗДАТЕЛЬСТВО||' '|| m.ДАТА_ВЫПУСКА);
	END LOOP;
    IF showizdanie%ROWCOUNT=0 then
        RAISE net_izdaniy;
    END IF;
EXCEPTION 
WHEN net_izdaniy then dbms_output.put_line('Нет изданий для отображения');
WHEN OTHERS then
    dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;
--Процедура № 3
CREATE OR REPLACE PROCEDURE procedura 
AS
    num number(2);
    net_izdniy exception;
BEGIN 
    select count(*) into num from "ИЗДАНИЯ";
        dbms_output.put_line('Количество изданий ='||' '||num);
    IF showizd%ROWCOUNT=0 then
        RAISE net_izdniy;
    END IF;
EXCEPTION 
WHEN net_izdniy then dbms_output.put_line('Нет изданий для отображения');
WHEN OTHERS then
    dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;
--Процедура № 4
CREATE OR REPLACE PROCEDURE procedura(nomer_izdania "ИЗДАНИЯ"."КОД_ИЗДАНИЯ"%Type := 1,novaya_stoimost "ИЗДАНИЯ"."СТОИМОСТЬ"%Type := 1500) 
AS
    magic number;
    net_izdniy exception;
BEGIN 
    Select count(*) into magic from "ИЗДАНИЯ" where "КОД_ИЗДАНИЯ" =nomer_izdania; -- В переменную magic будет помещено 0- если издание не найдена или 1, если издание есть в БД
    IF magic=0 then
        RAISE net_izdniy;
    END IF;
    Update "ИЗДАНИЯ" Set "СТОИМОСТЬ" = novaya_stoimost where "КОД_ИЗДАНИЯ" = novaya_stoimost;
        dbms_output.put_line('Издание под номером ' || nomer_izdania || ' теперь стоит ' || novaya_stoimost);    
EXCEPTION 
WHEN net_izdniy then dbms_output.put_line('Нет изданий для отображения');
WHEN OTHERS then
    dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;

/*
Практическая работа Функции.
Вариант 8.
Для Вашей  БД, схема которой  представлена на  рисунке  (скрипт «издания_авторы.sql») напишите функцию, возвращающую название издания по его коду.
 */
Create or replace FUNCTION funkcia(kod number)
RETURN ИЗДАНИЯ.НАЗВАНИЕ%Type
AS
nazvanie ИЗДАНИЯ.НАЗВАНИЕ%Type;
BEGIN
    SELECT НАЗВАНИЕ INTO nazvanie FROM ИЗДАНИЯ where КОД_ИЗДАНИЯ=kod;
    RETURN nazvanie;
Exception -- обработка системных исключений неявного курсора
    WHEN NO_DATA_FOUND THEN RETURN 'Издания с таким кодом не найдено';
END;

/*
Практическая работа Пакеты.
В качестве задания по теме Пакеты необходимо  создать пакет, содержащий  процедуры и  функцию из индивидуальных заданий в соответствующих темах.
*/

CREATE OR REPLACE PACKAGE paket_ as
qq number(4):=0;
Procedure procedura;
FUNCTION funkcia(kod number) RETURN ИЗДАНИЯ.НАЗВАНИЕ%Type;
CURSOR showizd IS select "ИЗДАНИЯ".* from "ИЗДАНИЯ";
end;

create OR REPLACE PACKAGE body paket_ as
PROCEDURE procedura 
AS
    net_izdniy exception;
BEGIN 
    FOR m IN showizd LOOP
	dbms_output.put_line(to_char(showizd%ROWCOUNT)||' '||m.НАЗВАНИЕ||' '|| m.ИЗДАТЕЛЬСТВО||' '|| m.ДАТА_ВЫПУСКА);
	END LOOP;
    IF showizd%ROWCOUNT=0 then
        RAISE net_izdniy;
    END IF;
EXCEPTION 
WHEN net_izdniy then dbms_output.put_line('Нет изданий для отображения');
WHEN OTHERS then
    dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;

FUNCTION funkcia(kod number)
RETURN ИЗДАНИЯ.НАЗВАНИЕ%Type
AS
nazvanie ИЗДАНИЯ.НАЗВАНИЕ%Type;
BEGIN
    SELECT НАЗВАНИЕ INTO nazvanie FROM ИЗДАНИЯ where КОД_ИЗДАНИЯ=kod;
    RETURN nazvanie;
Exception -- обработка системных исключений неявного курсора
    WHEN NO_DATA_FOUND THEN RETURN 'Издания с таким кодом не найдено';
END;

END paket_;


Select paket_.funkcia(2) from dual;

Begin
paket_.procedura;
End;

/*
Практическая работа по теме «Табличные триггеры»
Вариант 8.
Для Вашей  БД, схема которой  представлена на  рисунке  (скрипт «издания_авторы.sql») необходимо отслеживать  все изменения данных в таблице Авторы, записывая в таблицу ARCHIVE   пользователя, который произвел изменения, дату  и время изменения, действие (Insert/Update/Delete)  и количество измененных строк
*/
 
Create table ARCHIVE
(id number,
User_Name varchar2(100),
Action varchar2(10),
DATA_A Date,
Count_Rows number);

CREATE SEQUENCE ARCHIVE_seq
   START  WITH   1    INCREMENT  BY 1	NOCACHE;

create or replace TRIGGER Izdania_avtory_Archive
AFTER INSERT or UPDATE or DELETE ON АВТОРЫ
FOR EACH ROW
BEGIN
paket_.qq:=paket_.qq+1; 
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
INSERT INTO ARCHIVE(id,User_Name,Action,DATA_A,Count_Rows) VALUES (ARCHIVE_seq.nextval,usernm,act,dat,paket_.qq);
paket_.qq:=0;
END;

create or replace  package paket_ as
    qq number(4):=0;
end;
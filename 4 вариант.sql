/*Практическая работа по теме «Курсоры»
Вариант 4.
1.	Загрузить скрипт создания БД  «товары_покупки_покупатели.sql». Схема БД представлена на рисунке 
2.	Написать код и скомпилировать следующие курсоры PL/SQL:
1)	Явный курсор, показывающий фамилию и имя покупателя и количество  различных наименований товара купленных им за все время продаж.*/
DECLARE
-- объявление курсора
CURSOR showpokupatel IS
select "ПОКУПАТЕЛИ"."ФАМИЛИЯ" as "ФАМИЛИЯ",
    "ПОКУПАТЕЛИ"."ИМЯ" as "ИМЯ",
    count("ПОКУПКИ".N_N) as "КОЛИЧЕСТВО КУПЛЕННОГО ТОВАРА"
 from "ПОКУПАТЕЛИ" "ПОКУПАТЕЛИ",
    "ПОКУПКИ" "ПОКУПКИ",
    "ТОВАРЫ" "ТОВАРЫ" 
 where "ПОКУПАТЕЛИ"."КОД_ПОКУПАТЕЛЯ"="ПОКУПКИ"."КОД_ПОКУПАТЕЛЯ"
    and "ПОКУПКИ"."КОД_ТОВАРА"="ТОВАРЫ"."КОД_ТОВАРА"
 group by "ПОКУПАТЕЛИ"."ФАМИЛИЯ", "ПОКУПАТЕЛИ"."ИМЯ";
BEGIN
FOR m IN showpokupatel LOOP
	dbms_output.put_line(to_char(showpokupatel%ROWCOUNT)|| ' '||m."ИМЯ"||' '||m."ФАМИЛИЯ"||' '|| m."КОЛИЧЕСТВО КУПЛЕННОГО ТОВАРА");
END LOOP;
END;
--2)	Явный курсор, показывающий список товаров (название, стоимость),  купленных после указанной даты  (параметр).
DECLARE
Z "ПОКУПКИ"."ДАТА_ПОКУПКИ"%Type:=to_date('09.04.2021', 'DD.MM.YYYY');
CURSOR showtovar IS

select "ТОВАРЫ"."НАЗВАНИЕ" as "НАЗВАНИЕ",
    "ТОВАРЫ"."СТОИМОСТЬ_ЗА_ЕДИНИЦУ" as "СТОИМОСТЬ_ЗА_ЕДИНИЦУ",
    "ПОКУПКИ"."ДАТА_ПОКУПКИ" as "ДАТА_ПОКУПКИ" 
 from "ПОКУПКИ" "ПОКУПКИ",
    "ТОВАРЫ" "ТОВАРЫ" 
 where "ТОВАРЫ"."КОД_ТОВАРА"="ПОКУПКИ"."КОД_ТОВАРА" AND "ПОКУПКИ"."ДАТА_ПОКУПКИ" > z;

BEGIN
FOR m IN showtovar LOOP
	dbms_output.put_line(to_char(showtovar%ROWCOUNT)|| ' '||m."НАЗВАНИЕ"||' '||m."СТОИМОСТЬ_ЗА_ЕДИНИЦУ"||' '|| m."ДАТА_ПОКУПКИ");
END LOOP;
END;
--3)	Неявный курсор, возвращающий количество покупателей в базе данных.
DECLARE
m number(2);
BEGIN
-- если нужно выбрать только одну строку, то можно использовать неявный курсор select … into
select count(*) into m from "ПОКУПАТЕЛИ";
	dbms_output.put_line('Количество покупателей ='||' '||m);
END;
--4)	Неявный курсор, удаляющих из базы данных информацию об указанном покупателе (параметр).
DECLARE
z number:=1; 
n number;
s number;
BEGIN
Select count(*) into n from "ПОКУПКИ" where "ПОКУПКИ"."КОД_ПОКУПАТЕЛЯ"=z;
Delete from "ПОКУПКИ" where "ПОКУПКИ"."КОД_ПОКУПАТЕЛЯ"=z;
Select count(*) into s from "ПОКУПАТЕЛИ" where "КОД_ПОКУПАТЕЛЯ"=z;
Delete from ПОКУПАТЕЛИ where КОД_ПОКУПАТЕЛЯ=z;
dbms_output.put_line('Удален  '||s ||' покупатель(ей)  и  '|| n ||'  его покупок');
END;

/*Практическая работа по темам «Процедуры» и «Исключения» .
Цель работы — формирование умений по разработке процедур в  PL/SQL с обработкой исключительных ситуаций
Задание: создать процедуры без параметра и с параметром, включая обработку пользовательских и системных исключений
Этапы выполнения:
1.	Написать код процедур.
2.	Скомпилировать их.
3.	Удостовериться в корректности выдаваемых результатов.

Замечание: При обработке исключений можно использовать две специальные переменные - SQLCODE и SQLERRM. Первая содержит код ошибки, вторая - имя и описание ошибки
В качестве индивидуальных заданий по теме Процедуры необходимо переделать индивидуальные задания по теме «Курсоры»  в процедуры. В процедурах должны быть обработаны системные и пользовательские исключения.
*/


--1)	
CREATE OR REPLACE PROCEDURE pr_showpokupatel
AS
CURSOR showpokupatel IS
select "ПОКУПАТЕЛИ"."ФАМИЛИЯ" as "ФАМИЛИЯ", "ПОКУПАТЕЛИ"."ИМЯ" as "ИМЯ", count("ПОКУПКИ".N_N) as "КОЛИЧЕСТВО КУПЛЕННОГО ТОВАРА"
from "ПОКУПАТЕЛИ" "ПОКУПАТЕЛИ", "ПОКУПКИ" "ПОКУПКИ","ТОВАРЫ" "ТОВАРЫ" 
where "ПОКУПАТЕЛИ"."КОД_ПОКУПАТЕЛЯ"="ПОКУПКИ"."КОД_ПОКУПАТЕЛЯ"
and "ПОКУПКИ"."КОД_ТОВАРА"="ТОВАРЫ"."КОД_ТОВАРА"
group by "ПОКУПАТЕЛИ"."ФАМИЛИЯ", "ПОКУПАТЕЛИ"."ИМЯ";
net_pokupately exception;
BEGIN    
    FOR m IN showpokupatel LOOP
	dbms_output.put_line(to_char(showpokupatel%ROWCOUNT)|| ' '||m."ИМЯ"||' '||m."ФАМИЛИЯ"||' '|| m."КОЛИЧЕСТВО КУПЛЕННОГО ТОВАРА");
    END LOOP;
    IF showpokupatel%ROWCOUNT=0 then
        RAISE net_pokupately;
    END IF;
EXCEPTION 
WHEN net_pokupately then dbms_output.put_line('Нет такого покупателя');
WHEN OTHERS then
    dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;
--2)
CREATE OR REPLACE PROCEDURE showtovar(Z "ПОКУПКИ"."ДАТА_ПОКУПКИ"%Type:=to_date('09.04.2021', 'DD.MM.YYYY'))
AS
CURSOR showtovar IS
select "ТОВАРЫ"."НАЗВАНИЕ" as "НАЗВАНИЕ","ТОВАРЫ"."СТОИМОСТЬ_ЗА_ЕДИНИЦУ" as "СТОИМОСТЬ_ЗА_ЕДИНИЦУ","ПОКУПКИ"."ДАТА_ПОКУПКИ" as "ДАТА_ПОКУПКИ" 
from "ПОКУПКИ" "ПОКУПКИ", "ТОВАРЫ" "ТОВАРЫ" 
where "ТОВАРЫ"."КОД_ТОВАРА"="ПОКУПКИ"."КОД_ТОВАРА" AND "ПОКУПКИ"."ДАТА_ПОКУПКИ" > z;
net_tovarov exception;
BEGIN    
    FOR m IN showtovar LOOP
	dbms_output.put_line(to_char(showtovar%ROWCOUNT)|| ' '||m."НАЗВАНИЕ"||' '||m."СТОИМОСТЬ_ЗА_ЕДИНИЦУ"||' '|| m."ДАТА_ПОКУПКИ");
    END LOOP;
    IF showtovar%ROWCOUNT=0 then
        RAISE net_tovarov;
    END IF;
EXCEPTION 
WHEN net_tovarov then dbms_output.put_line('Нет такого покупателя');
WHEN OTHERS then
    dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;
--3)	
CREATE OR REPLACE PROCEDURE showtovar
AS
m number(2);
net_tovarov exception;
BEGIN
select count(*) into m from "ПОКУПАТЕЛИ";
	dbms_output.put_line('Количество покупателей ='||' '||m);
    IF m=0 then
        RAISE net_tovarov;
    END IF;
EXCEPTION 
WHEN net_tovarov then dbms_output.put_line('Нет покупателей');
WHEN OTHERS then
    dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;
--4)	
CREATE OR REPLACE PROCEDURE pr_delete_pokupatel(z number:=8)
AS
n number;
s number;
net_pokupatela exception;
BEGIN
Select count(*) into n from "ПОКУПКИ" where "ПОКУПКИ"."КОД_ПОКУПАТЕЛЯ"=z;
Delete from "ПОКУПКИ" where "ПОКУПКИ"."КОД_ПОКУПАТЕЛЯ"=z;
Select count(*) into s from "ПОКУПАТЕЛИ" where "КОД_ПОКУПАТЕЛЯ"=z;
Delete from ПОКУПАТЕЛИ where КОД_ПОКУПАТЕЛЯ=z;
dbms_output.put_line('Удален  '||s ||' покупатель(ей)  и  '|| n ||'  его покупок');
IF s=0 then
    RAISE net_pokupatela;
END IF;
EXCEPTION 
WHEN net_pokupatela then dbms_output.put_line('Нет покупателей');
WHEN OTHERS then
    dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;

/*
Практическая работа Функции.
Цель работы — формирование умений по разработке  и использованию функций  в  PL/SQL
Задание: создать функции, включая обработку исключений 
Вариант 4.
Для Вашей  БД, схема которой  представлена на  рисунке  (скрипт «товары_покупки_покупатели.sql») напишите функцию, возвращающую телефон покупателя по его коду.*/
Create or replace FUNCTION get_telephon(id number)
RETURN "ПОКУПАТЕЛИ"."ТЕЛЕФОН"%Type
AS
Tel  "ПОКУПАТЕЛИ"."ТЕЛЕФОН"%Type;
BEGIN
    SELECT "ТЕЛЕФОН" INTO Tel FROM "ПОКУПАТЕЛИ" where КОД_ПОКУПАТЕЛЯ=id;
            RETURN Tel;
Exception -- обработка системных исключений неявного курсора
        WHEN NO_DATA_FOUND THEN RETURN 'Покупатель не найден';
END;

SELECT get_telephon(1) FROM DUAL;
/*
Практическая работа Пакеты.
Цель работы — формирование умений по разработке пакетов в PL/SQL
Задание: создать спецификацию и тело пакета с написанными в предыдущих заданиях процедур и функций
Этапы выполнения:
1.	Создать спецификацию пакета
2.	Создать тело пакета
3.	Обратиться к одной из функций пакета
4.	Обратиться к одной из процедур пакета
5.	Удостовериться в корректности выдаваемых результатов.
*/
create or replace package Pokupatel_ as
qq number(4):=0;

PROCEDURE showtovar(Z "ПОКУПКИ"."ДАТА_ПОКУПКИ"%Type:=to_date('09.04.2021', 'DD.MM.YYYY'));

FUNCTION get_telephon(id number)
RETURN "ПОКУПАТЕЛИ"."ТЕЛЕФОН"%Type;

CURSOR showpokupatel IS
select "ПОКУПАТЕЛИ"."ФАМИЛИЯ" as "ФАМИЛИЯ", "ПОКУПАТЕЛИ"."ИМЯ" as "ИМЯ", count("ПОКУПКИ".N_N) as "КОЛИЧЕСТВО КУПЛЕННОГО ТОВАРА"
from "ПОКУПАТЕЛИ" "ПОКУПАТЕЛИ", "ПОКУПКИ" "ПОКУПКИ","ТОВАРЫ" "ТОВАРЫ" 
where "ПОКУПАТЕЛИ"."КОД_ПОКУПАТЕЛЯ"="ПОКУПКИ"."КОД_ПОКУПАТЕЛЯ"
and "ПОКУПКИ"."КОД_ТОВАРА"="ТОВАРЫ"."КОД_ТОВАРА"
group by "ПОКУПАТЕЛИ"."ФАМИЛИЯ", "ПОКУПАТЕЛИ"."ИМЯ";
end;


create or replace package body Pokupatel_ as

PROCEDURE showtovar(Z "ПОКУПКИ"."ДАТА_ПОКУПКИ"%Type:=to_date('09.04.2021', 'DD.MM.YYYY'))
AS
CURSOR showtovar IS
select "ТОВАРЫ"."НАЗВАНИЕ" as "НАЗВАНИЕ","ТОВАРЫ"."СТОИМОСТЬ_ЗА_ЕДИНИЦУ" as "СТОИМОСТЬ_ЗА_ЕДИНИЦУ","ПОКУПКИ"."ДАТА_ПОКУПКИ" as "ДАТА_ПОКУПКИ" 
from "ПОКУПКИ" "ПОКУПКИ", "ТОВАРЫ" "ТОВАРЫ" 
where "ТОВАРЫ"."КОД_ТОВАРА"="ПОКУПКИ"."КОД_ТОВАРА" AND "ПОКУПКИ"."ДАТА_ПОКУПКИ" > z;
net_tovarov exception;
BEGIN    
    FOR m IN showtovar LOOP
	dbms_output.put_line(to_char(showtovar%ROWCOUNT)|| ' '||m."НАЗВАНИЕ"||' '||m."СТОИМОСТЬ_ЗА_ЕДИНИЦУ"||' '|| m."ДАТА_ПОКУПКИ");
    END LOOP;
    IF showtovar%ROWCOUNT=0 then
        RAISE net_tovarov;
    END IF;
EXCEPTION 
WHEN net_tovarov then dbms_output.put_line('Нет такого покупателя');
WHEN OTHERS then
    dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;

Create or replace FUNCTION get_telephon(id number)
RETURN "ПОКУПАТЕЛИ"."ТЕЛЕФОН"%Type
AS
Tel  "ПОКУПАТЕЛИ"."ТЕЛЕФОН"%Type;
BEGIN
    SELECT "ТЕЛЕФОН" INTO Tel FROM "ПОКУПАТЕЛИ" where КОД_ПОКУПАТЕЛЯ=id;
            RETURN Tel;
Exception 
        WHEN NO_DATA_FOUND THEN RETURN 'Покупатель не найден';
END;
END Pokupatel_;

--------------------
SELECT Pokupatel_.get_telephon(1) FROM DUAL;

Begin
Pokupatel_.showtovar('09.10.2021');
End;

/*
Практическая работа по теме «Табличные триггеры»
Цель работы — формирование умений по разработке  и использованию табличных триггеров  в  PL/SQL
Вариант 4.
Для Вашей  БД, схема которой  представлена на  рисунке  (скрипт «товары_покупки_покупатели.sql») необходимо отслеживать  все изменения данных в таблице Покупатели, записывая в таблицу ARCHIVE   пользователя, который произвел изменения, дату  и время изменения, действие (Insert/Update/Delete)  и количество измененных строк
*/
Create table ARCHIV
(id number,
User_Name varchar2(100),
Action varchar2(10),
DATA_A Date,
Count_Rows number);

CREATE SEQUENCE ARCHIV_seq
   START  WITH   1    INCREMENT  BY 1	NOCACHE;

create or replace TRIGGER pokupatel_Archive
AFTER INSERT or UPDATE or DELETE ON ПОКУПАТЕЛИ
FOR EACH ROW
BEGIN
Pokupatel_.qq:=Pokupatel_.qq+1; 
END;

create or replace TRIGGER Add_Archive
AFTER INSERT or UPDATE or DELETE ON ПОКУПАТЕЛИ
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
INSERT INTO ARCHIV(id,User_Name,Action,DATA_A,Count_Rows) VALUES (ARCHIV_seq.nextval,usernm,act,dat,Pokupatel_.qq);
Pokupatel_.qq:=0;
END;


create package Pokupatel_ as
        qq number(4):=0;
end;


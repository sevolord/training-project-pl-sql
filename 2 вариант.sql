/*
2 Вариант 
Практическая работа по теме «Курсоры»
Цель работы — формирование умений по разработке неявных и явных курсоров PL/SQL
Задание: реализовать явные курсоры без параметра и с параметром.
Этапы выполнения:
1.	Написать код курсора без параметра и курсора с параметром.
2.	Написать неявный курсор Select… into …
3.	Написать неявный курсор на изменение или удаление данных
4.	Скомпилировать их.
5.	Удостовериться в корректности выдаваемых результатов.
Замечание: неявными курсорами являются команды манипулирования данными (подмножество  DML) INSERT, UPDATE и DELETE, а также конструкция SELECT … INTO…

Индивидуальные задания по теме курсоры

Вариант 2.
1.	Загрузить скрипт создания БД  «Авторы_картины_музеи.sql». Схема БД представлена на рисунке 
2.	Написать код и скомпилировать следующие курсоры PL/SQL:
1)	Явный курсор, показывающий название картины, ее автора.
*/
DECLARE
CURSOR showavtor IS
select * from Картины, Авторы 
where Картины.Автор=Авторы.Код_автора;
BEGIN
    FOR m IN showavtor LOOP
    dbms_output.put_line(to_char(showavtor%ROWCOUNT)||' '||'Картина: '||m.Название||', Автор: '|| m.Имя||' '||m.Фамилия);
    END LOOP;
END;

--2)	Явный курсор, показывающий список картин в указанном музее (параметр)

DECLARE
    museum number := 1; 
    CURSOR showkartina(m number) IS
    select Название from Картины
    where Музей = m;   
BEGIN
    FOR m IN showkartina(museum) LOOP
        dbms_output.put_line(to_char(showkartina%ROWCOUNT)||' '||m.Название);
    END LOOP;
END;

--3)	Неявный курсор, возвращающий количество картин  в указанном музее (параметр). Если такого музея нет, то вывести сообщение «Такого музея нет в базе данных»
DECLARE
museum number(2) := 1;
m number(2);
BEGIN
  select count(*) into m from "КАРТИНЫ" where "КАРТИНЫ"."МУЗЕЙ"=museum ;
        case
        when m!=0 then
        dbms_output.put_line('Количество картин ='||' '||m);
        else 
        dbms_output.put_line('Такого музея нет в базе данных');
        end case;    
END;

--4)	Неявный курсор, изменяющий стоимость указанной картины (параметр) на новую (параметр)
DECLARE
kartina number:=5;
new_price number:=100500;
 
BEGIN
    update Картины set Стоимость=new_price where Код_картины=kartina;
    if sql%found then
    dbms_output.put_line(to_char(sql%ROWCOUNT)||' '||'Стоимость изменена');  
    end if;    
END;

/*Практическая работа по темам «Процедуры» и «Исключения»
Цель работы — формирование умений по разработке процедур в PL/SQL с обработкой исключительных ситуаций
Задание: создать процедуры без параметра и с параметром, включая обработку пользовательских и системных исключений
Этапы выполнения:
1.	Написать код процедур.
2.	Скомпилировать их.
3.	Удостовериться в корректности выдаваемых результатов.
В качестве индивидуальных заданий по теме Процедуры необходимо переделать индивидуальные задания по теме «Курсоры» в процедуры. В процедурах должны быть обработаны системные и пользовательские исключения.
1)	процедура, показывающий название картины, ее автора.*/
create or replace PROCEDURE kartina_showavtor As
CURSOR showavtor IS
select * from Картины, Авторы 
where Картины.Автор=Авторы.Код_автора;
BEGIN
    FOR m IN showavtor LOOP
    dbms_output.put_line(to_char(showavtor%ROWCOUNT)||' '||'Картина: '||m.Название||', Автор: '|| m.Имя||' '||m.Фамилия);
    END LOOP;
END;

--2)	процедура, показывающий список картин в указанном музее (параметр)
CREATE OR REPLACE PROCEDURE show_kartini(museum  number) 
AS
CURSOR show_kartini IS
  select "КАРТИНЫ"."НАЗВАНИЕ" as "НАЗВАНИЕ_КАРТИНЫ",  "МУЗЕИ"."НАЗВАНИЕ" as "НАЗВАНИЕ_МУЗЕЯ", "МУЗЕИ"."ГОРОД" as "ГОРОД","МУЗЕИ"."СТРАНА" as "СТРАНА"
  from "АВТОРЫ" "АВТОРЫ","КАРТИНЫ" "КАРТИНЫ","МУЗЕИ" "МУЗЕИ" 
  where "КАРТИНЫ"."АВТОР"="АВТОРЫ"."КОД_АВТОРА" 
  and "МУЗЕИ"."КОД_МУЗЕЯ"="КАРТИНЫ"."МУЗЕЙ" and "КАРТИНЫ"."МУЗЕЙ"= museum ;
	net_kartin exception;
BEGIN
  FOR m IN show_kartini LOOP
	dbms_output.put_line(to_char(show_kartini %ROWCOUNT)||' '||m."НАЗВАНИЕ_КАРТИНЫ"||' '|| m."НАЗВАНИЕ_МУЗЕЯ"||' '|| m."ГОРОД" ||' '|| m."СТРАНА");
	END LOOP;
	IF show_kartini%ROWCOUNT=0 then
    RAISE net_kartin;
  END IF;
EXCEPTION 
WHEN net_kartin then dbms_output.put_line('Нет картин в музее');
WHEN OTHERS then
  dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;

--3)	процедура,, возвращающий количество картин  в указанном музее (параметр). Если такого музея нет, то вывести сообщение «Такого музея нет в базе данных»
CREATE OR REPLACE PROCEDURE showkartina_museum (museum  number) 
AS
m number(2);
net_kartin exception;
BEGIN
  select count(*) into m from "КАРТИНЫ" where "КАРТИНЫ"."МУЗЕЙ"=museum  ;
  IF m=0 then
    RAISE net_kartin;
  ELSE 
    dbms_output.put_line('Количество картин '||m); 
  END IF;
EXCEPTION 
WHEN net_kartin then dbms_output.put_line(‘Такого музея нет в базе данных’);
WHEN OTHERS then
  dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;

--4)	процедура, изменяющий стоимость указанной картины (параметр) на новую (параметр)

CREATE OR REPLACE PROCEDURE new_price_kartina (kartina number, new_price number) AS
 No_kartina exception;
BEGIN
    update Картины set Стоимость=new_price where Код_картины=kartina;
    if sql%found then
    dbms_output.put_line(to_char(sql%ROWCOUNT)||' '||'Стоимость изменена');  
     else
     raise No_kartina;
    end if;   
    exception
    when No_kartina then
     dbms_output.put_line(to_char(sql%ROWCOUNT)||' '||'Не найден код картины');
    WHEN OTHERS then
     dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;

/*Практическая работа Функции.
Цель работы — формирование умений по разработке  и использованию функций  в  PL/SQL
Задание: создать функции, включая обработку исключений 

Вариант 2.
Для Вашей  БД, схема которой  представлена на  рисунке  (скрипт «Авторы_картины_музеи.sql») напишите функцию, возвращающую название музея по его коду. */


Create or replace FUNCTION get_name_museum(kod number)
RETURN Музеи.Название%Type
AS
name_museum Музеи.Название%Type;
BEGIN
 SELECT Название INTO name_museum FROM Музеи where Код_музея=kod;
 RETURN name_museum;
Exception 
 WHEN NO_DATA_FOUND THEN RETURN 'Музей не найден';
 WHEN others THEN raise_application_error(-20001, 'функция возвращает много строк');
END;


/*Практическая работа Пакеты.
Цель работы — формирование умений по разработке пакетов в  PL/SQL
Задание: создать спецификацию и тело пакета с написанными в предыдущих заданиях процедур и функций
Этапы выполнения:
1.	Создать спецификацию пакета
2.	Создать тело пакета
3.	Обратиться к одной из функций пакета
4.	Обратиться к одной из процедур пакета
5.	Удостовериться в корректности выдаваемых результатов.*/

create or replace package Kartini_Avtory_musei as
qq number(4):=0;
Procedure new_price_kartina (kartina number, new_price number
Procedure kartina_showavtor ; 
FUNCTION get_name_museum(kod number)
    RETURN Музеи.Название%Type;
CURSOR showavtor IS
    select * from Картины, Авторы 
    where Картины.Автор=Авторы.Код_автора;
end;
---------------------------
create or replace package body Kartini_Avtory_musei as
-- процедура, изменяющий стоимость указанной картины (параметр) на новую (параметр)
CREATE OR REPLACE PROCEDURE new_price_kartina (kartina number, new_price number) AS
 No_kartina exception;
BEGIN
    update Картины set Стоимость=new_price where Код_картины=kartina;
    if sql%found then
    dbms_output.put_line(to_char(sql%ROWCOUNT)||' '||'Стоимость изменена');  
     else
     raise No_kartina;
    end if;   
    exception
    when No_kartina then
     dbms_output.put_line(to_char(sql%ROWCOUNT)||' '||'Не найден код картины');
    WHEN OTHERS then
     dbms_output.put_line('ORA Error NUM: '|| SQLCODE || 'ORA Error MSG: '|| SQLERRM);
END;

--1)	процедура, показывающий название картины, ее автора.
create or replace PROCEDURE kartina_showavtor As
CURSOR showavtor IS
select * from Картины, Авторы 
where Картины.Автор=Авторы.Код_автора;
BEGIN
    FOR m IN showavtor LOOP
    dbms_output.put_line(to_char(showavtor%ROWCOUNT)||' '||'Картина: '||m.Название||', Автор: '|| m.Имя||' '||m.Фамилия);
    END LOOP;
END;

-- функция, возвращающую название музея по его коду.
Create or replace FUNCTION get_name_museum(kod number)
RETURN Музеи.Название%Type
AS
name_museum Музеи.Название%Type;
BEGIN
 SELECT Название INTO name_museum FROM Музеи where Код_музея=kod;
 RETURN name_museum;
Exception 
 WHEN NO_DATA_FOUND THEN RETURN 'Музей не найден';
 WHEN others THEN raise_application_error(-20001, 'функция возвращает много строк');
END;

END Kartini_Avtory_musei;

/*Практическая работа по теме «Табличные триггеры»

Цель работы — формирование умений по разработке  и использованию табличных триггеров  в  PL/SQL
Вариант 2.
Для Вашей  БД, схема которой  представлена на  рисунке  (скрипт «Авторы_картины_музеи.sql») необходимо отслеживать  все изменения данных в таблице Музеи, записывая в таблицу ARCHIVE   пользователя, который произвел изменения, дату  и время изменения, действие (Insert/Update/Delete)  и количество измененных строк
*/


-----Создание таблицы, в которую будут протоколироваться действия
Create table MUSEUM_ARCHIV
(id number,
User_Name varchar2(100),
Action varchar2(10),
DATA_A Date,
Count_Rows number);
--- Создание последовательности для нумерации в таблице MUSEUM_ARCHIV
CREATE SEQUENCE MUSEUM_ARCHIV_seq
 START WITH 1 INCREMENT BY 1 NOCACHE;
-----Строковый триггер для подсчета количества записей, попавших по действие команды
create or replace TRIGGER Musm_Archive
AFTER INSERT or UPDATE or DELETE ON МУЗЕИ
FOR EACH ROW
BEGIN
Kartini_Avtory_musei.qq:=Kartini_Avtory_musei.qq+1; 
END;
----Операторный триггер для добавления записи в архив
create or replace TRIGGER Add_Archive
AFTER INSERT or UPDATE or DELETE ON МУЗЕИ
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
INSERT INTO MUSEUM_ARCHIV(id,User_Name,Action,DATA_A,Count_Rows) VALUES (MUSM_ARC
HIV_seq.nextval,usernm,act,dat,Kartini_Avtory_musei.qq);
Kartini_Avtory_musei.qq:=0;
END;
----Создание пакета с глобальной переменной. Нужно создавать, если Вы не делали этого
ранее
create package Kartini_Avtory_musei as
 --объявление глобальной переменной
 qq number(4):=0;
end;







create table издания (
    код_издания number(10),
    название varchar2(1000),
    автор varchar2(1000),
    жанр varchar2(1000),
    год_издания number(4),
    издательство varchar2(1000),
    PRIMARY KEY (код_издания)
);

create table читатели (
    код_читателя number(10),
    фамилия varchar2(100),
    имя varchar2(100),
    N_группы number(4),
    PRIMARY KEY (код_читателя)
);

create table издания_читатели (
    N_n number(10),
    код_издания number(10),
    код_читателя number(10),
    дата_выдачи date,
    дата_возврата date,
    PRIMARY KEY (N_n),
    FOREIGN KEY (код_издания) REFERENCES издания(код_издания),
    FOREIGN KEY (код_читателя) REFERENCES читатели(код_читателя)
);

INSERT INTO издания (код_издания, название, автор, жанр, год_издания, издательство) VALUES (1, 'Слон', 'Лебедев Михаил', 'детектив', 2010, 'АСТ');
INSERT INTO издания (код_издания, название, автор, жанр, год_издания, издательство) VALUES (2, 'Любимые сказки', 'Лебедев Михаил', 'детская литература', 2015, 'АСТ');
INSERT INTO издания (код_издания, название, автор, жанр, год_издания, издательство) VALUES (3, 'Дом № 16', 'Романова Маргорита', 'детектив', 2018, 'АСТ');
INSERT INTO издания (код_издания, название, автор, жанр, год_издания, издательство) VALUES (4, 'Наша история', 'Лебедева Мария', 'роман', 2020, 'Мир книги');
INSERT INTO издания (код_издания, название, автор, жанр, год_издания, издательство) VALUES (5, 'Лучшее время', 'Иванов Михаил', 'роман', 2018, 'Мир книги');
INSERT INTO издания (код_издания, название, автор, жанр, год_издания, издательство) VALUES (6, 'Время', 'Блестнин Иван', 'детектив', 2017,'АСТ');
INSERT INTO издания (код_издания, название, автор, жанр, год_издания, издательство) VALUES (7, 'Он знает весь мир', 'Кириллов Александр', 'детектив', 2018, 'Свет');
INSERT INTO издания (код_издания, название, автор, жанр, год_издания, издательство) VALUES (8, 'Новые приключения Незнайки', 'Лиловская Анна', 'детская литература', 2012, 'АСТ');
INSERT INTO издания (код_издания, название, автор, жанр, год_издания, издательство) VALUES (9, 'Приплыли', 'детектив', 'Терновый Михаил', 2002,'Свет');
INSERT INTO издания (код_издания, название, автор, жанр, год_издания, издательство) VALUES (10, 'Колобок', 'Терновый Михаил', 'детская литература', 2001, 'Свет');

INSERT INTO читатели (код_читателя, фамилия, имя, N_группы) VALUES (1, 'Герасимов', 'Александр', 1011);
INSERT INTO читатели (код_читателя, фамилия, имя, N_группы) VALUES (2, 'Васильев', 'Аркадий', 1012);
INSERT INTO читатели (код_читателя, фамилия, имя, N_группы) VALUES (3, 'Федоров', 'Аркадий', 2031);
INSERT INTO читатели (код_читателя, фамилия, имя, N_группы) VALUES (4, 'Пупочкин', 'Аркадий', 2013);
INSERT INTO читатели (код_читателя, фамилия, имя, N_группы) VALUES (5, 'Курочкина', 'Анна', 2013);
INSERT INTO читатели (код_читателя, фамилия, имя, N_группы) VALUES (6, 'Семакина', 'Анна', 2013);
INSERT INTO читатели (код_читателя, фамилия, имя, N_группы) VALUES (7, 'Семакин', 'Валерий', 1011);
INSERT INTO читатели (код_читателя, фамилия, имя, N_группы) VALUES (8, 'Кнут', 'Иван', 1012);

INSERT INTO издания_читатели (N_n, код_издания, код_читателя, дата_выдачи, дата_возврата) VALUES (1, 1, 1, '01/01/2021', '02/01/2021');
INSERT INTO издания_читатели (N_n, код_издания, код_читателя, дата_выдачи, дата_возврата) VALUES (2, 2, 1, '01/01/2021', '07/15/2021');
INSERT INTO издания_читатели (N_n, код_издания, код_читателя, дата_выдачи, дата_возврата) VALUES (3, 2, 6, '02/01/2022', null);
INSERT INTO издания_читатели (N_n, код_издания, код_читателя, дата_выдачи, дата_возврата) VALUES (4, 6, 8, '03/17/2022', '03/29/2022');
INSERT INTO издания_читатели (N_n, код_издания, код_читателя, дата_выдачи, дата_возврата) VALUES (5, 5, 2, '01/01/2022', null);
INSERT INTO издания_читатели (N_n, код_издания, код_читателя, дата_выдачи, дата_возврата) VALUES (6, 5, 3, '01/14/2022', null);
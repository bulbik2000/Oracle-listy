create table Funkcje(
    funkcja varchar2(10) constraint fun_pk primary key,
    min_myszy number(3) constraint min_msz check (min_myszy>5),
    max_myszy number(3) constraint max_msz_1 check (200>max_myszy),
    constraint max_msz_2 check (max_myszy>=min_myszy)
);
create table Wrogowie(
    imie_wroga varchar2(15) constraint imie_wr_pk PRIMARY KEY,
    stopien_wrogosci number(2) constraint st_wr_ch check (stopien_wrogosci>=1 and stopien_wrogosci<=10),
    gatunek varchar2(15),
    lapowka varchar2(20)
);


create table Bandy(
    nr_bandy number(2) constraint band_pk primary key,
    nazwa varchar2(20) constraint nazwa_nn NOT NULL,
    teren varchar2(15) constraint nazwa_un UNIQUE,
    szef_bandy varchar2(15) constraint sz_band_un UNIQUE
);



create table Kocury(
    imie varchar2(15) constraint imie_nn NOT NULL,
    plec varchar2(1) constraint plec_ch CHECK(plec IN ('D','M')),
    pseudo varchar2(15) constraint pseudo_pk PRIMARY KEY CONSTRAINT szef_fk REFERENCES Kocury(pseudo),
    funkcja varchar2(10) CONSTRAINT funk_fk REFERENCES Funkcje(funkcja),
    szef varchar2(15),
    w_statku_od DATE default SYSDATE,
    przydzial_myszy number(3),
    myszy_extra number(3),
    nr_bandy number(2)CONSTRAINT band_fk REFERENCES Bandy(nr_bandy)
);

ALTER TABLE Bandy
ADD CONSTRAINT koc_fk
FOREIGN KEY (szef_bandy) REFERENCES Kocury(pseudo);


create table Wrogowie_Kocurow(
    pseudo varchar2(15) constraint pseudo_fk references Kocury(pseudo),
    imie_wroga varchar2(15) constraint im_wr_fk references Wrogowie(imie_wroga),
    data_incydentu date constraint data_inc_nn not null,
    opis_incydentu varchar2(50),
    CONSTRAINT wr_koc_pk PRIMARY KEY (pseudo,imie_wroga)
);

INSERT ALL
  INTO Wrogowie(imie_wroga,stopien_wrogosci,gatunek,lapowka) VALUES ('KAZIO',10,'CZLOWIEK','FLASZKA')
  INTO Wrogowie(imie_wroga,stopien_wrogosci,gatunek,lapowka) VALUES ('GLUPIA ZOSKA',1,'CZLOWIEK','KORALIK')
    INTO Wrogowie(imie_wroga,stopien_wrogosci,gatunek,lapowka) VALUES ('SWAWOLNY DYZIO',7,'CZLOWIEK','GUMA DO ZUCIA')
    INTO Wrogowie(imie_wroga,stopien_wrogosci,gatunek,lapowka) VALUES ('BUREK',4,'PIES','KOSC')
    INTO Wrogowie(imie_wroga,stopien_wrogosci,gatunek,lapowka) VALUES ('DZIKI BILL',10,'PIES',NULL)
    INTO Wrogowie(imie_wroga,stopien_wrogosci,gatunek,lapowka) VALUES ('REKSIO',2,'PIES','KOSC')
    INTO Wrogowie(imie_wroga,stopien_wrogosci,gatunek,lapowka) VALUES ('BETHOVEN',1,'PIES','PEDIGRIPALL')
    INTO Wrogowie(imie_wroga,stopien_wrogosci,gatunek,lapowka) VALUES ('CHYTRUSEK',5,'LIS','KURCZAK')
    INTO Wrogowie(imie_wroga,stopien_wrogosci,gatunek,lapowka) VALUES ('SMUKLA',1,'SOSNA',NULL)
    INTO Wrogowie(imie_wroga,stopien_wrogosci,gatunek,lapowka) VALUES ('BAZYLI',3,'KOGUT','KURA DO STADA')
SELECT * FROM dual;


INSERT ALL
  INTO funkcje(funkcja,min_myszy,max_myszy) VALUES ('SZEFUNIO',90,110)
  INTO funkcje(funkcja,min_myszy,max_myszy) VALUES ('BANDZIOR',70,90)
  INTO funkcje(funkcja,min_myszy,max_myszy) VALUES ('LOWCZY',60,70)
  INTO funkcje(funkcja,min_myszy,max_myszy) VALUES ('LAPACZ',50,60)
  INTO funkcje(funkcja,min_myszy,max_myszy) VALUES ('KOT',40,50)
  INTO funkcje(funkcja,min_myszy,max_myszy) VALUES ('MILUSIA',20,30)
  INTO funkcje(funkcja,min_myszy,max_myszy) VALUES ('DZIELCZY',45,55)
  INTO funkcje(funkcja,min_myszy,max_myszy) VALUES ('HONOROWA',6,25)
SELECT * FROM dual;

ALTER TABLE Kocury DISABLE CONSTRAINT band_fk;

INSERT ALL
  INTO Kocury(imie,plec,pseudo,funkcja,szef,w_statku_od,przydzial_myszy,myszy_extra,nr_bandy) VALUES ('JACEK','M','PLACEK','LOWCZY','LYSY','2008-12-01',67,NULL,2)
  INTO Kocury(imie,plec,pseudo,funkcja,szef,w_statku_od,przydzial_myszy,myszy_extra,nr_bandy) VALUES ('BARI','M','RURA','LAPACZ','LYSY','2009-09-01',56,NULL,2)
  INTO Kocury(imie,plec,pseudo,funkcja,szef,w_statku_od,przydzial_myszy,myszy_extra,nr_bandy)  VALUES ('MICKA','D','LOLA','MILUSIA','TYGRYS','2009-10-14',25,47,1)
  INTO Kocury(imie,plec,pseudo,funkcja,szef,w_statku_od,przydzial_myszy,myszy_extra,nr_bandy)  VALUES ('LUCEK','M','ZERO','KOT','KURKA','2010-03-01',43,NULL,3)
  INTO Kocury(imie,plec,pseudo,funkcja,szef,w_statku_od,przydzial_myszy,myszy_extra,nr_bandy) VALUES ('SONIA','D','PUSZYSTA','MILUSIA','ZOMBI','2010-11-18',20,35,3)
  INTO Kocury(imie,plec,pseudo,funkcja,szef,w_statku_od,przydzial_myszy,myszy_extra,nr_bandy) VALUES ('LATKA','D','UCHO','KOT','RAFA','2011-01-01',40,NULL,4)
  INTO Kocury(imie,plec,pseudo,funkcja,szef,w_statku_od,przydzial_myszy,myszy_extra,nr_bandy) VALUES ('DUDEK','M','MALY','KOT','RAFA','2011-05-15',40,NULL,4)
  INTO Kocury(imie,plec,pseudo,funkcja,szef,w_statku_od,przydzial_myszy,myszy_extra,nr_bandy) VALUES ('MRUCZEK','M','TYGRYS','SZEFUNIO',NULL,'2002-01-01',103,33,1)
  INTO Kocury(imie,plec,pseudo,funkcja,szef,w_statku_od,przydzial_myszy,myszy_extra,nr_bandy) VALUES ('CHYTRY','M','BOLEK','DZIELCZY','TYGRYS','2002-05-05',50,NULL,1)
  INTO Kocury(imie,plec,pseudo,funkcja,szef,w_statku_od,przydzial_myszy,myszy_extra,nr_bandy) VALUES ('KOREK','M','ZOMBI','BANDZIOR','TYGRYS','2004-03-16',75,13,3)
  INTO Kocury(imie,plec,pseudo,funkcja,szef,w_statku_od,przydzial_myszy,myszy_extra,nr_bandy) VALUES ('BOLEK','M','LYSY','BANDZIOR','TYGRYS','2006-08-15',72,21,2)
  INTO Kocury(imie,plec,pseudo,funkcja,szef,w_statku_od,przydzial_myszy,myszy_extra,nr_bandy) VALUES ('ZUZIA','D','SZYBKA','LOWCZY','LYSY','2006-07-21',65,NULL,2)
  INTO Kocury(imie,plec,pseudo,funkcja,szef,w_statku_od,przydzial_myszy,myszy_extra,nr_bandy) VALUES ('RUDA','D','MALA','MILUSIA','TYGRYS','2006-09-17',22,42,1)
  INTO Kocury(imie,plec,pseudo,funkcja,szef,w_statku_od,przydzial_myszy,myszy_extra,nr_bandy) VALUES ('PUCEK','M','RAFA','LOWCZY','TYGRYS','2006-10-15',65,NULL,4)
  INTO Kocury(imie,plec,pseudo,funkcja,szef,w_statku_od,przydzial_myszy,myszy_extra,nr_bandy) VALUES ('PUNIA','D','KURKA','LOWCZY','ZOMBI','2008-01-01',61,NULL,3)
  INTO Kocury(imie,plec,pseudo,funkcja,szef,w_statku_od,przydzial_myszy,myszy_extra,nr_bandy) VALUES ('BELA','D','LASKA','MILUSIA','LYSY','2008-02-01',24,28,2)
  INTO Kocury(imie,plec,pseudo,funkcja,szef,w_statku_od,przydzial_myszy,myszy_extra,nr_bandy) VALUES ('KSAWERY','M','MAN','LAPACZ','RAFA','2008-07-12',51,NULL,4)
  INTO Kocury(imie,plec,pseudo,funkcja,szef,w_statku_od,przydzial_myszy,myszy_extra,nr_bandy) VALUES ('MELA','D','DAMA','LAPACZ','RAFA','2008-11-01',51,NULL,4)
SELECT * FROM dual;

INSERT ALL
  INTO Bandy(nr_bandy,nazwa,teren,szef_bandy) VALUES (1,'SZEFOSTWO','CALOSC','TYGRYS')
  INTO Bandy(nr_bandy,nazwa,teren,szef_bandy) VALUES (2,'CZARNI RYCERZE','POLE','LYSY')
  INTO Bandy(nr_bandy,nazwa,teren,szef_bandy) VALUES (3,'BIALI LOWCY','SAD','ZOMBI')
  INTO Bandy(nr_bandy,nazwa,teren,szef_bandy) VALUES (4,'LACIACI MYSLIWI','GORKA','RAFA')
  INTO Bandy(nr_bandy,nazwa,teren,szef_bandy) VALUES (5,'ROCKERSI','ZAGRODA',NULL)
SELECT * FROM dual;

ALTER TABLE Kocury ENABLE CONSTRAINT band_fk;



INSERT ALL
  INTO Wrogowie_Kocurow(pseudo,imie_wroga,data_incydentu,opis_incydentu) VALUES ('TYGRYS','KAZIO','2004-10-13','USILOWAL NABIC NA WIDLY')
  INTO Wrogowie_Kocurow(pseudo,imie_wroga,data_incydentu,opis_incydentu) VALUES ('ZOMBI','SWAWOLNY DYZIO','2005-03-07','WYBIL OKO Z PROCY')
  INTO Wrogowie_Kocurow(pseudo,imie_wroga,data_incydentu,opis_incydentu) VALUES ('BOLEK','KAZIO','2005-03-29','POSZCZUL BURKIEM')
  INTO Wrogowie_Kocurow(pseudo,imie_wroga,data_incydentu,opis_incydentu) VALUES ('SZYBKA','GLUPIA ZOSKA','2006-09-12','UZYLA KOTA JAKO SCIERKI')
  INTO Wrogowie_Kocurow(pseudo,imie_wroga,data_incydentu,opis_incydentu) VALUES ('MALA','CHYTRUSEK','2007-03-07','ZALECAL SIE')
  INTO Wrogowie_Kocurow(pseudo,imie_wroga,data_incydentu,opis_incydentu) VALUES ('TYGRYS','DZIKI BILL','2007-06-12','USILOWAL POZBAWIC ZYCIA')
  INTO Wrogowie_Kocurow(pseudo,imie_wroga,data_incydentu,opis_incydentu) VALUES ('BOLEK','DZIKI BILL','2007-11-10','ODGRYZL UCHO')
  INTO Wrogowie_Kocurow(pseudo,imie_wroga,data_incydentu,opis_incydentu) VALUES ('LASKA','DZIKI BILL','2008-12-12','POGRYZL ZE LEDWO SIE WYLIZALA')
  INTO Wrogowie_Kocurow(pseudo,imie_wroga,data_incydentu,opis_incydentu) VALUES ('LASKA','KAZIO','2009-01-07','ZLAPAL ZA OGON I ZROBIL WIATRAK')
  INTO Wrogowie_Kocurow(pseudo,imie_wroga,data_incydentu,opis_incydentu) VALUES ('DAMA','KAZIO','2009-02-07','CHCIAL OBEDRZEC ZE SKORY')
  INTO Wrogowie_Kocurow(pseudo,imie_wroga,data_incydentu,opis_incydentu) VALUES ('MAN','REKSIO','2009-04-14','WYJATKOWO NIEGRZECZNIE OBSZCZEKAL')
  INTO Wrogowie_Kocurow(pseudo,imie_wroga,data_incydentu,opis_incydentu) VALUES ('LYSY','BETHOVEN','2009-05-11','NIE PODZIELIL SIE SWOJA KASZA')
  INTO Wrogowie_Kocurow(pseudo,imie_wroga,data_incydentu,opis_incydentu) VALUES ('RURA','DZIKI BILL','2009-09-03','ODGRYZL OGON')
  INTO Wrogowie_Kocurow(pseudo,imie_wroga,data_incydentu,opis_incydentu) VALUES ('PLACEK','BAZYLI','2010-07-12','DZIOBIAC UNIEMOZLIWIL PODEBRANIE KURCZAKA')
  INTO Wrogowie_Kocurow(pseudo,imie_wroga,data_incydentu,opis_incydentu) VALUES ('PUSZYSTA','SMUKLA','2010-11-19','OBRZUCILA SZYSZKAMI')
  INTO Wrogowie_Kocurow(pseudo,imie_wroga,data_incydentu,opis_incydentu) VALUES ('KURKA','BUREK','2010-12-14','POGONIL')
  INTO Wrogowie_Kocurow(pseudo,imie_wroga,data_incydentu,opis_incydentu) VALUES ('MALY','CHYTRUSEK','2011-07-13','PODEBRAL PODEBRANE JAJKA')
  INTO Wrogowie_Kocurow(pseudo,imie_wroga,data_incydentu,opis_incydentu) VALUES ('UCHO','SWAWOLNY DYZIO','2011-07-14','OBRZUCIL KAMIENIAMI')
SELECT * FROM dual;


--zad1

select imie_wroga "wrog", opis_incydentu "przewina"
from wrogowie_kocurow
where EXTRACT(YEAR FROM data_incydentu) = 2009;

--zad2

select imie ,funkcja  ,w_statku_od "z nami od"
from kocury
where plec = 'D' AND
w_statku_od >= DATE '2005-09-01' and w_statku_od <= DATE '2007-07-31';


--zad3

select imie_wroga "wrog" ,gatunek  , stopien_wrogosci
from wrogowie
where lapowka is null
order by stopien_wrogosci;


--zad4

SELECT imie||
          ' zwany '||pseudo||
          ' (fun. '||funkcja || ') lowi myszki w bandzie ' 
          || nr_bandy || ' od ' || w_statku_od "Wszystko o kocurach"
FROM Kocury
WHERE plec='M'
order BY w_statku_od desc,pseudo;


--zad5

SELECT pseudo, 
REGEXP_REPLACE(REGEXP_REPLACE(pseudo,'A','#',1,1),'L','%',1,1) 
"Po wymianie A na # oraz L na %" 
FROM Kocury;






--zad6
SELECT imie, 
w_statku_od "W statku", 
CEIL(NVL(przydzial_myszy,0/1.1)) "Zjadal",
ADD_MONTHS(w_statku_od,6) "Podwyzka",
NVL(przydzial_myszy,0) "Zjada" 
FROM Kocury
where add_months(w_statku_od,144) <= Date '2021-07-05'
and extract (month from w_statku_od) between 3 and 9;

--Zad7.

SELECT imie,
NVL(przydzial_myszy,0)*3 "Myszy kwartalne",
NVL(myszy_extra,0)*3 "Kwartalne dodatki"
FROM Kocury
WHERE NVL(przydzial_myszy,0) >=55 AND NVL(przydzial_myszy,0)>2* NVL(myszy_extra,0);


--zad8
SELECT imie, 
    CASE
        WHEN (NVL(przydzial_myszy,0)+NVL(myszy_extra,0))*12 = 660 THEN 'Limit'
        WHEN (NVL(przydzial_myszy,0)+NVL(myszy_extra,0))*12 > 660 
        THEN TO_CHAR((NVL(przydzial_myszy,0)+NVL(myszy_extra,0))*12)
        ELSE 'Ponizej 660'
    END "Zjada rocznie"
FROM Kocury;

--Zad9.1)

SElECT pseudo, w_statku_od "W statku", 
    CASE
        WHEN NEXT_DAY(LAST_DAY('2021-10-26')-7,3) >= '2021-10-26' THEN  
        CASE  
            WHEN EXTRACT(day from w_statku_od)<=15 THEN NEXT_DAY(LAST_DAY('2021-10-26')-7,'WEDNESDAY')
            ELSE NEXT_DAY(LAST_DAY(ADD_MONTHS('2021-10-26',1))-7,'WEDNESDAY')
        END
    ELSE NEXT_DAY(LAST_DAY(ADD_MONTHS('2021-10-26',1))-7,'WEDNESDAY')
END "Wyplata"
FROM Kocury
ORDER BY w_statku_od;

--Zad9.2)

SElECT pseudo, w_statku_od "W statku", 
    CASE
        WHEN NEXT_DAY(LAST_DAY('2021-10-28')-7,'WEDNESDAY') >= '2021-10-28' THEN  
        CASE  
            WHEN EXTRACT(day from w_statku_od)<=15 THEN NEXT_DAY(LAST_DAY('2021-10-28')-7,'WEDNESDAY')
            ELSE NEXT_DAY(LAST_DAY(ADD_MONTHS('2021-10-28',1))-7,'WEDNESDAY')
        END
    ELSE NEXT_DAY(LAST_DAY(ADD_MONTHS('2021-10-28',1))-7,'WEDNESDAY')
END "Wyplata"
FROM Kocury
ORDER BY w_statku_od;

--Zad10.1)

select 
    case count(pseudo)
        when 1 then pseudo || '- unikalny'
        else pseudo || '- nieunikalny'
        end "Unikalnosc atr. pseudo"
from Kocury 
group by pseudo
order by pseudo;

--Zad10.2)
select * from kocury;
select
    case count(*)
        when 1 then szef || '- unikalny'
        else szef || '- nieunikalny'
        end "Unikalnosc atr. szef"
from Kocury 
group by szef
order by szef;


--Zad11.

select pseudo "pseudonim", count(imie_wroga) "Liczba wrogow"
from wrogowie_kocurow
group by pseudo
having count(imie_wroga)>=2;





--Zad12.

select 
    'Liczba kotow= ' || count(*) ||
    ' lowi jako ' || funkcja ||
    ' i zjada max ' || TO_CHAR(MAX(NVL(przydzial_myszy,0)+ NVL(myszy_extra,0))) || 
    ' myszy mieiecznie'
from kocury
where funkcja <> 'Szefunio'
and plec <> 'M'
group by funkcja
having AVG(NVL(przydzial_myszy,0)+ NVL(myszy_extra,0))>50;

--Zad13.

select nr_bandy "Nr bandy", 
       plec "Plec", 
       MIN(NVL(przydzial_myszy,0)+ NVL(myszy_extra,0)) "Min przydzial myszy"
from kocury
group by nr_bandy,plec;


--Zad14.

SELECT LEVEL "Poziom", pseudo "Pseudonim", 
funkcja "Funkcja", nr_bandy "Nr bandy"
FROM Kocury
WHERE plec  = 'M'
CONNECT BY PRIOR pseudo = szef
START WITH funkcja = 'BANDZIOR';

--Zad15.

SELECT
  LPAD(TO_CHAR(LEVEL - 1), (LEVEL - 1) * 4 + 1, '===>') || '        ' || imie "Hierarchia",
  NVL(szef, 'Sam sobie panem') "Pseudo szefa",
  funkcja "Funkcja"
FROM Kocury
WHERE myszy_extra > 0
CONNECT BY PRIOR pseudo = szef
START WITH szef IS NULL;




--Zad16.

SELECT RPAD(' ', 4 * (LEVEL - 1), ' ') || pseudo "Droga sluzbowa"
FROM Kocury
CONNECT BY PRIOR szef = pseudo
START WITH EXTRACT(YEAR FROM w_statku_od) < EXTRACT(YEAR FROM TO_DATE('2021-07-05')) - 12
           AND plec = 'M'
           AND myszy_extra IS NULL;


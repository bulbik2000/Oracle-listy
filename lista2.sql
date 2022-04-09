Zad17.

select K.pseudo "Poluje w polu",K.przydzial_myszy, B.nazwa "Banda"
from Kocury K
     join Bandy B on K.nr_bandy = B.nr_bandy
where Teren in ('POLE','CALOSC') and K.przydzial_myszy>50
order by K.przydzial_myszy desc;

Zad18.

select K1.imie, K1.w_statku_od "Poluje od" 
from Kocury K1 
join Kocury K2 on K2.imie = 'JACEK' and K1.w_statku_od < K2.w_statku_od
order by K1.w_statku_od desc;

Zad19.

a) 
select K1.imie, K1.funkcja, K2.imie "Szef 1", K3.imie "Szef 2", K4.imie "Szef 3"
from Kocury K1 left join 
(Kocury K2 left join (
(Kocury K3 left join Kocury K4 on K3.szef = K4.pseudo)) on K2.szef = K3.pseudo) on K1.szef = K2.pseudo
where K1.funkcja = 'KOT' or K1.funkcja = 'MILUSIA';

b)

select * 
from 
    (select connect_by_root imie "Imie", connect_by_root funkcja "funkcja",imie, level "P"
    from Kocury
    connect by prior szef = pseudo
    start with funkcja in ('KOT','MILUSIA')
    ) pivot (
        max(imie) for P in (2 szef1, 3 szef2, 4 szef3)    
);

c)

select imie, funkcja,reverse(rtrim(SYS_CONNECT_BY_PATH((reverse(imie)), ' | '), imie)) "IMIONA KOLEJNYCH SZEFÓW"
from Kocury
where funkcja = 'KOT'
      or funkcja = 'MILUSIA'
connect by prior pseudo = szef
start with szef is null;

Zad20.

select K.imie "Imie Kotnki", B.nazwa "Nazwa bandy", W.imie_wroga, 
W.stopien_wrogosci "Ocena wroga", WK.data_incydentu "Data inc."
from Kocury K
     join Bandy B on K.nr_bandy = B.nr_bandy
     join Wrogowie_Kocurow WK on K.pseudo = WK.pseudo and wk.data_incydentu > TO_DATE('2007-01-01')
     join Wrogowie W on WK.imie_wroga = W.imie_wroga
where K.plec='D'
order by K.imie;

Zad21.

select B.nazwa "Nazwa bandy", count(K.pseudo) "Koty z wrogami"
from bandy B 
join (select distinct K.pseudo,K.nr_bandy
      from Kocury K 
      join Wrogowie_Kocurow WK on K.pseudo = WK.pseudo) K
on B.nr_bandy = K.nr_bandy
group by B.nazwa;


Zad22.

select pseudo, count(imie_wroga)
from Kocury 
left join Wrogowie_Kocurow using(pseudo)
where imie_wroga is not null
group by pseudo
having count(imie_wroga)>1;

Zad23.

select imie, ((NVL(przydzial_myszy,0)+NVL(myszy_extra,0))*12) "Dawka Roczna", 
'Powyzej 864' "Dawka"
from Kocury
where myszy_extra is not null and (NVL(przydzial_myszy,0)+NVL(myszy_extra,0))*12>864
union
select imie, CEIL('864') "Dawka Roczna", 
'864' "Dawka"
from Kocury
where myszy_extra is not null and (NVL(przydzial_myszy,0)+NVL(myszy_extra,0))*12=864
union
select imie, ((NVL(przydzial_myszy,0)+NVL(myszy_extra,0))*12) "Dawka Roczna", 
'Ponizej 864' "Dawka"
from Kocury
where myszy_extra is not null and (NVL(przydzial_myszy,0)+NVL(myszy_extra,0))*12<864
order by 2 desc;

Zad24.

a) select B.nr_bandy,nazwa,teren
from Bandy B
minus
select distinct B.nr_bandy,nazwa,teren
from Bandy B
join Kocury K on K.nr_bandy=B.nr_bandy;

b) select B.nr_bandy, nazwa, teren
from Bandy B 
left join Kocury K
  on B.nr_bandy = K.nr_bandy
where K.imie is NULL;

Zad25.

select imie, funkcja, NVL(przydzial_myszy,0)
from Kocury
where NVL(przydzial_myszy,0) >= all
    (select NVL(przydzial_myszy,0)*3
    from Kocury K
    join Bandy B on K.nr_bandy = B.nr_bandy 
                and B.teren in ('SAD','CALOSC') 
                and K.funkcja = 'MILUSIA');

Zad26.

select K2.funkcja, K2.AVG
from 
    (select MIN(AVG) "MINAVG", MAX(AVG) "MAXAVG"
    from
        (select funkcja, CEIL(AVG(NVL(przydzial_myszy,0) + NVL(myszy_extra, 0))) "AVG"
        from Kocury
        where funkcja != 'SZEFUNIO'
        group by funkcja)
    ) K1
join 
(select funkcja, CEIL(AVG(przydzial_myszy + NVL(myszy_extra, 0))) "AVG"
from Kocury
where funkcja != 'SZEFUNIO'
group by funkcja) K2
on K1.MAXAVG = K2.AVG or K1.MINAVG = K2.AVG
order by K2.AVG;

Zad27.

a) select pseudo, NVL(przydzial_myszy,0) + NVL(myszy_extra,0) "Zjada"
from Kocury K
where (select count(distinct NVL(przydzial_myszy,0) + NVL(myszy_extra,0))
      from Kocury
      where NVL(przydzial_myszy,0) + NVL(myszy_extra,0) > NVL(K.przydzial_myszy,0) + NVL(K.myszy_extra,0))<6
order by 2 desc;

b)

select pseudo, NVL(przydzial_myszy,0) + NVL(myszy_extra,0) "Zjada"
from Kocury K
where NVL(przydzial_myszy,0) + NVL(myszy_extra,0) in 
    (select *
     from
        (select distinct przydzial_myszy + NVL(myszy_extra,0)
          from Kocury
          order by 1 desc) 
     where rownum<=6
);

c)
select K1.pseudo, AVG(NVL(K1.przydzial_myszy,0) + NVL(K1.myszy_extra,0)) "Zjada"
from Kocury K1
left join Kocury K2 
on K1.przydzial_myszy+NVL(K1.myszy_extra,0) < K2.przydzial_myszy+NVL(K2.myszy_extra,0)
group by K1.pseudo
having count(K2.pseudo)<=6
order by 2 desc;

d)

select pseudo, ZJADA, RANK
from
    (select pseudo,
        NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) "ZJADA",
        RANK() over (
            order by przydzial_myszy+NVL(myszy_extra,0) DESC
        ) RANK
    from Kocury)
where RANK<=6;

Zad28.

with 
Lata
as (select extract(year from w_statku_od) "YEAR", count(*) "COUNT"
    from Kocury
    group by extract(year from w_statku_od))
select TO_CHAR(YEAR),COUNT
from Lata
where COUNT = (select MAX(COUNT)
               from Lata
               where COUNT<= (select AVG(ROUND(COUNT,7))
                              from LATA))
or 
COUNT = (select MIN(COUNT)
               from Lata
               where COUNT >= (select AVG(ROUND(COUNT,7))
                              from LATA))
union 
(SELECT 'Srednia' "YEAR", ROUND(AVG(COUNT), 7)
FROM Lata)
order by 2; 


Zad29.
a) 
select K1.imie, MIN(K1.przydzial_myszy + NVL(K1.myszy_extra, 0)) "ZJADA",
K1.nr_bandy "NR Bandy", AVG(NVL(K2.przydzial_myszy,0)+NVL(K2.myszy_extra,0)) "AVG"
from Kocury K1
join Kocury K2 on K1.nr_bandy = K2.nr_bandy
where K1.plec='M'
group by K1.imie,K1.nr_bandy
having MIN(NVL(K1.przydzial_myszy,0)+NVL(K1.myszy_extra,0))<
AVG(NVL(K2.przydzial_myszy,0)+NVL(K2.myszy_extra,0));

b) 
select K1.imie, NVL(K1.przydzial_myszy,0)+NVL(K1.myszy_extra,0) "ZJADA",
K1.nr_bandy "NR Bandy", K2_AVG.AVG
from (select K2.nr_bandy,AVG(NVL(K2.przydzial_myszy,0)+NVL(K2.myszy_extra,0)) "AVG"
     from Kocury K2
     group by K2.nr_bandy) K2_AVG 
join
    Kocury K1 
on K1.nr_bandy = K2_AVG.nr_bandy and NVL(K1.przydzial_myszy,0)+NVL(K1.myszy_extra,0)<K2_AVG.AVG
where K1.plec='M';
c)
select K1.imie, NVL(K1.przydzial_myszy,0)+NVL(K1.myszy_extra,0) "ZJADA",
K1.nr_bandy "NR Bandy",
    (select AVG(NVL(K2.przydzial_myszy,0)+NVL(K2.myszy_extra,0))
     from Kocury K2
     where K2.nr_bandy = K1.nr_bandy
     group by K2.nr_bandy) "AVG"
from Kocury K1
where plec = 'M'
and NVL(K1.przydzial_myszy,0)+NVL(K1.myszy_extra,0)<
    (select AVG(NVL(K2.przydzial_myszy,0)+NVL(K2.myszy_extra,0))
     from Kocury K2
     where K2.nr_bandy = K1.nr_bandy
     group by K2.nr_bandy);

Zad30.


select imie, TO_CHAR(w_statku_od, 'YYYY-MM-DD') || ' <--- NAJSTARSZY STAZEM W BANDZIE ' || nazwa "WSTAPIL DO STADKA"
from (
  select imie, w_statku_od, nazwa, min(w_statku_od) over (partition by Kocury.nr_bandy) minstaz
  from Kocury join Bandy on Kocury.nr_bandy= Bandy.nr_bandy
)
where w_statku_od = minstaz

union all

select imie, TO_CHAR(w_statku_od, 'YYYY-MM-DD') || ' <--- NAJMLODSZY STAZEM W BANDZIE ' || nazwa "WSTAPIL DO STADKA"
from (
  select imie, w_statku_od, nazwa, max(w_statku_od) over (partition by Kocury.nr_bandy) maxstaz
  from Kocury join Bandy on Kocury.nr_bandy = Bandy.nr_bandy
)
where w_statku_od = maxstaz

union all

select imie, TO_CHAR(w_statku_od, 'YYYY-MM-DD')
from (
  select imie, w_statku_od, nazwa,
    min(w_statku_od) over (partition by Kocury.nr_bandy) minstaz,
    max(w_statku_od) over (partition by Kocury.nr_bandy) maxstaz
  from Kocury join Bandy on Kocury.nr_bandy= Bandy.nr_bandy
)
where w_statku_od != minstaz and
      w_statku_od != maxstaz
order by imie;
Zad31.

create or replace view Stats(nazwa_bandy, sre_spoz, max_spoz, min_spoz, koty, koty_z_dod)
as 
select nazwa, AVG(przydzial_myszy), MAX(przydzial_myszy), MIN(przydzial_myszy), COUNT(pseudo), COUNT(myszy_extra)
from Kocury 
join Bandy on Kocury.nr_bandy= Bandy.nr_bandy
group by nazwa;

select *
from Stats;

select K.pseudo,K.imie,K.funkcja,przydzial_myszy "Zjada",
'od ' || S.min_spoz || ' do ' || S.max_spoz "Granice spozycia",
w_statku_od "lowi od"
from Stats S 
join Bandy B on S.nazwa_bandy = B.nazwa
join Kocury K on B.nr_bandy = K.nr_bandy
where pseudo='&pseudo';



Zad32.

create or replace view Stats_2
as 
select pseudo,plec, przydzial_myszy, myszy_extra ,nr_bandy
from Kocury 
where pseudo in 
(
    select pseudo
    from Kocury join Bandy B on Kocury.nr_bandy = B.nr_bandy
    where B.nazwa = 'CZARNI RYCERZE'
    order by w_statku_od
    fetch next 3 rows only
) or pseudo in 
(
    select pseudo
    from Kocury join Bandy B on Kocury.nr_bandy = B.nr_bandy
    where B.nazwa = 'LACIACI MYSLIWI'
    order by w_statku_od
    fetch next 3 rows only
);

select * from stats_2;

update stats_2
set przydzial_myszy = przydzial_myszy + DECODE(plec, 'D', 0.1 * (select min(przydzial_myszy) from Kocury), 10),
    myszy_extra = NVL(myszy_extra, 0) + 0.15 * (select avg(NVl(Kocury.myszy_extra, 0)) from Kocury where stats_2.nr_bandy = nr_bandy);

select * from stats_2;

rollback;

Zad33.
a)

select *
from
(select TO_CHAR(DECODE(plec, 'D', nazwa, ' ')) "NAZWA BANDY",
  TO_CHAR(DECODE(plec, 'D', 'Kotka', 'Kocor')),
  TO_CHAR(COUNT(pseudo)) "ILE",
  TO_CHAR(NVL((select SUM(przydzial_myszy + NVL(myszy_extra, 0)) from Kocury K where funkcja = 'SZEFUNIO' and K.nr_bandy= Kocury.nr_bandy and K.plec = Kocury.plec),0)) "SZEFUNIO",
  TO_CHAR(NVL((select SUM(przydzial_myszy + NVL(myszy_extra, 0)) from Kocury K where funkcja = 'BANDZIOR' and K.nr_bandy= Kocury.nr_bandy and K.plec = Kocury.plec),0)) "BANDZIOR",
  TO_CHAR(NVL((select SUM(przydzial_myszy + NVL(myszy_extra, 0)) from Kocury K where funkcja = 'LOWCZY' and K.nr_bandy= Kocury.nr_bandy and K.plec = Kocury.plec),0)) "LOWCZY",
  TO_CHAR(NVL((select SUM(przydzial_myszy + NVL(myszy_extra, 0)) from Kocury K where funkcja = 'LAPACZ' and K.nr_bandy= Kocury.nr_bandy and K.plec = Kocury.plec),0)) "LAPACZ",
  TO_CHAR(NVL((select SUM(przydzial_myszy + NVL(myszy_extra, 0)) from Kocury K where funkcja = 'KOT' and K.nr_bandy= Kocury.nr_bandy and K.plec = Kocury.plec),0)) "KOT",
  TO_CHAR(NVL((select SUM(przydzial_myszy + NVL(myszy_extra, 0)) from Kocury K where funkcja = 'MILUSIA' and K.nr_bandy= Kocury.nr_bandy and K.plec = Kocury.plec),0)) "MILUSIA",
  TO_CHAR(NVL((select SUM(przydzial_myszy + NVL(myszy_extra, 0)) from Kocury K where funkcja = 'DZIELCZY' and K.nr_bandy= Kocury.nr_bandy and K.plec = Kocury.plec),0)) "DZIELCZY",
  TO_CHAR(NVL((select SUM(przydzial_myszy + NVL(myszy_extra, 0)) from Kocury K where K.nr_bandy= Kocury.nr_bandy and K.plec = Kocury.plec),0)) "SUMA"
from Kocury 
join Bandy on Kocury.nr_bandy = Bandy.nr_bandy
group by nazwa, plec, Kocury.nr_bandy
order by nazwa)

UNION ALL

select 'Z--------------', '------', '--------', '---------', '---------', '--------', '--------', '--------', '--------', '--------', '--------' FROM DUAL

union all

select distinct 'ZJADA RAZEM',
       ' ',
       ' ',
       TO_CHAR(NVL((select SUM(przydzial_myszy + NVL(myszy_extra, 0)) from Kocury K where funkcja = 'SZEFUNIO'),0)) "SZEFUNIO",
       TO_CHAR(NVL((select SUM(przydzial_myszy + NVL(myszy_extra, 0)) from Kocury K where funkcja = 'BANDZIOR'),0)) "BANDZIOR",
       TO_CHAR(NVL((select SUM(przydzial_myszy + NVL(myszy_extra, 0)) from Kocury K where funkcja = 'LOWCZY'),0)) "LOWCZY",
       TO_CHAR(NVL((select SUM(przydzial_myszy + NVL(myszy_extra, 0)) from Kocury K where funkcja = 'LAPACZ'),0)) "LAPACZ",
       TO_CHAR(NVL((select SUM(przydzial_myszy + NVL(myszy_extra, 0)) from Kocury K where funkcja = 'KOT'),0)) "KOT",
       TO_CHAR(NVL((select SUM(przydzial_myszy + NVL(myszy_extra, 0)) from Kocury K where funkcja = 'MILUSIA'),0)) "MILUSIA",
       TO_CHAR(NVL((select SUM(przydzial_myszy + NVL(myszy_extra, 0)) from Kocury K where funkcja = 'DZIELCZY'),0)) "DZIELCZY",
       TO_CHAR(NVL((select SUM(przydzial_myszy + NVL(myszy_extra, 0)) from Kocury K),0)) "SUMA"
from Kocury;

b)

select *
from
(
  select TO_CHAR(DECODE(plec, 'D', nazwa, ' ')) "NAZWA BANDY",
    TO_CHAR(DECODE(plec, 'D', 'Kotka', 'Kocor')) "Plec",
    TO_CHAR(ile) "ILE",
    TO_CHAR(NVL(szefunio, 0)) "SZEFUNIO",
    TO_CHAR(NVL(bandzior,0)) "BANDZIOR",
    TO_CHAR(NVL(lowczy,0)) "LOWCZY",
    TO_CHAR(NVL(lapacz,0)) "LAPACZ",
    TO_CHAR(NVL(kot,0)) "KOT",
    TO_CHAR(NVL(milusia,0)) "MILUSIA",
    TO_CHAR(NVL(dzielczy,0)) "DZIELCZY",
    TO_CHAR(NVL(suma,0)) "SUMA"
  from
  (
    select nazwa, plec, funkcja, przydzial_myszy + NVL(myszy_extra, 0) liczba
    from Kocury join Bandy on Kocury.nr_bandy= Bandy.nr_bandy
  ) pivot (
      sum(liczba) for funkcja in (
      'SZEFUNIO' szefunio, 'BANDZIOR' bandzior, 'LOWCZY' lowczy, 'LAPACZ' lapacz,
      'KOT' kot, 'MILUSIA' milusia, 'DZIELCZY' dzielczy
    )
  ) join (
    select nazwa "N", plec "P", COUNT(pseudo) ile, SUM(przydzial_myszy + NVL(myszy_extra, 0)) suma
    from Kocury K join Bandy B on K.nr_bandy= B.nr_bandy
    group by nazwa, plec
    order by nazwa
  ) on N = nazwa and P = plec
)


union all

select 'Z--------------', '------', '--------', '---------', '---------', '--------', '--------', '--------', '--------', '--------', '--------' FROM DUAL

union all

select  'ZJADA RAZEM',
        ' ',
        ' ',
        TO_CHAR(NVL(szefunio, 0)) szefunio,
        TO_CHAR(NVL(bandzior, 0)) bandzior,
        TO_CHAR(NVL(lowczy, 0)) lowczy,
        TO_CHAR(NVL(lapacz, 0)) lapacz,
        TO_CHAR(NVL(kot, 0)) kot,
        TO_CHAR(NVL(milusia, 0)) milusia,
        TO_CHAR(NVL(dzielczy, 0)) dzielczy,
        TO_CHAR(NVL(suma, 0)) suma
from
(
  select      funkcja, przydzial_myszy + NVL(myszy_extra, 0) liczba
  from        Kocury join Bandy on Kocury.nr_bandy= Bandy.nr_bandy
) pivot (
    SUM(liczba) for funkcja in (
    'SZEFUNIO' szefunio, 'BANDZIOR' bandzior, 'LOWCZY' lowczy, 'LAPACZ' lapacz,
    'KOT' kot, 'MILUSIA' milusia, 'DZIELCZY' dzielczy
  )
) cross join (
  select      SUM(przydzial_myszy + NVL(myszy_extra, 0)) suma
  from       Kocury
);


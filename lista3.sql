Zad 34.

declare 
    func Kocury.funkcja%Type :='&funkcja';
    liczba_kotow Number;
begin
    select count(pseudo), min(funkcja) into liczba_kotow,func
    from Kocury 
    where funkcja = func;
    if liczba_kotow>0 then DBMS_OUTPUT.PUT_LINE('Funkcja '||func);
        else DBMS_OUTPUT.PUT_LINE('Nie ma kotow o funkcji ' || func);
    end if;
end;

Zad 35.

declare 
    pseudo_ Kocury.pseudo%Type :='&pseudo';
    imie Kocury.imie%Type;
    przydzial number;
    miesiac number;
    found boolean default false;
begin
    select imie, (nvl(przydzial_myszy,0)+nvl(myszy_extra,0))*12, extract (month from w_statku_od)
    into imie,przydzial, miesiac
    from Kocury 
    where pseudo = pseudo_;

    if przydzial>700 then DBMS_OUTPUT.PUT_LINE('calkowity roczny przydzial myszy >700');
        found:=true;
    end if;
    if imie like '%A%' then DBMS_OUTPUT.PUT_LINE('imię zawiera litere A');
        found:=true;
    end if;
    if miesiac = 5 then DBMS_OUTPUT.PUT_LINE('maj jest miesiacem przystapienia do stada');
        found:=true;
    end if;
    if not found then DBMS_OUTPUT.PUT_LINE('nie odpowiada kryteriom');
    end if;
exception
    when no_data_found then DBMS_OUTPUT.PUT_LINE('Nie ma');
    when others then dbms_output.put_line(sqlerrm);
end;



Zad 36.

declare 
    suma_przydzialow number default 0;
    liczba_zmian number default 0;
    max_przydzial number default 0;
    
    cursor kursor is 
        select pseudo, przydzial_myszy,funkcja 
        from kocury 
        for update of przydzial_myszy;
    wiersz kursor%ROWTYPE;
begin 
    select sum(przydzial_myszy) 
    into suma_przydzialow 
    from Kocury;
    
    <<loop_>> loop
        open kursor;
        loop
            fetch kursor into wiersz;
            exit when kursor%notfound;
            
            select max_myszy
            into max_przydzial 
            from Funkcje 
            where funkcja=wiersz.Funkcja;
            
            if(1.1*wiersz.przydzial_myszy <= max_przydzial) then 
                update kocury
                set przydzial_myszy = round(1.1*wiersz.przydzial_myszy)
                where wiersz.pseudo = pseudo;
                liczba_zmian:=liczba_zmian+1;
                suma_przydzialow:=suma_przydzialow+round(0.1*wiersz.przydzial_myszy);
            elsif(wiersz.przydzial_myszy!=max_przydzial) then
                update kocury 
                set przydzial_myszy = max_przydzial
                where wiersz.pseudo = pseudo;
                liczba_zmian:=liczba_zmian+1;
                suma_przydzialow:=suma_przydzialow + (max_przydzial-wiersz.przydzial_myszy);
            end if;
        exit loop_ when suma_przydzialow>1050;
        end loop;
        close kursor;
        end loop loop_;
  dbms_output.put_line('Calk. przydzial w stadku ' || suma_przydzialow);
  dbms_output.put_line('Zmian - ' || liczba_zmian);
end;

select sum(przydzial_myszy)
from Kocury;

rollback;

Zad 37.

declare
    nr number :=1;
    
    cursor koty is 
        select pseudo, nvl(przydzial_myszy,0)+nvl(myszy_extra,0) zjada 
        from Kocury order by zjada desc;
begin
    dbms_output.put_line('Nr    Pseudonim    Zjada');
    dbms_output.put_line('------------------------');
    for kot in koty
    loop 
        dbms_output.put_line( LPAD(nr,2) || '' || LPAD(kot.pseudo,10) || '' || LPAD(kot.zjada,10) );
        nr:=nr+1;
        exit when nr > 5;
    end loop;
exception
    when others then dbms_output.put_line(sqlerrm);
end;

Zad 38.

declare
    max_poziom number := 0;
    poziom number := 1;
    liczba_poziomow number default '&liczba_szefow';
    cursor koty is 
        (SELECT * from Kocury where funkcja in ('MILUSIA', 'KOT'));
    kot Kocury%ROWTYPE;   
begin

    select max(level)-1 
    into max_poziom
    from Kocury 
    connect by prior pseudo = szef 
    start with szef is null ;
    liczba_poziomow := least(max_poziom, liczba_poziomow);
    
    dbms_output.put('Imie        ');
    for i in 1..liczba_poziomow 
    loop
        dbms_output.put('  |  ' || rpad('Szef ' || i, 10));
    end loop;
    
    dbms_output.new_line();
    dbms_output.put('--------------');
    for i in 1..liczba_poziomow loop
      dbms_output.put(' --------------');
    end loop;
    dbms_output.new_line();
    
for wiersz in koty
loop
    poziom:=1;
    dbms_output.put(RPAD(wiersz.imie,10));
    kot:=wiersz;
    
    while poziom<=liczba_poziomow 
    loop
        if kot.szef is null then 
           dbms_output.put(rpad(' ',15)); 
        else
            select * 
            into kot 
            from Kocury 
            where kot.szef = pseudo;
            dbms_output.put(LPAD(kot.imie,15));
        end if;
        poziom:=poziom+1;
    end loop;
    dbms_output.new_line();
end loop;
exception
    when others then dbms_output.put_line(sqlerrm);
end;

Zad 39.

DECLARE
    nrB number := &numer;
    nazwaB varchar2(20) := UPPER('&nazwa');
    terenB varchar2(15) := UPPER('&teren');
    blad varchar2(256) := '';
    ilosc number :=0;
    zlaliczba exception;
    istnieje exception;
BEGIN

    if nrB <=0 then raise zlaliczba;
    end if;

    select count(nr_bandy) 
    into ilosc 
    from Bandy 
    where nr_bandy = nrB;   
    if ilosc > 0 then blad := TO_char(nrB); 
    end if;

    select count(nazwa) 
    into ilosc 
    from Bandy 
    where nazwa=nazwaB;
    if ilosc > 0 then
        if length(blad)>0 then blad:= blad || ', ' || nazwaB;
        else blad := nazwaB ;
        end if;
    end if;
    
    select count(teren) into ilosc 
    from Bandy 
    where teren=terenB;
    if ilosc > 0 then
        if length(blad) >0 then blad := blad || ', ' || terenB;
        else blad := terenB;
        end if;
    end if;

    if length(blad)>0 then raise istnieje; end if;

    insert into Bandy (nr_bandy, nazwa, teren,szef_bandy) values (nrB, nazwaB, terenB,null) ;

    exception
        when zlaliczba then DBMS_OUTPUT.PUT_LINE('Liczba musi byc >0! ');
        when istnieje then DBMS_OUTPUT.PUT_LINE(blad || ' :wartosc juz istnieje');
end;







Zad 40.

CREATE OR REPLACE PROCEDURE nowa_banda(nrB Bandy.nr_bandy%TYPE, nazwaB bandy.nazwa%TYPE, terenB bandy.teren%TYPE)
  IS
    blad STRING(256) := '';
    ilosc number :=0;
    zlaliczba exception;
    istnieje exception;
BEGIN

    if nrB <=0 then raise zlaliczba;
    end if;

    select count(nr_bandy) 
    into ilosc 
    from Bandy 
    where nr_bandy = nrB;   
    if ilosc > 0 then blad := TO_char(nrB); 
    end if;

    select count(nazwa) 
    into ilosc 
    from Bandy 
    where nazwaB=nazwa;
    if ilosc > 0 then
        if length(blad)>0 then blad:= blad || ', ' || nazwaB;
        else blad := nazwaB ;
        end if;
    end if;
    
    select count(teren) into ilosc 
    from Bandy 
    where terenB=teren ;
    if ilosc > 0 then
        if length(blad) >0 then blad := blad || ', ' || terenB;
        else blad := terenB;
        end if;
    end if;

    if length(blad)>0 then raise istnieje; end if;

    insert into Bandy (nr_bandy, nazwa, teren,szef_bandy) values (nrB, nazwaB, terenB,null) ;

    exception
        when zlaliczba then DBMS_OUTPUT.PUT_LINE('Liczba musi byc >0! ');
        when istnieje then DBMS_OUTPUT.PUT_LINE(blad || ' :wartosc juz istnieje');
end;

rollback;
begin
    nowa_banda(1, 'SZEFOSTWO', 'SAD');
end;
select * from bandy;
select * from USER_OBJECTS;
DROP procedure nowa_banda;

Zad 41.

create or replace trigger aut_nr_bandy
  BEFORE insert on BANDY                  
  for each row              
  DECLARE 
    ost_numer number := 0;
  BEGIN
    select MAX(NR_BANDY)+1 
    into ost_numer 
    from BANDY;
    :new.NR_BANDY:=ost_numer;
end;

begin
    insert into Bandy values(10, 'nazwa2', 'teren2',null);
  end;

drop trigger aut_nr_bandy;

Zad 42.

a)

create or replace package pamiec as
  przydzial_tygr number default 0;
  nagroda number default 0;
  strata number default 0;
end;

create or replace trigger przydzial_tygrysa
    before update on Kocury
    begin
      select przydzial_myszy 
      into pamiec.przydzial_tygr 
      from Kocury where pseudo = 'TYGRYS';
    end;

  create or replace trigger zmiany
    before update on Kocury
    for each row
    declare
      roznica number default 0;
    begin
      if :new.funkcja = 'MILUSIA' then                          
          if :new.przydzial_myszy <= :old.przydzial_myszy then  
              dbms_output.put_line('Nowy przydzial nie moze byc mniejszy');
              :new.przydzial_myszy := :old.przydzial_myszy;     
          else
              roznica := :new.przydzial_myszy - :old.przydzial_myszy;
              if roznica < 0.1*pamiec.przydzial_tygr  then            
                  dbms_output.put_line('Kara za zmiane '|| :old.pseudo||' z '|| :old.przydzial_myszy||' na '|| :new.przydzial_myszy);
                  pamiec.strata := pamiec.strata+1;                   
                  :new.przydzial_myszy := :new.przydzial_myszy + 0.1*pamiec.przydzial_tygr; 
                  :new.myszy_extra := :new.myszy_extra + 5;                              
              elsif roznica > 0.1*pamiec.przydzial_tygr then           
                  pamiec.nagroda := pamiec.nagroda+1;                  
                  dbms_output.put_line('Nagroda za zmiane '|| :old.pseudo||' z '|| :old.przydzial_myszy||' na '|| :new.przydzial_myszy);
              end if;
          end if;
      end if;
    end;

  create or replace trigger zmiany_tygrysa
    after update on Kocury
    declare
      pom number default 0;
    begin
        if pamiec.strata >0 then
            pom:= pamiec.strata;
            pamiec.strata :=0;        
            update KOCURY 
            set przydzial_myszy = FLOOR(przydzial_myszy - przydzial_myszy*0.1*pom) 
            where pseudo='TYGRYS';  
            dbms_output.put_line('Zabrano '|| FLOOR(pamiec.przydzial_tygr*0.1*pom)||' przydzialu myszy tygrysowi.');
        end if;
        if pamiec.nagroda >0 then
            pom := pamiec.nagroda;
            pamiec.nagroda:=0;
            update KOCURY 
            set myszy_extra  = myszy_extra+(5*pom) 
            where pseudo='TYGRYS';
            dbms_output.put_line('Dodano '|| 5*pom ||' myszy ekstra tygrysowi');
        end if;
    end;

select * from Kocury;

update Kocury
set przydzial_myszy = (przydzial_myszy +15) where funkcja='MILUSIA';
rollback ;

drop trigger przydzial_tygrysa;
drop trigger zmiany;
drop trigger zmiany_tygrysa;
drop package pamiec;

b)


create or replace trigger compound_trigger
  for update on Kocury
  compound trigger
    przydzial_tygr number default 0;
    nagroda number default 0;
    strata number default 0;
    roznica number default 0;
    pom number default 0;

  before statement is begin 
      select przydzial_myszy
      into  przydzial_tygr 
      from Kocury where pseudo='TYGRYS';
  end before statement ;

  before each row is begin 
      if :new.funkcja = 'MILUSIA' then                         
          IF :new.przydzial_myszy <= :old.przydzial_myszy then  
              dbms_output.put_line('Nie mozna zmienić przydziału '|| :old.PSEUDO||' z '|| :old.przydzial_myszy||' na '|| :new.przydzial_myszy);
              :new.przydzial_myszy := :old.przydzial_myszy;     
          else
              roznica := :new.przydzial_myszy - :old.przydzial_myszy;
              IF roznica < 0.1*przydzial_tygr  then            
                dbms_output.put_line(roznica || '  prz tygr: '|| przydzial_tygr);
                dbms_output.put_line('Kara za zmiane '|| :old.PSEUDO||' z '|| :old.przydzial_myszy||' na '|| :new.przydzial_myszy);
                  strata := strata+1;                   --+ kara dla tygrysa
                  :new.przydzial_myszy := :new.przydzial_myszy + 0.1*przydzial_tygr; 
                  :new.myszy_extra := :new.myszy_extra + 5;                              
              elsif roznica > 0.1*przydzial_tygr then           
                  nagroda := nagroda+1;                  
                  dbms_output.put_line('Nagroda za zmiane '|| :old.pseudo||' z '|| :old.przydzial_myszy||' na '|| :new.przydzial_myszy);
              end if;
          end if;
      end if;
  end before each row ;

  after statement is begin
      if strata >0 then
            pom:= strata;
            strata :=0;
            update KOCURY 
            set przydzial_myszy = FLOOR(przydzial_myszy - przydzial_myszy*0.1*pom) 
            where pseudo='TYGRYS';  
            dbms_output.put_line('Zabrano '|| FLOOR(przydzial_tygr*0.1*pom)||' przydzialu myszy tygrysowi.');
        end if;
        if nagroda >0 then
            pom := nagroda;
            nagroda:=0;
            update Kocury set myszy_extra  = myszy_extra+(5*pom) where pseudo='TYGRYS';
            dbms_output.put_line('Dodano '|| 5*pom ||' myszy extra tygrysowi');
        end if;
  end after statement ;
end;

Zad 43.

DECLARE
    cursor funkcje is 
    (select funkcja 
     from Funkcje);
    ilosc number;
BEGIN

    dbms_output.put('NAZWA BANDY       PLEC    ILE ');
    for fun in funkcje loop
      dbms_output.put(RPAD(fun.funkcja,10));
    end loop;

    dbms_output.put_line('    SUMA');
    dbms_output.put('----------------- ------ ----');

    for fun in funkcje loop
          dbms_output.put(' ---------');
    end loop;
    dbms_output.put_line(' --------');
            ------------
    for banda in (select nazwa, nr_bandy from bandy) loop
        for ple in (select plec from Kocury group by plec) loop
            dbms_output.put(case when ple.plec = 'M' then RPAD(banda.nazwa,18) else  RPAD(' ',18) end);
            dbms_output.put(case when ple.plec = 'M' then 'Kocor' else 'Kotka' end);

            select count(*) 
            into ilosc 
            from Kocury 
            where Kocury.nr_bandy = banda.nr_bandy and Kocury.plec=ple.plec;  
            dbms_output.put(LPAD(ilosc,4));

            for fun in funkcje loop
                select sum(NVL(przydzial_myszy,0)+NVL(myszy_extra,0)) 
                into ilosc 
                from Kocury K
                where K.plec=ple.plec and K.funkcja=fun.funkcja AND K.nr_bandy=banda.nr_bandy;    
                dbms_output.put(LPAD(NVL(ilosc,0),10));
            end loop;

            select SUM(NVL(przydzial_myszy,0)+NVL(myszy_extra,0)) 
            into ilosc 
            from KOCURY K 
            where K.nr_bandy=banda.nr_bandy and ple.plec=K.plec;
            dbms_output.put(LPAD(NVL(ilosc,0),10));
            dbms_output.new_line();
        end loop;
    end loop;
    dbms_output.put('----------------- ------ ----');
    for fun in funkcje loop dbms_output.put(' ---------'); end loop;
    dbms_output.put_line(' --------');


    dbms_output.put('Zjada razem                ');
    for fun in funkcje loop
        select SUM(NVL(przydzial_myszy,0)+NVL(myszy_extra,0)) 
        into ilosc 
        from Kocury K where K.funkcja=fun.funkcja;
        dbms_output.put(LPAD(NVL(ilosc,0),10));
    end loop;

    select sum(nvl(przydzial_myszy,0)+nvl(myszy_extra,0)) 
    into ilosc 
    from Kocury;
    dbms_output.put(LPAD(ilosc,10));
    dbms_output.new_line();
end;

Zad 44.

create or replace function podatek (pseudonim Kocury.pseudo%TYPE) return number 
is
    podatek number default 0;
    ile number default 0;
    data_ date ;
    begin
      select ceil(0.05*(nvl(przydzial_myszy,0)+nvl(myszy_extra,0))) 
      into podatek 
      from Kocury where pseudonim=Kocury.pseudo; 

      select count(pseudo) 
      into ile 
      from Kocury where szef = pseudonim;            
      if ile <= 0 then podatek:=podatek+2; 
      end if ;

      select count(pseudo) 
      into ile 
      from WROGOWIE_KOCUROW  
      where pseudo=pseudonim; 
      if ile <= 0 then podatek:=podatek+1; end if;

      select w_statku_od 
      into data_ 
      from Kocury 
      where pseudonim=pseudo;
      if extract(year from data_)= '2021' then podatek:=podatek+1; 
      end if; 

      return podatek;
end;

  create or replace package podatek_package as
    function podatek(pseudonim Kocury.pseudo%TYPE) return number;
    procedure nowa_banda(nrB Bandy.nr_bandy%TYPE, nazwaB bandy.nazwa%TYPE, terenB bandy.teren%TYPE);
  end podatek_package;

  create or replace package body podatek_package as
    function podatek (pseudonim Kocury.pseudo%TYPE) return number is
    podatek number default 0;
    ile number default 0;
    data_ date;
    begin
    PROCEDURE nowa_banda(nrB Bandy.nr_bandy%TYPE, nazwaB bandy.nazwa%TYPE, terenB bandy.teren%TYPE)


begin
  dbms_output.put(RPAD('pseudonim',10));
  dbms_output.put(LPAD('podatek ',20));
  dbms_output.new_line();
  for kocur in (select pseudo 
                from Kocury) loop
    dbms_output.put_line(RPAD(kocur.pseudo,10) || LPAD(podatek(kocur.pseudo),20));
  end loop;
  end;
  

drop function podatek;
drop package podatek_package;




Zad 45.
create or replace trigger check_extra
  before update of przydzial_myszy on Kocury
  for each row
  declare
    pragma autonomous_transaction ;
  begin
    if :new.funkcja='MILUSIA' and :new.przydzial_myszy> :old.przydzial_myszy then
        IF LOGIN_USER != 'TYGRYS' then
          dbms_output.put('Uzytkownik: ' || LOGIN_USER);
            execute immediate '
            declare
              cursor milusie is select pseudo from Kocury where funkcja=''MILUSIA'';
            begin
              for milusia in milusie loop
                  insert into Dodatki_extra(pseudo,dodatek_extra) values (milusia.pseudo, -10);
              end loop;
            end;';
          commit;
        end if;
    end if;
  end;

update Kocury
set przydzial_myszy = przydzial_myszy+10
where funkcja='MILUSIA';
rollback;
drop trigger check_extra;

create table DODATKI_EXTRA (
    ID_DODATKU number(2) constraint dod_pk_id primary key,
    PSEUDO varchar2(15) constraint fk_pseudo references KOCURY(PSEUDO),
    DODATEK_EXTRA number(3) not null
);

Zad 46.

create table zmiana (
    zmiana_id number(2) constraint pk_id primary key,
    edytor varchar2(15) not null,
    data_ date not null,
    edytowany varchar2(15) constraint fg_pseudo references Kocury(pseudo),
    operacja varchar2(15) not null
);

CREATE OR REPLACE TRIGGER check_
  before update on KOCURY
  for each row
  DECLARE
    pragma AUTONOMOUS_TRANSACTION ;   
    maxm number default 0;
    minm number default 0;
    zla_liczba exception ;
    edytor varchar2(15) default  ' ';
    edytowany varchar2(15) default  ' ';
    operacja varchar2(15) ;
  BEGIN
    select max_myszy, min_myszy 
    into maxm, minm 
    from Funkcje where funkcja=:new.funkcja;

    if :new.przydzial_myszy > maxm or :new.przydzial_myszy < minm then
      if updating 
      then operacja := 'UPDATE';
      end if;
      if inserting
      then operacja := 'INSERT';
      end if;
      edytowany := :new.pseudo;
      edytujacy := LOGIN_USER;
      insert into Zmiana(edytujacy,DATA_,edytowany,operacja) values (edytujacy, sysdate, edytowany, operacja);
      commit ;
      raise_application_error(-25000,'Niemozliwe dokonanie zmian.');
    end if;
    exception 
        when zla_liczba then dbms_output.put_line('Dana wartosc jest za duza lub za mala. Nie wykonano zmian.');
  end;

update Kocury
set przydzial_myszy = 70 
where pesudo='PLACEK';
  
select * from Zmiana;
rollback;
drop trigger check_;
drop table Zmiana;


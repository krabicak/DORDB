spool 'C:/Users/Petr/Desktop/09_vystup.txt';
--Trivialni integritini omezeni

--Tabulka Vyukova_akce 
--Atribut konec nesmí být dříve než-li atribut konec (typ DATE)
insert into vyukova_akce (maxstudentu,zpusobvyukyzkrata,pocatek,konec,predmetid,mistnostid) 
values (20,'PR','12/12/2020','01/01/2020',(SELECT MIN(Predmetid) FROM Predmet),(SELECT MIN(mistnostid) FROM mistnost));

--Tabulka Pracovnik
--Atribut mobil musí být unikátní - zajištěno unikátním klíčem
begin
insert into pracovnik(jmeno,prijmeni,titulpred,titulza,telefon,mobil,email,pracovisteid,heslo,plat) 
values ('František','Hotovec','Mgr.','MBA','111222333','444555666','frantisek.hotovec1@uhk.cz',(SELECT MIN(pracovisteid) FROM pracoviste),'Heslo123','45000');
insert into pracovnik(jmeno,prijmeni,titulpred,titulza,telefon,mobil,email,pracovisteid,heslo,plat) 
values ('František','Hotovec','Mgr.','MBA','111222333','444555666','frantisek.hotovec2@uhk.cz',(SELECT MIN(pracovisteid) FROM pracoviste),'Heslo123','45000');
end;
/

--Atribut email musí být unikátní - zajištěno unikátním klíčem
begin
insert into pracovnik(jmeno,prijmeni,titulpred,titulza,telefon,mobil,email,pracovisteid,heslo,plat) 
values ('František','Hotovec','Mgr.','MBA','111222333','444555666','frantisek.hotovec@uhk.cz',(SELECT MIN(pracovisteid) FROM pracoviste),'Heslo123','45000');
insert into pracovnik(jmeno,prijmeni,titulpred,titulza,telefon,mobil,email,pracovisteid,heslo,plat) 
values ('František','Hotovec','Mgr.','MBA','444555666','111222333','frantisek.hotovec@uhk.cz',(SELECT MIN(pracovisteid) FROM pracoviste),'Heslo123','45000');
end;
/

--Tabulka Predmet
--Atribut zkratka musí být unikátní - zajištěno unikátním klíčem
begin
insert into predmet(nazev,zkratka,pocetkreditu,zkratkazakonceni,zkratkakategorie) values('Testovaci predmet','TEST','666','ZK','A');
insert into predmet(nazev,zkratka,pocetkreditu,zkratkazakonceni,zkratkakategorie) values('Testovaci predmet','TEST','666','ZK','A');
end;
/

--Tabulka Pracoviste
--Atribut zkratka musí být unikátní - zajištěno unikátním klíčem
begin
insert into pracoviste (nazev,zkratka) values ('Testovaci pracoviste','TEST');
insert into pracoviste (nazev,zkratka) values ('Testovaci pracoviste','TEST');
end;
/

--Netrivialní integritní omezení
--Tabulka Vyukova_akce
--Nelze vytvořit vyukovou akci pro více studentů, než kolik se vejde do místnosti
declare
v_predmetid NUMBER(38,0);
v_mistnostid NUMBER(38,0);
v_maxstudentu NUMBER(38,0);

begin
select min(mistnostid) into v_mistnostid from mistnost where kapacita > 0;
select max(predmetid) into v_predmetid from predmet;
select kapacita into v_maxstudentu from mistnost where mistnostid = v_mistnostid;
v_maxstudentu := v_maxstudentu + 10;
insert into vyukova_akce(maxstudentu,zpusobvyukyzkrata,pocatek,konec,predmetid,mistnostid) values(v_maxstudentu,'PR','01/12/2020','31/12/2020',v_predmetid,v_mistnostid);
end;
/

--Tabulka Zapis
--Nelze zapsat více studentů na výukovou akci než je kapacita
declare
v_predmetid NUMBER(38,0);
v_mistnostid NUMBER(38,0);
v_studentidmax NUMBER(38,0);
v_studentidmin NUMBER(38,0);
v_posledniidakce NUMBER(38,0);
begin

select min(mistnostid) into v_mistnostid from mistnost where kapacita > 0;

select max(predmetid) into v_predmetid from predmet;

select min(studentid) into v_studentidmin from student;

select max(studentid) into v_studentidmax from student;

insert into vyukova_akce(maxstudentu,zpusobvyukyzkrata,pocatek,konec,predmetid,mistnostid) 
values(1,'PR','01/12/2020','31/12/2020',v_predmetid,v_mistnostid);

select max(vyukovaakceid) into v_posledniidakce from vyukova_akce; 

insert into zapis(studentid,vyukovaakceid) values(v_studentidmin,v_posledniidakce);

insert into zapis(studentid,vyukovaakceid) values(v_studentidmax,v_posledniidakce);

end;
/
spool off;
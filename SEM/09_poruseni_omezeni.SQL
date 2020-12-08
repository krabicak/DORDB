--Trivialni integritini omezeni

--Tabulka Vyukova_akce 
--Atribut konec nesmí být dříve než-li atribut konec (typ DATE)
insert into vyukova_akce (maxstudentu,zpusobvyukyzkrata,pocatek,konec,predmetid,mistnostid) 
values (20,'PR','12/12/2020','01/01/2020',(SELECT MIN(Predmetid) FROM Predmet),(SELECT MIN(mistnostid) FROM mistnost));
--nefunguje!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

--Tabulka Pracovnik
--Atribut mobil musí být unikátní - zajištěno unikátním klíčem
begin
insert into pracovnik(jmeno,prijmeni,titulpred,titulza,telefon,mobil,email,pracovisteid,heslo,plat) 
values ('František','Hotovec','Mgr.','MBA','111222333','444555666','frantisek.hotovec1@uhk.cz',(SELECT MIN(pracovisteid) FROM pracoviste),'Heslo123','45000');
insert into pracovnik(jmeno,prijmeni,titulpred,titulza,telefon,mobil,email,pracovisteid,heslo,plat) 
values ('František','Hotovec','Mgr.','MBA','111222333','444555666','frantisek.hotovec2@uhk.cz',(SELECT MIN(pracovisteid) FROM pracoviste),'Heslo123','45000');
end;
/
--OK

--Atribut email musí být unikátní - zajištěno unikátním klíčem
begin
insert into pracovnik(jmeno,prijmeni,titulpred,titulza,telefon,mobil,email,pracovisteid,heslo,plat) 
values ('František','Hotovec','Mgr.','MBA','111222333','444555666','frantisek.hotovec@uhk.cz',(SELECT MIN(pracovisteid) FROM pracoviste),'Heslo123','45000');
insert into pracovnik(jmeno,prijmeni,titulpred,titulza,telefon,mobil,email,pracovisteid,heslo,plat) 
values ('František','Hotovec','Mgr.','MBA','444555666','111222333','frantisek.hotovec@uhk.cz',(SELECT MIN(pracovisteid) FROM pracoviste),'Heslo123','45000');
end;
/
--OK

--Tabulka Predmet
--Atribut zkratka musí být unikátní - zajištěno unikátním klíčem
begin
insert into predmet(nazev,zkratka,pocetkreditu,zkratkazakonceni,zkratkakategorie) values('Testovaci predmet','TEST','666','ZK','A');
insert into predmet(nazev,zkratka,pocetkreditu,zkratkazakonceni,zkratkakategorie) values('Testovaci predmet','TEST','666','ZK','A');
end;
/
--OK

--Tabulka Pracoviste
--Atribut zkratka musí být unikátní - zajištěno unikátním klíčem
begin
insert into pracoviste (nazev,zkratka) values ('Testovaci pracoviste','TEST');
insert into pracoviste (nazev,zkratka) values ('Testovaci pracoviste','TEST');
end;
/
--OK


--Netrivialní integritní omezení
--Tabulka Vyukova_akce
--Nelze vytvořit vyukovou akci pro více studentů, než kolik se vejde do místnosti
SET SERVEROUTPUT ON 
declare
v_predmetid NUMBER(38,0);
v_mistnostid NUMBER(38,0);
v_maxstudentu NUMBER(38,0);

begin
select min(mistnostid) into v_mistnostid from mistnost where kapacita > 0;
select max(predmetid) into v_predmetid from predmet;
select kapacita into v_maxstudentu from mistnost where mistnostid = v_mistnostid;
dbms_output.put_line('ID mistnosti: ' || v_mistnostid);
dbms_output.put_line('kapacita: ' || v_maxstudentu);
v_maxstudentu := v_maxstudentu + 10;
dbms_output.put_line('zvysena kapacita: ' || v_maxstudentu);
dbms_output.put_line('predmet ID: ' || v_predmetid);
insert into vyukova_akce(maxstudentu,zpusobvyukyzkrata,pocatek,konec,predmetid,mistnostid) values(v_maxstudentu,'PR','01/12/2020','31/12/2020',v_predmetid,v_mistnostid);
end;
/
--NEFUNGUJE!!!!!!!!!!!!!!!!!!!!!!!

--Tabulka Zapis
--Nelze zapsat více studentů na výukovou akci než je kapacita
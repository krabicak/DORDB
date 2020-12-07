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

--Tabulka Zapis
--Nelze zapsat více studentů na výukovou akci než je kapacita
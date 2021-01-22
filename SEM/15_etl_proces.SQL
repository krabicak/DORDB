
CREATE TABLE kategorie_predmetu
As
SELECT zkratkakategorie, nazevkategorie
FROM kategorie_predmetu@ORA2.UHK.CZ
LOGGING;

ALTER TABLE kategorie_predmetu ADD CONSTRAINT kategorie_predmetu_pk PRIMARY KEY ( zkratkakategorie );

CREATE TABLE mistnost 
As
SELECT     
    mistnostid
    ,kapacita
    ,koducebny
    ,nvl(popisucebny, 'neuvedený') AS "popisucebny" 
FROM mistnost@ORA2.UHK.CZ
LOGGING;

ALTER TABLE mistnost ADD CONSTRAINT mistnost_pk PRIMARY KEY ( mistnostid );

CREATE TABLE pracoviste 
As
SELECT
    pracovisteid
    ,nazev
    ,zkratka
FROM pracoviste@ORA2.UHK.CZ
LOGGING;

ALTER TABLE pracoviste ADD CONSTRAINT pracoviste_pk PRIMARY KEY ( pracovisteid );

ALTER TABLE pracoviste ADD CONSTRAINT pracoviste_zkratka_un UNIQUE ( zkratka );

CREATE TABLE pracovnik
As
SELECT
    pracovnikid
    ,jmeno
    ,prijmeni
    ,nvl(titulpred, 'neuveden') AS "titulpred"
    ,nvl(titulza, 'neuveden') AS "titulza" 
    ,nvl(telefon, 'neuveden') AS "telefon"
    ,nvl(mobil, 'neuveden') AS "mobil"
    ,nvl(email, 'neuveden') AS "email"
    ,pracovisteid
    ,heslo  
    ,plat   
    ,nvl(nadrizenyid, 0) AS "nadrizenyid"
FROM pracovnik@ORA2.UHK.CZ
LOGGING;

ALTER TABLE pracovnik ADD CONSTRAINT pracovnik_pk PRIMARY KEY ( pracovnikid );

CREATE TABLE predmet 
As
SELECT
    predmetid
    ,nazev
    ,zkratka
    ,pocetkreditu
    ,zkratkazakonceni
    ,zkratkakategorie
FROM predmet@ORA2.UHK.CZ
LOGGING;

ALTER TABLE predmet ADD CONSTRAINT predmet_pk PRIMARY KEY ( predmetid );

ALTER TABLE predmet ADD CONSTRAINT predmet_zkratka_un UNIQUE ( zkratka );

CREATE TABLE student 
As
SELECT
    studentid
    ,jmeno
    ,prijmeni
FROM student@ORA2.UHK.CZ
LOGGING;

ALTER TABLE student ADD CONSTRAINT student_pk PRIMARY KEY ( studentid );

CREATE TABLE vyukova_akce As
SELECT
    vyukovaakceid
    ,maxstudentu
    ,zpusobvyukyzkrata
    ,nvl(pocatek, to_date('08.02.20','DD.MM.RR')) AS "pocatek"
    ,nvl(konec, to_date('08.02.20','DD.MM.RR')) AS "konec"
    ,mistnostid
FROM vyukova_akce@ORA2.UHK.CZ
LOGGING;

ALTER TABLE vyukova_akce ADD CONSTRAINT vyukova_akce_pk PRIMARY KEY ( vyukovaakceid );

CREATE TABLE zakonceni_predmetu As
SELECT
    zkratkazakonceni
    ,nazevzakonceni
FROM zakonceni_predmetu@ORA2.UHK.CZ
LOGGING;

ALTER TABLE zakonceni_predmetu ADD CONSTRAINT zakonceni_predmetu_pk PRIMARY KEY ( zkratkazakonceni );

CREATE TABLE zapis_predmetu 
As
SELECT
    zp.predmetid
    ,zp.studentid
    ,zp.pokus
    ,zp.vystudovan
    ,v.pracovnikid
    ,va.vyukovaakceid
FROM zapis_predmetu@ORA2.UHK.CZ zp 
     ,vyukova_akce@ORA2.UHK.CZ va 
     ,vyucujici@ORA2.UHK.CZ v 
    WHERE va.predmetid=zp.predmetid
    AND v.vyukovaakceid=va.vyukovaakceid;
    
CREATE TABLE zpusob_vyuky As
SELECT
    zkrata
    ,nazevzpusobu
FROM zpusob_vyuky@ORA2.UHK.CZ
LOGGING;

ALTER TABLE zpusob_vyuky ADD CONSTRAINT zpusob_vyuky_pk PRIMARY KEY ( zkrata );

ALTER TABLE pracovnik
    ADD CONSTRAINT pracovnik_pracoviste_fk FOREIGN KEY ( pracovisteid )
        REFERENCES pracoviste ( pracovisteid )
    NOT DEFERRABLE;

ALTER TABLE pracovnik
    ADD CONSTRAINT pracovnik_pracovnik_fk FOREIGN KEY ( pracovnikid )
        REFERENCES pracovnik ( pracovnikid )
    NOT DEFERRABLE;

ALTER TABLE predmet
    ADD CONSTRAINT predmet_kategorie_fk FOREIGN KEY ( zkratkakategorie )
        REFERENCES kategorie_predmetu ( zkratkakategorie )
    NOT DEFERRABLE;

ALTER TABLE predmet
    ADD CONSTRAINT predmet_zakonceni_fk FOREIGN KEY ( zkratkazakonceni )
        REFERENCES zakonceni_predmetu ( zkratkazakonceni )
    NOT DEFERRABLE;

ALTER TABLE vyukova_akce
    ADD CONSTRAINT vyukova_akce_mistnost_fk FOREIGN KEY ( mistnostid )
        REFERENCES mistnost ( mistnostid )
    NOT DEFERRABLE;

ALTER TABLE vyukova_akce
    ADD CONSTRAINT vyukova_akce_zpusob_vyuky_fk FOREIGN KEY ( ZPUSOBVYUKYZKRATA )
        REFERENCES zpusob_vyuky ( zkrata )
    NOT DEFERRABLE;

ALTER TABLE zapis_predmetu
    ADD CONSTRAINT zapis_predmetu_pracovnik_fk FOREIGN KEY ( pracovnikid )
        REFERENCES pracovnik ( pracovnikid )
    NOT DEFERRABLE;

ALTER TABLE zapis_predmetu
    ADD CONSTRAINT zapis_predmetu_predmet_fk FOREIGN KEY ( predmetid )
        REFERENCES predmet ( predmetid )
    NOT DEFERRABLE;

ALTER TABLE zapis_predmetu
    ADD CONSTRAINT zapis_predmetu_student_fk FOREIGN KEY ( studentid )
        REFERENCES student ( studentid )
    NOT DEFERRABLE;
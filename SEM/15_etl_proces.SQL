
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
    ,popisucebny DEFAULT 'neuvedený'
FROM mistnost@ORA2.UHK.CZ
LOGGING;

ALTER TABLE mistnost ADD CONSTRAINT mistnost_pk PRIMARY KEY ( mistnostid );

CREATE TABLE pracoviste 
As
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
    ,titulpred DEFAULT 'neuveden'
    ,titulza DEFAULT 'neuveden' 
    ,telefon DEFAULT 'neuveden'
    ,mobil DEFAULT 'neuveden' 
    ,email DEFAULT 'neuveden'
    ,pracovisteid
    ,heslo  
    ,plat   
    ,nadrizenyid DEFAULT 'neuveden'
FROM pracovnik@ORA2.UHK.CZ
LOGGING;

ALTER TABLE pracovnik ADD CONSTRAINT pracovnik_pk PRIMARY KEY ( pracovnikid );

ALTER TABLE pracovnik ADD CONSTRAINT pracovnik_mobil_un UNIQUE ( mobil );

ALTER TABLE pracovnik ADD CONSTRAINT pracovnik_email_un UNIQUE ( email );

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

ALTER TABLE predmet ADD CONSTRAINT predmet_pk PRIMARY KEY ( predmet_id );

ALTER TABLE predmet ADD CONSTRAINT predmet_zkratka_un UNIQUE ( zkratka );

CREATE TABLE student 
As
SELECT
    ,studentid
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
    ,pocatek  DEFAULT '01-01-2000T08:00:00'
    ,konec DEFAULT '01-01-2000T09:00:00'
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

CREATE TABLE zapis_predmetu As
SELECT
    zp.predmetid
    ,zp.studentid
    ,zp.pokus
    ,zp.vystudovan
    ,v.pracovnikid
    ,va.vyukovaakceid
FROM zapis_predmetu@ORA2.UHK.CZ zp 
    JOIN vyukova_akce@ORA2.UHK.CZ va ON va.predmetid=zp.predmetid
    JOIN vyucujici@ORA2.UHK.CZ v ON v.vyukovaakceid=va.vyukovaakceid
LOGGING;

CREATE TABLE zpusob_vyuky As
SELECT
    zkrata
    ,nazevzpusobu
FROM zpusob_vyuky@ORA2.UHK.CZ
LOGGING;

ALTER TABLE zpusob_vyuky ADD CONSTRAINT zpusob_vyuky_pk PRIMARY KEY ( zkrata );

ALTER TABLE pracovnik
    ADD CONSTRAINT pracovnik_pracoviste_fk FOREIGN KEY ( pracoviste_pracovisteid )
        REFERENCES pracoviste ( pracovisteid )
    NOT DEFERRABLE;

ALTER TABLE pracovnik
    ADD CONSTRAINT pracovnik_pracovnik_fk FOREIGN KEY ( pracovnik_pracovnikid )
        REFERENCES pracovnik ( pracovnikid )
    NOT DEFERRABLE;

ALTER TABLE predmet
    ADD CONSTRAINT predmet_kategorie_fk FOREIGN KEY ( kategorie_zkratka )
        REFERENCES kategorie_predmetu ( zkratkakategorie )
    NOT DEFERRABLE;

ALTER TABLE predmet
    ADD CONSTRAINT predmet_vyukova_akce_fk FOREIGN KEY ( vyukova_akce_vyukovaakceid )
        REFERENCES vyukova_akce ( vyukovaakceid )
    NOT DEFERRABLE;

ALTER TABLE predmet
    ADD CONSTRAINT predmet_zakonceni_fk FOREIGN KEY ( zakonceni_zkratka )
        REFERENCES zakonceni_predmetu ( zkratkazakonceni )
    NOT DEFERRABLE;

ALTER TABLE vyukova_akce
    ADD CONSTRAINT vyukova_akce_mistnost_fk FOREIGN KEY ( mistnost_mistnostid )
        REFERENCES mistnost ( mistnostid )
    NOT DEFERRABLE;

ALTER TABLE vyukova_akce
    ADD CONSTRAINT vyukova_akce_zpusob_vyuky_fk FOREIGN KEY ( zpusob_vyuky_zkrata )
        REFERENCES zpusob_vyuky ( zkrata )
    NOT DEFERRABLE;

ALTER TABLE zapis_predmetu
    ADD CONSTRAINT zapis_predmetu_pracovnik_fk FOREIGN KEY ( pracovnik_pracovnikid )
        REFERENCES pracovnik ( pracovnikid )
    NOT DEFERRABLE;

ALTER TABLE zapis_predmetu
    ADD CONSTRAINT zapis_predmetu_predmet_fk FOREIGN KEY ( predmet_predmetid )
        REFERENCES predmet ( predmet_id )
    NOT DEFERRABLE;

ALTER TABLE zapis_predmetu
    ADD CONSTRAINT zapis_predmetu_student_fk FOREIGN KEY ( student_studentid )
        REFERENCES student ( studentid )
    NOT DEFERRABLE;
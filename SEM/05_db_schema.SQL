CREATE TABLE kategorie_predmetu (
    zkratkakategorie  NVARCHAR2(10) NOT NULL,
    nazevkategorie    NVARCHAR2(50) NOT NULL
);

ALTER TABLE kategorie_predmetu ADD CONSTRAINT kategorie_predmetu_pk PRIMARY KEY ( zkratkakategorie );

CREATE TABLE mistnost (
    mistnostid   INTEGER NOT NULL,
    kapacita     INTEGER NOT NULL,
    koducebny    NVARCHAR2(10) NOT NULL,
    popisucebny  NVARCHAR2(50)
);

ALTER TABLE mistnost ADD CONSTRAINT mistnost_pk PRIMARY KEY ( mistnostid );

CREATE TABLE pracoviste (
    pracovisteid  INTEGER NOT NULL,
    nazev         NVARCHAR2(50) NOT NULL,
    zkratka       NVARCHAR2(50) NOT NULL
);

ALTER TABLE pracoviste ADD CONSTRAINT pracoviste_pk PRIMARY KEY ( pracovisteid );

ALTER TABLE pracoviste ADD CONSTRAINT pracoviste_zkratka_un UNIQUE ( zkratka );

CREATE TABLE pracovnik (
    pracovnikid   INTEGER NOT NULL,
    jmeno         NVARCHAR2(50) NOT NULL,
    prijmeni      NVARCHAR2(50) NOT NULL,
    titulpred     NVARCHAR2(50),
    titulza       NVARCHAR2(50),
    telefon       NVARCHAR2(50),
    mobil         NVARCHAR2(50),
    email         NVARCHAR2(50),
    pracovisteid  INTEGER,
    heslo         NVARCHAR2(100) NOT NULL,
    plat          INTEGER NOT NULL,
    nadrizenyid   INTEGER
);

ALTER TABLE pracovnik ADD CONSTRAINT pracovnik_pk PRIMARY KEY ( pracovnikid );

ALTER TABLE pracovnik ADD CONSTRAINT pracovnik_mobil_un UNIQUE ( mobil );

ALTER TABLE pracovnik ADD CONSTRAINT pracovnik_email_un UNIQUE ( email );

CREATE TABLE predmet (
    predmetid         INTEGER NOT NULL,
    nazev             NVARCHAR2(50) NOT NULL,
    zkratka           NVARCHAR2(50) NOT NULL,
    pocetkreditu      INTEGER NOT NULL,
    zkratkazakonceni  NVARCHAR2(10) NOT NULL,
    zkratkakategorie  NVARCHAR2(10)
);

ALTER TABLE predmet ADD CONSTRAINT predmet_pk PRIMARY KEY ( predmetid );

ALTER TABLE predmet ADD CONSTRAINT predmet_zkratka_un UNIQUE ( zkratka );

CREATE TABLE student (
    studentid  INTEGER NOT NULL,
    jmeno      NVARCHAR2(50) NOT NULL,
    prijmeni   NVARCHAR2(50) NOT NULL
);

ALTER TABLE student ADD CONSTRAINT student_pk PRIMARY KEY ( studentid );

CREATE TABLE vyucujici (
    pracovnikid    INTEGER NOT NULL,
    vyukovaakceid  INTEGER NOT NULL
);

ALTER TABLE vyucujici ADD CONSTRAINT relation_11_pk PRIMARY KEY ( pracovnikid,
                                                                  vyukovaakceid );

CREATE TABLE vyukova_akce (
    vyukovaakceid      INTEGER NOT NULL,
    maxstudentu        INTEGER NOT NULL,
    zpusobvyukyzkrata  NVARCHAR2(10) NOT NULL,
    pocatek            DATE,
    konec              DATE,
    predmetid          INTEGER NOT NULL,
    mistnostid         INTEGER NOT NULL
);

ALTER TABLE vyukova_akce ADD CONSTRAINT vyukova_akce_pk PRIMARY KEY ( vyukovaakceid );

CREATE TABLE zakonceni_predmetu (
    zkratkazakonceni  NVARCHAR2(10) NOT NULL,
    nazevzakonceni    NVARCHAR2(50) NOT NULL
);

ALTER TABLE zakonceni_predmetu ADD CONSTRAINT zakonceni_predmetu_pk PRIMARY KEY ( zkratkazakonceni );

CREATE TABLE zapis (
    studentid      INTEGER NOT NULL,
    vyukovaakceid  INTEGER NOT NULL
);

ALTER TABLE zapis ADD CONSTRAINT relation_13_pk PRIMARY KEY ( studentid,
                                                              vyukovaakceid );

CREATE TABLE zpusob_vyuky (
    zkrata        NVARCHAR2(10) NOT NULL,
    nazevzpusobu  NVARCHAR2(50) NOT NULL
);

ALTER TABLE zpusob_vyuky ADD CONSTRAINT zpusob_vyuky_pk PRIMARY KEY ( zkrata );

CREATE TABLE zapis_predmetu (
    predmetid   INTEGER NOT NULL,
    studentid   INTEGER NOT NULL,
    pokus       INTEGER NOT NULL,
    vystudovan  CHAR(1) NOT NULL
)
LOGGING;

ALTER TABLE pracovnik
    ADD CONSTRAINT pracovnik_pracoviste_fk FOREIGN KEY ( pracovisteid )
        REFERENCES pracoviste ( pracovisteid );

ALTER TABLE pracovnik
    ADD CONSTRAINT pracovnik_pracovnik_fk FOREIGN KEY ( nadrizenyid )
        REFERENCES pracovnik ( pracovnikid );

ALTER TABLE predmet
    ADD CONSTRAINT predmet_kategorie_predmetu_fk FOREIGN KEY ( zkratkakategorie )
        REFERENCES kategorie_predmetu ( zkratkakategorie );

ALTER TABLE predmet
    ADD CONSTRAINT predmet_zakonceni_predmetu_fk FOREIGN KEY ( zkratkazakonceni )
        REFERENCES zakonceni_predmetu ( zkratkazakonceni );

ALTER TABLE vyucujici
    ADD CONSTRAINT relation_11_pracovnik_fk FOREIGN KEY ( pracovnikid )
        REFERENCES pracovnik ( pracovnikid );

ALTER TABLE vyucujici
    ADD CONSTRAINT relation_11_vyukova_akce_fk FOREIGN KEY ( vyukovaakceid )
        REFERENCES vyukova_akce ( vyukovaakceid );

ALTER TABLE zapis
    ADD CONSTRAINT relation_13_student_fk FOREIGN KEY ( studentid )
        REFERENCES student ( studentid );

ALTER TABLE zapis
    ADD CONSTRAINT relation_13_vyukova_akce_fk FOREIGN KEY ( vyukovaakceid )
        REFERENCES vyukova_akce ( vyukovaakceid );

ALTER TABLE vyukova_akce
    ADD CONSTRAINT vyukova_akce_mistnost_fk FOREIGN KEY ( mistnostid )
        REFERENCES mistnost ( mistnostid );

ALTER TABLE vyukova_akce
    ADD CONSTRAINT vyukova_akce_predmet_fk FOREIGN KEY ( predmetid )
        REFERENCES predmet ( predmetid );

ALTER TABLE vyukova_akce
    ADD CONSTRAINT vyukova_akce_zpusob_vyuky_fk FOREIGN KEY ( zpusobvyukyzkrata )
        REFERENCES zpusob_vyuky ( zkrata );

ALTER TABLE zapis_predmetu
    ADD CONSTRAINT zapis_predmetu_predmet_fk FOREIGN KEY ( predmetid )
        REFERENCES predmet ( predmetid );

ALTER TABLE zapis_predmetu
    ADD CONSTRAINT zapis_predmetu_student_fk FOREIGN KEY ( studentid )
        REFERENCES student ( studentid );

CREATE SEQUENCE mistnost_mistnostid_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER mistnost_mistnostid_trg BEFORE
    INSERT ON mistnost
    FOR EACH ROW
    WHEN ( new.mistnostid IS NULL )
BEGIN
    :new.mistnostid := mistnost_mistnostid_seq.nextval;
END;
/

CREATE SEQUENCE pracoviste_pracovisteid_seq START WITH 1 NOCACHE ORDER;

ALTER SESSION SET PLSCOPE_SETTINGS = 'IDENTIFIERS:NONE';
/

CREATE OR REPLACE TRIGGER pracoviste_pracovisteid_trg BEFORE
    INSERT ON pracoviste
    FOR EACH ROW
    WHEN ( new.pracovisteid IS NULL )
BEGIN
    :new.pracovisteid := pracoviste_pracovisteid_seq.nextval;
END;
/

CREATE SEQUENCE pracovnik_pracovnikid_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER pracovnik_pracovnikid_trg BEFORE
    INSERT ON pracovnik
    FOR EACH ROW
    WHEN ( new.pracovnikid IS NULL )
BEGIN
    :new.pracovnikid := pracovnik_pracovnikid_seq.nextval;
END;
/

CREATE SEQUENCE predmet_predmetid_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER predmet_predmetid_trg BEFORE
    INSERT ON predmet
    FOR EACH ROW
    WHEN ( new.predmetid IS NULL )
BEGIN
    :new.predmetid := predmet_predmetid_seq.nextval;
END;
/

CREATE SEQUENCE student_studentid_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER student_studentid_trg BEFORE
    INSERT ON student
    FOR EACH ROW
    WHEN ( new.studentid IS NULL )
BEGIN
    :new.studentid := student_studentid_seq.nextval;
END;
/

CREATE SEQUENCE vyukova_akce_vyukovaakceid_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER vyukova_akce_vyukovaakceid_trg BEFORE
    INSERT ON vyukova_akce
    FOR EACH ROW
    WHEN ( new.vyukovaakceid IS NULL )
BEGIN
    :new.vyukovaakceid := vyukova_akce_vyukovaakceid_seq.nextval;
END;
/
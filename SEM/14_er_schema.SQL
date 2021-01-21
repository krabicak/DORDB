CREATE SEQUENCE mistnost_mistnostid_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE pracoviste_pracovisteid_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE pracovnik_pracovnikid_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE predmet_predmetid_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE student_studentid_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE vyukova_akce_vyukovaakceid_seq START WITH 1 NOCACHE ORDER;

CREATE TABLE kategorie_predmetu (
    zkratkakategorie  NVARCHAR2(10) NOT NULL,
    nazevkategorie    NVARCHAR2(50) NOT NULL
)
LOGGING;

ALTER TABLE kategorie_predmetu ADD CONSTRAINT kategorie_predmetu_pk PRIMARY KEY ( zkratkakategorie );

CREATE TABLE mistnost (
    mistnostid   INTEGER NOT NULL,
    kapacita     INTEGER NOT NULL,
    koducebny    NVARCHAR2(10) NOT NULL,
    popisucebny  NVARCHAR2(50)
)
LOGGING;

ALTER TABLE mistnost ADD CONSTRAINT mistnost_pk PRIMARY KEY ( mistnostid );

CREATE TABLE pracoviste (
    pracovisteid  INTEGER NOT NULL,
    nazev         NVARCHAR2(50) NOT NULL,
    zkratka       NVARCHAR2(50) NOT NULL
)
LOGGING;

ALTER TABLE pracoviste ADD CONSTRAINT pracoviste_pk PRIMARY KEY ( pracovisteid );

ALTER TABLE pracoviste ADD CONSTRAINT pracoviste_zkratka_un UNIQUE ( zkratka );

CREATE TABLE pracovnik (
    pracovnikid              INTEGER NOT NULL,
    jmeno                    NVARCHAR2(50) NOT NULL,
    prijmeni                 NVARCHAR2(50) NOT NULL,
    titulpred                NVARCHAR2(50),
    titulza                  NVARCHAR2(50),
    telefon                  NVARCHAR2(50),
    mobil                    NVARCHAR2(50),
    email                    NVARCHAR2(50),
    pracoviste_pracovisteid  INTEGER,
    heslo                    NVARCHAR2(100) NOT NULL,
    plat                     INTEGER NOT NULL,
    pracovnik_pracovnikid    INTEGER
)
LOGGING;

ALTER TABLE pracovnik ADD CONSTRAINT pracovnik_pk PRIMARY KEY ( pracovnikid );

ALTER TABLE pracovnik ADD CONSTRAINT pracovnik_mobil_un UNIQUE ( mobil );

ALTER TABLE pracovnik ADD CONSTRAINT pracovnik_email_un UNIQUE ( email );

CREATE TABLE predmet (
    predmet_id                  INTEGER
        CONSTRAINT nnc_predmet_predmet_id NOT NULL,
    nazev                       NVARCHAR2(50)
        CONSTRAINT nnc_predmet_nazev NOT NULL,
    zkratka                     NVARCHAR2(50)
        CONSTRAINT nnc_predmet_zkratka NOT NULL,
    pocetkreditu                INTEGER
        CONSTRAINT nnc_predmet_pocetkreditu NOT NULL,
    zakonceni_predmetu_zkratka  NVARCHAR2(10)
             CONSTRAINT nnc_predmet_zakonceni_zkratka NOT NULL,
    kategorie_predmetu_zkratka  NVARCHAR2(10)
)
LOGGING;

ALTER TABLE predmet ADD CONSTRAINT predmet_pk PRIMARY KEY ( predmet_id );

ALTER TABLE predmet ADD CONSTRAINT predmet_zkratka_un UNIQUE ( zkratka );

CREATE TABLE student (
    studentid  INTEGER NOT NULL,
    jmeno      NVARCHAR2(50) NOT NULL,
    prijmeni   NVARCHAR2(50) NOT NULL
)
LOGGING;

ALTER TABLE student ADD CONSTRAINT student_pk PRIMARY KEY ( studentid );

CREATE TABLE vyukova_akce (
    vyukovaakceid        INTEGER NOT NULL,
    maxstudentu          INTEGER NOT NULL,
    zpusob_vyuky_zkrata  NVARCHAR2(10) NOT NULL,
    pocatek              DATE,
    konec                DATE,
    mistnost_mistnostid  INTEGER NOT NULL
)
LOGGING;

ALTER TABLE vyukova_akce ADD CONSTRAINT vyukova_akce_pk PRIMARY KEY ( vyukovaakceid );

CREATE TABLE zakonceni_predmetu (
    zkratkazakonceni  NVARCHAR2(10) NOT NULL,
    nazevzakonceni    NVARCHAR2(50) NOT NULL
)
LOGGING;

ALTER TABLE zakonceni_predmetu ADD CONSTRAINT zakonceni_zkratka_pk PRIMARY KEY ( zkratkazakonceni );

CREATE TABLE zapis_predmetu (
    predmet_predmet_id          INTEGER
             CONSTRAINT nnc_zapis_predmetu_predmet_id NOT NULL,
    student_studentid           INTEGER
             CONSTRAINT nnc_zapis_predmetu_studentid NOT NULL,
    pokus                       INTEGER
        CONSTRAINT nnc_zapis_predmetu_pokus NOT NULL,
    vystudovan                  CHAR(1)
        CONSTRAINT nnc_zapis_predmetu_vystudovan NOT NULL,
    pracovnik_pracovnikid       INTEGER 
             CONSTRAINT nnc_zapis_predmetu_pracovnikid NOT NULL,
    vyukova_akce_vyukovaakceid  INTEGER 
             CONSTRAINT nnc_zapis_predmetu_akce_id NOT NULL
)
LOGGING;

CREATE TABLE zpusob_vyuky (
    zkrata        NVARCHAR2(10) NOT NULL,
    nazevzpusobu  NVARCHAR2(50) NOT NULL
)
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
    ADD CONSTRAINT predmet_kategorie_predmetu_fk FOREIGN KEY ( kategorie_predmetu_zkratka )
        REFERENCES kategorie_predmetu ( zkratkakategorie )
    NOT DEFERRABLE;

ALTER TABLE predmet
    ADD CONSTRAINT predmet_zakonceni_predmetu_fk FOREIGN KEY ( zakonceni_predmetu_zkratka )
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
    ADD CONSTRAINT zapis_predmetu_predmet_fk FOREIGN KEY ( predmet_predmet_id )
        REFERENCES predmet ( predmet_id )
    NOT DEFERRABLE;

ALTER TABLE zapis_predmetu
    ADD CONSTRAINT zapis_predmetu_student_fk FOREIGN KEY ( student_studentid )
        REFERENCES student ( studentid )
    NOT DEFERRABLE;

ALTER TABLE zapis_predmetu
    ADD CONSTRAINT zapis_predmetu_vyukova_akce_fk FOREIGN KEY ( vyukova_akce_vyukovaakceid )
        REFERENCES vyukova_akce ( vyukovaakceid )
    NOT DEFERRABLE;

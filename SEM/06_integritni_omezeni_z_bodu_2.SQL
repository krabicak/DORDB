-- Trivialni integritini omezeni

--Tabulka Vyukova_akce 
--Atribut konec nesmí být dříve než-li atribut konec (typ DATE)
ALTER TABLE VYUKOVA_AKCE ADD CONSTRAINT VYUKOVA_AKCE__C1 CHECK (pocatek < konec);

-- Netrivialní integritní omezení
-- Tabulka Vyukova_akce
-- Nelze vytvořit vyukovou akci pro více studentů, než kolik se vejde do místnosti
create or replace PROCEDURE KAPACITA_MISTNOSTI (IDMISTNOST IN NUMBER, MAXSTUDENTU IN NUMBER) AS
KAPACITA NUMBER;
BEGIN
    SELECT KAPACITA INTO KAPACITA FROM MISTNOST m WHERE m.mistnostid=IDMISTNOST;
    IF(MAXSTUDENTU > KAPACITA) THEN
        RAISE_APPLICATION_ERROR(-20000,'Překročena maximální kapacita místnosti.');
    END IF;
END KAPACITA_MISTNOSTI;

CREATE OR REPLACE TRIGGER VYUKOVA_AKCE_TRG
BEFORE insert OR update
ON VYUKOVA_AKCE
FOR EACH ROW BEGIN
    KAPACITA_MISTNOSTI(:NEW.MISTNOSTID,:NEW.MAXSTUDENTU);
END;

-- Tabulka Zapis
-- Nelze zapsat více studentů na výukovou akci než je kapacita
create or replace PROCEDURE KAPACITA_VYUKOVE_AKCE (IDVYUKOVAAKCE IN NUMBER) AS
POCETZAPISU NUMBER := 0;
MAXSTUDENTU NUMBER;
BEGIN
    SELECT COUNT(*) INTO POCETZAPISU FROM ZAPIS z
        JOIN VYUKOVA_AKCE v ON z.vyukovaakceid=v.vyukovaakceid 
        WHERE v.VYUKOVAAKCEID=IDVYUKOVAAKCE;
    SELECT v.maxstudentu INTO MAXSTUDENTU FROM VYUKOVA_AKCE v
        WHERE v.VYUKOVAAKCEID=IDVYUKOVAAKCE;
    IF(MAXSTUDENTU <= POCETZAPISU) THEN
        RAISE_APPLICATION_ERROR(-20000,'Překročena maximální kapacita výukové akce.');
    END IF;
END KAPACITA_VYUKOVE_AKCE;

CREATE OR REPLACE TRIGGER ZAPIS_TRG
BEFORE insert
ON ZAPIS
FOR EACH ROW BEGIN
    KAPACITA_VYUKOVE_AKCE(:NEW.VYUKOVAAKCEID);
END;

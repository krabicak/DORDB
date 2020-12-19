CREATE OR REPLACE PACKAGE zapis_studenta_api AS
   PROCEDURE ZAPSAT_PREDMET (STUDENT_ID IN NUMBER,PREDMET_ID IN NUMBER);
   PROCEDURE zapsat_vyukovou_akci (STUDENT_ID IN NUMBER,vyukova_akce_id IN NUMBER);
END zapis_studenta_api;
/

CREATE OR REPLACE PACKAGE BODY zapis_studenta_api AS
PROCEDURE ZAPSAT_PREDMET 
(
  STUDENT_ID IN NUMBER
, PREDMET_ID IN NUMBER 
) AS 
  pok NUMBER := NULL;
  vys NUMBER := NULL;
  exi NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO exi 
    FROM zapis_predmetu 
    WHERE predmetid=PREDMET_ID AND studentid=STUDENT_ID;
  IF exi != 0 THEN
    SELECT pokus,vystudovan INTO pok,vys 
        FROM zapis_predmetu 
        WHERE predmetid=PREDMET_ID AND studentid=STUDENT_ID;
    IF vys = 1 THEN
        RAISE_APPLICATION_ERROR(-20000,'Nelze zapsat již vystudovaný předmět.');
    END IF;
    IF pok>=3 THEN
        RAISE_APPLICATION_ERROR(-20000,'Byl vyčerpán limit zapsání předmětu.');
    END IF;
    pok := pok + 1;
    UPDATE zapis_predmetu SET pokus=pok WHERE studentid=student_id AND predmetid=predmet_id;
  ELSE 
    INSERT INTO zapis_predmetu VALUES (STUDENT_ID,PREDMET_ID,1,0);
  END IF;
END ZAPSAT_PREDMET;
  
PROCEDURE zapsat_vyukovou_akci (STUDENT_ID IN NUMBER,vyukova_akce_id IN NUMBER) AS  
  exi NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO exi
      FROM zapis_predmetu zp JOIN vyukova_akce va ON zp.predmetid=va.predmetid 
      WHERE va.vyukovaakceid=vyukova_akce_id AND zp.studentid=STUDENT_ID;
    IF exi = 0 THEN
      RAISE_APPLICATION_ERROR(-20000,'Student musí být nejprve zapsán do předmětu.');
    END IF;
    INSERT INTO ZAPIS VALUES (STUDENT_ID,vyukova_akce_id);
  END zapsat_vyukovou_akci;  
END zapis_studenta_api;
/
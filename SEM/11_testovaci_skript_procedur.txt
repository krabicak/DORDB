-- 1. Zapis studenta do predmetu
SET AUTOTRACE ON;

DECLARE
  stid integer := 101;
  pid integer := 9509;

BEGIN
  zapis_studenta_api.zapsat_predmet(stid,pid);
END;
/

-- vypis
SELECT * FROM zapis_predmetu WHERE studentid = (101) and predmetid=(1000);


SET AUTOTRACE ON;
-- 2. Zapis studenta na vyukovou akci

DECLARE
  stid integer := 1000;
  vaid integer := 367;
BEGIN
  zapis_studenta_api.zapsat_vyukovou_akci(stid, vaid);
END;
/

-- vypis
SELECT * FROM zapis WHERE studentid = (1000) and vyukovaakceid=(367);
--upraveni tabulky student
alter table student add pocethodin number(38,0);

--prepocet poctu akci
DECLARE
    v_sumaakci NUMBER(38) := 0;
BEGIN FOR r_product IN (
    SELECT * FROM student
) LOOP
    select count(*) into v_sumaakci from zapis where studentid = r_product.studentid;
    update student set pocethodin = v_sumaakci where studentid = r_product.studentid;
 end loop;
END;
/

--procedura inkrement
CREATE OR REPLACE PROCEDURE incr_pocetAkci (p_studentId IN NUMBER) AS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_sumAkci NUMBER(38):=0;
BEGIN
  SELECT pocetAkci INTO v_sumAkci FROM student WHERE studentId = p_studentId;  
  UPDATE student SET pocetAkci=v_sumAkci+1 where studentId=p_studentId;
  COMMIT;
END;
/

--trigger pro vkladani
create or replace trigger trig_zapis_insert
after insert on zapis
for each row
begin
    incr_pocetAkci(:NEW.studentId);
end;
/

--procedura dekrement
CREATE OR REPLACE PROCEDURE decr_pocetAkci (p_studentId IN NUMBER) AS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_sumAkci NUMBER(38):=0;
BEGIN
  SELECT pocetAkci INTO v_sumAkci FROM student WHERE studentId = p_studentId;  
  UPDATE student SET pocetAkci=v_sumAkci-1 where studentId=p_studentId;
  commit;
END;
/

--trigger pro odebirani
create or replace trigger trig_zapis_delete
after delete on zapis
for each row
begin
    decr_pocetAkci(:OLD.studentId);
end;
/

--trigger pro update
create or replace trigger trig_zapis_update
after update on zapis
for each row
DECLARE
    v_sumaakci NUMBER(38) := 0;
begin
    incr_pocetAkci(:NEW.studentId);
    decr_pocetAkci(:OLD.studentId);
end;
/

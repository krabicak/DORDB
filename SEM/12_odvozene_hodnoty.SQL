--upraveni tabulky student
alter table student add pocethodin number(38,0);

--prepocet poctu akci
DECLARE
    v_sumaakci NUMBER(38) := 0;
BEGIN FOR r_product IN (
    SELECT * FROM student
) LOOP
    select count(*) into v_sumaakci from zapis where studentid = r_product.studentid;
    update student set pocetakci = v_sumaakci where studentid = r_product.studentid;
 end loop;
END;
/

--trigger pro vkladani
create or replace trigger trig_zapis_insert
after insert on zapis
for each row
DECLARE
    v_sumaakci NUMBER(38) := 0;
begin
    select pocetakci into v_sumaakci from student where studentid = :NEW.studentid;
    update student set pocetakci = v_sumaakci+1 where studentid = :NEW.studentid;
end;
/

--trigger pro odebirani
create or replace trigger trig_zapis_delete
after delete on zapis
for each row
DECLARE
    v_sumaakci NUMBER(38) := 0;
begin
    select pocetakci into v_sumaakci from student where studentid = :OLD.studentid;
    update student set pocetakci = v_sumaakci-1 where studentid = :OLD.studentid;
end;
/

--trigger pro update
create or replace trigger trig_zapis_update
after update on zapis
for each row
DECLARE
    v_sumaakci NUMBER(38) := 0;
begin
    select pocetakci into v_sumaakci from student where studentid = :OLD.studentid;
    update student set pocetakci = v_sumaakci-1 where studentid = :OLD.studentid;
    select pocetakci into v_sumaakci from student where studentid = :NEW.studentid;
    update student set pocetakci = v_sumaakci+1 where studentid = :NEW.studentid;
end;
/

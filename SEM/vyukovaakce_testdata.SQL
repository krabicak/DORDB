set serveroutput on;
DECLARE 
   maxmistnost number:= 999;
   maxpredmet number:= 999;
   
   nahodnemistnost number:= 999;
   nahodnepredmet number:= 999;
   
   v_mistnostid number := 999;
   v_predmetid number := 999;
   
   v_nahodnestudent number := 999;
   
   v_vyuka varchar2(10);
   v_nahodnevyuka number := 0;
   
   v_nahodnedatum number := 0;
BEGIN
    SELECT count(*) INTO maxmistnost from mistnost;
    SELECT count(*) INTO maxpredmet from predmet;
    --for
    FOR l_counter IN 1..500
    LOOP
        nahodnemistnost := ROUND(dbms_random.value(1,maxmistnost),0);
        nahodnepredmet := ROUND(dbms_random.value(1,maxpredmet),0);
        v_nahodnestudent := ROUND(dbms_random.value(1,15)*10,0);
        v_nahodnevyuka := ROUND(dbms_random.value(1,2),0);
        v_nahodnedatum := ROUND(dbms_random.value(1,2),0);
    
        SELECT mistnostid into v_mistnostid from (SELECT mistnostid, ROWNUM AS RN FROM mistnost) WHERE RN =  nahodnemistnost;
        SELECT predmetid into v_predmetid from (SELECT predmetid, ROWNUM AS RN FROM predmet) WHERE RN =  nahodnepredmet;

    
        IF v_nahodnevyuka = 1 THEN
            v_vyuka := 'PR';
        ELSE
           v_vyuka := 'CV';
        end if;
        
        IF v_nahodnedatum = 1 THEN
            insert into vyukova_akce (maxstudentu,zpusobvyukyzkrata,pocatek,konec,predmetid,mistnostid) values (v_nahodnestudent,v_vyuka,'29/09/2020','05/02/2021',v_predmetid,v_mistnostid);
        ELSE
           insert into vyukova_akce (maxstudentu,zpusobvyukyzkrata,pocatek,konec,predmetid,mistnostid) values (v_nahodnestudent,v_vyuka,'08/02/2020','31/08/2020',v_predmetid,v_mistnostid);
        end if;
        
    END LOOP;
    --for konec
END;
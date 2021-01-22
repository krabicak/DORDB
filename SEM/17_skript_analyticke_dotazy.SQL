--Seznam všech místností dle využití studenty za rok 2020
select m.koducebny, count(zp.studentid) as "Počet studentů" from mistnost m 
join vyukova_akce va on m.mistnostid=va.mistnostid 
join zapis_predmetu zp on va.vyukovaakceid=zp.vyukovaakceid
where va."pocatek">to_date('31.12.19','DD.MM.RR') 
    AND va."pocatek"<to_date('01.01.21','DD.MM.RR')
    AND va."konec">to_date('31.12.19','DD.MM.RR')
    AND va."konec"<to_date('01.01.21','DD.MM.RR')
    group by rollup(m.koducebny,zp.studentid)
    ORDER BY "Počet studentů";

--Vyucujici, ktery ucil nejvice studentu prvni pololeti roku 2021
select count(zp.studentid) from pracovnik p 
join zapis_predmetu zp on p.pracovnikid=zp.pracovnikid
join vyukova_akce va on zp.vyukovaakceid=va.vyukovaakceid 
where va."pocatek">to_date('31.12.20','DD.MM.RR') 
    AND va."pocatek"<to_date('01.07.21','DD.MM.RR')
    AND va."konec">to_date('01.01.21','DD.MM.RR')
    AND va."konec"<to_date('01.07.21','DD.MM.RR')
    group by p.pracovnikid,p.jmeno,p.prijmeni;
# DORDB #


# Rozvrh prací #

## KŮLIČ ##
- **[1.] Obrázek s modelem (E-R diagram)**
	-  musí obsahovat minimálně 4 entity, lze použít model z vlastních předchozích
semestrálních prací apod. Doporučena jsou originální zadání (nikoliv různé knihovny,
databáze CD/DVD, autobazary, apod.)

- **[4.] ✓Návrh pěti slovně formulovaných dotazů nad schématem**
 
	- musí se jednat o různorodé
netriviální dotazy (navrhněte dotazy vedoucí na použití poddotazů, vnějších spojení,
množinových operací, agregací, atd.)

- **[7.] ✓Skript, který naplní tabulky testovacími daty**

	- tabulky by měly obsahovat řádově tisíce řádků
(pro generování testovacích dat můžete použít různé již hotové nástroje).

- **[9.] ✓Skript, který se pokusí porušit postupně všechna dodatečná integritní omezení + výstup spool z provádění tohoto skriptu (budou vidět chyby při porušení I.O.)**
- **[12.] Skript, který doplní do zvolené tabulky schématu sloupec, který bude obsahovat odvozené hodnoty (průměrný plat zaměstnance v rámci oddělní apod.) – tyto hodnoty budou automaticky aktualizovány pomocí triggerů**
- **[13.] Navrhněte fakta a dimenze (E-R diagram) pro datový sklad vycházející z vaší databáze. Přidejte i časovou dimenzi.**
- **[14.]  Skript, který vytvoří databázové schéma odpovídající E-R diagramu datového skladu.**
- **[16.] Návrh dvou slovně formulovaných analytických dotazů nad datovým skladem, které povedou na agregaci faktu přes několik dimenzí za určité časové období.**


## KRABIČÁK ##
- **[2.] ✓Slovní popis dodatečných integritních omezení**

	- např. že plat musí být kladné číslo; že množství pracovníku v místnosti nemůže překročit kapacitu místnosti apod. (nepočítáme I.O. jako „unikátní“ nebo „cizí klíč“
nebo omezení velikosti položky u řetězců nebo čísel)

	- vyžadováno alespoň jedno „triviální omezení“ (jako např. plat 0) a jedno
„netriviální“ omezení (vztahem k jiné tabulce, agregační funkce jako v příkladu
s kapacitou apod.)
- **[3.] Návrh API rozhraní „business logiky“ pro dva procesy, jako např. přijetí zaměstnance =
založení záznamu zaměstnance, svázání s nadřízeným, svázání se sdíleným služebním vozem
(vazba N:M), založení požadavku na koupi pracovních pomůcek (jeden notebook, jedna myš).
Procesy by měly být složitější, než jen takové, které vedou na jeden update či insert
v proceduře.**
	-  procedury, jejich parametry, slovní popis činnosti
- **[5.] ✓Skript, který vytvoří databázové schéma odpovídající E-R diagramu**
- **[6.] Skript, který vytvoří v databázovém schématu dodatečná integritní omezení -DONE**
	- netriviální omezení budou realizována pomocí triggerů, které budou volat uložené
procedury provádějící kontrolu; porušení I.O. způsobí vyhození vlastní vyjímky
- **[8.] Skript (včetně výstupu spool), který provede postupně všechny navržené dotazy**
	- z výstupu bude patrný dotaz, jeho exekuční plán (použijte SET AUTOTRACE ON) a
výsledek

	- u dvou (dle úvahy) nejsložitějších dotazů se pokuste vymyslet ještě druhou verzi
dotazu (vracející tentýž výsledek), a porovnáním (podle cost) exekučních plánů
(budou opět součástí výstupu) posuďte, který dotaz byl efektivnější

- **[10.] Skript pro vytvoření balíku (package) a procedur „business logiky“**
- **[11.] Testovací skript (včetně výstupu spool obdrženého po spuštění) pro obě procedury**
- **[15.] Skript pro jednoduchý ETL proces dat z vaši produkční databáze**
- **[17.] . Skript (včetně výstupu spool), který provede postupně všechny navržené analytické dotazy.**

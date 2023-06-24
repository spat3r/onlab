### 1. Feladatkiírás

Az éldetektálás egy fontos eleme a gépi látásnak és a képfeldolgozási feladatoknak. Az egyes szoftveres megvalósítások rendelkeznek a módosíthatóság és az egyszerűbb implementálhatóság könnyebbségével. Ugyanakkor a hardveres megvalósítások sokkal gyorsabbak,az újraprogramozható eszközök pedig mindkét oldal előnyével rendelkeznek.

A félév során ismerkedjen meg az éldetektálási lehetőséggekkel és algoritmusokkal. A konzulenssel egyeztetve válasszon ki éldetektálási algoritmusokat, dolgozza ki azok hardveres megvalósítására alkalmas gyorsító IP mag fejlesztési lépésit.

A hallgató feladatának a következőkre kell kiterjednie:
 - Ismerje meg és mutassa be az éldetektálás módjait!
 - Ismerje meg és mutassa be FPGA alapú rendszerek hardveres gyorsítással lehetőségeit.
 - Készítsen platformfüggetlen éldetektálásra alkalmas IP rendszertervét és az almodulok funkcionális és interfészspecifikációját.
 - Határozza meg a rendszer szintézis- és futásidejű paramétereit.
 - Készítse el az IP mag technológiafüggetlen, szintetizálható RTL leírását SystemVerilog nyelven.
 - Az elkészített RTL design funkcionális verifikációjához készítsen automatizált regressziós tesztelésre alkalmas HDL tesztkörnyezeteket.
 - Szintetizálja az RTL designt a konzulenssel egyeztetett technológiára.
 - Ellenőrizze a rendszer működését valós áramköri környezetben.


### 2. Tartalomjegyzék

- [1. Feladatkiírás](#1-feladatkiírás)
- [2. Tartalomjegyzék](#2-tartalomjegyzék)
- [3. Bevezetés](#3-bevezetés)
- [4. Irodalomkutatás, felhasználási lehetőségek, motiváció](#4-irodalomkutatás-felhasználási-lehetőségek-motiváció)
- [5. Felhasznált eszközök](#5-felhasznált-eszközök)
  - [LOGSYS Kintex-7 specifikáció](#logsys-kintex-7-specifikáció)
- [6. Rendszerterv](#6-rendszerterv)
  - [Requirements](#requirements)
  - [Paraméterek](#paraméterek)
  - [6.1. Portok:](#61-portok)
  - [6.2. RGB2Y](#62-rgb2y)
  - [6.3. buffer](#63-buffer)
  - [6.4. blur](#64-blur)
  - [6.5. sobel](#65-sobel)
- [7. Requirements](#7-requirements)
  - [7.1. Sub-req önlab 2-re](#71-sub-req-önlab-2-re)
- [8. Verifikáció](#8-verifikáció)
  - [8.1. Assertions](#81-assertions)
- [9. Implementáció](#9-implementáció)
- [10. hardver tesztelés](#10-hardver-tesztelés)
- [11. Eredmények](#11-eredmények)
  - [11.1. Assertion eredmények](#111-assertion-eredmények)
  - [11.2. Cover eredmények](#112-cover-eredmények)
  - [11.3. Teljesített Requirementek](#113-teljesített-requirementek)


### 3. Bevezetés

A képfeldolgozás és a gépi látás során a cél, hogy a képekből illetve képkockákból jellegzetességet, információt nyerjünk ki. Ezek az információk lehetnek pontok, élek vagy teljes objektumok, de a neurális hálókkal absztraktabb tulajdonságok és jellegzetességek is felismerhetőek.

Az éldetektálás egy fontos lépése a hagyományos programozási eszközökkel történő képfeldolgozásnak. A képfeldolgozási folyamatok gyorsítására, vagy akár a Neurális Hálók alkalmazásánál a képi információk előfeldolgozására alkalmas lehet. Segítségével kiemelhetünk számunkra lényeges információkat és könnyen lecsökkenthetjük az adatmennyiséget és annak az információnak komplexitását, amivel dolgozni szeretnénk.

A legelterjedtebb alkalmazási módja az egyes képfeldolgozási algoritmusoknak a orvosi alkalmazásokban; a robotok és az önvezető járművek gépi látása során; objektumok, dolgok beazonosítására szatelit képeken, kamera felvételeken (ide értve különösképpen az arcfelismerést) csak, hogy néhányat említsek.

Az első félév során egy Sobel operátorral ellátott szűrőláncot valósítottam meg és teszteltem. A következő lépés egy alacsony erőforrásigényű gyök és arkusztangens megvalósítása lesz, így egy pontos Canny éldetektálást tudok megvalósítani. Végül, egy alkalmas hardvergyorsítóval és softprocesszoros környezettel felszerelve elkészíteni a Hough algoritmus 

### 4. Irodalomkutatás, felhasználási lehetőségek, motiváció

Az éldetektálás során változásokat keresünk a képben, olyanokat amelyek arra utalnak hogy valamilyen él van. A képekben a színek kevés könnyen használható információt tartalmaznak. Az élek egy alkalmas mutatója a képekben a fényesség, amelyet elő tudunk állítani az RGB értékek megfelelő lineáris kombinációjából. Egy adott pont fényessége szoros összefüggésben van a ráeső fény, az anyagának és a képet rögzítő eszköz érzékelésével. Ha az egymással szomszédos, vagy közeli pontok fényessége azonos, akkor sok tulajdonság azonos, de könnyen feltételezhetjük, hogy azonos felülethez tartoznak. A fényerősség beli nagy változások a legtöbb esetben úgy valósulnak meg, ha a felület mélységében vagy irányában nagyot változik, megváltozik az fényképezett anyag tulajdonsága vagy megvilágítása.

![pixelek a terben](pics/pic2field.png)
A pixelek világosságának összehasonlítása egy diszkrét differenciálás a képet 3 dimenziós felületként értelmezve. Az ábrán láthatóan, egy kép értelmezhető úgy, hogy a diszkrét x és y tengelyek által behatárolt Descartes koordinátarendszerben helyezkednek el. A világosság pedig egy valamilyen f(x,y) függvény. Ezt legjobban a jobboldali ábra szemlélteti, 3 dimenziós térben tudjuk ezt felületként ábrázolni úgy hogy z = f(x,y). A differenciálás tulajdonképpen nem más, mint különbségképzés. Az aktuális pixel fényességéből kivonom az előző pixel fényességét, ez fogja addni a differenciaképet a számítás végén. Matematikailag leírva, az A mátrixxal leírható képet (az i-edik oszlop j-edik eleme a megegyező koordinátájú pixel világossága n biten ábrázolva) konvolváljuk a $[-1,1]$ és a $[-1,1]^T$ transzponált vektorral.

$$ [-1, 1] * A \space \space A * [-1, 1]^T  $$

Ezt kiegészítendő a különböző algoritumusok más és más operátort használnálnak. Ez előbbit kiegészítve egy 3 x 3-as kernellé / mátrixxá a Prewitt operátort kapjuk.

$$
\mathbf{G_x} = \begin{bmatrix} 
+1 & 0 & -1 \\
+1 & 0 & -1 \\
+1 & 0 & -1
\end{bmatrix} * \mathbf{A}
\quad and \quad
\mathbf{G_y} = \begin{bmatrix} 
+1 & +1 & +1 \\
0 & 0 & 0 \\
-1 & -1 & -1
\end{bmatrix} * \mathbf{A}
$$

Ezen belül ki tudunk emelni egyes pixeleket attól függően, hogy milyen eredményt szeretnénk elérni, mit szeretnénk kiemelni és mit elnyomni. A Sobel alap operátor a következőképpen néz ki, mindössze a számolt pixel sorára és oszlopára nagyobb figyelmet fordítunk, a környezőeket pedig kevésbé vesszük figyelembe.

$$
\mathbf{G_x} = \begin{bmatrix} 
+1 & 0 & -1 \\
+2 & 0 & -2 \\
+1 & 0 & -1
\end{bmatrix} * \mathbf{A}
\quad and \quad
\mathbf{G_y} = \begin{bmatrix} 
+1 & +2 & +1 \\
 0 &  0 &  0 \\
-1 & -2 & -1
\end{bmatrix} * \mathbf{A}
$$



### 5. Felhasznált eszközök

A hardverben történő megvalósításhoz a konzulensemtől kapott Xilinx Kintex-7-es FPGA-t tartalmazó kártyát használtam. A fejlesztő kártyán elhelyezett mini-HDMI kártyán keresztül érkezik a képi információ, amit a könzulensemtől kapott HDMI adó és vevő modulok fogadnak és alakítják át pixeladattá és vezérlőjelekké, majd az adó oldalo ugyaezeket az információkat továbbítják.
A fejlesztés során az FPGA gyártójának fejlesztői környezetét, a Xilinx Vivadot használtam, így tudtam a megfelelő programozó fájokat elkészíteni. A fejlesztés egy jelentős szakaszában kizárólag a ModelSim szimulátorát használtam a leírt viselkedés funkcionális ellenőrzésére. Ezzel ellenőriztem az egyes bugokat és csak akkor szintetizáltam le és töltöttem fel a kártyára, amikor már bizonyos voltam abban, hogy az elvárt működést fogja produkálni a rendszer illetve nem fogalmaztam meg nem szintetizálható elemeket a moduljaimban.
Az RTL kód írása közben a lowRISC kódolási konvenciókat követtem, hogy átlátható és jól értelmezhető legyen a moduljaim leírása. Emellett az alkalmazása megszabadított a túl gyors kódolás okozta átláthatatlan és túlegyszerűsített megfogalmazások használazától.

#### LOGSYS Kintex-7 specifikáció

### 6. Rendszerterv

A rendszerterv hivatott taglalni a design formális megkötéseit. A természetes nyelveken megfogalmazott leírások hátránya, hogy azok értelmezése szubjektív tud lenni, ezáltal a megvalósítás módja, de akár a pontosan megvalósított funkció is erősen függ az alkotótól. Egy fomális megfogalmazás olyan, amely nem lehet kétértelmű, formális nyelven van megfogalmazva, amely nyelvtanából következik, hogy az csak egy féleképpen működhet. A rendszertervet 3 különbözőképpen fogalmaztam meg. Összegyűjtöttem egy követelménylistát, amely bár informálisan, de nagy pontossággal fogalmazza meg azokat a tulajdonságokat, amelyeket meg szeretnék valósítani. Emellett definiáltam a design paramétereis amelyek meghatározzák annak különböző tulajdonságait és viselkedési módját. Ezt követően pedig meghatároztam a portokat és azok időzítési követelményeit, amelyek szerint biztsosítható a modul elvárt működése.

#### Requirements
Az elsődleges követelményeket olyan módon fogalmaztam meg, hogy azok teljes mértékben fedjék az első féléves munka során megvalósított feladat minden tulajdonságát és aspektusát.

 - [x] REQ1: Az IP legyen alkalmas a VESA-DMT szabvány szerinti 1600x900-as felbontású 60Hz-es képfrissítésű videóbemenet feldolgozására.
 - [x] REQ2: Az IP rendelkezzen szinkron, magas-aktív resettel.
 - [x] REQ3: A feldolgozó láncban lévő regiszterekeknek ne legyen resetje.
 - [ ] REQ4: A feldolgozó lánc kimenete legyen resetelve, ha a vezérlőjelek alapján nincs érvényes kimenet.
 - [ ] REQ5: A reset hatására az adatkimeneteken és az érvényes pixelt jelző kimeneten nulla, a szinkronizáló jeleken pedig azok polaritásának ellentetje.
 - [ ] REQ6: Az IP-n paraméteresen legyen állítható a szinkronizáló jelek polaritása.
 - [ ] REQ7: Az IP-n használati időben legyen választható, hogy a képkockákat átengedje vagy szürkeárnyalatosra konvertálja.
 - [ ] REQ8: Az IP-n használati időben legyen választható, hogy a szürkeárnyalatos képet manipuláló  konvolúciós almodulok közül melyik van bekapcsolva.
 - [ ] REQ9: Az IP legyen alkalmas szürkeárnyalatos kép előállítására az ITU-R BT.709-6 szabvány szerinti együtthatókkal lineáris RGB színekből.
 - [ ] REQ10: Az IP legyen alkalmas a képkockák gaussian blur elsimítására
 - [ ] REQ11: Az IP legyen alkalmas a képkockák Sobel szűrésére.
 - [ ] REQ12: A kimenet legfeljebb 5%-nyi abszolút hibával térjen el a fixpontos modeltől.

<!-- A rendszerterv több lépésben is változtatásra került, ugyanakkor mindössze bővítésre, illetve a Kintex-7 es chipen elérhető konkrét erőforrásokra optimalizált megoldások kerültek bele. --> 

#### Paraméterek
| Paraméter  | Alapérték  | Felhasználás |
|---|---|---|
| SCREENWIDTH  | 1600 | A konvolúciós blokkokat megelőző sorbufferek mélysége. A pixelek száma egy sorban.  |
| COLORDEPTH  | 8 | Az egy alapszínt reprezentáló bitek száma.  |

A topmodul két szintézis paraméterrel rendelkezik. Szükséges megadni a képkockák maximális szélességét, ezáltal nincs kihasználatlan memória, mert csak a képi információt tartalmazó képpontokat tároljuk el. Abban az esetben, ha a fogadott képkocka nem éri el a paraméterben megadott szélességet, viszont ez le van követve a vezérlőjelekkel, akkor nincs probléma. A vezérlőjelek megfelelően vannak késleltetve, ezek alapján a rendszerben megfelelően keletkezik az új sort jelző impulzus, a memória modul lesz részben kihasználatlan, de ez nem csorbjt a használhatóságon. Abban az esetben, ha inkoherens a bemenet az elvárthoz képest, a kimeneti adat is nemdeterminisztikus lesz.
A második paraméter a színmélység, az egy színt reprezentáló bitek számával szükséges megadni. A paraméter alapértéke 8, azaz 8 + 8 + 8 biten vannak kódolva az egyedi színeket előállító piros zöld és kék színek. Alacsonyabb színmélységű képkockák esetén nem jelent hátrányt, amennyiben a bementi adat legmagasabb bitje a legmagasabb bitpozícióra kerül az eszköz bemenetén.
![](bitfield.png)
A szintézis paraméterek mellett futásidejű paramétereket is definiáltam, amelyeket byteban helyezkednek el az abrázolt módon. A *h_pol* és a *v_pol* a bemeneti vezérlőjelek polaritását adja meg, alacsony aktív vezérlőjelek esetén a modulon belül invertálásra kerülnek a jelek, hogy azok könnyen használhatóak maradjanak a számítást végző almodulok számára. A *skip_blr* bit magasba állításával a Gaussian Blur konvolúciós blokk iktatható ki a számítási pipeline-ból és a szürkeárnyalatos kép egyből a Sobel bemenetére köthető. Hasonló módon a *skip_sob* bit segítségével a Sobel szűrés iktatható ki. Mindkettőt használva a a szürkeárnyalatos kép fog kikerülni a kimenetre. A *stage_sel* bitek segítségével a pipeline egyes kimenetei köthetőek az IP kimenetére. Ennek a kódolása az alábbi táblázat szerinti.
| stage_sel kombináció binárisan | megvalósított működés |
|---|---|
| 3'b000 | Az almodulokat kihagyva, pixelek közvetlenül a kimenetre kerülnek  |
| 3'b001 | A szürkeárnyalatos kép kerül a kimenetre |
| 3'b010 | A Gaussian Blur modul kimenetét kapcsolja a kimenetre |
| 3'b100 | A Sobel szűrő modul kimenetét kapcsolja a kimenetre |

#### 6.1. Portok:
- **clk**, **rst**: A modul órajele és reset jele. Minden esetben a pixel órajelet javasolt használni, a modul nem rendelkezik külön bemeneti metastabilszűréssel az adatbemeneteken és nem is tartozik ezekhez handshake jellegű szinkronizáló jel. A reset magas aktív, az órajelhez szinkronizált.
- **sw**: Bemeneti kapcsolókombinációk megadására alkalmas port, használat közben módosítható a belső struktúra, egyes elemek ki és bekapcsolásával. Használat során a futásidejű paraméterek állíthatóak vele.
- **red_i**, **green_i**, **blue_i**: A bemeneti adatok, a modul bementei órajelével való szinkronitást biztosítania kell a felhasználónak.
- **dv_i**: A bemeneti adathoz tartozó vezérlőjel. A dv_i jel aktív magas, ha a bemeneten érvényes adatok szerepelnek az adott órajelciklusban. 
- **hs_i**, **vs_i**: A kijelző eszköz vezérlőjele. A hs_i és vs_i a függőleges és horizontális szinkronizáció információját hordozzák, az egyes almoduloknak ezeket kell késleltetnie, hogy az adat helyesen jelenjen meg a képernyőn.
- **red_o**, **green_o**, **blue_o**: A kimeneti adatok. A megvalósítutt funkciót tekinte szürkeárnyalatosak a pixelek, de igazodva bemenethez és egy potenciális következő fokozathoz, a kimenet is három szín széles.
- **dvo_o**, **hs_o**, **vs_o**: A kimeneti, megfelelően késleltett vezérlőjelek.

Az eszközön belüli almodulok közel azonos paraméterkiosztással és portokkal rendelkeznek. Minden almodul esetén a bemeneti portok a képpontadatok valamint a vezérlőjelek és ugyanezek kimeneti portok is. A bufferek kimenete bitvektor-tömb, illetve a konvolúciós blokkok bemenete is ilyen. Emellett a buffer cirkuláris memóriacímzőjének az újraindításához szükséges egy sor végét jelző bit.

![](pics/topmodule.png)

#### 6.2. RGB2Y

Az rgb2y modul a pixeladatokból történő világosságkomponens kiszámításáért felelős. A modul a lineárisan kódolt RGB színkomponensekből képez fényességadatot. A számításhoz az ITU_r szabványt veszi alapul és ezen együtthatókkal számolja ki a képpontok világosságát.

![](pics/rgb2y.png)

- **clk**, **rst**: Az almodul órajele és resetjele. A pixelórajelet szükséges megadni.
- **red_i**, **green_i**, **blue_i**:
- **dv_i**, **hs_i**, **vs_i**:
- **gamma_o**:
- **dvo_o**, **hs_o**, **vs_o**:




#### 6.3. buffer

![](pics/buffer.png)



#### 6.4. blur

![](pics/blur.png)



#### 6.5. sobel

![](pics/sobel.png)



### 7. Requirements



#### 7.1. Sub-req önlab 2-re
 - A modul legyen alkalmas tetszőleges monitor időzítési szabványú videóbemenet feldolgozására.
 - A bemeneti órajel leállása esetén a rendszer kerüljön HALT állapotba, kimenetek kerüljenek resetelésre.
 - UART interfészen keresztül legyen elérhető a belső regiszterek.
 - A bemeneti órajel leállása esetén legyen biztosítható külső órajellel a belső regiszterek kiolvasása.
 - A bemeneti órajel leállása esetén legyen kívülről állítható a belső control regiszterek.
 - Paraméter segítségével legyen elérhető FIR üzemmód, ahol tetszőlegesen állítható a konvolúciós együttható.
 - Az IP rendelkezzen APB busz interfésszel a külső vezérléshez.
 - Az IP rendelkezzen AXI4 - Stream Interfésszel a videóbemenet fogadására és továbbítására.
 - Az interfészen keresztül legyen olvasható a bemenet hisztogramja
  <!-- - [ ] önlab 2: REQ5: Az IP rendelkezzen alacsony aktív asynch resettel. -->
  <!-- - [ ] REQ6: Az IP-n használati időben engedélyezhető / tiltható legyen resetelés nélkül. -->


### 8. Verifikáció

![testenviroment](./pics/test_environment.png)

#### 8.1. Assertions



### 9. Implementáció
A REQ2 és REQ3 tervezési megfontolások voltak, az eszköz készítése és implementálása során alkalmaztam őket így ezek teljesültek.



A megvalósítás során fermerült problémák:
  - hogyan érjem el, hogy a minden pixel rajta legyen a végleges képen és ne legyen semmi sem levágva
  - mátrixos rajz a késleltetések kidolgozására. miért legyen inkább 1 órajel késleltetés 

### 10. hardver tesztelés


### 11. Eredmények

#### 11.1. Assertion eredmények

#### 11.2. Cover eredmények


#### 11.3. Teljesített Requirementek

 - [ ] REQ1: Az IP legyen alkalmas a VESA-DMT szabvány szerinti 1600x900-as felbontású 60Hz-es képfrissítésű videóbemenet feldolgozására.

Nem tudtam elkészíteni a megfelelő asserteket ezért kézzel ellenőríztem a megfelelő időzítéssel és kézzel számoltam hogy azokat tartja-e.

 - [ ] REQ2: Az IP rendelkezzen szinkron, magas-aktív resettel.

Az implementáció során minden szinkron blokk magas aktív reset jellel került leírásra úgy, hogy a reset jel nem szerepelt az érzékenységi listán, így szinkron resetként valósult meg.

> always_ff @(posedge clk) begin
>   if (rst) begin
>     ...
>   end else begin
>     ...
>   end

 - [ ] REQ3: A processing chainben lévő ff-eknek ne legyen resetje.

Az implementáció során a szinkron blokkokon belül nem részleteztem, hogy mi történjen abban az esetben amikor a reset jel aktív, ezért a flipflopok, amelyek nem kerültek itt leírásra, ilyenkor megörzik értéküket.

 <!-- - [ ] REQ4: A processing chain kimenete legyen resetelve, ha a control path alapján nincs érvényes kimenet.

Az implemetáció során kizártam azokat a lehetőségeket amikor bármely sync jel előfordulna a datavaliddal együtt, ezt követően pedig kézzel ellenőriztem során minden esetben a -->

 - [ ] REQ5: A reset hatására az adatkimeneteken és az érvényes pixelt jelző kimeneten nulla, a szinkronizáló jeleken pedig azok polaritásának ellentetje.

Kézzel ellenőriztem, illetve az implementáció során minden almodul kimenete multiplexálva van nullára azaz a fekete színre, ha a bemeneten érvénytelen az adat a datavalid control signal alapján.

 - [ ] REQ6: Az IP-n paraméteresen legyen állítható a szinkronizáló jelek polaritása.

Az implementáció során betettem egy futásidejű paraméteres invertert, tulajdonképpen multiplexert, így megváltoztatható a bemeneten a controlsignálok polaritása. (A REQ1-hez igazodva nincs szükség rá jelen esetben, többletfunkciót bővít).

 - [ ] REQ7: Az IP-n használati időben legyen választható, hogy a képkockákat átengedje vagy szürkeárnyalatosra konvertálja.

Az implementáció során a topmodul kimenetére egy multiplexert tettem amely az sw bemeneti változó értékeinek megfelelően a pipeline egyes szintjeit kapcsolja egymás után a kimentre. A megfelelő kimeneteket egyesével, kézzel ellenőriztem.

 - [ ] REQ8: Az IP-n használati időben legyen választható, hogy a szürkeárnyalatos képet manipuláló  konvolúciós almodulok közül melyik van bekapcsolva.

Az implementáció során két multiplexert helyeztem el a designban, amelyek segítségével a két konvolúciós modult ki tudom iktatni, át tudom hidalni. A kimenetet kézzel ellenőriztem.

 - [ ] REQ9: Az IP legyen alkalmas szürkeárnyalatos kép előállítására az ITU-R BT.709-6 szabvány szerinti együtthatókkal lineáris RGB színekből.

Az implementáció során a szabvány együtthatóinak 7 biten reprezentálható konstansait implementáltam a szürkeárnyalatos kép számításához.

 - [ ] REQ10: Az IP legyen alkalmas a képkockák gaussian blur elsimítására
 - [ ] REQ11: Az IP legyen alkalmas a képkockák Sobel szűrésére.
 - [ ] REQ12: A kimenet legfeljebb 5%-nyi abszolút hibával térjen el a fixpontos modeltől.

Pythonban környezetben, OpenCV könyvtárat használtam fel egy fixpontos, u8.0bites számokat használó segédmodel elkészítéséhez. Ehhez hasonlítottam a modulomat és az alább látható képeket kaptam. A képeken jelöltem melyik melyik modellel készült.

Emellett készítettem egy összehasonlító képet is, amelyen a modellek közötti abszolút hibát jelöltem.
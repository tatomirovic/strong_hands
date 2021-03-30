# strong_hands
 
Kripto tokeni znaju da budu jako volatilni i ljudi u panici prodaju svoje dragocene Ethere, iako bi za njih bilo bolje da ih cuvaju na duze staze. Vas zadatak jeste da napravite smart contract koji ce da postice ljude da cuvaju svoje Ethere na duzi vremenski period.

Korisnici ce slati Ethere na contract koji ce ih “zakljucati” na odredjeni vremeni period
Korisnici mogu da izvuku svoje pare pre vremenskog perioda ali ce imati odredjenu kaznu zbog toga. Ako izvuku neposredno posle ubacivanja izgubice 50% svog novca i to ce vremenom da se snizava do 0% na kraju tog vremenskog perioda
Korisnici moraju da prilikom izvlacenja izvuku ceo iznos, nije moguce samo delimicno da izvlace “zakljucan ether”
Korisnici mogu da depozituju novac vise puta ali im se onda resetuje taj vremenski period (odnosno sledeci put kad deposituju, krene odbrojavanje od pocetka)
Korisnici koji izvuku pre vremena i plate kaznu (odnosno izvuku manje pare nego sto su ubacili) tu kaznu zapravo daju ostalim clanovima koji nisu izasli. Tako da svaki put kad neko izadje, ostali clanovi dobiju proporcionalno taj deo kazne. Proporcionalno u odnosu koliko imaju Ethera depositovano na contractu.
Ether koji se nalazi na contractu se prilikom ubacivanja na contract pretvara u aEth. Odnosno Ether se deposituje u AaveV2 market koji ce davati pasivnu zaradu na taj Ether koji je depozitovan u contract.
Profit koji se ostvari od depozitovanja Ethera u AaveV2 market (znaci tu pasivnu kamatu koju je zaradio). Taj novac moze vlasnik contracta da povuce sebi u bilo kom trenutku.

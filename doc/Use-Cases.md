# Use Cases für Naturheilpraxis

## Kontextabgrenzung

![Kontextdiagramm](Kontextdiagramm.png)

Der Heilpraktiker erfasst erbrachte Leistungen für seine Patienten und rechnet
diese ab. Vorlagen für eine Rechnung werden im Dateisystem abgelegt. Rechnungen
können auf eine lokalen Drucker ausgegeben werden.

## Überblick

![Überblick](Use-Cases.png)

## Patienten verwalten

Als Heilpraktiker lege ich einen neuen Patienten an. Ich erfasse Name,
Anschrift, Kontaktmöglichkeit, Praxis, Annahmejahr, Geburtsdatum und weitere
Informationen. Die Praxis ist mit der Standardpraxis vorbelegt. Das Annahmejahr
ist mit dem aktuellen Jahr vorbelegt. Als Merkmale sind Standardmerkmale
vorausgewählt. Um Duplikate beim Anlegen zu vermeiden, wird vor dem Sichern nach
vorhandenen Patienten mit dem selben Vor- und Nachnamen sowie Geburtstag
gesucht. Existiert ein solcher Patient wird vor dem sichern nachgefragt, ob der
neue Patient wirklich angelegt werden soll.

Als Heilpraktiker bearbeite ich einen vorhanden Patienten. Als erstes muss ich
den _Patient suchen_. Zum Bearbeiten wird der Patient aus der Liste ausgewählt.
Alle Informationen die beim Anlegen erfasst werden, können geändert werden.

## Leistungen erfassen

Als Heilpraktiker erfasse ich erbrachte Leistungen für einen Patienten. Zunächst
muss der Patient ausgewählt werden, für den Leistungen erfasst werden. Dies
erfolgt mit _Patient suchen_. Aus der Liste wird der gesuchte Patient
ausgewählt. Es werden alle bisher erbrachten Leistungen aufgelistet.

Als Heilpraktiker lösche ich eine erbrachte Leistungen für einen Patienten.
\[...\]

Als Heilpraktiker bearbeite ich das Gebührenverzeichnis für Heilpraktiker.
\[...\]

## Rechnung schreiben

Als Heilpraktiker erstelle ich eine Rechnung für erbrachte Leistungen.
\[...\]

Als Heilpraktiker annuliere ich eine bestehende Rechnung.
\[...\]

Als Heilpraktiker drucke ich eine bestehende Rechnung.
\[...\]

## Patient suchen

Als Heilpraktiker suche ich einen bestimmten Patienten. Um den Patienten zu
finden kann nach Patienten-ID, Nachname, Vorname, Geburtstag, Straße, Wohnort,
Postleitzahl, Telefonnummer und Annahmejahr gesucht werden. Die Liste der
gefundenen Patienten kann nach jeder Spalte sortiert werden. Die
Standardsortierung ist nach Patienten-ID. Ohne Suchkritierium, werden alle
Patienten in der Liste aufgeführt.

## Rechnung suchen

Als Heilpraktiker suche ich eine bestimmte Rechnung.
\[...\]

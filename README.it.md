Italiano | [English](/README.md)

# Ispezioni dei ristoranti a NYC – Analisi dei dati con Power BI

Questo progetto analizza il dataset del **Department of Health and Mental Hygiene (DOHMH)** relativo alle **ispezioni sanitarie di ristoranti e mense universitarie** di New York City.

Il progetto è concepito come **portfolio project** e rappresenta l’evoluzione di una precedente analisi basata su SQL.

## Dataset

Il dataset di partenza contiene informazioni relative a:

* ispezioni sanitarie
* punteggi assegnati alle ispezioni
* violazioni rilevate, incluse violazioni critiche
* area geografica (borough)
* tipologia di cucina
* data di ispezione

Il dataset è fornito in formato grezzo e richiede un processo di pulizia e trasformazione prima di poter essere utilizzato in un modello analitico.

## Obiettivo del progetto

L’obiettivo è fornire una vista **sintetica e stabile** del sistema di ispezioni sanitarie, rispondendo a domande chiave quali:

* Qual è il livello medio di qualità delle ispezioni?
* Quanto è diffuso il rischio sanitario critico?
* Il sistema mostra segnali di miglioramento strutturale nel tempo?
* Esistono relazioni significative tra aree geografiche e tipologie di cucina?
* Quali tipologie di cucina presentano risultati migliori o peggiori?

L’approccio adottato è **KPI-driven** e orientato al **supporto decisionale**.

## Pulizia e trasformazione dei dati

Il processo di trasformazione è realizzato interamente in **Power Query** e include:

1. importazione del file CSV originale
2. selezione e rinomina delle colonne rilevanti
3. tipizzazione esplicita dei campi
4. normalizzazione dei valori nulli e pulizia del testo
5. creazione di una chiave data intera (`YYYYMMDD`)
6. preservazione della granularità ispezione–violazione

Nessuna riga viene esclusa a priori. Le logiche di aggregazione e filtraggio sono demandate alle misure DAX.

L’output è un **modello dati a stella semplificato**, ottimizzato per **performance, leggibilità e stabilità**.

## Modello dati

Il modello utilizza una struttura a stella composta da una **tabella dei fatti** centrale e relative tabelle dimensionali per:

* tempo
* area geografica
* tipologia di cucina
* ristorante
* tipo di violazione

La **granularità reale dell’ispezione** è ricostruita come combinazione di ristorante e data di ispezione.

Questa scelta è fondamentale per:

* evitare duplicazioni dello score dovute a più violazioni per singola ispezione
* garantire aggregazioni corrette delle metriche
* mantenere coerenza tra KPI e analisi temporali

## Dashboard

La dashboard Power BI è suddivisa in **due pannelli funzionali**, ciascuno dedicato a un diverso livello di analisi.

* Il pannello di overview fornisce una visione immediata dello stato del sistema tramite KPI aggregati, classifiche per tipologia di cucina e indicatori di rischio operativo.
* Il pannello temporale analizza l’evoluzione dei principali KPI nel tempo tramite medie mobili, consentendo una lettura più stabile delle dinamiche.
* Le metriche rispondono a filtri globali di **anno** e **area geografica** e utilizzano tooltip contestuali.

## Scelte metodologiche

* i punteggi delle ispezioni non sono cumulativi nel tempo; ogni ispezione ha un punteggio indipendente
* una singola ispezione può includere più violazioni, ma un solo punteggio complessivo
* le metriche di rischio sono basate su ispezioni critiche, definite come ispezioni con almeno una violazione critica

## Principali evidenze

* La qualità media delle ispezioni risulta complessivamente stabile nel tempo, con differenze territoriali coerenti e punteggi medi sotto controllo.
* Il rischio sanitario critico è ampiamente diffuso, ma mostra una riduzione graduale negli anni più recenti, suggerendo un possibile miglioramento strutturale.
* Le tipologie di cucina presentano pattern differenti nel medio periodo, con alcune categorie sistematicamente associate a punteggi medi più elevati.

## Strumenti utilizzati

- **Pulizia dati:** Excel Power Query
- **Modellazione e visualizzazione dati:** PowerBI + misure DAX
- **IDE:** Visual Studio Code  
- **Versionamento e documentazione:** Git / GitHub

## Competenze dimostrate

* modellazione dati con schema a stella
* pulizia e trasformazione dati in Power Query
* sviluppo di KPI e metriche rolling in DAX
* utilizzo di parametri di campo per analisi dinamiche
* progettazione di dashboard orientate al supporto decisionale
* documentazione tecnica strutturata

## Documentazione tecnica

* [Pulizia e caricamento dati](03_power_query/power_query.it.md)
* [Modello dati](04_data_model/data_model.it.md)
* [Formule DAX](05_dax/dax.it.md)
* [Dashboard](06_dashboard/dashboard.it.md)
* *[Dataset originale](https://data.cityofnewyork.us/Health/DOHMH-New-York-City-Restaurant-Inspection-Results/43nn-pn8j/about_data)*

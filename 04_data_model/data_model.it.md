# Modello dati

Il progetto utilizza un **modello dati a stella semplificato**, progettato per supportare KPI aggregati, analisi comparative e trend temporali in Power BI, mantenendo **chiarezza semantica e buone performance**.

Il modello è intenzionalmente contenuto e focalizzato su **reporting decisionale**, non su analisi transazionali di dettaglio.

## Tabella dei fatti

### fact_inspections

La fact table contiene i risultati delle ispezioni sanitarie dei ristoranti e le violazioni rilevate durante ciascuna ispezione.

| Campo                  | Descrizione                                                                      |
| ---------------------- | -------------------------------------------------------------------------------- |
| inspection_key         | Chiave tecnica della riga (surrogate key, non identificativa dell’ispezione)     |
| date_key               | Chiave verso la dimensione temporale `date_dim`                                  |
| restaurant_key         | Chiave verso la dimensione `restaurant_dim`                                      |
| area_key               | Chiave verso la dimensione `area_dim`                                            |
| cuisine_key            | Chiave verso la dimensione `cuisine_dim`                                         |
| violation_key          | Chiave verso la dimensione `violation_dim`                                       |
| score                  | Punteggio assegnato all’ispezione                                                 |
| has_critical_violation | Flag che indica la presenza di almeno una violazione critica                     |

### Granularità del dato

Ogni riga della fact table **non rappresenta un’ispezione unica**, ma una **violazione rilevata durante un’ispezione**.

In particolare:

- una singola ispezione è identificata dalla combinazione di ristorante e data di ispezione  
- una singola ispezione può generare più righe nella fact table  
- lo score è unico per ispezione, ma viene ripetuto su tutte le righe associate alle violazioni rilevate  

La **granularità reale dell’ispezione** è quindi definita come combinazione di:

```

restaurant_key + date_key

````

A livello logico, l’identificatore di ispezione può essere ricostruito come:

```m
Text.From([restaurant_key]) & "_" & Text.From([date_key])
```

Questa scelta consente di:

* evitare duplicazioni dello score dovute a più violazioni per singola ispezione
* identificare univocamente ogni evento di ispezione
* escludere automaticamente dalle aggregazioni le righe prive di ristorante o data

### Violazioni critiche

Il flag `has_critical_violation` indica la presenza di almeno una violazione codificata come critica nel dataset.

Il modello non include eventi testuali di chiusura o note narrative e si concentra esclusivamente su **codifiche strutturate**, coerenti con l’obiettivo di analisi quantitativa e comparativa.

## Dimensioni

### date_dim

| Campo    | Descrizione                     |
| -------- | ------------------------------- |
| date_key | Chiave data in formato YYYYMMDD |
| year     | Anno                            |

La dimensione temporale utilizza una **chiave intera YYYYMMDD**, scelta per garantire:

* ordinamento cronologico naturale
* join più efficienti
* semplicità e stabilità del modello

Questa struttura è pienamente adeguata alle analisi temporali previste.

### area_dim

| Campo     | Descrizione         |
| --------- | ------------------- |
| area_key  | Identificativo area |
| area_name | Nome area           |

### cuisine_dim

| Campo        | Descrizione           |
| ------------ | --------------------- |
| cuisine_key  | Identificativo cucina |
| cuisine_type | Tipologia di cucina   |

### restaurant_dim

| Campo          | Descrizione                      |
| -------------- | -------------------------------- |
| restaurant_key | Chiave tecnica del ristorante    |
| restaurant_id  | Identificativo originale (CAMIS) |

La dimensione ristorante consente di gestire correttamente esercizi sottoposti a **più ispezioni nel tempo**, mantenendo separata l’identità del ristorante dall’evento di ispezione.

### violation_dim

| Campo                 | Descrizione                           |
| :--------------------- | :------------------------------------- |
| violation_key         | Chiave tecnica della violazione       |
| violation_code        | Codice violazione                     |
| violation_description | Descrizione testuale della violazione |

Il campo `violation_description` non viene utilizzato per KPI o aggregazioni, in quanto testo libero non standardizzato.
Le analisi fanno riferimento esclusivamente ai **codici di violazione**.

## Relazioni

<figure align="center">
  <img src="star_scheme_PBI.png" alt="Schema a stella del modello dati - tabella dei fatti e dimensioni" width="700">
  <figcaption>Schema a stella del modello dati - tabella dei fatti e dimensioni</figcaption>
</figure>

Tutte le relazioni sono:

* one-to-many
* a direzione singola
* dalle dimensioni verso la fact table

Non sono presenti relazioni bidirezionali o bridge table, al fine di mantenere:

* semplicità del modello
* prevedibilità del comportamento dei filtri
* migliori performance di calcolo

## Scelte metodologiche

* le metriche basate sullo score aggregano sempre a livello di ispezione reale
* le metriche basate sulle violazioni operano a livello di riga della fact table
* la separazione tra KPI operativi e metriche descrittive è intenzionale
* il modello privilegia leggibilità e stabilità rispetto a una normalizzazione estrema

*Torna al [README](/README.it.md)*
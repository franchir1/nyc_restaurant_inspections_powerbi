# Power Query – Processo ETL

Questa sezione documenta il processo ETL realizzato in **Power Query** a partire dal dataset originale del Department of Health and Mental Hygiene (DOHMH).

L’obiettivo del processo è preparare i dati per il reporting in Power BI,
preservando la granularità originale e demandando le logiche di aggregazione alle misure DAX.

## 1. Origine dei dati

Il dataset viene importato da file CSV utilizzando:

- delimitatore `;`
- encoding UTF-8
- schema esplicito con 27 colonne

L’importazione con schema definito consente di mantenere controllo sui tipi di dato
e ridurre ambiguità in fase di trasformazione.

## 2. Selezione delle colonne

Vengono mantenute esclusivamente le colonne necessarie al modello dati finale:

- CAMIS  
- BORO  
- CUISINE DESCRIPTION  
- INSPECTION DATE  
- VIOLATION CODE  
- VIOLATION DESCRIPTION  
- CRITICAL FLAG  
- SCORE  

Questa selezione riduce la complessità del modello e migliora le performance complessive.

## 3. Rinomina delle colonne

Le colonne vengono rinominate utilizzando nomi semantici coerenti con il data model:

- CAMIS → restaurant_id  
- BORO → area_name  
- CUISINE DESCRIPTION → cuisine_desc  
- INSPECTION DATE → inspection_date  
- VIOLATION CODE → violation_code  
- VIOLATION DESCRIPTION → violation_desc  
- CRITICAL FLAG → critical_flag  
- SCORE → score  

La rinomina anticipata facilita la leggibilità del modello e delle formule DAX.

## 4. Tipizzazione dei campi

Viene impostata una tipizzazione esplicita dei campi principali:

- restaurant_id come intero  
- inspection_date come data  
- score come intero  

La tipizzazione esplicita previene conversioni implicite e comportamenti inattesi nelle aggregazioni.

## 5. Creazione della chiave data (YYYYMMDD)

A partire da `inspection_date` viene generata una chiave intera `date_key` nel formato `YYYYMMDD`.

I valori `null` e la data placeholder `1900-01-01` vengono impostati a `null`,
in quanto non rappresentano ispezioni valide ai fini analitici.

La chiave `date_key` viene utilizzata come riferimento alla dimensione temporale.

## 6. Normalizzazione dei valori null e pulizia del testo

Vengono applicate le seguenti operazioni di pulizia:

- conversione delle stringhe vuote in `null`  
- applicazione di `Text.Trim` sui campi testuali  

Queste operazioni garantiscono coerenza nelle join, nelle deduplicazioni
e nelle aggregazioni successive.

## 7. Rimozione e riordino delle colonne

Dopo la creazione di `date_key`:

- la colonna `inspection_date` viene rimossa  
- le colonne vengono riordinate per migliorare la leggibilità della fact table  

## Note metodologiche

- nessuna riga viene esclusa a priori durante il processo ETL  
- la granularità ispezione–violazione viene preservata intenzionalmente  
- la ricostruzione della granularità reale dell’ispezione (ristorante + data)
  viene applicata a livello di DAX, non in ETL  

Questa scelta consente di mantenere il processo di trasformazione semplice,
trasparente e facilmente estendibile.

*Torna al [README](/README.it.md)*

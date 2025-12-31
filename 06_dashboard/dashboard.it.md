# Dashboard – NYC Restaurant Inspection Overview

Questa dashboard fornisce una visione analitica strutturata delle ispezioni sanitarie dei ristoranti di New York City, con l’obiettivo di valutare volume delle ispezioni, qualità media, rischio operativo e andamenti nel tempo.

L’analisi è costruita su un modello con granularità ispezione–violazione; le aggregazioni legate allo score sono calcolate a livello di ispezione reale, ricostruita come combinazione di ristorante e data di ispezione, evitando duplicazioni dovute alla presenza di più violazioni per singola ispezione.

## Struttura della dashboard

La dashboard è organizzata in due pannelli principali, ciascuno con un ruolo analitico distinto.

## Obiettivo della dashboard

La dashboard è progettata per:

- identificare pattern strutturali  
- confrontare aree geografiche e tipologie di cucina  
- osservare trend di miglioramento o deterioramento nel tempo  
- supportare analisi esplorative tramite filtri e tooltip contestuali

## KPI principali

I KPI sono calcolati nel contesto dei filtri attivi (anno e area):

- Inspection Count: numero totale di ispezioni distinte  
- Average Inspection Score: punteggio medio delle ispezioni  
- Critical Inspection Rate: percentuale di ispezioni che presentano almeno una violazione critica, utilizzata come indicatore di rischio operativo  

<p align="center">
  <img src="dashboard_overview.png" alt="Dashboard principale" width="800">
</p>
<p align="center"><em>Dashboard principale</em></p>

### Filtri globali

- intervallo temporale (anni)  
- area / borough  

Tutti i visual reagiscono dinamicamente alle selezioni applicate.

### Interpretazione dei KPI

**Average Inspection Score**

Il punteggio medio delle ispezioni risulta complessivamente stabile nel periodo analizzato, con valori sotto controllo e differenze territoriali coerenti.  
Lo score rappresenta la qualità media delle ispezioni, ma non misura la gravità complessiva delle violazioni.

**Critical Inspection Rate**

Il tasso di ispezioni con almeno una violazione critica risulta elevato, ma mostra una riduzione graduale negli anni più recenti.  
La metrica misura la frequenza del rischio sanitario critico, non la sua intensità.

**Inspection Count**

Il numero di ispezioni varia in funzione dell’area geografica ed è proporzionale alla dimensione demografica e al numero di esercizi.  
L’incremento osservato dopo il 2021 è compatibile con un recupero post-pandemico e con un miglioramento dei processi di reporting.

### Classifiche per tipologia di cucina

Il pannello overview include due classifiche:

- Best Cuisine (Top 5): tipologie di cucina con punteggio medio più basso  
- Worst Cuisine (Bottom 5): tipologie di cucina con punteggio medio più alto  

È disponibile un tooltip dedicato che fornisce contesto aggiuntivo per ciascuna tipologia di cucina, includendo score medio e tasso di ispezioni critiche.

**Interpretazione**

Le classifiche mostrano differenze persistenti tra tipologie di cucina nel medio periodo.  
I punteggi più elevati suggeriscono una maggiore esposizione a criticità operative, senza implicare una causalità diretta legata alla tipologia di cucina.

### Codici di violazione più ricorrenti

Il grafico “Most Recurring Violation Codes” mostra i codici di violazione più frequenti nel dataset.

Non viene assunta una correlazione uno-a-uno tra singolo codice di violazione e score.  
Lo score è determinato dall’insieme delle violazioni rilevate durante la stessa ispezione.

È disponibile un tooltip dedicato con codice, descrizione e conteggio.

**Interpretazione**

Alcuni codici di violazione risultano sistematicamente più frequenti, indicando problemi igienici ricorrenti e di natura strutturale.  
La frequenza dei codici non è direttamente mappabile allo score, che dipende dalla combinazione complessiva delle violazioni rilevate.

## 2. Analisi temporale

Il secondo pannello è dedicato all’analisi dell’evoluzione degli indicatori nel tempo.

### Metriche selezionabili

Un parametro di campo consente di analizzare tre metriche tramite lo stesso visual:

- Inspection Score (3Y Rolling)  
- Critical Inspection Rate (3Y Rolling)  
- Inspection Count (3Y Rolling)  

Ogni metrica viene interpretata in modo indipendente.  
L’asse Y si adatta automaticamente al contesto della misura selezionata.

<p align="center">
  <img src="dashboard_trends.png" alt="Analisi temporali" width="800">
</p>
<p align="center"><em>Analisi temporali</em></p>

### Media mobile a 3 anni

Tutte le metriche temporali utilizzano una finestra mobile aggregata di 3 anni, scelta per ridurre la volatilità annuale mantenendo reattività al cambiamento.

Nel caso del Critical Inspection Rate, la metrica può rimanere più volatile poiché è un rapporto tra conteggi.  
Per mantenere interpretabilità non vengono utilizzate finestre più lunghe o baseline cumulative.

### Interpretazione dei trend

**Average Inspection Score (3Y Rolling)**

Il trend dello score medio evidenzia una dinamica stabile e sotto controllo.  
La rolling window riduce la volatilità annuale senza nascondere eventuali cambiamenti strutturali.

**Critical Inspection Rate (3Y Rolling)**

Il tasso di ispezioni critiche mostra un picco nel periodo 2021–2022 seguito da una lenta riduzione.  
La persistenza di valori elevati suggerisce un rischio diffuso, con segnali di miglioramento graduale.

**Inspection Count (3Y Rolling)**

Il numero di ispezioni mostra una crescita progressiva negli anni più recenti.  
La dinamica è compatibile con un aumento dell’attività ispettiva piuttosto che con variazioni casuali del dato.

## Scelte metodologiche chiave

- lo score non è cumulativo nel tempo; ogni ispezione ha uno score indipendente  
- una singola ispezione può includere più violazioni, ma un solo score  
- le aggregazioni sullo score sono effettuate a livello di ispezione reale (ristorante + data)  
- il KPI di rischio è basato su ispezioni critiche, definite come ispezioni con almeno una violazione critica    

*Torna al [README](/README.it.md)*
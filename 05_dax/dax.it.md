# Documentazione delle formule DAX

Questo documento descrive l’insieme finale delle misure DAX utilizzate nel dashboard **NYC Restaurant Inspection Overview**.

Le misure sono organizzate per area funzionale e seguono definizioni semantiche coerenti con il modello dati e con obiettivi di reporting orientati al processo decisionale.

## Misure BASE

### BASE - Conteggio Ispezioni

Conta il numero totale di ispezioni distinte nel contesto di filtro corrente.
Il conteggio è calcolato al reale livello di ispezione, ricostruito come combinazione di ristorante e data.

```DAX
BASE - Inspection Count =
DISTINCTCOUNT ( fact_table[inspection_key] )
```

### BASE - Conteggio Ispezioni Critiche

Conta le ispezioni che includono almeno una violazione critica.
Un’ispezione è considerata critica se almeno una violazione associata è contrassegnata come critica.

```DAX
BASE - Critical Inspection Count =
CALCULATE (
    DISTINCTCOUNT ( fact_table[inspection_key] ),
    fact_table[critical_flag] = "Critical"
)
```

### BASE - Tasso di Ispezioni Critiche

Calcola la percentuale di ispezioni critiche sul totale delle ispezioni.

```DAX
BASE - Critical Inspection Rate =
DIVIDE (
    [BASE - Critical Inspection Count],
    [BASE - Inspection Count]
)
```

### BASE - Conteggio Violazioni

Conta il numero totale di violazioni registrate.
Questa misura opera a livello di riga della fact table e include solo le righe con una violazione valorizzata.

```DAX
BASE - Violation Count =
CALCULATE (
    COUNTROWS ( fact_table ),
    NOT ISBLANK ( fact_table[violation_key] )
)
```

## Misure SCORE

### SCORE - Punteggio Medio Ispezione

Calcola il punteggio medio delle ispezioni nel contesto di filtro corrente.
I valori nulli sono automaticamente ignorati dalla funzione di aggregazione.

```DAX
SCORE - Average Inspection Score =
AVERAGE ( fact_table[score] )
```

## Misure TEMPORALI (finestre mobili a 3 anni)

### TIME - Totale Ispezioni (Rolling 3 Anni)

Conta il numero totale di ispezioni su una finestra mobile aggregata di 3 anni
relativa all’anno selezionato.

```DAX
TIME - Total Inspection (3Y Rolling) =
CALCULATE (
    [BASE - Inspection Count],
    FILTER (
        ALL ( date_dim[year] ),
        date_dim[year] >= MAX ( date_dim[year] ) - 2
            && date_dim[year] <= MAX ( date_dim[year] )
    )
)
```

### TIME - Punteggio Ispezione (Rolling 3 Anni)

Calcola il punteggio medio delle ispezioni su una finestra mobile aggregata di 3 anni.

```DAX
TIME - Inspection Score (3Y Rolling) =
VAR curr_year = MAX ( date_dim[year] )
RETURN
CALCULATE (
    [SCORE - Average Inspection Score],
    FILTER (
        ALL ( date_dim[year] ),
        date_dim[year] >= curr_year - 2
            && date_dim[year] <= curr_year
    )
)
```

### TIME - Tasso di Ispezioni Critiche (Rolling 3 Anni)

Calcola il tasso aggregato di ispezioni critiche su una finestra mobile aggregata di 3 anni.
Il tasso è definito come il rapporto tra il totale delle ispezioni critiche
e il totale delle ispezioni nello stesso periodo.

```DAX
TIME - Critical Inspection Rate (3Y Rolling) =
VAR Inspections_3Y =
    CALCULATE (
        [BASE - Inspection Count],
        FILTER (
            ALL ( date_dim[year] ),
            date_dim[year] >= MAX ( date_dim[year] ) - 2
                && date_dim[year] <= MAX ( date_dim[year] )
        )
    )

VAR Critical_Inspections_3Y =
    CALCULATE (
        [BASE - Critical Inspection Count],
        FILTER (
            ALL ( date_dim[year] ),
            date_dim[year] >= MAX ( date_dim[year] ) - 2
                && date_dim[year] <= MAX ( date_dim[year] )
        )
    )

RETURN
DIVIDE ( Critical_Inspections_3Y, Inspections_3Y )
```

## Note metodologiche

* tutte le metriche rolling utilizzano una finestra aggregata di 3 anni, non una media dei tassi annuali
* `DIVIDE()` è utilizzata in modo sistematico per evitare errori di divisione per zero
* la granularità dell’ispezione è mantenuta coerente in tutte le misure
* le misure sono progettate per essere analizzate in modo indipendente quando usate con i Field Parameters
* `AVERAGE()` e `DISTINCTCOUNT()` gestiscono correttamente i valori nulli
* per le metriche basate su `COUNTROWS()`, vengono applicate condizioni esplicite per escludere le righe prive di identificativo di ispezione

*Torna al [README](/README.it.md)*

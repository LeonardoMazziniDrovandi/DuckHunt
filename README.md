# Duck Hunt (Processing)

Videogioco interattivo sviluppato in Java ispirato al classico arcade Duck Hunt.

### Riepilogo
* Ricrea fedelmente l'esperienza arcade originale con mirino controllato dal mouse.
* Gestisce in automatico animazioni frame-by-frame, direzioni di volo e rilevamento delle collisioni.
* Offre un sistema di progressione a round, monitoraggio dei colpi (3 per turno) e calcolo del punteggio.
* Necessario Processing IDE

---

### 🛠️ Configurazione Iniziale (Step-by-Step)

Per far funzionare correttamente il gioco, è necessario configurare l'ambiente di sviluppo Processing e importare le risorse corrette. Segui questi passaggi dettagliati.

**1. Installare l'ambiente Processing**
* Vai sul sito ufficiale di [Processing](https://processing.org/).
* Scarica e installa la versione adatta al tuo sistema operativo.

**2. Aggiungere la libreria audio**
Il gioco utilizza `processing.sound.*` per gestire gli effetti sonori classici.
* Apri l'IDE di Processing.
* Vai nel menu in alto: clicca su **Sketch** > **Importa Libreria** > **Aggiungi Libreria...**
* Cerca "Sound" (sviluppata dalla Processing Foundation) e clicca su **Install**.

**3. Organizzare la struttura dei file**
Affinché il codice trovi le texture e i file audio, la cartella del progetto deve mantenere una struttura precisa. Assicurati che lo sketch principale (`DuckHunt.pde`) sia affiancato dai seguenti elementi:
* Cartella `immagini` (contenente background, sprite delle anatre, proiettili e icone della GUI).
* Cartella `suoni` (contenente gli effetti in `.mp3` come sparo, game over, ecc.).
* File `arcaden.ttf` (il font personalizzato per replicare lo stile retro).

---

### 🚀 Installazione e Utilizzo

**Scarica il repo**
```bash
git clone https://github.com/LeonardoMazziniDrovandi/DuckHunt.git
```

**Avvio del Gioco**
* Apri il file `DuckHunt.pde` con l'IDE di Processing.
* Clicca sul pulsante **Esegui** (l'icona "Play" in alto a sinistra).

**Comandi di Gioco**
* **Spazio:** Inizia la partita dalla schermata del titolo.
* **Mouse (Click Sinistro):** Spara un colpo (massimo 3 colpi per ogni ondata).
* **ESC:** Torna alla schermata del titolo durante il gioco, oppure esci dall'applicazione se ti trovi già nel menu principale.

---

### 📈 Dinamiche di Gioco e Output

Il gioco comunica visivamente e acusticamente i risultati delle tue azioni a schermo:

* ✅ **Colpo a segno:** L'anatra si blocca, riproduce l'animazione di caduta e guadagni 1000 punti. Viene registrata nella barra inferiore.
* ⏭️ **Mancata:** Se esaurisci i colpi o scade il timer, l'anatra vola via fuori dallo schermo.
* 🌟 **Perfect:** Ottieni un bonus di 10.000 punti se colpisci 10 anatre su 10 in un singolo round.
* ❌ **Game Over:** Si attiva se non riesci a colpire almeno 6 anatre alla fine del round. Lo schermo mostrerà il riquadro di sconfitta e il gioco si resetterà.

> **Note sulla Licenza:** Progetto realizzato a scopo educativo e ricreativo per dimostrare la gestione di input, array temporali e stati logici su Processing. I diritti del marchio originale appartengono a Nintendo.

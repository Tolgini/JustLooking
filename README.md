# Just Looking: Shadow Archer

**Just Looking: Shadow Archer** ist ein kleines PC-Spiel-Projekt für **Godot 4**: ein 2D Archery Survival / Wave Defense Prototype mit dunkler Fantasy-Optik aus einfachen Platzhalterformen. Das Projekt nutzt ausschließlich GDScript und Godot-Szenen - keine HTML-, CSS- oder JavaScript-Dateien und keine fremden Assets.

## Spielbeschreibung

Du steuerst einen Bogenschützen in einer kleinen Arena. Aus den Schatten kommen Gegner in immer stärkeren Wellen auf dich zu. Ziele mit der Maus, schieße Pfeile, sammle Score und Coins und wähle nach jeder überlebten Welle ein Upgrade.

Aktuell enthalten:

- Startmenü
- Spielbare Arena mit dunkler Placeholder-Fantasy-Optik
- Spieler-Bogenschütze mit Maus-Zielen und Pfeilschuss
- Gegner, die den Spieler verfolgen und Nahkampfschaden verursachen
- Gerade fliegende Pfeile mit Treffererkennung und Schaden
- Wave-System mit steigender Gegnerzahl und Skalierung
- Score- und Coin-Belohnungen
- Upgrade-Auswahl nach jeder Welle:
  1. Mehr Schaden
  2. Schnellere Pfeile
  3. Mehr maximale Leben
  4. Schnellere Schussrate
  5. Mehrfachschuss
- Pause-Menü
- Game-Over-Menü mit Neustart
- HUD für Leben, Coins, Wave und Score

## Steuerung

| Aktion | Eingabe |
| --- | --- |
| Bewegen | WASD oder Pfeiltasten |
| Zielen | Maus bewegen |
| Schießen | Linke Maustaste gedrückt halten oder klicken |
| Pause | Esc oder P |
| Menüauswahl | Maus |

## Projekt in Godot 4 öffnen

1. Installiere **Godot 4.x** von <https://godotengine.org/>.
2. Klone oder lade dieses Repository lokal herunter.
3. Öffne den Godot Project Manager.
4. Wähle **Import**.
5. Wähle die Datei `project.godot` im Repository-Ordner aus.
6. Öffne das Projekt.
7. Drücke **Play** oder **F5**. Die Hauptszene ist bereits auf `res://scenes/Main.tscn` gesetzt.

Alternativ per Kommandozeile, wenn `godot4` im PATH liegt:

```bash
godot4 --path .
```

Zum direkten Starten aus dem Repository:

```bash
godot4 --path . --run
```

## Wie ich es teste

Manueller Smoke-Test in Godot 4:

1. Projekt öffnen und mit **F5** starten.
2. Im Startmenü **Spiel starten** klicken.
3. Mit WASD/Pfeiltasten bewegen.
4. Mit Maus zielen und mit Linksklick Gegner abschießen.
5. Prüfen, ob HUD-Werte für Leben, Coins, Wave und Score aktualisiert werden.
6. Eine Welle abschließen und ein Upgrade auswählen.
7. Mit Esc oder P pausieren und fortsetzen.
8. Sich treffen lassen, bis Game Over erscheint, und Neustart testen.

Optionaler Headless-Parse-Test, wenn Godot installiert ist:

```bash
godot4 --headless --path . --quit-after 1
```

## Was noch für Steam ergänzt werden sollte

Vor einer günstigen Steam-Veröffentlichung im Bereich 2-5€ sollten mindestens ergänzt werden:

- Eigene finale Grafiken, Animationen und Effekte
- Musik und Soundeffekte mit sauberer Lizenzlage
- Balancing für Wellen, Schaden, Upgrades und Spielzeit
- Steam-Kapselbilder, Trailer, Screenshots und Store-Beschreibung
- Optionsmenü für Auflösung, Vollbild, Lautstärke und Eingaben
- Speichern von Highscores, Einstellungen und Fortschritt
- Controller-Unterstützung
- Achievements und optional Steamworks-Integration
- Lokalisierung, mindestens Deutsch und Englisch
- QA-Tests auf mehreren Windows-PCs und idealerweise Steam Deck / Linux
- Export-Presets und Build-Pipeline für Release-Builds

## Geplante nächste Features

- Verschiedene Gegnertypen mit eigenen Bewegungs- und Angriffsmustern
- Boss-Wellen
- Shop zwischen Wellen
- Seltene Upgrade-Varianten und Synergien
- Kritische Treffer, Durchschlag und Elementarpfeile
- Mehr Arenen mit einfachen Hindernissen
- Meta-Fortschritt oder freischaltbare Archer-Varianten
- Polierte Treffer-, Todes- und UI-Animationen

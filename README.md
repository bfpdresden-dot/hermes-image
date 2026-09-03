# hermes-image

Bestimmt, welche Fassung von **Hermes Agent** auf der eigenen Instanz läuft.

## Warum es dieses Repository gibt

Vorher wurde Hermes aus einem fremden Vorlagen-Repository gebaut. Zog dort
niemand nach, brachte auch ein erneutes Ausrollen nichts Neues — die Instanz
hing monatelang auf einer alten Fassung fest.

Jetzt kommt das Image direkt von NousResearch, und **diese eine Datei**
entscheidet, welche Fassung das ist.

## Aktualisieren

1. In `Dockerfile` die Fassung hinter `:` ändern
   (Liste: <https://hub.docker.com/r/nousresearch/hermes-agent/tags>)
2. Committen und pushen
3. Im Betriebswerkzeug neu ausrollen

Rund 900 MB Download, zwei bis fünf Minuten.

## Wenn etwas nicht geht

Vorige Fassung eintragen, erneut ausrollen. Die Daten liegen außerhalb des
Containers und überleben jeden Wechsel.

## Drei Stolpersteine beim Sprung auf v0.21

Alle drei sind im `Dockerfile` kommentiert — dort steht auch, woran man sie
erkennt:

1. **Datenpfad** — das Image nimmt jetzt ein anderes Heimatverzeichnis.
2. **Container-Rolle** — mit dem Befehl `dashboard` wird der Gateway bewusst
   nicht eingerichtet.
3. **Rechte** — der Prozess läuft nicht mehr als root.

## Was hier NICHT hineingehört

Keine Zugangsdaten, keine Hostnamen, keine Pfade der eigenen Installation.
Alles Instanzspezifische steht als Umgebungsvariable im Betriebswerkzeug.

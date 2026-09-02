# hermes-image

Bestimmt, welche Fassung von **Hermes Agent** auf `hermes.bfp-dresden.de` laeuft.

## Warum es dieses Repository gibt

Coolify baute Hermes vorher aus dem fremden Vorlagen-Repo
`praveen-ks-2001/hermes-agent-template`. Zog dort niemand nach, brachte auch ein
Redeploy nichts Neues — deshalb lief Hermes am 02.09.2026 noch auf der Fassung
vom **20. Juli** (v0.19.0 / 2026.7.20).

Jetzt kommt das Image direkt von NousResearch, und **diese Datei allein**
entscheidet, welche Fassung das ist.

## Aktualisieren

1. In `Dockerfile` die Fassung hinter `:` aendern
   (Liste: <https://hub.docker.com/r/nousresearch/hermes-agent/tags>)
2. Committen und pushen
3. In Coolify beim Dienst `hermes-agent` **Redeploy**

Rund 900 MB Download, zwei bis fuenf Minuten.

## Wenn etwas nicht geht

Vorige Fassung eintragen, erneut ausrollen. Die Daten liegen ausserhalb des
Containers (Bind-Mount auf dem Host nach `/data`) und ueberleben jeden Wechsel.

## Was hier NICHT hineingehoert

Keine Zugangsdaten. Das Repository ist oeffentlich; alle Geheimnisse stehen als
Umgebungsvariablen in Coolify.

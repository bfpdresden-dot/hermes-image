# Hermes Agent fuer hermes.bfp-dresden.de
#
# Diese Datei baut NICHTS. Sie haelt nur fest, welche Fassung des offiziellen
# Images laeuft — Coolify zieht sie und startet sie unveraendert.
#
# UPDATE: Zahl unten aendern, committen, in Coolify "Redeploy" druecken.
# Verfuegbare Fassungen: https://hub.docker.com/r/nousresearch/hermes-agent/tags
#
# ⚠️ KEIN "latest": Sonst wechselt die Fassung bei jedem Redeploy von selbst.
#    Bei Problemen einfach die vorige Zahl eintragen und erneut ausrollen.

FROM nousresearch/hermes-agent:v2026.8.31

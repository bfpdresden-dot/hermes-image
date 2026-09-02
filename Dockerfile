# Hermes Agent fuer hermes.bfp-dresden.de
#
# Diese Datei baut NICHTS. Sie haelt fest, welche Fassung des offiziellen
# Images laeuft und wie sie starten soll.
#
# UPDATE: Zahl unten aendern, committen, in Coolify "Redeploy" druecken.
# Verfuegbare Fassungen: https://hub.docker.com/r/nousresearch/hermes-agent/tags
#
# KEIN "latest": Sonst wechselt die Fassung bei jedem Redeploy von selbst.
#    Bei Problemen einfach die vorige Zahl eintragen und erneut ausrollen.

FROM nousresearch/hermes-agent:v2026.8.31

# --- Wo die Daten liegen ---------------------------------------------------
# Ab v0.21 nimmt das Image /opt/data als Heimatverzeichnis. Die vorhandenen
# Einstellungen und Sitzungen liegen aber unter /data (Bind-Mount vom Host:
# /data/coolify/applications/rw32cdrix8axo30pa1a8kkxo/hermes). Ohne diese Zeile
# sieht Hermes sie nicht und schreibt in ein namenloses Volume, das bei jedem
# Redeploy verworfen wird.
#
# Das Startskript des Images sieht den Schalter ausdruecklich vor
# (docker/stage2-hook.sh, Zeile 20):
#     HERMES_HOME=${HERMES_HOME:-/opt/data}
#
# ⚠️ NICHT /data, sondern /data/.hermes. Die alte Fassung hatte /data als
# HOME und legte ihre Daten wie ueblich in $HOME/.hermes ab. Zeigt HERMES_HOME
# auf /data, sieht die neue Fassung diesen Unterordner nicht, faengt bei null
# an und legt eine leere config.yaml daneben — das Dashboard meldet dann
# "Gateway aus" und alle Einstellungen scheinen weg. Sie sind es nicht.
#
# Das Startskript richtet ausserdem die Besitzrechte von HERMES_HOME selbst
# (stage2-hook.sh, chown_hermes_tree). Das ist noetig, weil die alte Fassung
# als root lief und die neue als hermes (uid 10000) — sonst kann sie die
# vorhandenen Dateien nicht lesen. HERMES_UID=0 waere kein Ausweg, das Image
# laesst nur 1 bis 65534 zu.
ENV HERMES_HOME=/data/.hermes

# --- Was gestartet wird ----------------------------------------------------
# OHNE diese Zeile startet das Image die interaktive Konsole, zeigt den
# Begruessungsbildschirm, beendet die Sitzung sofort wieder (kein Terminal) und
# startet endlos neu. Es lauscht dann kein Port und die Domain antwortet mit
# 502 — genau das ist am 02.09.2026 passiert.
#
#   --host 0.0.0.0  Standard waere 127.0.0.1 und damit von aussen unerreichbar
#   --port 8080     entspricht "Ports Exposes" in Coolify (Standard waere 9119)
#   --no-open       kein Browserstart im Container
#   --skip-build    die fertige Oberflaeche ausliefern statt sie zu bauen
CMD ["dashboard", "--host", "0.0.0.0", "--port", "8080", "--no-open", "--skip-build"]

# Hermes Agent fuer hermes.bfp-dresden.de
#
# Diese Datei baut NICHTS. Sie haelt nur fest, welche Fassung des offiziellen
# Images laeuft — Coolify zieht sie und startet sie.
#
# UPDATE: Zahl unten aendern, committen, in Coolify "Redeploy" druecken.
# Verfuegbare Fassungen: https://hub.docker.com/r/nousresearch/hermes-agent/tags
#
# KEIN "latest": Sonst wechselt die Fassung bei jedem Redeploy von selbst.
#    Bei Problemen einfach die vorige Zahl eintragen und erneut ausrollen.

FROM nousresearch/hermes-agent:v2026.8.31

# OHNE diese Zeile startet das Image die interaktive Konsole, zeigt den
# Begruessungsbildschirm, beendet die Sitzung sofort wieder (kein Terminal) und
# startet endlos neu — es lauscht kein Port, die Domain antwortet mit 502.
# Genau das ist am 02.09.2026 passiert.
#
#   --host 0.0.0.0  Standard waere 127.0.0.1 und damit aus dem Container heraus
#                   nicht erreichbar
#   --port 8080     entspricht "Ports Exposes" in Coolify (Standard waere 9119)
#   --no-open       kein Browserstart im Container
#   --skip-build    die fertige Oberflaeche ausliefern statt sie zu bauen
CMD ["dashboard", "--host", "0.0.0.0", "--port", "8080", "--no-open", "--skip-build"]

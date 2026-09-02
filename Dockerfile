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
# Daten liegen aber unter /data/.hermes (Bind-Mount vom Host:
# /data/coolify/applications/rw32cdrix8axo30pa1a8kkxo/hermes).
#
# ⚠️ NICHT /data, sondern /data/.hermes. Die alte Fassung hatte /data als HOME
# und legte ihre Daten wie ueblich in $HOME/.hermes ab. Zeigt HERMES_HOME auf
# den Elternordner, faengt Hermes bei null an und legt eine leere config.yaml
# daneben — das Dashboard meldet dann "Gateway stopped" und alles wirkt weg.
#
# Das Startskript richtet ausserdem die Besitzrechte selbst (stage2-hook.sh,
# chown_hermes_tree): noetig, weil die alte Fassung als root lief und die neue
# als hermes (uid 10000). HERMES_UID=0 waere kein Ausweg — nur 1 bis 65534.
ENV HERMES_HOME=/data/.hermes

# --- Dashboard als DIENST, nicht als Hauptbefehl ----------------------------
# ⚠️ Das ist der Kern. Laeuft der Container mit dem Befehl "dashboard", stuft
# das Image ihn als reinen Dashboard-Container ein und richtet den Gateway
# ABSICHTLICH nicht ein (hermes_cli/container_boot.py, _is_dashboard_container):
#
#     "A dashboard-only container never spawns or supervises per-profile
#      gateways — that is the gateway container's job."
#
# Ergebnis war: Dashboard erreichbar, Gateway dauerhaft "stopped", und
# `gateway start` antwortete "no such gateway 'default'", weil der s6-Dienst
# gar nicht angelegt wurde.
#
# Richtig ist: Das Image bringt einen eigenen Dashboard-Dienst mit, der ueber
# diese Schalter eingeschaltet wird (/etc/s6-overlay/s6-rc.d/dashboard/run).
# Dann laufen Gateway UND Dashboard im selben Container nebeneinander.
ENV HERMES_DASHBOARD=1
ENV HERMES_DASHBOARD_HOST=0.0.0.0
ENV HERMES_DASHBOARD_PORT=8080

# --- Was der Container IST --------------------------------------------------
# Der Hauptbefehl bestimmt die Rolle. "gateway run" heisst: Gateway-Container.
# Das Startskript legt daraufhin den s6-Dienst gateway-<Profil> an und haelt
# ihn am Leben; der Dashboard-Dienst laeuft parallel (siehe oben).
#
# Ohne Hauptbefehl startet das Image die interaktive Konsole, beendet sie
# mangels Terminal sofort wieder und startet endlos neu — dann lauscht kein
# Port und die Domain antwortet mit 502.
CMD ["gateway", "run"]

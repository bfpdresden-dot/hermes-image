# Hermes Agent — festgehaltene Fassung fuer die eigene Instanz
#
# Diese Datei baut NICHTS. Sie haelt fest, welche Fassung des offiziellen
# Images laeuft und wie sie starten soll.
#
# UPDATE: Zahl unten aendern, committen, im Betriebswerkzeug neu ausrollen.
# Verfuegbare Fassungen: https://hub.docker.com/r/nousresearch/hermes-agent/tags
#
# KEIN "latest": Sonst wechselt die Fassung bei jedem Ausrollen von selbst.
#    Bei Problemen einfach die vorige Zahl eintragen und erneut ausrollen.

FROM nousresearch/hermes-agent:v2026.9.21

# --- Wo die Daten liegen ---------------------------------------------------
# Ab v0.21 nimmt das Image /opt/data als Heimatverzeichnis. Wer von einer
# aelteren Fassung kommt, hat seine Daten aber unter dem alten Pfad liegen —
# dort, wo das Datenverzeichnis in den Container eingehaengt wird.
#
# Ohne diese Zeile faengt Hermes bei null an und legt eine leere config.yaml
# daneben. Das Dashboard meldet dann "Gateway stopped" und alles wirkt
# geloescht. Es ist nichts geloescht.
#
# ⚠️ Auf das Verzeichnis .hermes zeigen, nicht auf dessen Elternordner: Die
# alte Fassung hatte den Elternordner als HOME und legte ihre Daten wie ueblich
# in $HOME/.hermes ab.
#
# Das Startskript des Images sieht den Schalter ausdruecklich vor
# (docker/stage2-hook.sh):  HERMES_HOME=${HERMES_HOME:-/opt/data}
#
# Es richtet ausserdem die Besitzrechte selbst (chown_hermes_tree) — noetig,
# weil aeltere Fassungen als root liefen und die neue als Benutzer hermes
# (uid 10000). HERMES_UID=0 ist KEIN Ausweg, das Image laesst nur 1 bis 65534 zu.
ENV HERMES_HOME=/data/.hermes

# --- Dashboard als DIENST, nicht als Hauptbefehl ----------------------------
# ⚠️ Das ist der Kern. Laeuft der Container mit dem Befehl "dashboard", stuft
# das Image ihn als reinen Dashboard-Container ein und richtet den Gateway
# ABSICHTLICH nicht ein (hermes_cli/container_boot.py, _is_dashboard_container):
#
#     "A dashboard-only container never spawns or supervises per-profile
#      gateways — that is the gateway container's job."
#
# Symptom sonst: Dashboard erreichbar, Gateway dauerhaft "stopped", und
# `gateway start` antwortet "no such gateway 'default'", obwohl das Profil
# existiert — der s6-Dienst wurde nie angelegt.
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
# Port und der Reverse-Proxy antwortet mit 502.
CMD ["gateway", "run"]

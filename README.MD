# gitops-docker-atlas

GitOps-managed Self-Hosting Infrastructure für meinen Homeserver.

Dieses Repository enthält die vollständige Infrastruktur- und Service-Konfiguration meines Homelabs. Alle selbst gehosteten Anwendungen werden als Docker-Container betrieben und zentral über Git verwaltet.
  
## Architecture
Die Infrastruktur folgt einem GitOps-Ansatz:
 - Infrastruktur und Service-Konfigurationen werden deklarativ im Repository gepflegt.
 - Änderungen erfolgen über Git und sind vollständig nachvollziehbar.
 - Services werden als Docker-Container bereitgestellt.
 - Konfigurationen sind versioniert und reproduzierbar.

## Security
Sensible Informationen werden nicht im Klartext gespeichert.
 - Secrets werden mit Mozilla SOPS verschlüsselt.
 - Die Schlüsselverwaltung erfolgt über age.
 - Verschlüsselte Dateien können sicher im Repository versioniert werden.

## Repository Scope
Dieses Repository enthält unter anderem:
 - Docker Compose Stacks
 - Service-Konfigurationen
 - Automatisierungs- und Deployment-Konfigurationen
 - Verschlüsselte Secrets

## Goals
 - Reproduzierbare Infrastruktur
 - Nachvollziehbare Änderungen durch Git
 - Einfache Wartung und Erweiterung selbst gehosteter Dienste
 - Sichere Verwaltung sensibler Konfigurationsdaten

## Disclaimer
Dieses Repository bildet die Infrastruktur meines persönlichen Homelabs ab. Die enthaltenen Konfigurationen sind auf meine Anforderungen zugeschnitten und dienen primär der Verwaltung meiner eigenen Self-Hosting-Umgebung.
# Honey Badger Chess — I2P Overlay Konzept

## Ziel
Honey Badger Chess soll langfristig offline, lokal und optional über ein anonymes P2P-Overlay funktionieren.

## Netzwerk-Schichten

1. Local Offline Mode
- Keine Server
- Cipher Profile
- Session Code
- Burn / TTL
- Visual Chess Cipher

2. I2P Overlay Mode
- Kommunikation über lokalen I2P Router
- Keine direkte IP-Kommunikation zwischen Nutzern
- Tunnel-basierte Nachrichtenübertragung
- Geeignet für private Match Rooms und Cipher Sessions

3. Future Relay Mode
- Optionaler Relay-Fallback
- Keine Klartextdaten
- Nur verschlüsselte Payloads

## I2P Prinzipien für HBC

- Garlic Routing als Transport-Idee
- Mehrere Cipher-Moves pro Payload
- Noise-Moves als Traffic-Morphing
- Session TTL als flüchtige Kommunikation
- Challenge/Response zur Identitätsprüfung
- Keine zentrale Pflicht-Infrastruktur

## HBC Mapping

Text
→ Offline Cipher
→ Noise Moves
→ Visual Chess Moves
→ Session Envelope
→ optional I2P Transport

## Geplante Module

- I2PRouterStatus
- I2PMessageEnvelope
- I2PMatchRoom
- I2PHandshake
- I2PTransportBridge

## Wichtig
I2P ist Transport. Die eigentliche Sicherheit kommt zusätzlich durch:
- lokale Verschlüsselung
- Session Keys
- Challenge/Response
- Burn Sessions
- keine unnötige Speicherung

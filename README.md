# Leveransplaneraren

En sida för att planera veckans leveranser av grönsaker. Den hanterar utskrift av etiketter samt organiseringen av
grönsaksandelar.

Webbsidan är skriven i Ruby och använder sig av Google Sheet för data. Den kan skicka SMS till kunderna via Twilio.

## Att göra

* Flytta över configurationen från app/app.rb till miljövariabler.
* Ersätta padrino med sinatra
* Ersätta Google sheet med pgsql

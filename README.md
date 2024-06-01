# Arktox

[![version](https://img.shields.io/badge/version-0.1.0-blue)](https://github.com/OptixWolf/Arktox/releases/latest)
[![](https://img.shields.io/github/downloads/OptixWolf/Arktox/total)](https://github.com/OptixWolf/Arktox/releases/latest)
[![](https://img.shields.io/discord/1107109693165416588?logo=discord)](https://discord.com/invite/KW7GWQfKaj)

## Deutsch
Arktox ist eine Flutter-Anwendung, die Daten aus einer MySQL-Datenbank liest und ausgibt.
In diesem Fall enthält die Datenbank Daten über andere großartige Projekte, die entdeckt werden können.
Außerdem bietet die Anwendung Skripte und Chats mit anderen Nutzern.

### So richtest du Arktox mit deiner eigenen Datenbank ein

> [!IMPORTANT]
> Um das Projekt auszuführen, musst du [Flutter](https://docs.flutter.dev/get-started/install) installiert haben

Schritt 1: Lade das Projekt [hier](https://github.com/OptixWolf/Arktox/archive/refs/heads/main.zip) herunter  
Schritt 2: Erstelle eine MySQL Datenbank  
Schritt 3: Um die Datenbank zu erstellen führe die Skripte `arktox_creating_script.sql`, `arktox_inserting_script.sql` und `arktox_insert_otherthings_script.sql` im scripts Ordner in dieser reihenfolge aus  
Schritt 4: Erstelle die Datei keys.dart im lib Ordner  
Schritt 5: Füge den folgenden Code in die Datei keys.dart ein und ersetze die Werte mit deinen eigenen
```dart
const host = 'youripadress';
const port = yourport;
const user = 'youruser';
const password = 'yourpassword';
const databaseName = 'arktox';
```
Schritt 6: Führe `flutter pub get` aus  
Schritt 7: Erstelle das Projekt (nicht Web auswählen)

Allgemeine Informationen:
- Das Passwort der Benutzer der App in der Datenbank wird als SHA256-Hash angegeben

## English
Arktox is a Flutter application that reads and outputs data from a MySQL database.
In this case, the database contains data on other great projects that can be discovered.
Furthermore, the application offers scripts and chats with other users

### How to set up Arktox with your own database

> [!IMPORTANT]
> To run the project, you must have [Flutter](https://docs.flutter.dev/get-started/install) installed

Step 1: Download the project [here](https://github.com/OptixWolf/Arktox/archive/refs/heads/main.zip)  
Step 2: Create a MySQL database  
Step 3: To create the database execute the scripts `arktox_creating_script.sql`, `arktox_inserting_script.sql` and `arktox_insert_otherthings_script.sql` in the scripts folder in this order  
Step 4: Create the file keys.dart in the lib folder  
Step 5: Paste the following code into the keys.dart file and replace the values with your own
```dart
const host = 'youripadress';
const port = yourport;
const user = 'youruser';
const password = 'yourpassword';
const databaseName = 'arktox';
```
Step 6: Execute `flutter pub get`  
Step 7: Create the project (do not select web)

General information:
- The password of the users of the app in the database is specified as SHA256 hash

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'database.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() async {
  runApp(Phoenix(child: ArktoxApp()));
}

class ArktoxApp extends StatelessWidget {
  const ArktoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Preferences.getPref('darkmode'),
      builder: (context, themeModeSnapshot) {
        final currentThemeMode = themeModeSnapshot.data ?? ThemeMode.system;

        return MaterialApp(
          title: 'Arktox',
          home: const Homepage(),
          themeMode:
              currentThemeMode == true ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData.light(
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(
            useMaterial3: true,
          ),
        );
      },
    );
  }
}

class Preferences {
  static Future<bool> getPref(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool value = prefs.getBool(key) ?? true;
    return value;
  }

  static Future<void> setPref(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<String> getPrefString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String value = prefs.getString(key) ?? '';
    return value;
  }

  static Future<void> setPrefString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int currentPageIndex = 0;

  bool selectedArchivedValue = true;
  bool selectedDarkmodeValue = true;
  String email = '';
  String passwordHash = '';
  bool loggedIn = false;

  @override
  void initState() {
    super.initState();
    Preferences.getPref('archived').then((archivedValue) {
      setState(() {
        selectedArchivedValue = archivedValue;
      });
    });
    Preferences.getPref('darkmode').then((darkmodeValue) {
      setState(() {
        selectedDarkmodeValue = darkmodeValue;
      });
    });
    Preferences.getPrefString('email').then((emailValue) {
      Preferences.getPrefString('passwordHash').then((passwordHashValue) {
        email = emailValue;
        print(emailValue);
        passwordHash = passwordHashValue;
        print(passwordHashValue);
        var result = DatabaseService()
            .executeQuery(
                'SELECT user_id FROM nutzerdaten WHERE email = \'$emailValue\' AND password_hash = \'$passwordHashValue\'')
            .then((result) {
          if (result.isNotEmpty) {
            loggedIn = true;
            print(result.first);
          }
        });
      });
    });
  }

  void toggleSwitchArchived() {
    setState(() {
      selectedArchivedValue = !selectedArchivedValue;
      Preferences.setPref('archived', selectedArchivedValue);
    });
  }

  void toggleSwitchDarkmode() {
    setState(() {
      selectedDarkmodeValue = !selectedDarkmodeValue;
      Preferences.setPref('darkmode', selectedDarkmodeValue);
      Phoenix.rebirth(context);
    });
  }

  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.blue,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Startseite',
          ),
          NavigationDestination(
            icon: Icon(Icons.archive),
            label: 'Archiv',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('1337'),
              child: Icon(Icons.messenger_sharp),
            ),
            label: 'Nachrichten',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Einstellungen',
          ),
        ],
      ),
      body: <Widget>[
        /// Startseite
        Container(),

        /// Notifications page
        Container(),

        /// Messages page
        Container(),

        // Einstellungsseite
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Row(children: [
                  SizedBox(width: 7),
                  Text('Einstellungen', style: TextStyle(fontSize: 50)),
                ]),
                const SizedBox(
                  height: 25,
                ),
                const Row(children: [
                  SizedBox(width: 7),
                  Text('Konto Einstellungen', style: TextStyle(fontSize: 25)),
                ]),
                Card(
                    child: ListTile(
                  title: Text(loggedIn ? 'Abmelden' : 'Anmelden'),
                  subtitle: Text(loggedIn
                      ? 'Aktuell angemeldet mit: $email'
                      : 'Aktuell nicht angemeldet'),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: () {
                      if (loggedIn) {
                        Preferences.setPrefString('email', '');
                        Preferences.setPrefString('passwordHash', '');
                        Phoenix.rebirth(context);
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginPage()));
                      }
                    },
                  ),
                )),
                const SizedBox(
                  height: 25,
                ),
                const Row(children: [
                  SizedBox(width: 7),
                  Text('Allgemeine Einstellungen',
                      style: TextStyle(fontSize: 25)),
                ]),
                Card(
                    child: ListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text(
                      'Wenn deaktiviert, benutzt die App das helle Design'),
                  trailing: Switch(
                    value: selectedDarkmodeValue,
                    onChanged: (value) {
                      toggleSwitchDarkmode();
                    },
                  ),
                  onTap: () {
                    toggleSwitchDarkmode();
                  },
                )),
                Card(
                    child: ListTile(
                  title: const Text('Verstecke Archivierte Einträge'),
                  subtitle: const Text(
                      'Wenn deaktiviert, siehst du Archivierte Einträge'),
                  trailing: Switch(
                    value: selectedArchivedValue,
                    onChanged: (value) {
                      toggleSwitchArchived();
                    },
                  ),
                  onTap: () {
                    toggleSwitchArchived();
                  },
                ))
              ],
            ),
          ),
        )
      ][currentPageIndex],
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    String email = '';
    Digest passwordHashDigest = sha256.convert(utf8.encode(''));
    String passwordHash = '';

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => email = value,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Gib hier deine Email ein',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) =>
                      passwordHashDigest = sha256.convert(utf8.encode(value)),
                  decoration: const InputDecoration(
                    labelText: 'Passwort',
                    hintText: 'Gib hier ein sicheres Passwort ein',
                    prefixIcon: Icon(Icons.password),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          passwordHash = passwordHashDigest.toString();
                          DatabaseService()
                              .executeQuery(
                                  'SELECT user_id FROM nutzerdaten WHERE email = \'$email\' AND password_hash = \'$passwordHash\'')
                              .then((result) {
                            if (result.isNotEmpty) {
                              Preferences.setPrefString('email', email);
                              Preferences.setPrefString(
                                  'passwordHash', passwordHash);
                              Phoenix.rebirth(context);
                            }
                          });
                        },
                        color: Colors.blue,
                        child: Text('Anmelden'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          //
                        },
                        color: Colors.grey,
                        child: Text('Registrieren'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

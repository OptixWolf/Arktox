import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  int own_profile_id = -1;
  int own_user_id = -1;

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
        DatabaseService()
            .executeQuery(
                'SELECT user_id FROM nutzerdaten WHERE email = \'$emailValue\' AND password_hash = \'$passwordHashValue\'')
            .then((result) {
          if (result.isNotEmpty) {
            loggedIn = true;
            own_user_id = int.parse(result.first['user_id']);
            DatabaseService()
                .executeQuery(
                    'SELECT profile_id FROM profil WHERE user_id = $own_user_id')
                .then(
              (value) {
                if (value.isNotEmpty) {
                  own_profile_id = int.parse(value.first['profile_id']);
                }
              },
            );
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
                      ? 'Aktuell angemeldet mit: \n$email'
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
                  onTap: () {
                    if (loggedIn) {
                      Preferences.setPrefString('email', '');
                      Preferences.setPrefString('passwordHash', '');
                      Phoenix.rebirth(context);
                    } else {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    }
                  },
                )),
                Visibility(
                  visible: loggedIn,
                  child: Card(
                      child: ListTile(
                    title: const Text('Profil'),
                    subtitle: const Text('Zeigt dir dein Profil'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_right),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfilePage(
                                  profile_id: own_profile_id,
                                )));
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfilePage(
                                profile_id: own_profile_id,
                              )));
                    },
                  )),
                ),
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
      appBar: AppBar(
        title: const Text('Anmelden/Registrieren'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                        child: const Text('Anmelden'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          //
                        },
                        color: Colors.grey,
                        child: const Text('Registrieren'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final int profile_id;

  const ProfilePage({super.key, required this.profile_id});

  Future<List<Map<String, dynamic>>> getProfileDetails() async {
    var result = await DatabaseService()
        .executeQuery('SELECT * FROM profil WHERE profile_id = $profile_id');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilseite'),
      ),
      body: FutureBuilder(
          future: getProfileDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        child: SizedBox(
                          width: double.infinity,
                          height: 200.0,
                          child: Image.network(
                            snapshot.data?.first['profilbanner_link'],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const CircularProgressIndicator();
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                SizedBox(
                              width: double.infinity,
                              height: 200.0,
                              child: Image.asset(
                                'assets/default_banner.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                snapshot.data?.first['profilbild_link']),
                          ),
                          title: Text(snapshot.data?.first['username']),
                          subtitle: Text(snapshot.data?.first['about_me']),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            throw ();
          }),
    );
  }
}

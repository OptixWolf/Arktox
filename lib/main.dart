// ignore_for_file: avoid_print, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'database.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'dialog.dart';
import 'package:intl/intl.dart';
import 'dart:io';

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
  List<String> contacts = [];
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];

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

            /*DatabaseService()
                .executeQuery('SELECT profile_id FROM profil')
                .then((users) {
              if (users.isNotEmpty) {
                DatabaseService()
                    .executeQuery('SELECT * FROM follower')
                    .then((follower) {
                  if (follower.isNotEmpty) {
                    for (var user in users) {
                      if (user['profile_id'] != own_profile_id.toString()) {
                        print(user);
                        String current_user = user['profile_id'];
                        bool con1 = false;
                        bool con2 = false;
                        for (var follow in follower) {
                          print(follow);
                          if (follow['from_profile_id'] ==
                                  own_profile_id.toString() &&
                              follow['to_profile_id'] == current_user) {
                            con1 = true;
                          }
                          if (follow['from_profile_id'] == current_user &&
                              follow['to_profile_id'] ==
                                  own_profile_id.toString()) {
                            con2 = true;
                          }
                          if (con1 && con2) {
                            if (!contacts.contains(current_user)) {
                              contacts.add(current_user);
                            }
                          }
                        }
                      }
                    }
                    print(contacts);
                  }
                });
              }
            });*/
          }
        });
      });
    });

    DatabaseService().executeQuery('SELECT * FROM profil').then(
      (value) {
        items = value;
      },
    );
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

  void filterItems(String query) {
    setState(() {
      filteredItems = items
          .where((item) => item['username']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();

      if (query.isEmpty) {
        filteredItems.clear();
      }
    });
  }

  Future<List<String>> getContacts() async {
    var users =
        await DatabaseService().executeQuery('SELECT profile_id FROM profil');
    if (users.isNotEmpty) {
      var follower =
          await DatabaseService().executeQuery('SELECT * FROM follower');
      if (follower.isNotEmpty) {
        for (var user in users) {
          if (user['profile_id'] != own_profile_id.toString()) {
            print(user);
            String current_user = user['profile_id'];
            bool con1 = false;
            bool con2 = false;
            for (var follow in follower) {
              print(follow);
              if (follow['from_profile_id'] == own_profile_id.toString() &&
                  follow['to_profile_id'] == current_user) {
                con1 = true;
              }
              if (follow['from_profile_id'] == current_user &&
                  follow['to_profile_id'] == own_profile_id.toString()) {
                con2 = true;
              }
              if (con1 && con2) {
                if (!contacts.contains(current_user)) {
                  contacts.add(current_user);
                }
              }
            }
          }
        }
        print(contacts);
        return contacts;
      }
    }
    throw ();
  }

  Future<List<Map<String, dynamic>>> getMessages() {
    var result = DatabaseService().executeQuery(
        'SELECT * FROM nachrichten WHERE to_profile_id = $own_profile_id');
    return result;
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
            selectedIcon: Icon(Icons.archive),
            icon: Icon(Icons.archive_outlined),
            label: 'Archiv',
          ),
          NavigationDestination(
            icon: Icon(Icons.code),
            label: 'Skripte',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Suche',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.messenger),
            icon: Icon(Icons.messenger_outline),
            label: 'Nachrichten',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Einstellungen',
          ),
        ],
      ),
      body: <Widget>[
        /// Archiv
        Container(),

        /// Skripte
        Container(),

        /// Search page
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Row(
                children: [
                  SizedBox(width: 7),
                  Text('Suche', style: TextStyle(fontSize: 50)),
                ],
              ),
              const SizedBox(height: 25),
              TextField(
                onChanged: filterItems,
                decoration: const InputDecoration(
                  labelText: 'Personensuche',
                  hintText: 'Gib einen Nutzernamen ein...',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Visibility(
                visible: filteredItems.isEmpty,
                child: const Card(
                    child: ListTile(
                  title: Text(
                      'Kein Ergebnis\nGib etwas ein oder versuch es mit was anderem'),
                )),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: filteredItems.length > 9 ? 10 : filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(item[
                                  'profilbild_link'] ??
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmHkj6-Tndku8K2387sMaBf2DaiwfBtHQw951-fc9zzA&s'),
                        ),
                        title: Text(item['username']),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                  own_profile_id: own_profile_id,
                                  profile_id: int.parse(item['profile_id']))));
                        },
                      ),
                    ),
                  );
                },
              )),
            ],
          ),
        ),

        /// Messages page
        FutureBuilder(
            future: getContacts(),
            builder: (context, snapshot2) {
              if (snapshot2.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot2.hasError) {
                return Container();
              } else if (snapshot2.hasData) {
                return FutureBuilder(
                    future: getMessages(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Container();
                      } else if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const Row(children: [
                                SizedBox(width: 7),
                                Text('Nachrichten',
                                    style: TextStyle(fontSize: 50)),
                              ]),
                              const SizedBox(
                                height: 25,
                              ),
                              const Row(children: [
                                SizedBox(width: 7),
                                Text('Kontake:',
                                    style: TextStyle(fontSize: 25)),
                              ]),
                              Visibility(
                                visible:
                                    snapshot2.data!.isEmpty || items.isEmpty,
                                child: const Card(
                                  child: ListTile(
                                    title: Text(
                                        'Keine Kontakte\nUm jemanden hinzuzufügen müsst ihr euch gegenseitig folgen'),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: snapshot2.data!.isNotEmpty &&
                                    items.isNotEmpty,
                                child: Expanded(
                                  child: ListView.builder(
                                    itemCount: snapshot2.data!.length,
                                    itemBuilder: (context, index) {
                                      String username = '';
                                      String profilbild_link = '';
                                      int msgCount = 0;

                                      for (var element in items) {
                                        if (element["profile_id"] ==
                                            snapshot2.data![index]) {
                                          username = element["username"];
                                          profilbild_link = element[
                                                  "profilbild_link"] ??
                                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmHkj6-Tndku8K2387sMaBf2DaiwfBtHQw951-fc9zzA&s';
                                        }
                                      }

                                      for (var item in snapshot.data!) {
                                        if (item['from_profile_id'] ==
                                            snapshot2.data!
                                                .elementAt(index)
                                                .toString()) {
                                          if (item['readed'] == '0') {
                                            msgCount++;
                                          }
                                        }
                                      }

                                      return Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: ListTile(
                                            title: Text(username),
                                            leading: CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(profilbild_link),
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (context) => ProfilePage(
                                                              own_profile_id:
                                                                  own_profile_id,
                                                              profile_id: int
                                                                  .parse(snapshot2
                                                                          .data![
                                                                      index]))));
                                                    },
                                                    icon: const Icon(
                                                        Icons.person)),
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (context) => MessagePage(
                                                              own_profile_id:
                                                                  own_profile_id,
                                                              profile_id: int
                                                                  .parse(snapshot2
                                                                          .data![
                                                                      index]))));
                                                    },
                                                    icon: Badge(
                                                      label: Text(
                                                          msgCount.toString()),
                                                      child: const Icon(
                                                          Icons.chat),
                                                    ))
                                              ],
                                            ),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MessagePage(
                                                              own_profile_id:
                                                                  own_profile_id,
                                                              profile_id: int
                                                                  .parse(snapshot2
                                                                          .data![
                                                                      index]))));
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      throw ();
                    });
              }
              throw ();
            }),

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
                                  own_profile_id: own_profile_id,
                                )));
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfilePage(
                                profile_id: own_profile_id,
                                own_profile_id: own_profile_id,
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
                  obscureText: true,
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

class ProfilePage extends StatefulWidget {
  final int own_profile_id;
  final int profile_id;

  const ProfilePage(
      {super.key, required this.own_profile_id, required this.profile_id});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  int profileid = -1;
  int own_profileid = -1;
  bool following = false;
  int profile_follower_count = 0;

  @override
  void initState() {
    super.initState();
    profileid = widget.profile_id;
    own_profileid = widget.own_profile_id;

    getProfileDetails();

    DatabaseService()
        .executeQuery(
            'SELECT follower_id FROM follower WHERE from_profile_id = $own_profileid AND to_profile_id = $profileid')
        .then(
      (value) {
        if (value.isNotEmpty && value.first.isNotEmpty) {
          setState(() {
            following = true;
          });
        }
      },
    );

    DatabaseService()
        .executeQuery(
            'SELECT COUNT(follower_id) FROM follower WHERE to_profile_id = $profileid')
        .then(
      (value) {
        if (value.isNotEmpty && value.first.isNotEmpty) {
          setState(() {
            profile_follower_count =
                int.parse(value.first['COUNT(follower_id)']);
          });
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> getProfileDetails() async {
    var result = await DatabaseService()
        .executeQuery('SELECT * FROM profil WHERE profile_id = $profileid');
    return (result);
  }

  void changeFollowStatus() async {
    var result = await DatabaseService().executeQuery(
        'SELECT follower_id FROM follower WHERE from_profile_id = $own_profileid AND to_profile_id = $profileid');

    if (result.isNotEmpty && result.first.isNotEmpty) {
      var follower_id = result.first['follower_id'];
      DatabaseService().executeQuery(
          'DELETE FROM follower WHERE follower_id = $follower_id');
      setState(() {
        following = false;
        profile_follower_count = profile_follower_count - 1;
      });
    } else {
      DatabaseService().executeQuery(
          'INSERT INTO follower(from_profile_id, to_profile_id) VALUES($own_profileid, $profileid)');
      setState(() {
        following = true;
        profile_follower_count = profile_follower_count + 1;
      });
    }
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
                            snapshot.data?.first['profilbanner_link'] ??
                                'https://cdn.discordapp.com/banners/530832230885621780/046f40dae525cd2a7d23bb106a37c250.webp?size=1024&format=webp&width=0&height=256',
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const CircularProgressIndicator();
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Text('Bild konnte nicht geladen werden'),
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
                            backgroundImage: NetworkImage(snapshot
                                    .data?.first['profilbild_link'] ??
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmHkj6-Tndku8K2387sMaBf2DaiwfBtHQw951-fc9zzA&s'),
                          ),
                          title: Text(snapshot.data?.first['username']),
                          subtitle: Text(snapshot.data?.first['about_me'] ??
                              'Willkommen auf meinem Profil!'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: following
                                    ? const Icon(Icons.favorite)
                                    : const Icon(Icons.favorite_outline),
                                onPressed: () {
                                  changeFollowStatus();
                                },
                              ),
                              Text('$profile_follower_count Follower'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible:
                            own_profileid == profileid && own_profileid != -1,
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: ListTile(
                            leading: IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: ((context) => TextfieldDialog(
                                          own_profileid: own_profileid,
                                          own_profilbild_link: snapshot.data
                                                  ?.first['profilbild_link'] ??
                                              '',
                                          own_profilbanner_link:
                                              snapshot.data?.first[
                                                      'profilbanner_link'] ??
                                                  '',
                                          own_about_me: snapshot
                                                  .data?.first['about_me'] ??
                                              '',
                                        ))).then(
                                  (_) {
                                    setState(() {});
                                  },
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            title: const Text('Profil bearbeiten'),
                            subtitle: const Text(
                                'Profilbild, Profilbanner oder About me'),
                          ),
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

class MessagePage extends StatefulWidget {
  final int own_profile_id;
  final int profile_id;

  const MessagePage(
      {super.key, required this.own_profile_id, required this.profile_id});

  @override
  MessagePageState createState() => MessagePageState();
}

class MessagePageState extends State<MessagePage> {
  int profileid = -1;
  int own_profileid = -1;
  List<Map<String, dynamic>> messages = [];
  String message = '';
  String own_username = '';
  String other_username = '';
  String own_profilbild = '';
  String other_profilbild = '';
  bool loop = true;
  TextEditingController _textController = TextEditingController();
  ScrollController _listViewController = ScrollController();
  bool scrollDown = true;
  int messageCount = 0;

  @override
  void initState() {
    super.initState();
    profileid = widget.profile_id;
    own_profileid = widget.own_profile_id;

    DatabaseService().executeQuery('SELECT * FROM profil').then(
      (value) {
        for (var element in value) {
          if (element["profile_id"] == own_profileid.toString()) {
            own_username = element["username"];
            own_profilbild = element["profilbild_link"] ??
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmHkj6-Tndku8K2387sMaBf2DaiwfBtHQw951-fc9zzA&s';
          }
          if (element["profile_id"] == profileid.toString()) {
            other_username = element["username"];
            other_profilbild = element["profilbild_link"] ??
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmHkj6-Tndku8K2387sMaBf2DaiwfBtHQw951-fc9zzA&s';
          }
        }
      },
    );
    getMessages();

    Timer.periodic(const Duration(seconds: 3), (Timer t) {
      if (loop) {
        getMessages();
      } else {
        t.cancel();
      }
    });
  }

  Future<List<Map<String, dynamic>>> getProfileDetails() async {
    var result = await DatabaseService().executeQuery('SELECT * FROM profil');
    return (result);
  }

  void getMessages() {
    DatabaseService()
        .executeQuery(
            'SELECT * FROM nachrichten WHERE from_profile_id = $own_profileid AND to_profile_id = $profileid OR from_profile_id = $profileid AND to_profile_id = $own_profileid')
        .then(
      (value) {
        DatabaseService().executeQuery(
            'UPDATE nachrichten SET readed = 1 WHERE from_profile_id = $own_profileid AND to_profile_id = $profileid OR from_profile_id = $profileid AND to_profile_id = $own_profileid');
        try {
          setState(() {
            messages.clear();
            messages = value;
            print('reloaded');

            if (messageCount != value.length) {
              messageCount = value.length;
              scrollDown = true;
            }

            if (scrollDown) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _listViewController.animateTo(
                  _listViewController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              });
              scrollDown = false;
            }
          });
        } catch (e) {
          loop = false;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nachrichten'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(other_profilbild),
                    ),
                    title: Text(other_username),
                    trailing: IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfilePage(
                                own_profile_id: own_profileid,
                                profile_id: profileid)));
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  margin: EdgeInsets.zero,
                  child: ListView.builder(
                    controller: _listViewController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Visibility(
                            visible:
                                messages.elementAt(index)['from_profile_id'] ==
                                    own_profileid.toString(),
                            child: Card(
                              color: const Color.fromARGB(255, 42, 116, 46),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(own_profilbild),
                                  ),
                                  title: Text(own_username),
                                  subtitle: Text(
                                      messages.elementAt(index)['message']),
                                  trailing: PopupMenuButton<int>(
                                    onSelected: (value) {
                                      if (value == 1) {
                                        Clipboard.setData(ClipboardData(
                                            text: messages
                                                .elementAt(index)['message']));
                                      }
                                      if (value == 2) {
                                        DatabaseService().executeQuery(
                                            'DELETE FROM nachrichten WHERE message_id = ' +
                                                messages.elementAt(
                                                    index)['message_id']);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 1,
                                        child: Row(
                                          children: [
                                            Icon(Icons.copy),
                                            Text('Kopieren'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 2,
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete),
                                            Text('Löschen'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible:
                                messages.elementAt(index)['from_profile_id'] ==
                                    profileid.toString(),
                            child: Card(
                              color: const Color.fromARGB(255, 25, 97, 156),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(other_profilbild),
                                  ),
                                  title: Text(other_username),
                                  subtitle: Text(
                                      messages.elementAt(index)['message']),
                                  trailing: PopupMenuButton<int>(
                                    onSelected: (value) {
                                      if (value == 1) {
                                        Clipboard.setData(ClipboardData(
                                            text: messages
                                                .elementAt(index)['message']));
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 1,
                                        child: Row(
                                          children: [
                                            Icon(Icons.copy),
                                            Text('Kopieren'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textInputAction: TextInputAction.go,
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              final now = DateTime.now();
                              final formattedDate =
                                  DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

                              DatabaseService().executeQuery(
                                  'INSERT INTO nachrichten(from_profile_id, to_profile_id, message, attachement_link, readed, message_send_at) VALUES($own_profileid, $profileid, \'$value\', \'\', 0, \'$formattedDate\')');
                              _textController.clear();
                              scrollDown = true;
                            }
                          },
                          controller: _textController,
                          onChanged: (value) => message = value,
                          decoration: const InputDecoration(
                            labelText: 'Nachricht',
                            hintText: 'Gib hier deine Nachricht ein...',
                            prefixIcon: Icon(Icons.message),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            if (message.isNotEmpty) {
                              final now = DateTime.now();
                              final formattedDate =
                                  DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

                              DatabaseService().executeQuery(
                                  'INSERT INTO nachrichten(from_profile_id, to_profile_id, message, attachement_link, readed, message_send_at) VALUES($own_profileid, $profileid, \'$message\', \'\', 0, \'$formattedDate\')');
                              _textController.clear();
                              message = '';
                              scrollDown = true;
                            }
                          },
                          icon: const Icon(Icons.send))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

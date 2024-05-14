// ignore_for_file: avoid_print, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'database.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'dialog.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:intl/intl.dart';

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
  int counter = 0;
  int counter2 = 0;

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
    contacts.clear();
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

  Future<List<Map<String, dynamic>>> getMessages() async {
    var result = await DatabaseService().executeQuery(
        'SELECT * FROM nachrichten WHERE to_profile_id = $own_profile_id');
    return result;
  }

  Future<List<Map<String, dynamic>>> getArchivKategorien() async {
    var result =
        await DatabaseService().executeQuery('SELECT * FROM kategorien_archiv');
    return result;
  }

  Future<List<Map<String, dynamic>>> getArchivEintraege() async {
    var result =
        await DatabaseService().executeQuery('SELECT * FROM archiv_eintraege');
    return result;
  }

  Future<List<Map<String, dynamic>>> getSkripteKategorien() async {
    var result = await DatabaseService()
        .executeQuery('SELECT * FROM kategorien_skripte');
    return result;
  }

  Future<List<Map<String, dynamic>>> getSkripteEintraege() async {
    var result = await DatabaseService().executeQuery('SELECT * FROM skripte');
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
        FutureBuilder(
            future: getArchivKategorien(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingAnimationWidget.threeArchedCircle(
                      color: Colors.blueGrey, size: 75),
                );
              } else if (snapshot.hasError) {
                return Container();
              } else if (snapshot.hasData) {
                return FutureBuilder(
                    future: getArchivEintraege(),
                    builder: (context, snapshot2) {
                      if (snapshot2.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: LoadingAnimationWidget.threeArchedCircle(
                              color: Colors.blueGrey, size: 75),
                        );
                      } else if (snapshot2.hasError) {
                        return Container();
                      } else if (snapshot2.hasData) {
                        counter = 0;
                        List<Map<String, dynamic>> own_items = [];
                        List<Map<String, dynamic>> verified_items = [];

                        for (var item in snapshot2.data!) {
                          if (item['profile_id'] == own_profile_id.toString()) {
                            own_items.add(item);
                          }
                        }

                        for (var item in snapshot2.data!) {
                          if (item['approval_status'] == '1') {
                            verified_items.add(item);
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              const Row(
                                children: [
                                  SizedBox(width: 7),
                                  Text('Archiv',
                                      style: TextStyle(fontSize: 50)),
                                ],
                              ),
                              Visibility(
                                visible: loggedIn && own_items.isNotEmpty,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Card(
                                      child: ListTile(
                                        title: const Text(
                                            'Eigene Archiv Einträge'),
                                        trailing: const Icon(Icons.open_in_new),
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SelectOwnArchiveItemPage(
                                                          own_profile_id:
                                                              own_profile_id)));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const SizedBox(height: 15),
                              const Row(children: [
                                SizedBox(width: 7),
                                Text('Kategorien',
                                    style: TextStyle(fontSize: 25)),
                              ]),
                              const SizedBox(height: 5),
                              Expanded(
                                flex: 3,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlattformPage(
                                                        kategorieid: snapshot
                                                                .data!
                                                                .elementAt(
                                                                    index)[
                                                            'kategorie_id'],
                                                        own_profile_id:
                                                            own_profile_id,
                                                      )));
                                        },
                                        title: Text(snapshot.data!
                                            .elementAt(index)['kategorie']),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Row(children: [
                                SizedBox(width: 7),
                                Text('Neuesten Archiv Einträge',
                                    style: TextStyle(fontSize: 25)),
                              ]),
                              const SizedBox(height: 5),
                              Expanded(
                                flex: 3,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: verified_items.length > 4
                                      ? 5
                                      : verified_items.length,
                                  itemBuilder: (context, index) {
                                    counter++;
                                    return Card(
                                      child: ListTile(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            ArchiveItemPage(
                                                              archiv_itemid: verified_items.elementAt(
                                                                  verified_items
                                                                          .length -
                                                                      index -
                                                                      1)['archiv_item_id'],
                                                              own_profile_id:
                                                                  own_profile_id,
                                                            )));
                                          },
                                          title: Text(verified_items.elementAt(
                                              verified_items.length -
                                                  counter)['title'])),
                                    );
                                  },
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

        /// Skripte
        FutureBuilder(
            future: getSkripteKategorien(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingAnimationWidget.threeArchedCircle(
                      color: Colors.blueGrey, size: 75),
                );
              } else if (snapshot.hasError) {
                return Container();
              } else if (snapshot.hasData) {
                return FutureBuilder(
                    future: getSkripteEintraege(),
                    builder: (context, snapshot2) {
                      if (snapshot2.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: LoadingAnimationWidget.threeArchedCircle(
                              color: Colors.blueGrey, size: 75),
                        );
                      } else if (snapshot2.hasError) {
                        return Container();
                      } else if (snapshot2.hasData) {
                        counter2 = 0;
                        List<Map<String, dynamic>> own_items = [];
                        List<Map<String, dynamic>> verified_items = [];

                        for (var item in snapshot2.data!) {
                          if (item['profile_id'] == own_profile_id.toString()) {
                            own_items.add(item);
                          }
                        }

                        for (var item in snapshot2.data!) {
                          if (item['approval_status'] == '1') {
                            verified_items.add(item);
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              const Row(
                                children: [
                                  SizedBox(width: 7),
                                  Text('Skripte',
                                      style: TextStyle(fontSize: 50)),
                                ],
                              ),
                              Visibility(
                                visible: loggedIn && own_items.isNotEmpty,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Card(
                                      child: ListTile(
                                        title: const Text('Eigene Skripte'),
                                        trailing: const Icon(Icons.open_in_new),
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SelectOwnSkriptItemPage(
                                                          own_profile_id:
                                                              own_profile_id)));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const SizedBox(height: 15),
                              const Row(children: [
                                SizedBox(width: 7),
                                Text('Kategorien',
                                    style: TextStyle(fontSize: 25)),
                              ]),
                              const SizedBox(height: 5),
                              Expanded(
                                flex: 3,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SkriptePlattformPage(
                                                        kategorieid: snapshot
                                                                .data!
                                                                .elementAt(
                                                                    index)[
                                                            'kategorie_id'],
                                                        own_profile_id:
                                                            own_profile_id,
                                                      )));
                                        },
                                        title: Text(snapshot.data!
                                            .elementAt(index)['kategorie']),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Row(children: [
                                SizedBox(width: 7),
                                Text('Neueste Skripte',
                                    style: TextStyle(fontSize: 25)),
                              ]),
                              const SizedBox(height: 5),
                              Expanded(
                                flex: 3,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: verified_items.length > 4
                                      ? 5
                                      : verified_items.length,
                                  itemBuilder: (context, index) {
                                    counter2++;
                                    return Card(
                                      child: ListTile(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SkriptItemPage(
                                                          skriptid: verified_items
                                                              .elementAt(verified_items
                                                                      .length -
                                                                  index -
                                                                  1)['skript_id'],
                                                          own_profile_id:
                                                              own_profile_id,
                                                        )));
                                          },
                                          title: Text(verified_items.elementAt(
                                              verified_items.length -
                                                  counter2)['title'])),
                                    );
                                  },
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

        /// Search page
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
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
                padding: EdgeInsets.zero,
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
                return Center(
                  child: LoadingAnimationWidget.threeArchedCircle(
                      color: Colors.blueGrey, size: 75),
                );
              } else if (snapshot2.hasError) {
                return Container();
              } else if (snapshot2.hasData) {
                return FutureBuilder(
                    future: getMessages(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: LoadingAnimationWidget.threeArchedCircle(
                              color: Colors.blueGrey, size: 75),
                        );
                      } else if (snapshot.hasError) {
                        return Container();
                      } else if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
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
                                Text('Kontakte:',
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
                                    padding: EdgeInsets.zero,
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
                const SizedBox(height: 20),
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

class PlattformPage extends StatelessWidget {
  final String kategorieid;
  final int own_profile_id;

  const PlattformPage(
      {super.key, required this.kategorieid, required this.own_profile_id});

  Future<List<Map<String, dynamic>>> getArchivePlatforms() async {
    var result = await DatabaseService().executeQuery(
        'SELECT pa.* FROM plattform_archiv pa WHERE pa.plattform_id IN (SELECT ae.plattform_id FROM archiv_eintraege ae WHERE ae.kategorie_id = $kategorieid)');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plattformen'),
      ),
      body: FutureBuilder(
          future: getArchivePlatforms(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                    color: Colors.blueGrey, size: 75),
              );
            } else if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SelectArchiveItemPage(
                                          kategorieid: kategorieid,
                                          plattformid: snapshot.data!
                                              .elementAt(index)['plattform_id'],
                                          own_profile_id: own_profile_id,
                                        )));
                              },
                              title: Text(
                                  snapshot.data!.elementAt(index)['plattform']),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            throw ();
          }),
    );
  }
}

class SkriptePlattformPage extends StatelessWidget {
  final String kategorieid;
  final int own_profile_id;

  const SkriptePlattformPage(
      {super.key, required this.kategorieid, required this.own_profile_id});

  Future<List<Map<String, dynamic>>> getArchivePlatforms() async {
    var result = await DatabaseService().executeQuery(
        'SELECT ps.* FROM plattform_skripte ps WHERE ps.plattform_id IN (SELECT s.plattform_id FROM skripte s WHERE s.kategorie_id = $kategorieid)');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plattformen'),
      ),
      body: FutureBuilder(
          future: getArchivePlatforms(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                    color: Colors.blueGrey, size: 75),
              );
            } else if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SelectSkriptItemPage(
                                          kategorieid: kategorieid,
                                          plattformid: snapshot.data!
                                              .elementAt(index)['plattform_id'],
                                          own_profile_id: own_profile_id,
                                        )));
                              },
                              title: Text(
                                  snapshot.data!.elementAt(index)['plattform']),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            throw ();
          }),
    );
  }
}

class SelectArchiveItemPage extends StatefulWidget {
  final String kategorieid;
  final String plattformid;
  final int own_profile_id;

  const SelectArchiveItemPage(
      {super.key,
      required this.kategorieid,
      required this.plattformid,
      required this.own_profile_id});

  @override
  SelectArchiveItemPageState createState() => SelectArchiveItemPageState();
}

class SelectArchiveItemPageState extends State<SelectArchiveItemPage> {
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];
  String constantFilterString = "[Archiviert]";

  @override
  void initState() {
    super.initState();
    Preferences.getPref('archived').then((archivedValue) {
      if (!archivedValue) {
        constantFilterString = "fijeghuioefbuognberonbgoierngioenbrognokenr";
      }
      loadItems();
    });
  }

  Future<void> loadItems() async {
    var result = await DatabaseService().executeQuery(
        'SELECT * FROM archiv_eintraege WHERE kategorie_id = ' +
            widget.kategorieid +
            ' AND plattform_id = ' +
            widget.plattformid +
            '');
    setState(() {
      items = result;
      items = items
          .where((item) => !item['title']
              .toString()
              .toLowerCase()
              .contains(constantFilterString.toLowerCase()))
          .toList();
      filteredItems = items;
    });
  }

  void filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = items;
      } else {
        filteredItems = items
            .where((item) => item['title']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archiv Eintrag Auswahl'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              onChanged: filterItems,
              decoration: const InputDecoration(
                labelText: 'Suche',
                hintText: 'Suche',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ArchiveItemPage(
                                  archiv_itemid: filteredItems[index]
                                      ['archiv_item_id'],
                                  own_profile_id: widget.own_profile_id,
                                )));
                      },
                      title: Text(filteredItems[index]['title']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectOwnArchiveItemPage extends StatefulWidget {
  final int own_profile_id;

  const SelectOwnArchiveItemPage({super.key, required this.own_profile_id});

  @override
  SelectOwnArchiveItemPageState createState() =>
      SelectOwnArchiveItemPageState();
}

class SelectOwnArchiveItemPageState extends State<SelectOwnArchiveItemPage> {
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];
  String constantFilterString = "[Archiviert]";

  @override
  void initState() {
    super.initState();
    Preferences.getPref('archived').then((archivedValue) {
      if (!archivedValue) {
        constantFilterString = "fijeghuioefbuognberonbgoierngioenbrognokenr";
      }
      loadItems();
    });
  }

  Future<void> loadItems() async {
    var result = await DatabaseService().executeQuery(
        'SELECT * FROM archiv_eintraege WHERE profile_id = ' +
            widget.own_profile_id.toString() +
            '');
    setState(() {
      items = result;
      items = items
          .where((item) => !item['title']
              .toString()
              .toLowerCase()
              .contains(constantFilterString.toLowerCase()))
          .toList();
      filteredItems = items;
    });
  }

  void filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = items;
      } else {
        filteredItems = items
            .where((item) => item['title']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deine Archiv Einträge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              onChanged: filterItems,
              decoration: const InputDecoration(
                labelText: 'Suche',
                hintText: 'Suche',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ArchiveItemPage(
                                  archiv_itemid: filteredItems[index]
                                      ['archiv_item_id'],
                                  own_profile_id: widget.own_profile_id,
                                )));
                      },
                      title: Text(filteredItems[index]['title']),
                      trailing: filteredItems[index]['approval_status'] == '1'
                          ? const Icon(Icons.check)
                          : const Icon(Icons.error),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectOwnSkriptItemPage extends StatefulWidget {
  final int own_profile_id;

  const SelectOwnSkriptItemPage({super.key, required this.own_profile_id});

  @override
  SelectOwnSkriptItemPageState createState() => SelectOwnSkriptItemPageState();
}

class SelectOwnSkriptItemPageState extends State<SelectOwnSkriptItemPage> {
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];
  String constantFilterString = "[Archiviert]";

  @override
  void initState() {
    super.initState();
    Preferences.getPref('archived').then((archivedValue) {
      if (!archivedValue) {
        constantFilterString = "fijeghuioefbuognberonbgoierngioenbrognokenr";
      }
      loadItems();
    });
  }

  Future<void> loadItems() async {
    var result = await DatabaseService().executeQuery(
        'SELECT * FROM skripte WHERE profile_id = ' +
            widget.own_profile_id.toString() +
            '');
    setState(() {
      items = result;
      items = items
          .where((item) => !item['title']
              .toString()
              .toLowerCase()
              .contains(constantFilterString.toLowerCase()))
          .toList();
      filteredItems = items;
    });
  }

  void filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = items;
      } else {
        filteredItems = items
            .where((item) => item['title']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deine Skripte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              onChanged: filterItems,
              decoration: const InputDecoration(
                labelText: 'Suche',
                hintText: 'Suche',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SkriptItemPage(
                                  skriptid: filteredItems[index]['skript_id'],
                                  own_profile_id: widget.own_profile_id,
                                )));
                      },
                      title: Text(filteredItems[index]['title']),
                      trailing: filteredItems[index]['approval_status'] == '1'
                          ? const Icon(Icons.check)
                          : const Icon(Icons.error),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectSkriptItemPage extends StatefulWidget {
  final String kategorieid;
  final String plattformid;
  final int own_profile_id;

  const SelectSkriptItemPage(
      {super.key,
      required this.kategorieid,
      required this.plattformid,
      required this.own_profile_id});

  @override
  SelectSkriptItemPageState createState() => SelectSkriptItemPageState();
}

class SelectSkriptItemPageState extends State<SelectSkriptItemPage> {
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];
  String constantFilterString = "[Archiviert]";

  @override
  void initState() {
    super.initState();
    Preferences.getPref('archived').then((archivedValue) {
      if (!archivedValue) {
        constantFilterString = "fijeghuioefbuognberonbgoierngioenbrognokenr";
      }
      loadItems();
    });
  }

  Future<void> loadItems() async {
    var result = await DatabaseService().executeQuery(
        'SELECT * FROM skripte WHERE kategorie_id = ' +
            widget.kategorieid +
            ' AND plattform_id = ' +
            widget.plattformid +
            '');
    setState(() {
      items = result;
      items = items
          .where((item) => !item['title']
              .toString()
              .toLowerCase()
              .contains(constantFilterString.toLowerCase()))
          .toList();
      filteredItems = items;
    });
  }

  void filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = items;
      } else {
        filteredItems = items
            .where((item) => item['title']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skript Auswahl'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              onChanged: filterItems,
              decoration: const InputDecoration(
                labelText: 'Suche',
                hintText: 'Suche',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SkriptItemPage(
                                  skriptid: filteredItems[index]['skript_id'],
                                  own_profile_id: widget.own_profile_id,
                                )));
                      },
                      title: Text(filteredItems[index]['title']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArchiveItemPage extends StatefulWidget {
  final String archiv_itemid;
  final int own_profile_id;

  const ArchiveItemPage(
      {super.key, required this.archiv_itemid, required this.own_profile_id});

  @override
  ArchiveItemPageState createState() => ArchiveItemPageState();
}

class ArchiveItemPageState extends State<ArchiveItemPage> {
  bool liked = false;
  int own_profileid = -1;
  String archiv_itemid = '-1';
  int archiv_like_count = 0;

  @override
  void initState() {
    super.initState();
    own_profileid = widget.own_profile_id;
    archiv_itemid = widget.archiv_itemid;
    DatabaseService()
        .executeQuery(
            'SELECT like_id FROM likes_archiv WHERE profile_id = $own_profileid AND post_id = $archiv_itemid')
        .then(
      (value) {
        if (value.isNotEmpty && value.first.isNotEmpty) {
          setState(() {
            liked = true;
          });
        }
      },
    );

    DatabaseService()
        .executeQuery(
            'SELECT COUNT(like_id) FROM likes_archiv WHERE post_id = $archiv_itemid')
        .then(
      (value) {
        if (value.isNotEmpty && value.first.isNotEmpty) {
          setState(() {
            archiv_like_count = int.parse(value.first['COUNT(like_id)']);
          });
        }
      },
    );
  }

  void setClipboardText(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  void _showSnackbar(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Inhalt wurde in die Zwischenablage gespeichert'),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getArchiveItem() async {
    var result = await DatabaseService().executeQuery(
        'SELECT * FROM archiv_eintraege WHERE archiv_item_id = $archiv_itemid');
    return result;
  }

  Future<List<Map<String, dynamic>>> getProfile(String authorid) async {
    var result = await DatabaseService()
        .executeQuery('SELECT * FROM profil WHERE profile_id = $authorid');
    return result;
  }

  void changeLikeStatus() async {
    var result = await DatabaseService().executeQuery(
        'SELECT like_id FROM likes_archiv WHERE profile_id = $own_profileid AND post_id = $archiv_itemid');

    if (result.isNotEmpty && result.first.isNotEmpty) {
      var like_id = result.first['like_id'];
      DatabaseService()
          .executeQuery('DELETE FROM likes_archiv WHERE like_id = $like_id');
      setState(() {
        liked = false;
        archiv_like_count = archiv_like_count - 1;
      });
    } else {
      DatabaseService().executeQuery(
          'INSERT INTO likes_archiv(profile_id, post_id) VALUES($own_profileid, $archiv_itemid)');
      setState(() {
        liked = true;
        archiv_like_count = archiv_like_count + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archiv Eintrag'),
      ),
      body: FutureBuilder(
          future: getArchiveItem(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                    color: Colors.blueGrey, size: 75),
              );
            } else if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              return FutureBuilder(
                  future: getProfile(snapshot.data!.first['profile_id']),
                  builder: (context, snapshot2) {
                    if (snapshot2.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.threeArchedCircle(
                            color: Colors.blueGrey, size: 75),
                      );
                    } else if (snapshot2.hasError) {
                      return Container();
                    } else if (snapshot2.hasData) {
                      return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Visibility(
                                  visible: snapshot.data!.first['hint'] != null,
                                  child: Column(
                                    children: [
                                      Card(
                                          surfaceTintColor: Colors.red,
                                          child: ListTile(
                                            title: const Text('Hinweis'),
                                            subtitle: Text(
                                                snapshot.data!.first['hint'] ??
                                                    ''),
                                          )),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                            child: Text(
                                                snapshot.data!.first['title'])),
                                        IconButton(
                                            onPressed: () {
                                              if (own_profileid != -1) {
                                                changeLikeStatus();
                                              }
                                            },
                                            icon: liked
                                                ? const Icon(Icons.favorite)
                                                : const Icon(
                                                    Icons.favorite_outline)),
                                        Text(archiv_like_count.toString()),
                                      ],
                                    ),
                                    subtitle: Text(
                                        snapshot.data!.first['description']),
                                  ),
                                ),
                                Card(
                                  color:
                                      snapshot.data!.first['approval_status'] ==
                                              '1'
                                          ? Colors.green
                                          : Colors.red,
                                  child: ListTile(
                                    title: const Text('Skript überprüfung'),
                                    subtitle: snapshot.data!
                                                .first['approval_status'] ==
                                            '1'
                                        ? const Text(
                                            'Das Skript wurde von einem Moderator bestätigt')
                                        : const Text(
                                            'Das Skript wurde noch nicht überprüft'),
                                    trailing: snapshot.data!
                                                .first['approval_status'] ==
                                            '1'
                                        ? const Icon(Icons.check_circle)
                                        : const Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Visibility(
                                  visible:
                                      snapshot.data!.first['command'] != null,
                                  child: Card(
                                      child: ListTile(
                                    title: const Text('Command'),
                                    subtitle: Text(
                                        snapshot.data!.first['command'] ?? ''),
                                    trailing: const Icon(Icons.copy),
                                    onTap: () {
                                      setClipboardText(
                                          snapshot.data!.first['command']);
                                      _showSnackbar(context);
                                    },
                                  )),
                                ),
                                Visibility(
                                  visible: snapshot.data!.first['link'] != null,
                                  child: Card(
                                      child: ListTile(
                                    title: Text(
                                        snapshot.data!.first['link_title'] ??
                                            ''),
                                    subtitle: Text(
                                        snapshot.data!.first['link'] ?? ''),
                                    trailing: const Icon(Icons.open_in_new),
                                    onTap: () {
                                      _launchURL(
                                          snapshot.data!.first['link'] ?? '');
                                    },
                                  )),
                                ),
                                Visibility(
                                  visible:
                                      snapshot.data!.first['link2'] != null,
                                  child: Card(
                                      child: ListTile(
                                    title: Text(
                                        snapshot.data!.first['link2_title'] ??
                                            ''),
                                    subtitle: Text(
                                        snapshot.data!.first['link2'] ?? ''),
                                    trailing: const Icon(Icons.open_in_new),
                                    onTap: () {
                                      _launchURL(
                                          snapshot.data!.first['link2'] ?? '');
                                    },
                                  )),
                                ),
                                Visibility(
                                  visible:
                                      snapshot.data!.first['link3'] != null,
                                  child: Card(
                                      child: ListTile(
                                    title: Text(
                                        snapshot.data!.first['link3_title'] ??
                                            ''),
                                    subtitle: Text(
                                        snapshot.data!.first['link3'] ?? ''),
                                    trailing: const Icon(Icons.open_in_new),
                                    onTap: () {
                                      _launchURL(
                                          snapshot.data!.first['link3'] ?? '');
                                    },
                                  )),
                                ),
                                const SizedBox(height: 20),
                                Card(
                                    child: ListTile(
                                  title: const Text('Projekt Autor'),
                                  subtitle: Text(
                                      snapshot.data!.first['project_author']),
                                  trailing: const Icon(Icons.open_in_new),
                                  onTap: () {
                                    _launchURL(snapshot.data!
                                            .first['project_author_link'] ??
                                        '');
                                  },
                                )),
                                Card(
                                    child: ListTile(
                                  leading: CircleAvatar(
                                      backgroundImage: NetworkImage(snapshot2
                                              .data!.first['profilbild_link'] ??
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmHkj6-Tndku8K2387sMaBf2DaiwfBtHQw951-fc9zzA&s')),
                                  title: const Text('Bereitgestellt durch'),
                                  subtitle:
                                      Text(snapshot2.data!.first['username']),
                                  trailing: const Icon(Icons.person),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => ProfilePage(
                                                  own_profile_id: own_profileid,
                                                  profile_id: int.parse(
                                                      snapshot2.data!
                                                          .first['profile_id']),
                                                )));
                                  },
                                ))
                              ],
                            ),
                          ));
                    }
                    throw ();
                  });
            }
            throw ();
          }),
    );
  }
}

class SkriptItemPage extends StatefulWidget {
  final String skriptid;
  final int own_profile_id;

  const SkriptItemPage(
      {super.key, required this.skriptid, required this.own_profile_id});

  @override
  SkriptItemPageState createState() => SkriptItemPageState();
}

class SkriptItemPageState extends State<SkriptItemPage> {
  bool liked = false;
  int own_profileid = -1;
  String skriptid = '-1';
  int skript_like_count = 0;

  @override
  void initState() {
    super.initState();
    own_profileid = widget.own_profile_id;
    skriptid = widget.skriptid;
    DatabaseService()
        .executeQuery(
            'SELECT like_id FROM likes_skripte WHERE profile_id = $own_profileid AND post_id = $skriptid')
        .then(
      (value) {
        if (value.isNotEmpty && value.first.isNotEmpty) {
          setState(() {
            liked = true;
          });
        }
      },
    );

    DatabaseService()
        .executeQuery(
            'SELECT COUNT(like_id) FROM likes_skripte WHERE post_id = $skriptid')
        .then(
      (value) {
        if (value.isNotEmpty && value.first.isNotEmpty) {
          setState(() {
            skript_like_count = int.parse(value.first['COUNT(like_id)']);
          });
        }
      },
    );
  }

  void setClipboardText(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  void _showSnackbar(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Inhalt wurde in die Zwischenablage gespeichert'),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getSkriptItem() async {
    var result = await DatabaseService()
        .executeQuery('SELECT * FROM skripte WHERE skript_id = $skriptid');
    return result;
  }

  Future<List<Map<String, dynamic>>> getProfile(String authorid) async {
    var result = await DatabaseService()
        .executeQuery('SELECT * FROM profil WHERE profile_id = $authorid');
    return result;
  }

  void changeLikeStatus() async {
    var result = await DatabaseService().executeQuery(
        'SELECT like_id FROM likes_skripte WHERE profile_id = $own_profileid AND post_id = $skriptid');

    if (result.isNotEmpty && result.first.isNotEmpty) {
      var like_id = result.first['like_id'];
      DatabaseService()
          .executeQuery('DELETE FROM likes_skripte WHERE like_id = $like_id');
      setState(() {
        liked = false;
        skript_like_count = skript_like_count - 1;
      });
    } else {
      DatabaseService().executeQuery(
          'INSERT INTO likes_skripte(profile_id, post_id) VALUES($own_profileid, $skriptid)');
      setState(() {
        liked = true;
        skript_like_count = skript_like_count + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skript'),
      ),
      body: FutureBuilder(
          future: getSkriptItem(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                    color: Colors.blueGrey, size: 75),
              );
            } else if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              return FutureBuilder(
                  future: getProfile(snapshot.data!.first['profile_id']),
                  builder: (context, snapshot2) {
                    if (snapshot2.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.threeArchedCircle(
                            color: Colors.blueGrey, size: 75),
                      );
                    } else if (snapshot2.hasError) {
                      return Container();
                    } else if (snapshot2.hasData) {
                      return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Card(
                                    child: ListTile(
                                  title: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                          child: Text(
                                              snapshot.data!.first['title'])),
                                      IconButton(
                                          onPressed: () {
                                            if (own_profileid != -1) {
                                              changeLikeStatus();
                                            }
                                          },
                                          icon: liked
                                              ? const Icon(Icons.favorite)
                                              : const Icon(
                                                  Icons.favorite_outline)),
                                      Text(skript_like_count.toString()),
                                    ],
                                  ),
                                  subtitle:
                                      Text(snapshot.data!.first['description']),
                                )),
                                Card(
                                  color:
                                      snapshot.data!.first['approval_status'] ==
                                              '1'
                                          ? Colors.green
                                          : Colors.red,
                                  child: ListTile(
                                    title: const Text('Skript überprüfung'),
                                    subtitle: snapshot.data!
                                                .first['approval_status'] ==
                                            '1'
                                        ? const Text(
                                            'Das Skript wurde von einem Moderator bestätigt')
                                        : const Text(
                                            'Das Skript wurde noch nicht überprüft'),
                                    trailing: snapshot.data!
                                                .first['approval_status'] ==
                                            '1'
                                        ? const Icon(Icons.check_circle)
                                        : const Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Card(
                                  color: Colors.blue,
                                  child: ListTile(
                                    onTap: () {
                                      setClipboardText(snapshot
                                          .data!.first['script']
                                          .toString()
                                          .replaceAll("\\n", "\n"));
                                      _showSnackbar(context);
                                    },
                                    title: const Text('Skript kopieren'),
                                    trailing: const Icon(Icons.copy),
                                  ),
                                ),
                                Card(
                                  child: ExpansionTile(
                                    title: const Text('Skript:'),
                                    children: [
                                      ListTile(
                                        subtitle: Text(snapshot
                                            .data!.first['script']
                                            .toString()
                                            .replaceAll("\\n", "\n")),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Card(
                                    child: ListTile(
                                  leading: CircleAvatar(
                                      backgroundImage: NetworkImage(snapshot2
                                              .data!.first['profilbild_link'] ??
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmHkj6-Tndku8K2387sMaBf2DaiwfBtHQw951-fc9zzA&s')),
                                  title: const Text('Bereitgestellt durch'),
                                  subtitle:
                                      Text(snapshot2.data!.first['username']),
                                  trailing: const Icon(Icons.person),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => ProfilePage(
                                                  own_profile_id: own_profileid,
                                                  profile_id: int.parse(
                                                      snapshot2.data!
                                                          .first['profile_id']),
                                                )));
                                  },
                                ))
                              ],
                            ),
                          ));
                    }
                    throw ();
                  });
            }
            throw ();
          }),
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
                  onChanged: (value) => email = value.replaceAll(' ', ''),
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
  String creation_date = '';

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

    DatabaseService()
        .executeQuery(
            'SELECT * FROM nutzerdaten WHERE user_id = (SELECT user_id FROM profil WHERE profile_id = $profileid)')
        .then(
      (value) {
        creation_date = value.first['created_at'].toString();

        DateFormat originalFormat = DateFormat('yyyy-MM-dd');
        DateFormat newFormat = DateFormat('dd.MM.yyyy');

        creation_date = newFormat.format(originalFormat.parse(creation_date));
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
              return Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                    color: Colors.blueGrey, size: 75),
              );
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
                          subtitle: Text('Dabei seit: ' + creation_date),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: following
                                        ? const Icon(Icons.favorite)
                                        : const Icon(Icons.favorite_outline),
                                    onPressed: () {
                                      if (own_profileid != -1) {
                                        changeFollowStatus();
                                      }
                                    },
                                  ),
                                  Text('$profile_follower_count Follower'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          title: const Text('Über mich:'),
                          subtitle: Text(snapshot.data?.first['about_me'] ?? '',
                              style: const TextStyle(fontSize: 14)),
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
                              color: Colors.green,
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
                              color: Colors.blue,
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
                                  'INSERT INTO nachrichten(from_profile_id, to_profile_id, message, attachement_link, readed, message_send_at) VALUES($own_profileid, $profileid, \'$message\', \'\', 0, \'$formattedDate\')');
                              _textController.clear();
                              scrollDown = true;
                            }
                          },
                          controller: _textController,
                          onChanged: (value) =>
                              message = value.replaceAll('\'', '\'\''),
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

_launchURL(String url) async {
  final Uri finalUrl = Uri.parse(url);
  if (!await launchUrl(finalUrl)) {
    throw Exception('Could not launch $finalUrl');
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database.dart';

void main() {
  DatabaseService().connect();
  runApp(const ArktoxApp());
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
  static const String darkmodeKey = 'darkmode';
  static const String archivedKey = 'archived';

  static Future<bool> getPref(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool value = prefs.getBool(key) ?? true;
    return value;
  }

  static Future<void> setPref(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
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
      runApp(ArktoxApp());
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
                Text('Allgemeine Einstellungen',
                    style: TextStyle(fontSize: 25)),
              ]),
              Card(
                  child: ListTile(
                title: const Text('App Darstellung'),
                subtitle: const Text(
                    'Wenn deaktiviert, benutzt die App das helle Design'),
                trailing: Switch(
                  value: selectedDarkmodeValue,
                  onChanged: (value) {
                    toggleSwitchDarkmode();
                  },
                ),
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
        )
      ][currentPageIndex],
    );
  }
}

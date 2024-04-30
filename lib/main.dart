import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const ArktoxApp());

class ArktoxApp extends StatelessWidget {
  const ArktoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Preferences.getDarkmode(),
      builder: (context, themeModeSnapshot) {
        final currentThemeMode = themeModeSnapshot.data ?? ThemeMode.system;

        return MaterialApp(
          title: 'Arktox',
          home: const Homepage(),
          themeMode: currentThemeMode == true ? ThemeMode.dark : ThemeMode.light,
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
  static const String platformKey = 'allPlatforms';
  static const String archivedKey = 'archived';

  static Future<bool> getDarkmode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool darkmodeValue = prefs.getBool(darkmodeKey) ?? true;
    return darkmodeValue;
  }

  static Future<void> setDarkmode(bool darkmodeValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(darkmodeKey, darkmodeValue);
  }

  static Future<bool> getPlatformSetting() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool platformValue = prefs.getBool(platformKey) ?? true;
    return platformValue;
  }

  static Future<void> setPlatformSetting(bool platformValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(platformKey, platformValue);
  }

  static Future<bool> getArchivedSetting() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool archivedValue = prefs.getBool(archivedKey) ?? true;
    return archivedValue;
  }

  static Future<void> setArchivedSetting(bool archivedValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(archivedKey, archivedValue);
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int currentPageIndex = 0;

  bool selectedPlatformValue = true;
  bool selectedArchivedValue = true;
  bool selectedDarkmodeValue = true;

  @override
    void initState() {
    super.initState();
    Preferences.getPlatformSetting().then((platformValue) {
      setState(() {
        selectedPlatformValue = platformValue;
      });
    });
    Preferences.getArchivedSetting().then((archivedValue) {
      setState(() {
        selectedArchivedValue = archivedValue;
      });
    });
    Preferences.getDarkmode().then((darkmodeValue) {
      setState(() {
        selectedDarkmodeValue = darkmodeValue;
      });
    });
  }

    void toggleSwitchPlatform() {
    setState(() {
      selectedPlatformValue = !selectedPlatformValue;
      Preferences.setPlatformSetting(selectedPlatformValue);
    });
  }

  void toggleSwitchArchived() {
    setState(() {
      selectedArchivedValue = !selectedArchivedValue;
      Preferences.setArchivedSetting(selectedArchivedValue);
    });
  }

  void toggleSwitchDarkmode() {
    setState(() {
      selectedDarkmodeValue = !selectedDarkmodeValue;
      Preferences.setDarkmode(selectedDarkmodeValue);
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
              Text('Allgemeine Einstellungen', style: TextStyle(fontSize: 25)),
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
              title: const Text('Aktiviere alle Plattformen'),
              subtitle: const Text(
                  'Wenn deaktiviert, siehst du nur noch Inhalte für deine aktuelle Plattform'),
              trailing: Switch(
                value: selectedPlatformValue,
                onChanged: (value) {
                  toggleSwitchPlatform();
                },
              ),
              onTap: () {
                toggleSwitchPlatform();
              },
            )),
            Card(
                child: ListTile(
              title: const Text('Verstecke Archivierte Einträge'),
              subtitle:
                  const Text('Wenn deaktiviert, siehst du Archivierte Einträge'),
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

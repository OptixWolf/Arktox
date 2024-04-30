import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const ArktoxApp());

class ArktoxApp extends StatelessWidget {
  const ArktoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThemeMode>(
      future: Preferences.getThemeMode(),
      builder: (context, themeModeSnapshot) {
        final currentThemeMode = themeModeSnapshot.data ?? ThemeMode.system;

        return MaterialApp(
          title: 'Arktox',
          home: const Homepage(),
          themeMode: currentThemeMode,
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
  static const String themeModeKey = 'themeMode';
  static const String platformKey = 'allPlatforms';
  static const String archivedKey = 'archived';

  static Future<ThemeMode> getThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int themeModeValue = prefs.getInt(themeModeKey) ?? 0;
    return ThemeMode.values[themeModeValue];
  }

  static Future<void> setThemeMode(ThemeMode themeMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeModeKey, themeMode.index);
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

  @override
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
        Container(),
      ][currentPageIndex],
    );
  }
}

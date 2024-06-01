USE arktox;

INSERT INTO nutzerdaten(email, created_at, last_seen) VALUES('62619140+OptixWolf@users.noreply.github.com', CURRENT_DATE(), CURRENT_TIMESTAMP());
INSERT INTO nutzerdaten(created_at, last_seen) VALUES(CURRENT_DATE(), CURRENT_TIMESTAMP());
INSERT INTO nutzerdaten(created_at, last_seen) VALUES(CURRENT_DATE(), CURRENT_TIMESTAMP());
INSERT INTO nutzerdaten(created_at, last_seen) VALUES(CURRENT_DATE(), CURRENT_TIMESTAMP());
INSERT INTO nutzerdaten(created_at, last_seen) VALUES(CURRENT_DATE(), CURRENT_TIMESTAMP());

INSERT INTO profil(user_id, username) VALUES(1, 'OptixWolf');
INSERT INTO profil(user_id, username) VALUES(2, 'Akira');
INSERT INTO profil(user_id, username) VALUES(3, 'Nikhil');
INSERT INTO profil(user_id, username) VALUES(4, 'Tatsumakey');
INSERT INTO profil(user_id, username) VALUES(5, 'beweisstuck');

INSERT INTO kategorien_archiv(kategorie) VALUES('Modifizierung');
INSERT INTO kategorien_archiv(kategorie) VALUES('Nützliches');
INSERT INTO kategorien_archiv(kategorie) VALUES('Personalisierung');
INSERT INTO kategorien_archiv(kategorie) VALUES('Selfhosting');

INSERT INTO kategorien_skripte(kategorie) VALUES('Installationen');

INSERT INTO plattform_archiv(plattform) VALUES('Android');
INSERT INTO plattform_archiv(plattform) VALUES('Android-LSPosed');
INSERT INTO plattform_archiv(plattform) VALUES('Android-Magisk');
INSERT INTO plattform_archiv(plattform) VALUES('Android-Recovery');
INSERT INTO plattform_archiv(plattform) VALUES('Browser');
INSERT INTO plattform_archiv(plattform) VALUES('Linux');
INSERT INTO plattform_archiv(plattform) VALUES('Universell');
INSERT INTO plattform_archiv(plattform) VALUES('Windows');
INSERT INTO plattform_archiv(plattform) VALUES('Linux (Gnome)');
INSERT INTO plattform_archiv(plattform) VALUES('Linux (KDE)');

INSERT INTO plattform_skripte(plattform) VALUES('Linux');

INSERT INTO archiv_eintraege (profile_id, approval_status, title, description, link, link_title, link2, link2_title, link3, link3_title, project_author, project_author_link, kategorie_id, plattform_id, command, hint, created_at) VALUES
(2, 1, 'Seal', 'Mit Seal kann man Videos und Audios ohne die App zu verlassen downloaden. Hat ebenfalls keine Ads oder ähnliches. Unterstützt Apps wie YouTube, Reddit, usw. Hierbei muss man nur auf \"Teilen\" beim Video gehen und auf \"Seal Schnelles Herunterladen\" klicken. Dies kann man aber auch mit der URL direkt in der App machen.', 'https://github.com/JunkFood02/Seal', 'Download', NULL, NULL, NULL, NULL, 'JunkFood02', 'https://github.com/JunkFood02', 2, 1, NULL, NULL, '2024-05-01'),
(1, 1, 'Nextcloud', 'Open-Source Software für Cloud und mehr.', 'https://nextcloud.com/', 'Download', NULL, NULL, NULL, NULL, 'Nextcloud GmbH', 'https://github.com/nextcloud', 4, 7, NULL, NULL, '2024-05-01'),
(1, 1, 'teams-for-linux', 'Besserer Microsoft Teams Client aus der Community.', 'https://github.com/IsmaelMartinez/teams-for-linux', 'Download', NULL, NULL, NULL, NULL, 'Ismael Martinez', 'https://github.com/IsmaelMartinez/', 2, 6, NULL, NULL, '2024-05-01'),
(1, 1, 'KeePassXC', 'Lokaler Open-Source Passwort Manager.', 'https://keepassxc.org/', 'Download', NULL, NULL, NULL, NULL, 'KeePassXC Team', 'https://github.com/keepassxreboot', 2, 7, NULL, NULL, '2024-05-01'),
(1, 1, 'xManager (Spotify)', 'xManager ist eine Spotify Modifikation die Premium Features ermöglicht.', 'https://github.com/xManager-App/xManager/releases', 'Download', NULL, NULL, NULL, NULL, 'Team-xManager', 'https://github.com/Team-xManager', 2, 1, NULL, 'Leider funktionieren keine Downloads.', '2024-05-01'),
(1, 1, 'ThisIsWin11', 'Viele nützliche Tools und Customisation für Windows 11.', 'https://github.com/builtbybel/ThisIsWin11', 'Download', NULL, NULL, NULL, NULL, 'builtbybel', 'https://github.com/builtbybel', 2, 8, NULL, NULL, '2024-05-01'),
(1, 1, 'Magisk', 'The Magic Mask for Android.', 'https://github.com/topjohnwu/Magisk', 'Download', NULL, NULL, NULL, NULL, 'topjohnwu', 'https://github.com/topjohnwu', 1, 3, NULL, NULL, '2024-05-01'),
(1, 1, 'Shizuku', 'Macht die nutzung von ADB ohne PC möglich.', 'https://play.google.com/store/apps/details?id=moe.shizuku.privileged.api', 'Download', 'https://github.com/RikkaApps/Shizuku', 'Github Projekt', NULL, NULL, 'RikkaApps', 'https://github.com/RikkaApps', 2, 1, NULL, NULL, '2024-05-01'),
(1, 1, 'SpotX (Spotify)', 'SpotX ist eine Spotify Modifikation die Premium Features ermöglicht.', 'https://github.com/SpotX-Official/SpotX-Bash', 'Download', NULL, NULL, NULL, NULL, 'SpotX-Official', 'https://github.com/SpotX-Official/', 2, 6, NULL, NULL, '2024-05-01'),
(1, 1, 'SD Maid 1 - Systemreiniger', 'Ein Systemreiniger mit nützliche Funktionen wie z.B. Bildduplikate finden und löschen.', 'https://play.google.com/store/apps/details?id=eu.thedarken.sdm', 'Download', 'https://github.com/d4rken-org/sdmaid', 'Github Projekt', NULL, NULL, 'd4rken-org', 'https://github.com/d4rken-org', 2, 1, NULL, 'Es gibt eine neue App für neuere Android Versionen.', '2024-05-01'),
(1, 1, 'De-Bloater', 'Ermöglicht das entfernen von Systemapps.', 'https://github.com/sunilpaulmathew/De-Bloater', 'Download', NULL, NULL, NULL, NULL, 'sunilpaulmathew', 'https://github.com/sunilpaulmathew', 2, 3, NULL, NULL, '2024-05-01'),
(1, 1, 'Wallpaper Engine for Kde', 'Ermöglicht die verwendung von Wallpaper Engine in KDE Plasma.', 'https://github.com/catsout/wallpaper-engine-kde-plugin', 'Download', NULL, NULL, NULL, NULL, 'catsout', 'https://github.com/catsout', 3, 10, NULL, NULL, '2024-05-01'),
(3, 1, 'Brezzy Weather', 'Ist eine Wetter-App, die ein schickes Design mitbringt und es ermöglicht, auf mehreren Wetter Quellen zuzugreifen.', 'https://github.com/breezy-weather/breezy-weather/releases', 'Download', NULL, NULL, NULL, NULL, 'Breezy Weather', 'https://github.com/breezy-weather/', 2, 1, NULL, NULL, '2024-05-01'),
(1, 1, 'PowerToys', 'Microsoft eigene Tools für Windows.', 'https://github.com/microsoft/PowerToys', 'Download', NULL, NULL, NULL, NULL, 'Microsoft', 'https://github.com/microsoft/', 2, 8, NULL, NULL, '2024-05-01'),
(1, 1, 'P3X OneNote', 'Eine OneNote Anwendung basierend auf Electron.', 'https://github.com/patrikx3/onenote', 'Download', NULL, NULL, NULL, NULL, 'patrikx3', 'https://patrikx3.com/en/front/about-me', 2, 6, NULL, NULL, '2024-05-01'),
(1, 1, 'SpotX (Spotify)', 'SpotX ist eine Spotify Modifikation die Premium Features ermöglicht.', 'https://github.com/amd64fox/SpotX', 'Download', NULL, NULL, NULL, NULL, 'SpotX-Official', 'https://github.com/SpotX-Official/', 2, 8, NULL, NULL, '2024-05-01'),
(1, 1, 'RPM-Outpost Discord', 'Ein RPM Paket für Fedora.', 'https://github.com/RPM-Outpost/discord', 'Download', NULL, NULL, NULL, NULL, 'RPM-Outpost', 'https://github.com/RPM-Outpost', 2, 6, NULL, 'Nur für Fedora-basierte Distributionen.', '2024-05-01'),
(1, 1, 'Chaotic AUR', 'Repository mit erstellten Pakten für archlinux.', 'https://aur.chaotic.cx/', 'Download', NULL, NULL, NULL, NULL, 'Chaotic-AUR', 'https://github.com/chaotic-aur', 2, 6, NULL, 'Nur für archlinux-basierte Distributionen.', '2024-05-01'),
(1, 1, 'ReVanced Manager', 'Mit ReVanced Manager kannst du ReVanced mit ausgewählten Patches erstellen lassen.\nDu kannst selbst bestimmen was in der App Modifiziert werden soll und was nicht.', 'https://github.com/revanced/revanced-manager', 'Download', NULL, NULL, NULL, NULL, 'ReVanced', 'https://github.com/revanced/', 2, 1, NULL, 'Hat aktuell für die erstellte App keine Auto Updates.', '2024-05-01'),
(1, 1, 'Lutris', 'Installiere (Windows) Spiele unter Linux (mit Wine und Emulatoren.)', 'https://lutris.net/', 'Download', NULL, NULL, NULL, NULL, 'Lutris', 'https://github.com/lutris', 2, 6, NULL, NULL, '2024-05-01'),
(1, 1, 'proton-ge-custom', 'GloriousEggrolls Version von Proton für Steam.', 'https://github.com/GloriousEggroll/proton-ge-custom', 'Download', NULL, NULL, NULL, NULL, 'GloriousEggroll', 'https://github.com/GloriousEggroll/', 2, 6, NULL, NULL, '2024-05-01'),
(1, 1, 'AppImageLauncher', 'Integriere AppImages wie Anwendungen.', 'https://github.com/TheAssassin/AppImageLauncher', 'Download', NULL, NULL, NULL, NULL, 'TheAssassin', 'https://github.com/TheAssassin', 2, 6, NULL, NULL, '2024-05-01'),
(1, 1, 'Bitwarden', 'Open-Source Passwort Manager.', 'https://bitwarden.com/', 'Download', NULL, NULL, NULL, NULL, 'Bitwarden, Inc.', 'https://github.com/bitwarden', 2, 7, NULL, NULL, '2024-05-01'),
(1, 1, 'Easy Effects', 'Audio Effekte für Pipewire.', 'https://github.com/wwmm/easyeffects', 'Download', NULL, NULL, NULL, NULL, 'wwmm', 'https://github.com/wwmm', 2, 6, NULL, 'Nur für Pipewire.', '2024-05-01'),
(1, 1, 'LSPosed Framework', 'Ein Riru / Zygisk Modul, das versucht, ein ART Hooking-Framework bereitzustellen, das konsistente APIs mit OG Xposed liefert und das LSPlant Hooking-Framework nutzt.', 'https://github.com/LSPosed/LSPosed', 'Download', NULL, NULL, NULL, NULL, 'LSPosed', 'https://github.com/LSPosed', 1, 2, NULL, NULL, '2024-05-01'),
(1, 1, 'OpenRGB', 'Hardware RGB Steuerungsprogramm.', 'https://openrgb.org/', 'Download', NULL, NULL, NULL, NULL, 'CalcProgrammer1', 'https://github.com/CalcProgrammer1/', 2, 6, NULL, NULL, '2024-05-01'),
(1, 1, 'Easy Effects Presets', 'Voreingestellte Audio Effekte für EasyEffects.', 'https://github.com/JackHack96/EasyEffects-Presets', 'Download', NULL, NULL, NULL, NULL, 'JackHack96', 'https://github.com/JackHack96/', 2, 6, NULL, NULL, '2024-05-01'),
(1, 1, 'Dark Reader', 'Ändere Seiten die kein Dark/White Mode unterstützen zu Dark/White Mode.', 'https://addons.mozilla.org/de/firefox/addon/darkreader/', 'Firefox-basierte Browser', 'https://chrome.google.com/webstore/detail/dark-reader/eimadpbcbfnmbkopoojfekhnkhdbieeh?hl=de', 'Chrome-basierte Browser', 'https://microsoftedge.microsoft.com/addons/detail/dark-reader/ifoakfbpdcdoeenechcleahebpibofpc', 'Edge-basierte Browser', 'darkreader', 'https://github.com/darkreader', 2, 5, NULL, NULL, '2024-05-01'),
(1, 1, 'Sponsorblock', 'Überspringen bestimmter Inhalte in YouTube', 'https://addons.mozilla.org/de/android/addon/sponsorblock/', 'Firefox-basierte Browser', 'https://chrome.google.com/webstore/detail/sponsorblock-for-youtube/mnjggcdmjocbbbhaepdhchncahnbgone', 'Chrome-basierte Browser', 'https://microsoftedge.microsoft.com/addons/detail/sponsorblock-für-youtube-/mbmgnelfcpoecdepckhlhegpcehmpmji', 'Edge-basierte Browser', 'ajayyy', 'https://github.com/ajayyy', 2, 5, NULL, NULL, '2024-05-01'),
(1, 1, 'AcrylicMenus', 'Fügt den Acrylic Effekt auf alle Win32 Kontextmenüs hinzu.', 'https://github.com/krlvm/AcrylicMenus', 'Download', NULL, NULL, NULL, NULL, 'krlvm', 'https://github.com/krlvm', 3, 8, NULL, NULL, '2024-05-01'),
(1, 1, 'Iris Monet (Substratum)', 'Ein Substratum Design.', 'https://play.google.com/store/apps/details?id=arz.substratum.iris.monet', 'Download', NULL, NULL, NULL, NULL, 'Arzjo Design', 'https://play.google.com/store/apps/dev?id=5509040561085650680', 3, 1, NULL, 'Substratum oder Substratum Lite wird benötigt!', '2024-05-01'),
(1, 1, 'Niagara Launcher', 'Moderner und Cleaner Launcher für Android.', 'https://play.google.com/store/apps/details?id=bitpit.launcher', 'Download', NULL, NULL, NULL, NULL, 'Peter Huber', 'https://play.google.com/store/apps/developer?id=Peter+Huber', 3, 1, NULL, NULL, '2024-05-01'),
(1, 1, 'Return YouTube Dislike', 'Holt die Dislikes von YouTube zurück', 'https://addons.mozilla.org/de/firefox/addon/return-youtube-dislikes/', 'Firefox-basierte Browser', 'https://chrome.google.com/webstore/detail/return-youtube-dislike/gebbhagfogifgggkldgodflihgfeippi', 'Chrome-/Edge-basierte Browser', NULL, NULL, 'Anarios', 'https://github.com/Anarios', 2, 5, NULL, NULL, '2024-05-01'),
(1, 1, 'AFWall+ (Android Firewall +)', 'Eine Firewall für Android.', 'https://play.google.com/store/apps/details?id=dev.ukanth.ufirewall', 'Download', 'https://github.com/ukanth/afwall', 'Github Projekt', NULL, NULL, 'portgenix', 'https://portgenix.com/', 2, 3, NULL, NULL, '2024-05-01'),
(1, 1, 'Distro Grub Themes', 'Grub Designs bestehend aus Linux Distributionen und Hardware Firmen.', 'https://github.com/AdisonCavani/distro-grub-themes', 'Download', NULL, NULL, NULL, NULL, 'AdisonCavani', 'https://github.com/AdisonCavani', 3, 6, NULL, NULL, '2024-05-01'),
(1, 1, 'Papirus Icon Theme', 'Ein Linux Icon Theme', 'https://github.com/PapirusDevelopmentTeam/papirus-icon-theme', 'Download', NULL, NULL, NULL, NULL, 'PapirusDevelopmentTeam', 'https://github.com/PapirusDevelopmentTeam', 3, 6, NULL, NULL, '2024-05-01'),
(1, 1, 'Tela Icon Theme', 'Ein Linux Icon Theme', 'https://github.com/vinceliuice/tela-icon-theme', 'Download (Normale Icons)', 'https://github.com/vinceliuice/Tela-circle-icon-theme', 'Download (Kreis Icons)', NULL, NULL, 'vinceliuice', 'https://github.com/vinceliuice', 3, 6, NULL, NULL, '2024-05-01'),
(1, 1, 'Qogir Icon Theme', 'Ein Linux Icon Theme', 'https://github.com/vinceliuice/Qogir-icon-theme', 'Download', NULL, NULL, NULL, NULL, 'vinceliuice', 'https://github.com/vinceliuice', 3, 6, NULL, NULL, '2024-05-01'),
(1, 1, 'Altes Kontext Menü (Rechtsklick Menü)', 'Dieser Befehl ändert einen Wert in der Registry, um das alte Context Menü zu aktivieren.', NULL, NULL, NULL, NULL, NULL, NULL, 'Microsoft', 'https://www.microsoft.com/de-de/software-download/', 3, 8, 'reg.exe add \"HKCU\\Software\\Classes\\CLSID\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\\InprocServer32\" /f /ve', NULL, '2024-05-01'),
(1, 1, 'Komorebi (Fork)', 'Live Wallpaper Programm', 'https://github.com/Komorebi-Fork/komorebi', 'Download', NULL, NULL, NULL, NULL, 'Komorebi-Fork', 'https://github.com/Komorebi-Fork', 3, 6, NULL, NULL, '2024-05-01'),
(1, 1, 'Breeze-Cursor-for-Windows', 'Schöner Linux Cursor für Windows.', 'https://github.com/black7375/Breeze-Cursors-for-Windows', 'Download', NULL, NULL, NULL, NULL, 'black7375', 'https://github.com/black7375', 3, 8, NULL, NULL, '2024-05-01'),
(1, 1, 'Reversal Icon Theme', 'Ein Linux Icon/Cursor Theme', 'https://github.com/yeyushengfan258/Reversal-icon-theme', 'Download', NULL, NULL, NULL, NULL, 'yeyushengfan258', 'https://github.com/yeyushengfan258', 3, 6, NULL, NULL, '2024-05-01'),
(1, 1, 'Hidamari', 'Live Wallpaper Programm', 'https://github.com/jeffshee/hidamari', 'Download', NULL, NULL, NULL, NULL, 'jeffshee', 'https://github.com/jeffshee', 3, 6, NULL, NULL, '2024-05-01'),
(1, 1, 'Smart Launcher 6', 'Ein Launcher für Android.', 'https://play.google.com/store/apps/details?id=ginlemon.flowerfree&hl=en&gl=US&pli=1', 'Download', NULL, NULL, NULL, NULL, 'Smart Launcher Team', 'https://www.smartlauncher.net/about', 3, 1, NULL, NULL, '2024-05-01'),
(1, 1, 'RoundedTB', 'Ein Programm um die Taskleiste von Windows anzupassen.', 'https://www.microsoft.com/store/productId/9MTFTXSJ9M7F', 'Download', NULL, NULL, NULL, NULL, 'RoundedTB', 'https://github.com/RoundedTB', 3, 8, NULL, 'Projekt wird nicht länger entwickelt.', '2024-05-01'),
(1, 1, 'Hyperion', 'Ein Launcher für Android.', 'https://play.google.com/store/apps/details?id=projekt.launcher', 'Download', NULL, NULL, NULL, NULL, 'prjkt.io', 'https://prjkt.io/#the-team', 3, 1, NULL, NULL, '2024-05-01'),
(1, 1, 'Lawnchair', 'Ein Launcher für Android.', 'https://github.com/LawnchairLauncher/lawnchair', 'Download', NULL, NULL, NULL, NULL, 'LawnchairLauncher', 'https://github.com/LawnchairLauncher', 3, 1, NULL, NULL, '2024-05-01'),
(1, 1, 'substratum lite theme engine', 'Die wichtigsten Funktionen von Substratum in einer App.', 'https://play.google.com/store/apps/details?id=projekt.substratum.lite', 'Download', NULL, NULL, NULL, NULL, 'prjkt.io', 'https://prjkt.io/#the-team', 3, 1, NULL, NULL, '2024-05-01'),
(1, 1, 'rEFInd theme Regular', 'Minimalistisches Design für den Refind Bootloader.', 'https://github.com/bobafetthotmail/refind-theme-regular', 'Download', NULL, NULL, NULL, NULL, 'bobafetthotmail', 'https://github.com/bobafetthotmail', 3, 6, NULL, NULL, '2024-05-01'),
(1, 1, 'Orchis GTK Theme', 'Ein GTK Theme', 'https://github.com/vinceliuice/Orchis-theme', 'Download', NULL, NULL, NULL, NULL, 'vinceliuice', 'https://github.com/vinceliuice', 3, 9, NULL, NULL, '2024-05-01'),
(1, 1, 'FireFDS Kit (Android 09)', 'Ein LSPosed Modul mit vielen Customizations für gerootete Samsung Geräte.\nEs könnte zu Fehlern/Abstürzen/Bootloops kommen, aber es läuft ziemlich stabil.', 'https://github.com/Xposed-Modules-Repo/sb.firefds.pie.firefdskit', 'Download', NULL, NULL, NULL, NULL, 'Firefds', 'https://github.com/Firefds/', 1, 2, NULL, 'Nur für Samsung Geräte und LSPosed!\n\n* Your warranty is now void.\n* Im not responsible for bricked devices, dead SD cards,\n* Please do some research if you have any concerns about features included in this recovery\n* before flashing it! YOU are choosing to make these modifications, and if\n* you point the finger at me for messing up your device, i will laugh at you.', '2024-05-01'),
(1, 1, 'MagiskHidePropsConf', 'Ein Magisk Modul um die Werte der Build.prop zu ändern,\ndamit wird z.B. SafetyNet auf unzertifizierten oder custom ROMs gefixt.', 'https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf', 'Download', NULL, NULL, NULL, NULL, 'Didgeridoohan', 'https://github.com/Didgeridoohan', 1, 3, NULL, 'Magisk wird benötigt!\nModul wird nicht länger entwickelt.\n\n* Your warranty is now void.\n* Im not responsible for bricked devices, dead SD cards,\n* Please do some research if you have any concerns about features included in this recovery\n* before flashing it! YOU are choosing to make these modifications, and if\n* you point the finger at me for messing up your device, i will laugh at you.', '2024-05-01'),
(1, 1, 'OpenGApps (Bis Android 11)', 'Google Apps für Custom Roms', 'https://opengapps.org/', 'Download', NULL, NULL, NULL, NULL, 'The Open GApps Team', 'https://github.com/orgs/opengapps/people', 1, 1, NULL, '* Your warranty is now void.\n* Im not responsible for bricked devices, dead SD cards,\n* Please do some research if you have any concerns about features included in this recovery\n* before flashing it! YOU are choosing to make these modifications, and if\n* you point the finger at me for messing up your device, i will laugh at you.', '2024-05-01'),
(1, 1, 'ChonDoe Flasher', 'Flasht System Image, Vendor Image und mehr für Samsung Geräten mit Dynamischen Partitionen.', 'https://androidfilehost.com/?fid=17248734326145717662', 'Download', NULL, NULL, NULL, NULL, 'AndroidHowTo', 'https://www.youtube.com/@AndroidHowTo2', 1, 1, NULL, '* Your warranty is now void.\n* Im not responsible for bricked devices, dead SD cards,\n* Please do some research if you have any concerns about features included in this recovery\n* before flashing it! YOU are choosing to make these modifications, and if\n* you point the finger at me for messing up your device, i will laugh at you.', '2024-05-01'),
(1, 1, 'Graphite GTK Theme', 'Ein GTK Theme', 'https://github.com/vinceliuice/Graphite-gtk-theme', 'Download', NULL, NULL, NULL, NULL, 'vinceliuice', 'https://github.com/vinceliuice', 3, 9, NULL, NULL, '2024-05-01'),
(1, 1, 'Hanabi (Gnome Shell)', 'Live Wallpaper Programm', 'https://github.com/jeffshee/gnome-ext-hanabi', 'Download', NULL, NULL, NULL, NULL, 'jeffshee', 'https://github.com/jeffshee', 3, 9, NULL, NULL, '2024-05-01'),
(1, 1, 'Patch Recovery - Fastbootd Patcher', 'Patcht Fastbootd ins Samsung Recovery um Fastboot zu verwenden.', 'https://github.com/Johx22/Patch-Recovery', 'Download', NULL, NULL, NULL, NULL, 'Johx22', 'https://github.com/Johx22', 1, 4, NULL, 'Nur für Samsung Geräte!\n\n* Your warranty is now void.\n* Im not responsible for bricked devices, dead SD cards,\n* Please do some research if you have any concerns about features included in this recovery\n* before flashing it! YOU are choosing to make these modifications, and if\n* you point the finger at me for messing up your device, i will laugh at you.', '2024-05-01'),
(1, 1, 'KnoxPatch', 'Ein LSPosed Modul um Knox wieder zu nutzen bei einem gerootetem Gerät.', 'https://github.com/BlackMesa123/KnoxPatch', 'Download', NULL, NULL, NULL, NULL, 'BlackMesa123', 'https://github.com/BlackMesa123', 1, 2, NULL, 'Nur für Samsung Geräte und LSPosed!\n\n* Your warranty is now void.\n* Im not responsible for bricked devices, dead SD cards,\n* Please do some research if you have any concerns about features included in this recovery\n* before flashing it! YOU are choosing to make these modifications, and if\n* you point the finger at me for messing up your device, i will laugh at you.', '2024-05-01'),
(1, 1, 'Lightly', 'Ein moderner Stil für qt Anwendungen.', 'https://github.com/Luwx/Lightly', 'Download', NULL, NULL, NULL, NULL, 'Luwx', 'https://github.com/Luwx', 3, 10, NULL, NULL, '2024-05-01'),
(1, 1, 'Qogir GTK Theme', 'Ein GTK Theme', 'https://github.com/vinceliuice/Qogir-theme', 'Download', NULL, NULL, NULL, NULL, 'vinceliuice', 'https://github.com/vinceliuice', 3, 9, NULL, NULL, '2024-05-01'),
(1, 1, 'adw-gtk3 Theme', 'Adwaita Design für ältere Anwendungen.', 'https://github.com/lassekongo83/adw-gtk3', 'Download', NULL, NULL, NULL, NULL, 'lassekongo83', 'https://github.com/lassekongo83', 3, 9, NULL, NULL, '2024-05-01'),
(1, 1, 'uBlock Origin', 'Adblocker', 'https://addons.mozilla.org/de/firefox/addon/ublock-origin/', 'Firefox-basierte Browser', 'https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm?hl=de', 'Chrome-basierte Browser', 'https://microsoftedge.microsoft.com/addons/detail/ublock-origin/odfafepnkmbhccpbejgmiehpchacaeak', 'Edge-basierte Browser', 'gorhill', 'https://github.com/gorhill', 2, 5, NULL, NULL, '2024-05-01'),
(1, 1, 'FireFDS Kit (Android 13)', 'Ein LSPosed Modul mit vielen Customizations für gerootete Samsung Geräte.\nEs könnte zu Fehlern/Abstürzen/Bootloops kommen, aber es läuft ziemlich stabil.', 'https://github.com/Xposed-Modules-Repo/sb.firefds.t.firefdskit', 'Download', NULL, NULL, NULL, NULL, 'Firefds', 'https://github.com/Firefds/', 1, 2, NULL, 'Nur für Samsung Geräte und LSPosed!\n\n* Your warranty is now void.\n* Im not responsible for bricked devices, dead SD cards,\n* Please do some research if you have any concerns about features included in this recovery\n* before flashing it! YOU are choosing to make these modifications, and if\n* you point the finger at me for messing up your device, i will laugh at you.', '2024-05-01'),
(1, 1, '[Archiviert] SafetyNet Fix (Mod)', 'Ein Magisk Modul um Googles SafetyNet Checks zu bestehen', 'https://github.com/Displax/safetynet-fix', 'Download', NULL, NULL, NULL, NULL, 'Displax', 'https://github.com/Displax', 1, 3, NULL, 'Magisk wird benötigt!\r\nFalls das nicht funktioniert, probiere PlayIntegrityFix aus.\r\n\r\n* Your warranty is now void.\r\n* Im not responsible for bricked devices, dead SD cards,\r\n* Please do some research if you have any concerns about features included in this recovery\r\n* before flashing it! YOU are choosing to make these modifications, and if\r\n* you point the finger at me for messing up your device, i will laugh at you.', '2024-05-01'),
(1, 1, 'NikGApps (Android 10 bis 13)', 'Google Apps für Custom Roms', 'https://nikgapps.com/', 'Download', NULL, NULL, NULL, NULL, 'NikGapps', 'https://nikgapps.com/team', 1, 1, NULL, '* Your warranty is now void.\n* Im not responsible for bricked devices, dead SD cards,\n* Please do some research if you have any concerns about features included in this recovery\n* before flashing it! YOU are choosing to make these modifications, and if\n* you point the finger at me for messing up your device, i will laugh at you.', '2024-05-01'),
(1, 1, 'FireFDS Kit (Android 10)', 'Ein LSPosed Modul mit vielen Customizations für gerootete Samsung Geräte.\nEs könnte zu Fehlern/Abstürzen/Bootloops kommen, aber es läuft ziemlich stabil.', 'https://github.com/Xposed-Modules-Repo/sb.firefds.q.firefdskit', 'Download', NULL, NULL, NULL, NULL, 'Firefds', 'https://github.com/Firefds/', 1, 2, NULL, 'Nur für Samsung Geräte und LSPosed!\n\n* Your warranty is now void.\n* Im not responsible for bricked devices, dead SD cards,\n* Please do some research if you have any concerns about features included in this recovery\n* before flashing it! YOU are choosing to make these modifications, and if\n* you point the finger at me for messing up your device, i will laugh at you.', '2024-05-01'),
(1, 1, 'Adwaita for Steam', 'Ein Steam Skin (Windows/Linux) mit dem Adwaita Design.\nEs gibt aber noch andere Designs in dem Projekt.', 'https://github.com/tkashkin/Adwaita-for-Steam', 'Download', NULL, NULL, NULL, NULL, 'tkashkin', 'https://github.com/tkashkin/', 3, 7, NULL, NULL, '2024-05-01'),
(1, 1, '[Archiviert] SafetyNet Fix', 'Ein Magisk Modul um Googles SafetyNet Checks zu bestehen', 'https://github.com/kdrag0n/safetynet-fix', 'Download', NULL, NULL, NULL, NULL, 'kdrag0n', 'https://github.com/kdrag0n', 1, 3, NULL, 'Magisk wird benötigt!\nFalls das nicht funktioniert, probiere PlayIntegrityFix aus.\n\n* Your warranty is now void.\n* Im not responsible for bricked devices, dead SD cards,\n* Please do some research if you have any concerns about features included in this recovery\n* before flashing it! YOU are choosing to make these modifications, and if\n* you point the finger at me for messing up your device, i will laugh at you.', '2024-05-01'),
(4, 1, 'Fordere Anmeldedaten/Passwort bei Administrationsaufforderung', 'Dieser Befehl ändert einen Wert in der Registry, um Anmeldedaten/Passwort bei einer Administrationsaufforderung anzufordern.', NULL, NULL, NULL, NULL, NULL, NULL, 'Microsoft', 'https://www.microsoft.com/de-de/software-download/', 3, 8, 'Set-ItemProperty -Path \"HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System\" -Name \"ConsentPromptBehaviorAdmin\" -Value 1', 'Bedenke, dass du für zukünftige Administrationsaktionen die Zugangsdaten zu einem Administrationskonto benötigst (in der Regel das Benutzerkonto)', '2024-05-01'),
(1, 1, 'FireFDS Kit (Android 11)', 'Ein LSPosed Modul mit vielen Customizations für gerootete Samsung Geräte.\nEs könnte zu Fehlern/Abstürzen/Bootloops kommen, aber es läuft ziemlich stabil.', 'https://github.com/Xposed-Modules-Repo/sb.firefds.r.firefdskit', 'Download', NULL, NULL, NULL, NULL, 'Firefds', 'https://github.com/Firefds/', 1, 2, NULL, 'Nur für Samsung Geräte und LSPosed!\n\n* Your warranty is now void.\n* Im not responsible for bricked devices, dead SD cards,\n* Please do some research if you have any concerns about features included in this recovery\n* before flashing it! YOU are choosing to make these modifications, and if\n* you point the finger at me for messing up your device, I will laugh at you.', '2024-05-01'),
(1, 1, 'SD Maid 2/SE - Systemreiniger', 'Ein Systemreiniger mit nützliche Funktionen wie z.B. Bildduplikate finden und löschen.', 'https://play.google.com/store/apps/details?id=eu.darken.sdmse', 'Download', 'https://github.com/d4rken-org/sdmaid-se', 'Github Projekt', NULL, NULL, 'd4rken-org', 'https://github.com/d4rken-org', 2, 1, NULL, 'Für neuere Android Versionen entwickelt.', '2024-05-01'),
(1, 1, 'SafetyNet Test', 'SafetyNet Test überprüft das Gerät mit SafetyNet-Kompatibilitätstests.', 'https://play.google.com/store/apps/details?id=org.freeandroidtools.safetynettest', 'Download', NULL, NULL, NULL, NULL, 'BITS Apps', 'https://play.google.com/store/apps/dev?id=4721986490394713006', 2, 3, NULL, NULL, '2024-05-01'),
(1, 1, 'User-Agent Switcher', 'Mit dem Plugin könnt ihr Webseiten einen anderen Browser vortäuschen', 'https://addons.mozilla.org/de/firefox/addon/user-agent-string-switcher/', 'Firefox-basierte Browser', 'https://chrome.google.com/webstore/detail/user-agent-switcher-and-m/bhchdcejhohfmigjafbampogmaanbfkg', 'Chrome-basierte Browser', 'https://microsoftedge.microsoft.com/addons/detail/useragent-switcher-and-m/cnjkedgepfdpdbnepgmajmmjdjkjnifa', 'Edge-basierte Browser', 'ray-lothian', 'https://github.com/ray-lothian', 2, 5, NULL, NULL, '2024-05-01'),
(1, 1, 'FireFDS Kit (Android 12)', 'Ein LSPosed Modul mit vielen Customizations für gerootete Samsung Geräte.\nEs könnte zu Fehlern/Abstürzen/Bootloops kommen, aber es läuft ziemlich stabil.', 'https://github.com/Xposed-Modules-Repo/sb.firefds.s.firefdskit', 'Download', NULL, NULL, NULL, NULL, 'Firefds', 'https://github.com/Firefds/', 1, 2, NULL, 'Nur für Samsung Geräte und LSPosed!\n\n* Your warranty is now void.\n* Im not responsible for bricked devices, dead SD cards,\n* Please do some research if you have any concerns about features included in this recovery\n* before flashing it! YOU are choosing to make these modifications, and if\n* you point the finger at me for messing up your device, I will laugh at you.', '2024-05-01'),
(1, 1, 'PlayIntegrityFix', 'Behebt Play Integrity API (und SafetyNet) Urteile. ', 'https://github.com/chiteroman/PlayIntegrityFix', 'Download', NULL, NULL, NULL, NULL, 'chiteroman', 'https://github.com/chiteroman', 1, 3, NULL, NULL, '2024-05-01'),
(1, 1, 'Play Integrity API Checker', 'Diese App zeigt Informationen über die Integrität Ihres Geräts an, wie von den Google Play-Diensten gemeldet. Wenn dies fehlschlägt, kann dies bedeuten, dass Ihr Gerät gerootet oder in gewisser Weise manipuliert ist (z. B. mit einem entsperrten Bootloader).', 'https://play.google.com/store/apps/details?id=gr.nikolasspyr.integritycheck&hl=de&gl=US', 'Download', 'https://github.com/1nikolas/play-integrity-checker-app', 'Github Projekt', NULL, NULL, '1nikolas', 'https://github.com/1nikolas', 2, 3, NULL, NULL, '2024-05-01'),
(1, 1, 'SearXNG', 'SearXNG ist eine Internet-Metasuchmaschine, die Ergebnisse aus verschiedenen Suchdiensten und Datenbanken zusammenfasst. Die Nutzer werden dabei nicht getrackt.', 'https://docs.searxng.org/', 'Download', 'https://github.com/searxng/searxng', 'Github Projekt', NULL, NULL, 'SearXNG', 'https://github.com/searxng', 4, 7, NULL, NULL, '2024-05-01'),
(1, 1, 'Pterodactyl', 'Pterodactyl ist ein Game Server Management Panel. Pterodactyl wurde mit Blick auf die Sicherheit entwickelt und führt alle Spieleserver in isolierten Docker-Containern aus, während es den Endbenutzern eine schöne und intuitive Benutzeroberfläche bietet.', 'https://pterodactyl.io/', 'Download', 'https://github.com/pterodactyl/panel', 'Github Projekt', NULL, NULL, 'Pterodactyl', 'https://pterodactyl.io/project/about.html', 4, 7, NULL, NULL, '2024-05-01');

INSERT INTO skripte(profile_id, approval_status, title, description, script, kategorie_id, plattform_id, created_at) VALUES
(1, 1, 'Archlinux Discord Canary Vencord Update', 'Ein Skript zum aktualisieren von Discord Canary + Vencord', '', 1, 1, '2024-05-01');

INSERT INTO version_history(version, changelog) VALUES
('0.0.1', 'Test'),
('0.1.0', 'Erste veröffentlichung\nKein Changelog verfügbar');

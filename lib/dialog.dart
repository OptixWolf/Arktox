import 'database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TextfieldDialog extends StatefulWidget {
  final int own_profileid;
  final String own_profilbild_link;
  final String own_profilbanner_link;
  final String own_about_me;

  const TextfieldDialog(
      {super.key,
      required this.own_profileid,
      required this.own_profilbild_link,
      required this.own_profilbanner_link,
      required this.own_about_me});

  @override
  State<TextfieldDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<TextfieldDialog> {
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller1.text = widget.own_profilbild_link;
    _controller2.text = widget.own_profilbanner_link;
    _controller3.text = widget.own_about_me;
    return AlertDialog(
      title: const Text('Neue Profileigenschaften'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller1,
            decoration: const InputDecoration(
              hintText: 'Profilbild Link (512 Zeichen)',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controller2,
            decoration: const InputDecoration(
              hintText: 'Profilbanner Link (512 Zeichen)',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controller3,
            decoration: const InputDecoration(
              hintText: 'About me Text (255 Zeichen)',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Abbrechen'),
        ),
        TextButton(
          onPressed: () {
            bool isLink(String text) {
              return Uri.parse(text).isAbsolute;
            }

            final pbil = _controller1.text;
            final pbal = _controller2.text;
            final pabt = _controller3.text;

            if (pbil != "") {
              if (isLink(pbil)) {
                DatabaseService().executeQuery(
                    'UPDATE profil SET profilbild_link = \'$pbil\' WHERE profile_id = ' +
                        widget.own_profileid.toString());
              }
            }

            if (pbal != "") {
              if (isLink(pbal)) {
                DatabaseService().executeQuery(
                    'UPDATE profil SET profilbanner_link = \'$pbal\' WHERE profile_id = ' +
                        widget.own_profileid.toString());
              }
            }

            if (pabt != "") {
              if (pabt.length < 256) {
                DatabaseService().executeQuery(
                    'UPDATE profil SET about_me = \'$pabt\' WHERE profile_id = ' +
                        widget.own_profileid.toString());
              }
            }

            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

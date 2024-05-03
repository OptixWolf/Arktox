import 'package:flutter/material.dart';
import 'package:project_arktox/database.dart';
import 'package:url_launcher/url_launcher.dart';

class TextfieldDialog extends StatefulWidget {
  final int own_profileid;

  const TextfieldDialog({super.key, required this.own_profileid});

  @override
  State<TextfieldDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<TextfieldDialog> {
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Neue Profileigenschaften\n(Max. 255 Zeichen)'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller1,
            decoration: const InputDecoration(
              hintText: 'Profilbild Link',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controller2,
            decoration: const InputDecoration(
              hintText: 'Profilbanner Link',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controller3,
            decoration: const InputDecoration(
              hintText: 'About me Text',
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

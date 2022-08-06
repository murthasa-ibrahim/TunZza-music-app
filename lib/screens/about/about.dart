import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenAbout extends StatelessWidget {
  const ScreenAbout({Key? key}) : super(key: key);
  final TextStyle textStyle =
      const TextStyle(fontSize: 20, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 14, 51, 82),
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 169, 174, 177),
          title: const Text(
            ' About',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          ListTile(
            leading: Text(
              'Name',
              style: textStyle,
            ),
            trailing: Text(
              'TunZza',
              style: textStyle,
            ),
          ),
          ListTile(
            leading: Text(
              'Version',
              style: textStyle,
            ),
            trailing: Text(
              '1.0.0',
              style: textStyle,
            ),
          ),
          ListTile(
            leading: const Text(
              'Send Feedback',
              style: TextStyle(
                color: Colors.teal,
                fontSize: 20,
              ),
            ),
            onTap: () {
              final Uri mail = Uri(
                  scheme: 'mailto',
                  path: 'murthazaibrahim@gmail.com',
                  query: 'subject= feedback about the music app tunzza ');
              launchUrl(mail);
            },
          ),
          const SizedBox(
            height: 40,
          ),
          Opacity(
            opacity: .7,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/play_store_512.png',
                  width: 200,
                  height: 200,
                )),
          ),
          const SizedBox(
            height: 40,
          ),
          Column(
            children: const [
              Text(
                'About',
                style: TextStyle(color: Colors.white24),
              ),
              Text(
                'TunZza Music App developed  by Murthaza',
                style: TextStyle(color: Colors.white24),
              ),
              Text(
                'Contact : murthazaibrahim@gmail.com',
                style: TextStyle(color: Colors.white24),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

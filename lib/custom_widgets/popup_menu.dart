import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music/controllers/favourite_controller.dart';
import 'package:my_music/screens/about/about.dart';
import 'package:my_music/screens/splash/splash.dart';

class PopupMenu extends StatelessWidget {
  const PopupMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (context) => [
              PopupMenuItem(
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => const ScreenAbout())));
                    },
                    child: const Text("About")),
              ),
              PopupMenuItem(
                child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text(
                                    'Do you really want to reset your app'),
                                actions: [
                                  ListTile(
                                    leading: TextButton(
                                      onPressed: (() =>
                                          Navigator.of(context).pop()),
                                      child: const Text('Cancel'),
                                    ),
                                    trailing: TextButton(
                                      onPressed: (() {
                                        Get.find<FavouriteControlller>().dbClear();
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    const ScreenSplash())));
                                      }),
                                      child: const Text('Ok'),
                                    ),
                                  )
                                ],
                              ));
                    },
                    child: const Text(
                      "Rest App",
                    )),
              ),
            ]);
  }
}

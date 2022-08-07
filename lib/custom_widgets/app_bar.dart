import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white.withOpacity(.2)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.keyboard_arrow_down_outlined,
                size: 35,
              ),
              color: Colors.white,
            ),
            const Spacer(),
            const Text(
              'Now Playing',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const Spacer(),
            const SizedBox(
              width: 35,
            )
          ],
        ),
      ),
    );
  }
}

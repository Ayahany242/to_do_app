import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.title,
  }) : super(key: key);

  Function() onPressed;
  IconData icon;
  Widget? title;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 24,
            color: Theme.of(context).primaryColorLight,
          )),
      title: title ?? Container(),
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 0,
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 18,
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }
}

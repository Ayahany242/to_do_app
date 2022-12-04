// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:to_do_task/controllers/theme_provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({
    Key? key,
    required this.payLoad,
  }) : super(key: key);

  final String payLoad;

  @override
  Widget build(BuildContext context) {
    // final ThemesProvider provider = Provider.of<ThemesProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: primaryClr,
            )),
        title: const Text('Title'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Hello, User_Name',
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                Text(
                  'you have a new reminder',
                  style: Provider.of<ProviderLogic>(context).subTitleStyle,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: primaryClr,
                ),
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    listTileMethod(Icons.text_format, 'title'),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'title',
                      style: TextStyle(
                          // color: Colors.grey[100],
                          color: white,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    listTileMethod(Icons.description, 'Description'),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'description',
                      style: TextStyle(
                        // color: Colors.grey[100],
                        color: white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    listTileMethod(Icons.calendar_today_outlined, 'Date'),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Date',
                      style: TextStyle(
                          // color: Colors.grey[100],
                          color: white,
                          fontSize: 20),
                    ),
                  ],
                )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  ListTile listTileMethod(IconData icon, String text) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
      ),
      iconColor: Colors.white,
      title: Text(text,
          style: const TextStyle(
            fontSize: 30,
          )),
      textColor: Colors.white,
    );
  }
}

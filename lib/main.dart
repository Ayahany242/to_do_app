import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:provider/provider.dart';
import '../controllers/theme_provider.dart';
import '../db/db_helper.dart';
import '../views/pages/add_task_page.dart';
import 'views/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) => ProviderLogic()..initialize(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderLogic>(
        builder: (context, themesProvider, child) => GetMaterialApp(
              routes: {
                '/': (context) => const HomePage(),
                AddTaskPage.addTaskPage: (context) => AddTaskPage(),
              },
              theme: themesProvider.light,
              darkTheme: themesProvider.dark,
              themeMode: themesProvider.themeMode,
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              //  home: const HomePage(),
              // home: const NotificationScreen(),
            ));
  }
}

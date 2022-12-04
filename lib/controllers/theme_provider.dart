import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderLogic extends ChangeNotifier {
  bool isDarkMode = false;
  int selectedRemind = 5;
  String selectedRepeat = 'None';
  int selectedColor = 0;
  DateTime selectedDate = DateTime.now();

  String startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();

  void selectReminder(String reminder) {
    selectedRemind = int.parse(reminder);
    notifyListeners();
  }

  void selectRepeat(String repeat) {
    selectedRepeat = repeat;
    notifyListeners();
  }

  void selectColor(int index) {
    selectedColor = index;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  getDateFromUser(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2040),
    );
    if (pickedDate != null)
      selectedDate = pickedDate;
    else
      print('pickedDate is null');
    notifyListeners();
  }

  getTimeFromUser(BuildContext context, {required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(
                const Duration(minutes: 15),
              ),
            ),
    );
    String formattedTime = pickedTime!.format(context);
    if (isStartTime) {
      startTime = formattedTime;
    } else if (!isStartTime) {
      endTime = formattedTime;
    } else {
      print('Time Canceled or something wrong');
    }
    notifyListeners();
  }

  final light = ThemeData.light().copyWith(
    primaryColor: const Color(0xFF4e5ae8),
    backgroundColor: Colors.white,
    // appBarTheme: AppBarTheme(backgroundColor: Colors.white, elevation: 0),
    primaryColorLight: Colors.purple,
  );

  final dark = ThemeData.dark().copyWith(
    primaryColor: const Color(0xFF424242),
    backgroundColor: const Color(0xFF121212),
    primaryColorLight: Colors.white,
  );

  ThemeMode get themeMode {
    if (isDarkMode) return ThemeMode.light;
    return ThemeMode.dark;
  }

  void switchedTheme(bool currentMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme', currentMode);
    isDarkMode = currentMode;
    notifyListeners();
  }

  initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('theme') ?? false;
    notifyListeners();
  }

  TextStyle get subTitleStyle {
    return GoogleFonts.lato(
        textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: isDarkMode ? Colors.black : Colors.white,
    ));
  }

  TextStyle get subheadingStyle {
    return GoogleFonts.lato(
        textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: isDarkMode ? Colors.black : Colors.white,
    ));
  }

  TextStyle get titleStyle {
    return GoogleFonts.lato(
        textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: isDarkMode ? Colors.black : Colors.white,
    ));
  }

  TextStyle get bodyStyle {
    return GoogleFonts.lato(
        textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: isDarkMode ? Colors.black : Colors.white,
    ));
  }

  TextStyle get body2Style {
    return GoogleFonts.lato(
        textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: isDarkMode ? Colors.black : Colors.grey[200],
    ));
  }

  TextStyle get headingStyle {
    return GoogleFonts.lato(
        textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: isDarkMode ? Colors.black : Colors.white,
    ));
  }
}

const Color bluishClr = Color(0xFFD58BDD);
const Color orangeClr = Color(0xFFFFD372);
const Color pinkClr = Color(0xFFFF99D7);
const Color white = Colors.white;
const Color primaryClr = Colors.purple;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

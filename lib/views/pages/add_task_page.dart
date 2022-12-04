import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/task_controller.dart';
import '../../controllers/theme_provider.dart';
import '../../models/task.dart';
import '../../views/widgets/button.dart';
import '../../views/widgets/custom_app_bar.dart';
import '../widgets/input_field.dart';

class AddTaskPage extends StatelessWidget {
  static String addTaskPage = 'add Task Page';

  AddTaskPage({Key? key}) : super(key: key);
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // final DateTime _selectedDate = DateTime.now();
  // final String _startTime =
  //     DateFormat('hh:mm a').format(DateTime.now()).toString();
  // final String _endTime = DateFormat('hh:mm a')
  //     .format(DateTime.now().add(const Duration(minutes: 15)))
  //     .toString();

  // int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  // String _selectedRepeat = 'None';
  final List<String> _repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  // int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    ProviderLogic provider = Provider.of<ProviderLogic>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(
        icon: Icons.arrow_back_ios,
        onPressed: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  'Add Task',
                  style: provider.headingStyle,
                ),
                InputField(
                  title: 'Title',
                  hint: 'enter title',
                  controller: _titleController,
                ),
                InputField(
                  title: 'Note',
                  hint: 'enter note',
                  controller: _noteController,
                ),
                InputField(
                  title: 'Date',
                  hint: DateFormat.yMd().format(provider.selectedDate),
                  widget: IconButton(
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: primaryClr,
                    ),
                    onPressed: () => provider.getDateFromUser(context),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        title: 'Start Time',
                        hint: provider.startTime,
                        widget: IconButton(
                            icon: const Icon(
                              Icons.access_time_outlined,
                              color: primaryClr,
                            ),
                            onPressed: () => provider.getTimeFromUser(context,
                                isStartTime: true)),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: InputField(
                        title: 'End Time',
                        hint: provider.endTime,
                        widget: IconButton(
                          icon: const Icon(
                            Icons.access_time_outlined,
                            color: primaryClr,
                          ),
                          onPressed: () => provider.getTimeFromUser(context,
                              isStartTime: false),
                        ),
                      ),
                    ),
                  ],
                ),
                Builder(builder: (context) {
                  return InputField(
                    title: 'Remind',
                    hint: '${provider.selectedRemind} minutes early',
                    widget: Row(
                      children: [
                        DropdownButton(
                          dropdownColor: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(10),
                          items: remindList
                              .map<DropdownMenuItem<String>>(
                                (int value) => DropdownMenuItem(
                                  value: value.toString(),
                                  child: Text(
                                    '$value',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                              .toList(),
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: primaryClr),
                          elevation: 4,
                          iconSize: 32,
                          style: provider.subTitleStyle,
                          underline: Container(height: 0),
                          onChanged: (String? newVal) =>
                              provider.selectReminder(newVal!),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                      ],
                    ),
                  );
                }),
                Builder(builder: (context) {
                  return InputField(
                    title: 'Repeat',
                    hint: '${provider.selectedRepeat} minutes early',
                    widget: Row(
                      children: [
                        DropdownButton(
                          dropdownColor: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(10),
                          items: _repeatList
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem(
                                  value: value.toString(),
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                              .toList(),
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: primaryClr),
                          elevation: 4,
                          iconSize: 32,
                          style: provider.subTitleStyle,
                          underline: Container(height: 0),
                          onChanged: (String? newVal) =>
                              provider.selectRepeat(newVal!),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colorPalette(context),
                    MyButton(
                        label: 'Create Task',
                        onTap: () {
                          _validateDate(context);
                        })
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _validateDate(BuildContext context) {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb(context);
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(_snackbarMethod());
    } else {
      print('################### SOMETHING BAD HAPPENED ###############');
    }
  }

  SnackBar _snackbarMethod() {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_outlined,
            color: Colors.red,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            'All Field are required',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.red.shade500,
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: const Duration(seconds: 2),
    );
  }

  _addTaskToDb(BuildContext context) async {
    ProviderLogic provider = Provider.of<ProviderLogic>(context, listen: false);
    int value = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(provider.selectedDate),
        startTime: provider.startTime,
        endTime: provider.endTime,
        color: provider.selectedColor,
        remind: provider.selectedRemind,
        repeat: provider.selectedRepeat,
      ),
    );
    print('$value');
  }

  Column _colorPalette(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Colors',
          style: Provider.of<ProviderLogic>(context, listen: false).titleStyle,
        ),
        const SizedBox(
          height: 8.0,
        ),
        Wrap(
          children: List<Widget>.generate(
            3,
            (index) => GestureDetector(
              onTap: () => context.read<ProviderLogic>().selectColor(index),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  backgroundColor: index == 0
                      ? bluishClr
                      : index == 1
                          ? pinkClr
                          : orangeClr,
                  radius: 14,
                  child: context.read<ProviderLogic>().selectedColor == index
                      ? const Icon(
                          Icons.done,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

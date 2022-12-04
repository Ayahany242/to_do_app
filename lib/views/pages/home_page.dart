import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/task_controller.dart';
import '../../controllers/theme_provider.dart';
import '../../models/task.dart';
import '../../services/notification_services.dart';
import '../../views/widgets/button.dart';
import '../../views/widgets/task_tile.dart';
import '../size_config.dart';
import '../widgets/custom_app_bar.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());

  late final NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
    // _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<ProviderLogic>(builder: (context, provider, child) {
      return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: CustomAppBar(
            icon: provider.isDarkMode == true
                ? Icons.nightlight_round_outlined
                : Icons.wb_sunny_outlined,
            onPressed: () {
              provider.switchedTheme(!provider.isDarkMode);
              // notifyHelper.displayNotification(title: 'title', body: 'body');
              // notifyHelper.scheduledNotification();
            },
          ),
          body: Column(children: [
            _addTaskBar(context),
            _addDateBar(context),
            const SizedBox(
              height: 6,
            ),
            _showTasks(context)
          ]));
    });
  }

  Widget _addTaskBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat.yMMMMd().format(DateTime.now()),
                style: context.read<ProviderLogic>().subheadingStyle),
            Text(
              'Today',
              style: context.read<ProviderLogic>().headingStyle,
            )
          ],
        ),
        MyButton(
            label: '+ Add Task',
            onTap: () async {
              await Navigator.of(context).pushNamed(AddTaskPage.addTaskPage);
            }),
      ]),
    );
  }

  _addDateBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 6),
      child: DatePicker(
        //context.read<ThemesProvider>().selectedDate,
        DateTime.now(),
        width: 70,
        height: 100,
        selectedTextColor: Colors.white,
        initialSelectedDate: DateTime.now(),
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        )),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        )),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        )),

        selectionColor: primaryClr,
        onDateChange: (newDate) =>
            context.read<ProviderLogic>().selectDate(newDate),
      ),
    );
  }

  _showTasks(BuildContext context) {
    return Expanded(
      child: Obx(
        () {
          if (_taskController.taskList.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                scrollDirection: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  var selectedDate = context.read<ProviderLogic>().selectedDate;
                  Task task = _taskController.taskList[index];

                  if (task.repeat == 'Daily' ||
                      task.date == DateFormat.yMd().format(selectedDate)) {
                    var date = DateFormat.jm().parse(task.startTime!);
                    var startTime = DateFormat('HH:mm').format(date);

                    notifyHelper.scheduledNotification(
                        int.parse(startTime.toString().split(':')[0]),
                        int.parse(startTime.toString().split(':')[1]),
                        task);
                    return AnimationConfiguration.staggeredList(
                      duration: const Duration(milliseconds: 600),
                      position: index,
                      child: SlideAnimation(
                        horizontalOffset: 300,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () => _showBottomSheet(context, task),
                            child: TaskTile(task),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return _noTaskMsg(context);
                  }
                },
                itemCount: _taskController.taskList.length,
              ),
            );
          } else {
            return _noTaskMsg(context);
          }
        },
      ),
    );
  }

  _noTaskMsg(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            color: primaryClr,
            child: SingleChildScrollView(
              child: Wrap(
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 6,
                        )
                      : const SizedBox(
                          //  height: 220,
                          height: 150,
                        ),
                  SvgPicture.asset(
                    'images/task.svg',
                    height: 90,
                    semanticsLabel: 'Task',
                    color: primaryClr.withOpacity(0.5),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      'You do not have an tasks yet! \nAdd new tasks tp make your days productive',
                      textAlign: TextAlign.center,
                      style: context.read<ProviderLogic>().subTitleStyle,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 120,
                        )
                      : const SizedBox(
                          height: 180,
                        ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  _buildBottomSheet(BuildContext context,
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    TextStyle titleStyle = context.read<ProviderLogic>().titleStyle;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: SizeConfig.screenWidth * 0.15,
        width: SizeConfig.screenWidth * 0.9,
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
            border: Border.all(
                width: 2,
                color: isClose
                    ? context.read<ProviderLogic>().isDarkMode
                        ? Colors.grey[600]!
                        : Colors.grey[300]!
                    : clr),
            borderRadius: BorderRadius.circular(20),
            color: isClose ? Colors.transparent : clr),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    bool isDarkMode = context.read<ProviderLogic>().isDarkMode;
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(top: 4),
            width: SizeConfig.screenWidth,
            height: (SizeConfig.orientation == Orientation.landscape)
                ? (task.isCompleted == 1
                    ? SizeConfig.screenHeight * 0.6
                    : SizeConfig.screenHeight * 0.8)
                : (task.isCompleted == 1
                    ? SizeConfig.screenHeight * 0.30
                    : SizeConfig.screenHeight * 0.39),
            color: isDarkMode ? Colors.white : darkHeaderClr,
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isDarkMode ? Colors.grey[600] : Colors.grey[300]),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        task.isCompleted == 1
                            ? Container()
                            : _buildBottomSheet(context,
                                label: 'Task Completed', onTap: () {
                                _taskController.markTaskCompleted(task.id!);
                                Get.back();
                              }, clr: primaryClr),
                        _buildBottomSheet(context, label: 'Delete Completed',
                            onTap: () {
                          _taskController.deleteTasks(task: task);
                          Get.back();
                        }, clr: Colors.red),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: isDarkMode ? Colors.grey[600] : Colors.white,
                          height: 2,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        _buildBottomSheet(context, label: 'Cancel', onTap: () {
                          Navigator.pop(context);
                        }, clr: primaryClr),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        });
  }

  Future<void> _onRefresh() async {
    _taskController.getTasks();
  }
}

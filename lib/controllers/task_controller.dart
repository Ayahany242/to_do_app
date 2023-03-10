import 'package:to_do_task/db/db_helper.dart';

import '../../models/task.dart';
import 'package:get/get.dart';

class TaskController {
  final RxList<Task> taskList = <Task>[].obs;
  Future<int> addTask({Task? task}) {
    return DBHelper.insert(task);
  }

// to get data from database
  Future<void> getTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks
        .map(
          (data) => Task.fromJson(data),
        )
        .toList());
  }

// to delete data from database
  void deleteTasks({Task? task}) async {
    await DBHelper.delete(task);
    getTasks();
  }

// to update data from database
  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}

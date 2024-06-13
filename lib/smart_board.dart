//
// Copyright 2024 (c) by Chris Romero. All Rights Reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the “Software”), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:smart_planner_demo/project_api.dart';
import 'package:smart_planner_demo/smart_page.dart';
import 'utils.dart';
import 'data.dart';
import 'smart_data_table.dart';
import 'create_activity.dart';
import 'create_worker.dart';

/// The Board where we plan our Project.
/// This Shows all active Workers and its Tasks.
//ignore: must_be_immutable
class SmartBoard extends StatefulWidget {
  SmartBoard({super.key, required this.project});

  Project project;

  @override
  State<SmartBoard> createState() => _SmartBoardState();
}

class _SmartBoardState extends State<SmartBoard> {
  late ScrollController _header;
  late ScrollController _body;
  late ScrollController _horizontal;
  late ScrollController _vertical;
  late LinkedScrollControllerGroup _headerGroup;
  late LinkedScrollControllerGroup _bodyGroup;
  List<String> _unassignedActivities = [];
  List<Worker> _activeWorkers = [];

  @override
  void initState() {
    super.initState();
    _headerGroup = LinkedScrollControllerGroup();
    _bodyGroup = LinkedScrollControllerGroup();
    _header = _headerGroup.addAndGet();
    _horizontal = _headerGroup.addAndGet();
    _body = _bodyGroup.addAndGet();
    _vertical = _bodyGroup.addAndGet();
    _unassignedActivities = widget.project.activities;
    _activeWorkers = widget.project.workers;
  }

  @override
  void dispose() {
    _vertical.dispose();
    _body.dispose();
    _horizontal.dispose();
    _header.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Smart Board")),
        body: SmartPage(builder: Builder(builder: (BuildContext context) {
          return Column(children: [
            Container(
                height: 50,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8),
                color: Colors.indigo,
                child: const Text(
                    "Add a new Task dragging one Activity from the Left List to the Right Board or remove one dragging it from the Board to the Activity list.",
                    style: TextStyle(color: Colors.white))),
            const SizedBox(height: 8),
            Expanded(
                child: Row(children: <Widget>[
              Column(children: [
                Expanded(
                    child: Container(
                        color: Colors.white, child: _buildActivities())),
                Container(
                    width: 300,
                    height: 48,
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: ElevatedButton(
                        onPressed: () => _createActivity(context),
                        child: const Text("New Activity")))
              ]),
              const SizedBox(width: 10),
              Expanded(
                  child: Container(color: Colors.white, child: _buildBody()))
            ]))
          ]);
        })));
  }

  Widget _buildActivities() {
    return DragTarget<Task>(builder:
        (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
      return SmartDataTable(
          columns: const <SmartDataColumn>[
            SmartDataColumn(
                columnWidth: 250,
                child: Text('Activities',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            SmartDataColumn(columnWidth: 50, child: SizedBox())
          ],
          rows: _unassignedActivities
              .map<SmartDataRow>((e) => SmartDataRow(children: <SmartDataCell>[
                    SmartDataCell(
                        cellWidth: 250,
                        child: Draggable<Task>(
                            data: Task(e, TasksStates.notAssigned),
                            feedback: Material(
                                child: SmartCard(
                                    activity:
                                        Task(e, TasksStates.notAssigned))),
                            child: Container(
                                alignment: Alignment.centerLeft,
                                width: 250,
                                height: 48,
                                child: Text(e)),
                            onDragCompleted: () => setState(() {
                                  _unassignedActivities.remove(e);
                                  _updateProject(context);
                                }))),
                    SmartDataCell(
                        cellWidth: 50,
                        child: SizedBox(
                            height: 48,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                conditionalDialogBuilder(context,
                                        "Are you sure you want to delete this Activity: $e?")
                                    .then((value) {
                                  if (value!) {
                                    setState(() {
                                      _unassignedActivities.remove(e);
                                      _updateProject(context);
                                    });
                                  }
                                });
                              },
                            )))
                  ]))
              .toList());
    }, onAcceptWithDetails: (DragTargetDetails<Task> details) {
      setState(() => _unassignedActivities.add(details.data.title));
    });
  }

  Widget _buildBody() {
    return Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Container(
            decoration: const BoxDecoration(
                color: Color(0xF2F2F2FF),
                border: Border(
                    left: BorderSide(color: Colors.grey),
                    top: BorderSide(color: Colors.grey))),
            width: 200,
            height: 32),
        Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _header,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.grey),
                            left: BorderSide(color: Colors.grey),
                            bottom: BorderSide(color: Colors.grey))),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <String>["To Do", "Doing", "Done"]
                            .map<Widget>((e) => Container(
                                width: 250,
                                height: 32,
                                padding: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                    color: const Color(0xF2F2F2FF),
                                    border: Border(
                                        top: BorderSide(
                                            width: 4.0,
                                            color: _getTaskColor(e == "To Do"
                                                ? TasksStates.toDo
                                                : e == "Doing"
                                                    ? TasksStates.doing
                                                    : TasksStates.done)),
                                        right: const BorderSide(
                                            color: Colors.grey))),
                                alignment: Alignment.centerLeft,
                                child: Text(e,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold))))
                            .toList()))))
      ]),
      Expanded(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(children: [
          Expanded(
              child: SingleChildScrollView(
                  controller: _body,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              left: BorderSide(color: Colors.grey),
                              right: BorderSide(color: Colors.grey),
                              top: BorderSide(color: Colors.grey))),
                      child: Column(
                          children: _activeWorkers
                              .map<Widget>((e) => _createWorkerHeader(e))
                              .toList())))),
          Container(
              width: 200,
              height: 48,
              padding: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: ElevatedButton(
                  onPressed: () => _createWorker(context),
                  child: const Text("New Worker")))
        ]),
        Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _horizontal,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: SingleChildScrollView(
                    controller: _vertical,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _activeWorkers
                            .map<Widget>((e) => _createTaskBoard(e))
                            .toList()))))
      ]))
    ]);
  }

  Widget _createWorkerHeader(Worker worker) {
    return Stack(children: [
      Container(
          width: 200,
          height: _getWorkerAreaSize(worker),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: Color(0xF2F2F2FF),
              border: Border(bottom: BorderSide(color: Colors.grey))),
          child: Text(worker.title,
              style: const TextStyle(fontWeight: FontWeight.bold))),
      worker.tasks.isEmpty
          ? IconButton(
              onPressed: () {
                conditionalDialogBuilder(context,
                        "Are you sure you want to delete this Worker: ${worker.title}?")
                    .then((value) {
                  if (value!) {
                    setState(() {
                      _activeWorkers.remove(worker);
                      _updateProject(context);
                    });
                  }
                });
              },
              icon: const Icon(Icons.delete, color: Colors.red))
          : const SizedBox()
    ]);
  }

  Row _createTaskBoard(Worker worker) {
    return Row(
        children: <TasksStates>[
      TasksStates.toDo,
      TasksStates.doing,
      TasksStates.done
    ]
            .map<Widget>((tt) => DragTarget<Task>(builder:
                    (BuildContext context, List<dynamic> accepted,
                        List<dynamic> rejected) {
                  return Container(
                      width: 250,
                      height: _getWorkerAreaSize(worker),
                      decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(color: Colors.grey),
                              bottom: BorderSide(color: Colors.grey))),
                      child: Column(
                          children: worker.tasks
                              .where((element) => element.state == tt)
                              .map<Widget>((d) {
                        return Draggable<Task>(
                            data: d,
                            feedback: Material(child: SmartCard(activity: d)),
                            child: SmartCard(activity: d),
                            onDragCompleted: () {
                              setState(() {
                                worker.tasks.remove(d);
                                _updateProject(context);
                              });
                            });
                      }).toList()));
                }, onAcceptWithDetails: (DragTargetDetails<Task> details) {
                  setState(
                      () => worker.tasks.add(Task(details.data.title, tt)));
                }))
            .toList());
  }

  double _getWorkerAreaSize(Worker worker) {
    double toDoCounter = 0;
    double doingCounter = 0;
    double doneCounter = 0;

    for (Task task in worker.tasks) {
      if (task.state == TasksStates.toDo) toDoCounter += 1;
      if (task.state == TasksStates.doing) doingCounter += 1;
      if (task.state == TasksStates.done) doneCounter += 1;
    }

    double result = toDoCounter;
    if (doingCounter > result) result = doingCounter;
    if (doneCounter > result) result = doneCounter;

    return (result * 48).clamp(192, double.infinity) + 1;
  }

  void _createActivity(BuildContext context) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CreateActivity()))
        .then((value) {
      if (value != null) {
        setState(() {
          _unassignedActivities.add(value);
          _updateProject(context);
        });
      }
    });
  }

  void _createWorker(BuildContext context) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CreateWorker()))
        .then((value) {
      if (value != null) {
        setState(() {
          _activeWorkers.add(value);
          _updateProject(context);
        });
      }
    });
  }

  void _updateProject(BuildContext context) {
    ProjectApi().saveProject(widget.project).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't update this Project")));
      return widget.project;
    });
  }
}

class SmartCard extends StatelessWidget {
  const SmartCard({super.key, required this.activity});

  final Task activity;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 250,
        height: 48,
        decoration: BoxDecoration(
            color: const Color(0xF2F2F2FF),
            border: Border(
                left:
                    BorderSide(color: _getTaskColor(activity.state), width: 4),
                right: const BorderSide(color: Colors.grey),
                top: const BorderSide(color: Colors.grey),
                bottom: const BorderSide(color: Colors.grey))),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(activity.title,
                style: const TextStyle(fontStyle: FontStyle.italic))));
  }
}

Color _getTaskColor(TasksStates state) => state == TasksStates.toDo
    ? Colors.green
    : state == TasksStates.doing
        ? Colors.amber
        : state == TasksStates.done
            ? Colors.lightBlue
            : Colors.grey;

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
import 'package:intl/intl.dart';
import 'smart_page.dart';
import 'utils.dart';
import 'smart_board.dart';
import 'create_project.dart';
import 'smart_data_table.dart';
import 'data.dart';
import 'project_api.dart';

/// Shows the list of all available projects.
class MyProjectsPage extends StatefulWidget {
  const MyProjectsPage({super.key});

  @override
  State<MyProjectsPage> createState() => _MyProjectsPageState();
}

class _MyProjectsPageState extends State<MyProjectsPage> {
  List<Project> _data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("My Projects")),
        body: FutureBuilder<List<Project>>(
            future: ProjectApi().getAllProjects(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Project>> snapshot) {
              if (snapshot.hasData) {
                _data = snapshot.data!;
                return SmartPage(
                    builder: Builder(builder: (BuildContext context) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SmartDataTable(
                          columns: const <SmartDataColumn>[
                            SmartDataColumn(
                                columnWidth: 600,
                                child: Center(
                                    child: Text('Project List',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))))
                          ],
                          rows: _data.map<SmartDataRow>((e) {
                            return SmartDataRow(
                                onTap: () => _showBoard(e.id!),
                                children: <SmartDataCell>[
                                  SmartDataCell(
                                      cellWidth: 600, child: _card(context, e))
                                ]);
                          }).toList(),
                        ),
                        const Expanded(child: SizedBox()),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                  width: 100,
                                  height: 32,
                                  child: ElevatedButton(
                                      onPressed: () => _createProject(),
                                      child: const Text("Create")))
                            ])
                      ]);
                }));
              } else if (snapshot.hasError) {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      const Icon(Icons.warning_rounded),
                      Text(
                          "Couldn't retrieve any data...: ${snapshot.error.toString()}")
                    ]));
              }

              return const Center(child: CircularProgressIndicator());
            }));
  }

  void _createProject() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CreateProject()))
        .then((value) {
      if (value != null) setState(() {});
    }).catchError((error) {
      dialogBuilder(context, "Oops!, an error has occurred: $error");
    });
  }

  void _showBoard(String id) {
    ProjectApi().getProject(id).then((value) => Navigator.push(context,
        MaterialPageRoute(builder: (context) => SmartBoard(project: value))));
  }

  Widget _card(BuildContext context, Project project) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(project.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  conditionalDialogBuilder(context,
                          "Are you sure you want to delete this Project: ${project.title}?")
                      .then((value) {
                    if (value!) {
                      ProjectApi().deleteProject(project).then((value) {
                        setState(() => _data.remove(project));
                      }).catchError((error) {
                        dialogBuilder(
                            context, "Oops!, an error has occurred: $error");
                      });
                    }
                  });
                })
          ]),
          SizedBox(height: 64, child: Text(project.overview)),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(
                "Created by ${project.createdBy} on ${DateFormat.yMMMd().format(project.createdOn)}",
                style: const TextStyle(fontStyle: FontStyle.italic))
          ])
        ]));
  }
}

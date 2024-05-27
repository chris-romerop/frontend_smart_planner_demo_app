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
import 'utils.dart';
import 'smart_page.dart';
import 'data.dart';
import 'project_api.dart';

class CreateProject extends StatefulWidget {
  const CreateProject({super.key});

  @override
  State<CreateProject> createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _overviewController = TextEditingController();
  final TextEditingController _createdByController = TextEditingController();

  @override
  void dispose() {
    _createdByController.dispose();
    _overviewController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("New Project")),
        body: SmartPage(builder: Builder(builder: (BuildContext context) {
          return Column(children: [
            Expanded(
                child: Form(
                    key: _formKey,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text("Project Settings",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 48)),
                                const SizedBox(height: 32),
                                Row(children: <Widget>[
                                  const SizedBox(
                                      width: 100,
                                      child: Text("Title:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                      width: 350,
                                      child: TextFormField(
                                          autofocus: true,
                                          controller: _titleController,
                                          decoration: const InputDecoration(
                                              hintText: "Write a Project Title",
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey))),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Write a Project Title";
                                            }
                                            return null;
                                          }))
                                ]),
                                const SizedBox(height: 10),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(
                                          width: 100,
                                          child: Text("Overview:",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                          height: 128,
                                          width: 350,
                                          child: TextFormField(
                                              autofocus: true,
                                              controller: _overviewController,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              minLines: 5,
                                              maxLines: 5,
                                              decoration: const InputDecoration(
                                                  hintText:
                                                      "Write what do you want to do in this Project",
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey))),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Write an overview";
                                                }
                                                return null;
                                              }))
                                    ]),
                                const SizedBox(height: 10),
                                Row(children: [
                                  const SizedBox(
                                      width: 100,
                                      child: Text("Created By:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  const SizedBox(width: 10.0),
                                  SizedBox(
                                      width: 350,
                                      child: TextFormField(
                                          controller: _createdByController,
                                          decoration: const InputDecoration(
                                              hintText: "Write your Name",
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey))),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Write your Name";
                                            }
                                            return null;
                                          }))
                                ])
                              ])
                        ]))),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              SizedBox(
                  width: 100,
                  height: 32,
                  child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.white)))),
              const SizedBox(width: 10),
              SizedBox(
                  width: 100,
                  height: 32,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Save
                          Project project = Project(
                              null,
                              _titleController.value.text,
                              _overviewController.value.text,
                              _createdByController.value.text,
                              DateTime.now(), [], []);
                          ProjectApi().saveProject(project).then((value) {
                            Navigator.pop(context, value);
                          }).catchError((error) {
                            dialogBuilder(context,
                                "Oops!, an error has occurred: $error");
                          });
                        }
                      },
                      child: const Text("Create")))
            ])
          ]);
        })));
  }
}

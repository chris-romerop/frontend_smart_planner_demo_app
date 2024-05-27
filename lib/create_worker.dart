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
import 'package:smart_planner_demo/smart_page.dart';
import 'data.dart';

class CreateWorker extends StatefulWidget {
  const CreateWorker({super.key});

  @override
  State<CreateWorker> createState() => _CreateWorkerState();
}

class _CreateWorkerState extends State<CreateWorker> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("New Worker")),
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
                                const Text("Worker Details",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 48)),
                                const SizedBox(height: 32),
                                Row(children: <Widget>[
                                  const SizedBox(
                                      width: 100,
                                      child: Text("Title",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                      width: 350,
                                      child: TextFormField(
                                          autofocus: true,
                                          controller: _titleController,
                                          decoration: const InputDecoration(
                                              hintText: "Write a Worker Title",
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey))),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Write a Worker Title";
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
                          Worker worker =
                              Worker(_titleController.value.text, <Task>[]);
                          Navigator.pop(context, worker);
                        }
                      },
                      child: const Text("Create")))
            ])
          ]);
        })));
  }
}

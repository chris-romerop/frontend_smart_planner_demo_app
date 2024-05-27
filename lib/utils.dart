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

const urlApi = "https://dg9wbproce.execute-api.us-east-2.amazonaws.com/smart-planner-demo";

Future<bool?> conditionalDialogBuilder(BuildContext context, String title) {
  return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: const Text("Alert!"),
            content: Text(title),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Ok")),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel"))
            ],
          ));
}

Future<bool?> dialogBuilder(BuildContext context, String title) {
  return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: const Text("Alert!"),
            content: Text(title),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Ok"))
            ],
          ));
}

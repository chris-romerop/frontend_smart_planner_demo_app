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
import 'package:intl/intl.dart';

/// Task States.
enum TasksStates { notAssigned, toDo, doing, done }

/// The Project data structure
class Project {
  final String? id;
  final String title;
  final String overview;
  final String createdBy;
  final DateTime createdOn;
  final List<String> activities;
  final List<Worker> workers;

  Project(this.id, this.title, this.overview, this.createdBy, this.createdOn,
      this.activities, this.workers);

  Project.fromJson(Map<String, dynamic> json)
      : id = json["id"] as String?,
        title = (json["title"] ?? "") as String,
        overview = (json["overview"] ?? "") as String,
        createdBy = (json["createdBy"] ?? "") as String,
        createdOn = DateTime.parse((json["createdOn"] ?? "") as String),
        activities = ((json["activities"] ?? []) as List<dynamic>)
            .map<String>((e) => e)
            .toList(),
        workers = (json["workers"] ?? [])
            .map<Worker>((e) => Worker.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "overview": overview,
        "createdBy": createdBy,
        "createdOn": DateFormat("yyyyMMdd").format(createdOn),
        "activities": activities,
        "workers": workers.map<Map<String, dynamic>>((e) => e.toJson()).toList()
      };
}

/// Worker definition.
class Worker {
  final String title;
  final List<Task> tasks;

  Worker(this.title, this.tasks);

  Worker.fromJson(Map<String, dynamic> json)
      : title = json["title"] as String,
        tasks = (json["tasks"] as List<dynamic>)
            .map<Task>((e) => Task.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() => {
        "title": title,
        "tasks": tasks.map<Map<String, dynamic>>((e) => e.toJson()).toList()
      };
}

/// Task definition.
class Task {
  final String title;
  final TasksStates state;

  Task(this.title, this.state);

  Task.fromJson(Map<String, dynamic> json)
      : title = json["title"] as String,
        state = TasksStates.values[(json["state"] as int)];

  Map<String, dynamic> toJson() =>
      {"title": title, "state": state.index.toString()};
}

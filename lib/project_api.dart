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
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'utils.dart';
import 'data.dart';

class ProjectApi {
  Future<Project> saveProject(Project project) async {
    final response = await http.post(Uri.parse("$urlApi/project"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(project.toJson()));
    if (response.statusCode == 200) {
      return Project.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Failed to create Project");
    }
  }

  Future<Project> getProject(String id) async {
    final response = await http
        .get(Uri.parse("$urlApi/project/$id"));
    if (response.statusCode == 200) {
      return Project.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to get required data");
    }
  }

  Future<bool> deleteProject(Project project) async {
    final response = await http.delete(Uri.parse("$urlApi/project"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(project.toJson()));
    return response.statusCode == 200;
  }

  Future<List<Project>> getAllProjects() async {
    final response = await http.get(Uri.parse("$urlApi/project"));
    if (response.statusCode == 200 || response.statusCode == 204) {
      return response.body.isEmpty
          ? []
          : (jsonDecode(response.body) as List<dynamic>).map((e) {
              return Project.fromJson(e);
            }).toList();
    } else {
      throw Exception("Failed to get required data");
    }
  }
}

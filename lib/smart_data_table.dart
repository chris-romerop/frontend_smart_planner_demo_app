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

/// A custom data column header.
//ignore: must_be_immutable
class SmartDataColumn extends StatelessWidget {
  const SmartDataColumn({super.key, required this.child, this.columnWidth});

  final Widget child;
  final double? columnWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 32.0,
        width: columnWidth ?? 100.0,
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
            color: Color(0xF2F2F2FF),
            border: Border(right: BorderSide(color: Colors.grey))),
        alignment: Alignment.centerLeft,
        child: child);
  }
}

/// A custom data row.
//ignore: must_be_immutable
class SmartDataRow extends StatelessWidget {
  const SmartDataRow({super.key, required this.children, this.onTap});

  final List<SmartDataCell> children;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        splashColor: Colors.white,
        hoverColor: const Color(0xF2F2F2FF),
        child: Container(
            decoration: const BoxDecoration(
                border: Border(
                    left: BorderSide(color: Colors.grey),
                    bottom: BorderSide(color: Colors.grey))),
            child: Row(children: children)));
  }
}

/// A custom data cell.
class SmartDataCell extends StatelessWidget {
  const SmartDataCell({super.key, required this.child, this.cellWidth});

  final Widget child;
  final double? cellWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: cellWidth ?? 100.0,
        padding: const EdgeInsets.only(left: 8.0),
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
            border: Border(right: BorderSide(color: Colors.grey))),
        child: child);
  }
}

/// A custom data table view.
//ignore: must_be_immutable
class SmartDataTable extends StatelessWidget {
  SmartDataTable({super.key, required this.columns, required this.rows});

  List<SmartDataColumn> columns;
  List<SmartDataRow> rows;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: Column(children: <Widget>[
              Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          left: BorderSide(color: Colors.grey),
                          top: BorderSide(color: Colors.grey),
                          bottom: BorderSide(color: Colors.grey))),
                  child: Row(children: columns)),
              SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: rows))
            ])));
  }
}

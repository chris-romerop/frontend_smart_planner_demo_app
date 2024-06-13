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

/// This is the base for our pages.
/// This widget allows you to resize the screen without any widget overflowing.
class SmartPage extends StatelessWidget {
  const SmartPage({super.key, required this.builder});

  final Builder builder;

  @override
  Widget build(BuildContext context) {
    const double height = 250.0;
    const double width = 650.0;
    const double paddingSize = 16.0;

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // Adjust the BoxConstraint
      BoxConstraints boxConstraints = BoxConstraints(
          maxHeight: constraints.maxHeight.clamp(height, double.infinity),
          maxWidth: constraints.maxWidth.clamp(width, double.infinity),
          minHeight: height,
          minWidth: width);

      return ScrollConfiguration(
          // Deactivate scrollbars visibility
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
              // Resize the screen without any widget overflowing.
              physics: const NeverScrollableScrollPhysics(),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: ConstrainedBox(
                      constraints: boxConstraints,
                      // Adding a border
                      child: Padding(
                          padding: const EdgeInsets.all(paddingSize),
                          child: ScrollConfiguration(
                              // Reactivate scrollbars visibility
                              behavior: ScrollConfiguration.of(context)
                                  .copyWith(scrollbars: true),
                              child: builder))))));
    });
  }
}

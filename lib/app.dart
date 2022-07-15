import 'package:flutter/material.dart';

import 'list_images.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Images Save in Local Storage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ListCategories(title: 'Images Save in Local Storage'),
    );
  }
}

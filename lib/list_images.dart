import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ListCategories extends StatefulWidget {
  static const routeName = '/category';
  const ListCategories({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ListCategories> createState() => _ListCategoriesState();
}

class _ListCategoriesState extends State<ListCategories> {
  final _text = TextEditingController();
  var listImages = [];
  Directory? appDocDir;
  late File fileListImage;
  late File image;
  bool loading = false;
  final rng = Random();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _saveImage(String url) async {
    setState(() {
      loading = true;
      listImages = [];
    });
    int random = rng.nextInt(10000);

    var response = await http.get(Uri.parse(url));

    fileListImage.writeAsString('${appDocDir!.path}/images$random.jpeg\n', mode: FileMode.writeOnlyAppend);
    image = File('${appDocDir!.path}/images$random.jpeg');

    image.writeAsBytesSync(response.bodyBytes);
    _initialize();
    setState(() {
      _text.clear();
      loading = false;
    });
  }

  void _initialize() async {
    appDocDir = await getApplicationDocumentsDirectory();

    fileListImage = File('${appDocDir!.path}/images.txt');

    if (await fileListImage.exists()) {
      String str = await fileListImage.readAsString();
      for (var path in str.split('\n')) {
        if (path.isNotEmpty) {
          image = File(path);
          if (await image.exists()) {
            var bytes = await image.readAsBytes();
            setState(() => listImages.add(bytes));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          loading ? const Center(child: CircularProgressIndicator()) : const SizedBox(),
          Column(
            children: [
              Expanded(
                child: listImages.isEmpty
                    ? Center(
                        child: Opacity(
                          opacity: 0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.photo),
                              Text('No saved images'),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: listImages.length,
                        itemBuilder: ((context, index) {
                          return Image.memory(listImages[index]);
                        }),
                      ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _text,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: loading ? Colors.grey : Colors.blue,
                        ),
                        onPressed: () {
                          loading ? null : _saveImage(_text.text);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

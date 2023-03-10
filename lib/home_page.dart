import 'package:flutter/material.dart';
import 'package:tbd/doc_page.dart';

const exampleFiles = [
  "abc",
  "def",
  "a file name",
  "two three four",
  "!!!!!!!!"
];

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              flex: 3,
              child: FittedBox(
                child: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Text("1")), // Should be menu screen
              ),
            ),
            const Expanded(
              flex: 14,
              child: TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 3,
              child: FittedBox(
                child: IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () => Text("1"), // Shoud be settings screen
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 20, bottom: 20),
              child: FittedBox(
                child: Text("Class Notes"),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: GridView.count(
              crossAxisCount: 3,
              children: getFilesFromNames(exampleFiles),
            ),
          ),
        ],
      ),
    );
  }
}

List<File> getFilesFromNames(List<String> names) {
  List<File> files = [];

  for (var name in names) {
    files.add(File(name));
  }

  return files;
}

class File extends StatelessWidget {
  final String filename;

  const File(this.filename);

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DocPage(),
        ),
      ),
      child: Column(
        children: [
          const Expanded(
            flex: 8,
            child: FittedBox(
              child: Icon(
                Icons.file_present,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              filename,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

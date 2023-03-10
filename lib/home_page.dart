import 'package:flutter/material.dart';

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
        backgroundColor: Colors.black54,
        title: Row(
          children: [
            Expanded(
              flex: 3,
              child: FittedBox(
                child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () => Text("1")),
              ),
            ),
            const Expanded(
              flex: 14,
              child: TextField(
                style: TextStyle(color: Colors.white70),
                decoration: InputDecoration(
                  hintText: "SEARCH",
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 3,
              child: FittedBox(
                child: IconButton(
                  icon: Icon(Icons.settings, color: Colors.black),
                  onPressed: () => Text("1"),
                ),
              ),
            ),
          ],
        ),
      ),
      body: GridView.count(
          crossAxisCount: 3, children: getFilesFromNames(exampleFiles)),
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
      onPressed: () => {},
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

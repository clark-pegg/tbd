import 'package:flutter/material.dart';
import 'package:tbd/doc_page.dart';
import 'package:tbd/settings_page.dart';

const exampleFiles = [
  "abc",
  "def",
  "a file name",
  "two three four",
  "!!!!!!!!"
];

class HomePage extends StatelessWidget {
  Widget _offsetPopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(
              "Add Folder",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Text(
              "To-Do List",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
          PopupMenuItem(
            value: 3,
            child: Text(
              "New Project",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
          PopupMenuItem(
            value: 4,
            child: Text(
              "New Calendar",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
          PopupMenuItem(
            value: 5,
            child: Text(
              "New Note",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
        ],
        offset: Offset(-40.0, -250),
        onSelected: (value) => _actionItemPopup(value),
        icon: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: ShapeDecoration(
              color: Colors.blue,
              shape: StadiumBorder(
                side: BorderSide(color: Colors.white, width: 2),
              )),
          child: Icon(Icons.add, color: Colors.white),
        ),
      );
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
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ),
                  ),
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
          Container(
              padding: EdgeInsets.only(right: 20.0, bottom: 20.0),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      height: 80.0, width: 80.0, child: _offsetPopup()))),
        ],
      ),
    );
  }

  _actionItemPopup(value) {
    Map<int, String> _routingTable = {
      1: "New Folder",
      2: "To-Do List",
      3: "New Project",
      4: "New Calendar",
      5: "New Note"
    };
    print("Selected " + _routingTable[value]!);
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

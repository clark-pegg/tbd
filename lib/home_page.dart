import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tbd/doc_page.dart';
import 'package:tbd/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<File>> getNotes() async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('notes');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    List<File> notes = [];
    // Get data from docs and convert map to List
    return querySnapshot.docs.map((doc) {
      File f = File(doc["name"], doc.id, doc["content"]);
      return f;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: getNotes(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong..."),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return showBody(context, snapshot);
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(
          child: Text(
            "Loading...",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  String? codeDialog;
  String? valueText;

  final TextEditingController _textFieldController = TextEditingController();
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New note'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "Name"),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    FirebaseFirestore.instance
                        .collection("notes")
                        .add({"name": codeDialog, "content": ""}).then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DocPage(
                            id: value.id,
                          ),
                        ),
                      );
                    });
                  });
                },
              ),
            ],
          );
        });
  }

  Widget showBody(context, snapshot) {
    _actionItemPopup(value) {
      Map<int, String> _routingTable = {
        1: "New Folder",
        2: "To-Do List",
        3: "New Project",
        4: "New Calendar",
        5: "New Note"
      };
      switch (value) {
        case 5:
          _displayTextInputDialog(context);
          break;
      }
    }

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
              children: snapshot.data,
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
}

class File extends StatelessWidget {
  final String filename;
  final String id;
  final String content;
  const File(this.filename, this.id, this.content);

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DocPage(
            id: this.id,
          ),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tbd/doc_page.dart';
import 'package:tbd/settings_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String sort = "Alphabetic";
  List<File> allFiles = [];

  Future<List<File>> getNotes(String sort) async {
    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notes");
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    // Get data from docs and convert map to List
    List<File> notes = querySnapshot.docs.map((doc) {
      File f = File(doc["name"], doc.id);
      return f;
    }).toList();

    print(sort);

    if (sort.compareTo("Alphabetic") == 0) {
      notes.sort((File a, File b) => a.filename.compareTo(b.filename));
    } else if (sort.compareTo("Reverse") == 0) {
      notes.sort((File a, File b) => b.filename.compareTo(a.filename));
    }
    allFiles = notes;
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: getNotes("Alphabetic"),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong... Error code(1)"),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return showBody(context, snapshot, 0);
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
  final TextEditingController _textFieldController = TextEditingController();
  Future<void> _displayTextInputDialog(BuildContext context) async {
    _textFieldController.clear();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New note'),
            content: TextField(
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
                    codeDialog = _textFieldController.text;
                    if ((codeDialog == null) || (codeDialog == '')) {
                      const invalidNameSnackBar = SnackBar(
                        content: Text('Enter a valid name'),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(invalidNameSnackBar);
                    } else {
                      var contain = allFiles.where((file) =>
                          file.filename.toLowerCase() ==
                          codeDialog?.toLowerCase());
                      String fn = codeDialog ?? "null";
                      if (contain.isEmpty) {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("notes")
                            .add({
                          "name": fn,
                          "displayed": [],
                          "names": [],
                          "dx": [],
                          "dy": [],
                          "text": [],
                          "bgFill": [],
                          "textCol": [],
                          "fontSize": [],
                          "width": [],
                          "height": [],
                          "border": [],
                        }).then((value) {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DocPage(
                                id: value.id,
                                filename: fn,
                              ),
                            ),
                          );
                        });
                      } else {
                        const invalidNameSnackBar = SnackBar(
                          content: Text('That name is already being used'),
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(invalidNameSnackBar);
                      }
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  Widget showBody(context, snapshot, sort) {
    _actionItemPopup(value) {
      Map<int, String> _routingTable = {
        // 1: "New Folder",
        // 2: "To-Do List",
        // 3: "New Project",
        // 4: "New Calendar",
        5: "New Note"
      };
      switch (value) {
        case 5:
          _displayTextInputDialog(context);
          break;
      }
    }

    Future<void> showSortingOptions() async {
      return showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text("Sorting Options"),
                content: SingleChildScrollView(
                    child: ListBody(children: [Text("Test")])),
                actions: [
                  TextButton(
                      child: const Text("Approve"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ]);
          });
    }

    Widget _offsetPopup() => PopupMenuButton<int>(
          itemBuilder: (context) => [
            // PopupMenuItem(
            //   value: 1,
            //   child: Text(
            //     "Add Folder",
            //     style:
            //         TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            //   ),
            // ),
            // PopupMenuItem(
            //   value: 2,
            //   child: Text(
            //     "To-Do List",
            //     style:
            //         TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            //   ),
            // ),
            // PopupMenuItem(
            //   value: 3,
            //   child: Text(
            //     "New Project",
            //     style:
            //         TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            //   ),
            // ),
            // PopupMenuItem(
            //   value: 4,
            //   child: Text(
            //     "New Calendar",
            //     style:
            //         TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            //   ),
            // ),
            PopupMenuItem(
              value: 5,
              child: Text(
                "New Note",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
          ],
          //offset: Offset(-40.0, -250),
          offset: Offset(-40.0, -62.5),
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
      drawer: Drawer(
          child: ListView(children: [
        ListTile(
            title: const Text("TBD Note Taking App"),
            tileColor: Colors.blue,
            textColor: Colors.white),
        ListTile(
            title: const Text("Change Sorting Rule"),
            onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                        title: const Text("Choose Sorting Option"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, "Cancel"),
                              child: const Text("Cancel")),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FutureBuilder(
                                              // Initialize FlutterFire:
                                              future: getNotes("Alphabetic"),
                                              builder: (context, snapshot) {
                                                // Check for errors
                                                if (snapshot.hasError) {
                                                  return Center(
                                                    child: Text(
                                                        "Something went wrong... Error code(2)"),
                                                  );
                                                }

                                                // Once complete, show your application
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  return showBody(
                                                      context, snapshot, 0);
                                                }

                                                // Otherwise, show something whilst waiting for initialization to complete
                                                return Center(
                                                  child: Text(
                                                    "Loading...",
                                                    style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                );
                                              },
                                            )));
                              },
                              child: const Text("Alphabetic")),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FutureBuilder(
                                              // Initialize FlutterFire:
                                              future: getNotes("Reverse"),
                                              builder: (context, snapshot) {
                                                // Check for errors
                                                if (snapshot.hasError) {
                                                  return Center(
                                                    child: Text(
                                                        "Something went wrong... Error code(3)"),
                                                  );
                                                }

                                                // Once complete, show your application
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  return showBody(
                                                      context, snapshot, 0);
                                                }

                                                // Otherwise, show something whilst waiting for initialization to complete
                                                return Center(
                                                  child: Text(
                                                    "Loading...",
                                                    style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                );
                                              },
                                            )));
                              },
                              child: const Text("Reverse Alphabetic"))
                        ])))
      ])),
      appBar: AppBar(
        title: Row(
          children: [
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
  const File(this.filename, this.id);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DocPage(
                  id: this.id,
                  filename: this.filename,
                ),
              ),
            ),
        onLongPress: () => _displayDeleteDialog(context, filename, id),
        child: MenuItemButton(
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
        ));
  }

  Future<void> _displayDeleteDialog(
      BuildContext context, String filename, String id) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete note'),
            content:
                Text("Are you sure you want to delete \"" + filename + "\"?"),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('DELETE'),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("notes")
                      .doc(id)
                      .delete()
                      .then((value) {});
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
            ],
          );
        });
  }
}

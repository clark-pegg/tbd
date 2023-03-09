import 'dart:io';
import 'dart:developer';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/widget.dart';
import '../models/widget_list_jsonstr.dart';

class TabsConfig {
  static List<String> tabs = [];
  static int selectedTabIndex = 0;
}

class DocPage extends StatefulWidget {
  const DocPage({Key? key}) : super(key: key);
  @override
  _DocPageState createState() => _DocPageState();
}

class _DocPageState extends State<DocPage> with TickerProviderStateMixin {
  late TabController controller;
  @override
  void initState() {
    // TODO: implement initState
    TabsConfig.tabs.add('plus.png');
    controller = TabController(
      length: TabsConfig.tabs.length,
      vsync: this,
      initialIndex: TabsConfig.selectedTabIndex,
    );
    super.initState();
  }

  void updateTabs() {
    try {
      controller = TabController(
        length: TabsConfig.tabs.length,
        vsync: this,
        initialIndex: TabsConfig.selectedTabIndex,
      );
      setState(() {});
    } catch (on) {
      print(on); // TODO: rem
    }
  }

  void toggleTab() {
    int index = TabsConfig.selectedTabIndex;
  }

  Offset offset = Offset.zero;
  Widget textBox(BuildContext context) {
    return Scaffold(
      body: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Enter your username',
        ),
      ),
    );
  }

  final List<bool> _selected =
      List.generate(20, (i) => false); // Fill it with false initially

  Widget _buildPopupDialog(BuildContext context) {
    List<Widgets> _widgets = [];
    List<dynamic> jsonList = jsonDecode(jsonString);
    _widgets = jsonList.map((json) => Widgets.fromJson(json)).toList();
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Text("Widgets"),
        content: SizedBox(
          width: 450,
          height: 500,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: ((context, index) {
              Widgets widget = _widgets[index];
              return ListTile(
                tileColor: _selected[index] ? Colors.blue : Colors.white,
                //textColor: Colors.white,
                onTap: () {
                  if (TabsConfig.tabs.contains('${widget.imageName}')) {
                    setState(() {
                      _selected[index] = !_selected[index];
                    });
                    TabsConfig.tabs.remove('${widget.imageName}');
                    updateTabs();
                  } else {
                    setState(() {
                      _selected[index] = !_selected[index];
                    });
                    TabsConfig.tabs.add('${widget.imageName}');
                    setState(() {});
                    updateTabs();
                  }
                },

                shape: ContinuousRectangleBorder(
                  side: BorderSide(color: Colors.black, width: 1),
                ),
                dense: true,
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                leading: Image.asset(
                  'images/${widget.imageName}',
                  width: 50,
                  height: 50,
                ),
                title: Text(widget.widgetName, style: TextStyle(fontSize: 30)),
                subtitle:
                    Text(widget.description, style: TextStyle(fontSize: 20)),
                trailing: widget.isFavourite
                    ? Icon(Icons.favorite, color: Colors.red)
                    : Icon(Icons.favorite_border, color: Colors.black),
              );
            }),
          ),
        ),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    //int numWidgets = 1;
    //length: numWidgets,

    return Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            onTap: (index) {
              print(TabsConfig.tabs[index]);
              if (TabsConfig.tabs[index] == 'plus.png') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context),
                );
              }
              if (TabsConfig.tabs[index] == 'text.png') {
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) => textBox(context),
                // );
              }
            },
            controller: controller,
            isScrollable: true,
            tabs: List.generate(
              TabsConfig.tabs.length,
              (index) => Image.asset(
                'images/${TabsConfig.tabs[index]}',
                width: 40,
                height: 40,
              ),
            ),
          ),
          title: Text('Example Name'),
        ),
        body: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: 36,
          decoration: InputDecoration(
              hintText: "Insert your text",
              enabledBorder: OutlineInputBorder()),
          scrollPadding: EdgeInsets.all(20.0),
          autofocus: true,
        ));
  }
}

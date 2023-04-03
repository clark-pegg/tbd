import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:developer';
import 'dart:convert';
import '../models/widget.dart';
import '../models/widget_list_jsonstr.dart';

class TabsConfig {
  static List<String> tabs = [];
  static int selectedTabIndex = 0;
}

class Notifier extends ChangeNotifier {

  int id = 0;

  void setId(int id) {
    this.id = id;
    notifyListeners(); // Here the magic happens
  }
}

class DisplayedWidgets {
  static List<String> displayed = [];
  static List<String> names = [];
  static List<double> dx = [];
  static List<double> dy = [];
  static List<double> dx_settings = [];
  static List<double> dy_settings = [];
  static List<String> text = [];
  static List<TextEditingController> textControllers = [];
  static List<bool> visibilityValuesSettings = [];
  static List<bool> visibilityValues = [];
  static int selectedDispIndex = 0;
  static List<double> width = [];
  static List<double> height = [];
  static List<DragUpdateDetails> details = [];
  static List<DragUpdateDetails> details_settings = [];
  static bool editing = false;

}

class DocPage extends StatefulWidget{
  final String id;
  const DocPage({Key? key, required this.id}) : super(key: key);
  @override
  _DocPageState createState() => _DocPageState();
}




class _DocPageState extends State<DocPage> with TickerProviderStateMixin {
  late TabController controller;
  late TabController controller1;
  List<bool> int2bool = [false, true];


  @override
  void initState() {
    // TODO: implement initState
    TabsConfig.tabs.add('plus.png');
    controller = TabController(
      length: TabsConfig.tabs.length,
      vsync: this,
      initialIndex: TabsConfig.selectedTabIndex,
    );
    controller1 = TabController(
      length: DisplayedWidgets.displayed.length,
      vsync: this,
      initialIndex: DisplayedWidgets.selectedDispIndex,
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

  void updateDisplayed() {
    try {
      controller1 = TabController(
        length: DisplayedWidgets.displayed.length,
        vsync: this,
        initialIndex: 0,
      );
      setState(() {});
    } catch (on) {
      print(on); // TODO: rem
    }
  }

  void toggleTab(){
    int index = TabsConfig.selectedTabIndex;
  }

  void toggleDisp(){
    int index = DisplayedWidgets.selectedDispIndex;
  }

  bool _enabled = true;

  void _onTap () {
    // Disable GestureDetector's 'onTap' property.
    setState(() => _enabled = ! _enabled);

    // Enable it after 1s.


    // Rest of your code...
  }

  final Notifier notifier = Notifier();
  Offset offset = Offset.zero;
  static double temp_dx = 0.0;
  static double temp_dy = 0.0;
  final List<String> textSettings = ["Close Menu", "Delete Widget", "Change Name","Height", "Width"];

  Widget _buildTextBoxSettings(BuildContext context, int id) {
  return StatefulBuilder(
      builder: (context, setState) {
        //if(DisplayedWidgets.dx[id])
        return Positioned(
            left: DisplayedWidgets.dx[id] - 95,
            top: DisplayedWidgets.dy[id] + 5,
            child: Visibility(
              visible: DisplayedWidgets.visibilityValuesSettings[id],
                child: SizedBox(
                  width: 100,
                  height: 1000,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: ((context, index) {

                      return ListTile(
                          shape: const ContinuousRectangleBorder(
                            side:  BorderSide(color: Colors.black, width: 2),
                          ),
                        title: Text('${textSettings[index]}'),
                        onTap: () => {
                            if(textSettings[index] == "Delete Widget"){
                                if(DisplayedWidgets.editing == true){
                                  for(var i = 0; i <
                                      DisplayedWidgets.displayed.length;
                                  i += 1) ... [
                                    if(i != id) ... [
                                      DisplayedWidgets.visibilityValues[i] =
                                      !DisplayedWidgets.visibilityValues[i]
                                    ],
                                  ],
                                },
                                DisplayedWidgets.displayed.removeAt(id),
                                DisplayedWidgets.names.removeAt(id),
                                DisplayedWidgets.editing = false,
                                DisplayedWidgets.height.removeAt(id),
                                DisplayedWidgets.width.removeAt(id),
                                DisplayedWidgets.dx.removeAt(id),
                                DisplayedWidgets.dy.removeAt(id),
                                DisplayedWidgets.dx_settings.removeAt(id),
                                DisplayedWidgets.dy_settings.removeAt(id),
                                DisplayedWidgets.visibilityValuesSettings[id] =
                                false,
                                DisplayedWidgets.visibilityValuesSettings
                                    .removeAt(id),
                                DisplayedWidgets.visibilityValues[id] = true,
                                DisplayedWidgets.visibilityValues.removeAt(id),
                                DisplayedWidgets.text.removeAt(id),
                                DisplayedWidgets.textControllers.removeAt(id),
                                DisplayedWidgets.details.removeAt(id),
                                DisplayedWidgets.details_settings.removeAt(id),
                                updateDisplayed(),
                            },
                          if(textSettings[index] == "Close Menu"){
                              DisplayedWidgets.editing = false,
                              DisplayedWidgets.dx[id] = temp_dx,
                              DisplayedWidgets.dy[id] = temp_dy,
                              DragUpdateDetails(globalPosition: Offset(DisplayedWidgets.dx[id],DisplayedWidgets.dy[id])),

                              DisplayedWidgets.visibilityValuesSettings[id] = !DisplayedWidgets.visibilityValuesSettings[id],
                              for(var i=0; i<DisplayedWidgets.displayed.length; i+=1){
                                if(i != id) {
                                  DisplayedWidgets.visibilityValues[i] =
                                  !DisplayedWidgets.visibilityValues[i]
                                },
                              },
                              updateDisplayed(),
                          },
                      },

                    );
                  }),
                ),
              ),
              // actions: <Widget>[
              //   IconButton(
              //     icon: const Icon(Icons.close),
              //     onPressed: () {
              //       setState(() {DisplayedWidgets.visibilityValuesSettings[id] = false;});
              //     },
              //   ),
              // ],


          )
        );



      });
  }


  Widget _buildTextBox(BuildContext context, int id) {
    return StatefulBuilder(
        builder: (context, setState)
    {
      late FocusNode myFocusNode;

      myFocusNode = FocusNode();
      DragUpdateDetails e = DisplayedWidgets.details[id];
      print(id);
            notifier.setId(id);
                return Positioned(
                  left: DisplayedWidgets.dx[id],
                  top: DisplayedWidgets.dy[id],
                  child: Visibility(
                    visible: DisplayedWidgets.visibilityValues[id],
                    child: GestureDetector(
                      onTap: _enabled ? _onTap: null,
                      onPanUpdate: (DragUpdateDetails e) {
                        setState(() {
                          offset = Offset(
                              DisplayedWidgets.details[id].delta.dx + DisplayedWidgets.dx[id],
                              DisplayedWidgets.details[id].delta.dy + DisplayedWidgets.dy[id]);
                          DisplayedWidgets.dx[id] += e.delta.dx;
                          DisplayedWidgets.dy[id] += e.delta.dy;
                          DisplayedWidgets.details[id] = DragUpdateDetails(globalPosition: Offset(DisplayedWidgets.dx[id],DisplayedWidgets.dy[id]));
                          updateDisplayed();
                        });
                      },
                      child: SizedBox(
                          width: DisplayedWidgets.width[id],
                          height: DisplayedWidgets.height[id],
                            child: Stack(children: <Widget> [
                                InkWell(
                                  onTap: () => myFocusNode.requestFocus(),
                                  onDoubleTap: () => {myFocusNode.unfocus(), DisplayedWidgets.text[id] = DisplayedWidgets.textControllers[id].text},
                                  onLongPress: () => {
                                    // open menu
                                    if(DisplayedWidgets.visibilityValuesSettings[id] == false) ... [
                                      DisplayedWidgets.editing = true,
                                      temp_dx = DisplayedWidgets.dx[id],
                                      temp_dy = DisplayedWidgets.dy[id],
                                      DisplayedWidgets.dx[id] = 100,
                                      DisplayedWidgets.dy[id] = 0,
                                      DragUpdateDetails(globalPosition: Offset(DisplayedWidgets.dx[id],DisplayedWidgets.dy[id])),
                                    ],
                                    // close menu
                                    if(DisplayedWidgets.visibilityValuesSettings[id] == true) ... [
                                      DisplayedWidgets.editing = false,
                                      DisplayedWidgets.dx[id] = temp_dx,
                                      DisplayedWidgets.dy[id] = temp_dy,
                                      DragUpdateDetails(globalPosition: Offset(DisplayedWidgets.dx[id],DisplayedWidgets.dy[id])),
                                    ],

                                    DisplayedWidgets.visibilityValuesSettings[id] = !DisplayedWidgets.visibilityValuesSettings[id],
                                    for(var i=0; i<DisplayedWidgets.displayed.length; i+=1) ... [
                                      if(i != id) ... [
                                        DisplayedWidgets.visibilityValues[i] = !DisplayedWidgets.visibilityValues[i]
                                      ],
                                    ],
                                    updateDisplayed(),
                                     },
                                  child: AbsorbPointer(
                                      child: ListTile(
                                        title: TextField(
                                          controller: DisplayedWidgets.textControllers[id],
                                          focusNode: myFocusNode,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 36,
                                          decoration: InputDecoration(
                                              labelText: DisplayedWidgets.names[id],
                                              // Set border for enabled state (default)
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 3, color: Colors.blue),
                                              ),
                                              // Set border for focused state
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 3, color: Colors.red),
                                              )),
                                        ),))
                              ),
                            ],
                            ),
                      ),

                    ),
                ),
                );
          });
}
  final List<bool> _selected = List.generate(20, (i) => false); // Fill it with false initially
  Widget _buildPopupDialog(BuildContext context) {
    List<Widgets> _widgets = [];
    List<dynamic> jsonList = jsonDecode(jsonString);
    _widgets = jsonList.map((json) => Widgets.fromJson(json)).toList();
    return StatefulBuilder(
        builder: (context, setState) {
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
                      }
                      else {
                        setState(() {
                          _selected[index] = !_selected[index];
                        });
                        TabsConfig.tabs.add('${widget.imageName}');
                        setState(() {});
                        updateTabs();
                      }
                    },

                    shape: const ContinuousRectangleBorder(
                      side:  BorderSide(color: Colors.black, width: 1),
                    ),
                    dense: true,
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    leading: Image.asset(
                      'images/${widget.imageName}',
                      width: 50,
                      height: 50,
                    ),
                    title: Text(widget.widgetName,
                        style: const TextStyle(
                            fontSize: 30
                        )),
                    subtitle: Text(widget.description,
                        style: const TextStyle(
                            fontSize: 20
                        )),
                    trailing: widget.isFavourite
                        ? Icon(Icons.favorite, color: Colors.red)
                        : Icon(Icons.favorite_border, color: Colors.black),
                  );
                }),
              ),
            ),
            actions: <Widget>[
              IconButton(
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
    int id = 0;

    //length: numWidgets,
    return StatefulBuilder(
        builder: (context, setState)
    {
      return Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              onTap: (index) {
                //print(TabsConfig.tabs[index]);
                if (TabsConfig.tabs[index] == 'plus.png') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context),
                  );
                }
                if (TabsConfig.tabs[index] == 'text.png' && DisplayedWidgets.editing == false) {
                  DisplayedWidgets.displayed.add('text');
                  DisplayedWidgets.names.add('Text box ${DisplayedWidgets.displayed.length}');
                  DisplayedWidgets.width.add(150);
                  DisplayedWidgets.height.add(100);
                  DisplayedWidgets.dx.add(50.0);
                  DisplayedWidgets.dy.add(100.0);
                  DisplayedWidgets.dx_settings.add(50.0);
                  DisplayedWidgets.dy_settings.add(100.0);
                  DisplayedWidgets.visibilityValuesSettings.add(false);
                  DisplayedWidgets.visibilityValues.add(true);
                  DisplayedWidgets.text.add("");
                  DisplayedWidgets.textControllers.add(TextEditingController());
                  DisplayedWidgets.details.add(DragUpdateDetails(globalPosition:Offset(0.0,0.0)));
                  DisplayedWidgets.details_settings.add(DragUpdateDetails(globalPosition:Offset(0.0,0.0)));
                  updateDisplayed();
                }else if (TabsConfig.tabs[index] == 'code.png') {
                  DisplayedWidgets.displayed.add('code');
                  DisplayedWidgets.dx.add(0.0);
                  DisplayedWidgets.dy.add(0.0);
                  DisplayedWidgets.visibilityValuesSettings.add(false);
                  updateDisplayed();
                }else if (TabsConfig.tabs[index] == 'math.png') {
                  DisplayedWidgets.displayed.add('math');
                  DisplayedWidgets.dx.add(0.0);
                  DisplayedWidgets.dy.add(0.0);
                  DisplayedWidgets.visibilityValuesSettings.add(false);
                  updateDisplayed();
                }
              },
              controller: controller,
              isScrollable: true,
              tabs: List.generate(
                TabsConfig.tabs.length,
                    (index) =>
                    Image.asset('images/${TabsConfig.tabs[index]}',
                      width: 40,
                      height: 40,
                    ),
              ),
            ),

            title: Text('Example Name'),
          ),
          body: SizedBox.expand(
            //need to add firebase integration here to see if widget data already exists
          child: Center(
              child: Stack(children: <Widget>[
                for(var i=0; i<DisplayedWidgets.displayed.length; i+=1) ... [
                    if(DisplayedWidgets.displayed[i] == 'text') ... [
                      _buildTextBox(context, i)
                    ],
                    Center(
                      child: Stack(children: <Widget>[
                        for(var i=0; i<DisplayedWidgets.displayed.length; i+=1) ... [
                          _buildTextBoxSettings(context, i),
                        ]
                      ],),
                    )

                ],

                ],),
          )
          ),
      );
    });
  }
}

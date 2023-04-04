import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:developer';
import 'dart:convert';
import '../models/widget.dart';
import '../models/widget_list_jsonstr.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:image_picker/image_picker.dart';

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
  //need to be stored in firebase 100%
  static List<String> displayed = [];
  static List<String> names = [];
  static List<double> dx = [];
  static List<double> dy = [];
  static List<String> text = [];
  static List<String> bgFill = [];
  static List<String> textCol = [];
  static List<double> fontSize = [];
  static List<double> width = [];
  static List<double> height = [];
  static List<double> border = [];

  static List<String> paths = [];

  //can be initialized later after pulling data from firebase
  static List<bool> visibilityValuesSettings = [];
  static List<bool> visibilityValues = [];
  static List<List<String>> curr_settings_text_box = [[]];
  static List<List<String>> curr_settings_image = [[]];
  static List<DragUpdateDetails> details = [];
  static List<TextEditingController> textControllers = [];

  //constant at initialization
  static bool editing = false;
  static bool input = false;
  static bool input1 = false;
  static int selectedDispIndex = 0;
  static String input_txt = "";
  static String input_name = "";
  static TextEditingController input_ctrl = TextEditingController();
}

class DocPage extends StatefulWidget {
  final String id;
  final String filename;
  const DocPage({Key? key, required this.id, required this.filename}) : super(key: key);
  @override
  _DocPageState createState() => _DocPageState();
}
class _DocPageState extends State<DocPage> with TickerProviderStateMixin {
  late TabController controller;
  late TabController controller1;
  StreamController<String> streamController = StreamController();
  String prev = "";
  bool _isNew = false;
  int num_widg_at_load = 0;

  List<bool> int2bool = [false, true];



  @override
  void initState() {

    // TODO: implement initState
    // print(TabsConfig.tabs);
    if (!TabsConfig.tabs.contains("plus.png")) {
      TabsConfig.tabs.add('plus.png');
    }

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

  void toggleTab() {
    int index = TabsConfig.selectedTabIndex;
  }

  void toggleDisp() {
    int index = DisplayedWidgets.selectedDispIndex;
  }

  bool _enabled = true;

  void _onTap() {
    // Disable GestureDetector's 'onTap' property.
    setState(() => _enabled = !_enabled);

    // Enable it after 1s.

    // Rest of your code...
  }


  final Notifier notifier = Notifier();
  Offset offset = Offset.zero;
  static double temp_dx = 0.0;
  static double temp_dy = 0.0;
  static Text temp_name = Text("");


  File? image;
  File? imageTemp;
  Widget _buildImagePicker(BuildContext context, int id) {
    return StatefulBuilder(builder: (context, setState) {
      DragUpdateDetails e = DisplayedWidgets.details[id];
      print(id);
      notifier.setId(id);
      return Positioned(
        left: DisplayedWidgets.dx[id],
        top: DisplayedWidgets.dy[id],
        child: Visibility(
          visible: DisplayedWidgets.visibilityValues[id],
          child: GestureDetector(
            onTap: _enabled ? _onTap : null,
            onPanUpdate: (DragUpdateDetails e) {
              setState(() {
                offset = Offset(
                    DisplayedWidgets.details[id].delta.dx + DisplayedWidgets.dx[id],
                    DisplayedWidgets.details[id].delta.dy + DisplayedWidgets.dy[id]);
                DisplayedWidgets.dx[id] += e.delta.dx;
                DisplayedWidgets.dy[id] += e.delta.dy;
                DisplayedWidgets.details[id] = DragUpdateDetails(
                    globalPosition: Offset(
                        DisplayedWidgets.dx[id], DisplayedWidgets.dy[id]));
                updateDisplayed();
              });
            },
            child: SizedBox(

              width: DisplayedWidgets.width[id],
              height: DisplayedWidgets.height[id],
              child: Stack(
                children: <Widget>[
                  InkWell(
                      onLongPress: () => {
                        // open menu
                        if (DisplayedWidgets.visibilityValuesSettings[id] == false) ...[
                          DisplayedWidgets.editing = true,
                          DisplayedWidgets.input1 = false,
                          temp_dx = DisplayedWidgets.dx[id],
                          temp_dy = DisplayedWidgets.dy[id],
                          DisplayedWidgets.dx[id] = 120,
                          DisplayedWidgets.dy[id] = 70,
                          DragUpdateDetails(
                              globalPosition: Offset(
                                  DisplayedWidgets.dx[id],
                                  DisplayedWidgets.dy[id])),
                        ],
                        // close menu
                        if (DisplayedWidgets.visibilityValuesSettings[id] == true) ...[
                          DisplayedWidgets.input1 = false,
                          DisplayedWidgets.editing = false,
                          DisplayedWidgets.dx[id] = temp_dx,
                          DisplayedWidgets.dy[id] = temp_dy,
                          DragUpdateDetails(
                              globalPosition: Offset(
                                  DisplayedWidgets.dx[id],
                                  DisplayedWidgets.dy[id])),
                        ],

                        DisplayedWidgets.visibilityValuesSettings[id] =
                        !DisplayedWidgets.visibilityValuesSettings[id],
                        for (var i = 0; i < DisplayedWidgets.displayed.length; i += 1) ...[
                          if (i != id) ...[
                            DisplayedWidgets.visibilityValues[i] =
                            !DisplayedWidgets.visibilityValues[i]
                          ],
                        ],
                        updateDisplayed(),
                      },
                      child: AbsorbPointer(
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.blueAccent),
                              image: DecorationImage(
                                  image: FileImage(File(DisplayedWidgets.paths[id]))
                              )
                          )
                      )
                  )),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future pickImageGal(int id) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if(image == null) return;
      DisplayedWidgets.paths[id] = image.path;
    } on Exception catch(e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageCam(int id) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if(image == null) return;
      DisplayedWidgets.paths[id] = image.path;
    } on Exception catch(e) {
      print('Failed to pick image: $e');
    }
  }

  final List<String> imageSettings = [
    "Close Menu",
    "Delete Widget",
    "Gallery",
    "Camera",
    "Height",
    "Width",
  ];

  Widget _buildInputImage(BuildContext context, int id) {
    return StatefulBuilder(builder: (context, setState) {
      late FocusNode inputFocus;
      inputFocus = FocusNode();
      return Positioned(
        left: DisplayedWidgets.dx[id] - 20,
        top: DisplayedWidgets.dy[id] - 70,
        child: Visibility(
            visible: DisplayedWidgets.input1,
            child: SizedBox(
              width: 200,
              height: 70,
              child: InkWell(
                  onTap: () => inputFocus.requestFocus(),
                  onDoubleTap: () => {inputFocus.unfocus(),
                    DisplayedWidgets.input_txt = DisplayedWidgets.input_ctrl.text,
                    if (DisplayedWidgets.input_name == "Height")
                      {
                        DisplayedWidgets.height[id] =
                            double.parse(DisplayedWidgets.input_txt),
                        FlutterError.onError = (details) {
                          DisplayedWidgets.input_ctrl.text = "";
                          DisplayedWidgets.input1 = false;
                          updateDisplayed();
                        },
                        DisplayedWidgets.input_ctrl.text = "",
                        DisplayedWidgets.input1 = false,
                        DisplayedWidgets.curr_settings_image[id][4] =
                            DisplayedWidgets.height[id].toString(),
                      }
                    else if (DisplayedWidgets.input_name == "Width")
                        {
                          DisplayedWidgets.width[id] =
                              double.parse(DisplayedWidgets.input_txt),
                          FlutterError.onError = (details) {
                            DisplayedWidgets.input_ctrl.text = "";
                            DisplayedWidgets.input1 = false;
                            updateDisplayed();
                          },
                          DisplayedWidgets.input_ctrl.text = "",
                          DisplayedWidgets.input1 = false,
                          DisplayedWidgets.curr_settings_image[id][5] =
                              DisplayedWidgets.width[id].toString(),
                        },
                    updateDisplayed()
                  },
                  child: AbsorbPointer(
                      child: ListTile(
                        title: TextField(
                          controller: DisplayedWidgets.input_ctrl,
                          focusNode: inputFocus,
                          //keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          decoration: InputDecoration(
                              labelText: DisplayedWidgets.input_name,
                              // Set border for enabled state (default)
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 3, color: Colors.blue),
                              ),
                              // Set border for focused state
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 3, color: Colors.red),
                              )),
                        ),
                      ))),
            )),
      );
    });
  }



  Widget _buildImageSettings(BuildContext context, int id) {
    return StatefulBuilder(builder: (context, setState) {
      //if(DisplayedWidgets.dx[id])
      return Positioned(
          left: DisplayedWidgets.dx[id] - 115,
          top: DisplayedWidgets.dy[id] - 65,
          child: Visibility(
            visible: DisplayedWidgets.visibilityValuesSettings[id],
            child: SizedBox(
              width: 100,
              height: (MediaQuery.of(context).size.height) - 150,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 6,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: ((context, index) {
                  if (index > 3) {
                    temp_name = Text(
                        '${imageSettings[index]}\nCurrent: ${DisplayedWidgets.curr_settings_image[id][index]}');
                  } else {
                    temp_name = Text(imageSettings[index]);
                  }
                  return ListTile(
                    shape: const ContinuousRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                    title: temp_name,
                    onTap: () => {
                      if (imageSettings[index] == "Delete Widget")
                        {
                          if (DisplayedWidgets.editing == true)
                            {
                              for (var i = 0; i < DisplayedWidgets.displayed.length; i += 1) ...[
                                if (i != id) ...[
                                  DisplayedWidgets.visibilityValues[i] = !DisplayedWidgets.visibilityValues[i]
                                ],
                              ],
                            },
                          DisplayedWidgets.displayed.removeAt(id),
                          DisplayedWidgets.names.removeAt(id),
                          DisplayedWidgets.editing = false,
                          DisplayedWidgets.height.removeAt(id),
                          DisplayedWidgets.width.removeAt(id),
                          DisplayedWidgets.border.removeAt(id),
                          DisplayedWidgets.paths.removeAt(id),
                          DisplayedWidgets.dx.removeAt(id),
                          DisplayedWidgets.dy.removeAt(id),
                          DisplayedWidgets.visibilityValuesSettings[id] = false,
                          DisplayedWidgets.visibilityValuesSettings.removeAt(id),
                          DisplayedWidgets.visibilityValues[id] = true,
                          DisplayedWidgets.input1 = false,
                          DisplayedWidgets.visibilityValues.removeAt(id),
                          DisplayedWidgets.text.removeAt(id),
                          DisplayedWidgets.textControllers.removeAt(id),
                          DisplayedWidgets.details.removeAt(id),
                          DisplayedWidgets.curr_settings_text_box.removeAt(id),
                          updateDisplayed(),
                        }
                      else if (imageSettings[index] == "Close Menu")
                        {
                          DisplayedWidgets.editing = false,
                          DisplayedWidgets.input1 = false,
                          DisplayedWidgets.dx[id] = temp_dx,
                          DisplayedWidgets.dy[id] = temp_dy,
                          DragUpdateDetails(
                              globalPosition: Offset(DisplayedWidgets.dx[id],
                                  DisplayedWidgets.dy[id])),
                          DisplayedWidgets.visibilityValuesSettings[id] = !DisplayedWidgets.visibilityValuesSettings[id],
                          for (var i = 0;
                          i < DisplayedWidgets.displayed.length;
                          i += 1)
                            {
                              if (i != id)
                                {
                                  DisplayedWidgets.visibilityValues[i] = !DisplayedWidgets.visibilityValues[i]
                                },
                            },
                          updateDisplayed(),
                        }


                        else if (imageSettings[index] == "Gallery")
                          {
                            print("Picking from Gallery"),
                            pickImageGal(id),
                            updateDisplayed(),
                          }
                        else if (imageSettings[index] == "Camera")
                            {
                              pickImageCam(id),
                              updateDisplayed(),
                            }

                        else
                        {
                          if (DisplayedWidgets.input1 == false)
                            {
                              DisplayedWidgets.input1 = true,
                            },
                          DisplayedWidgets.input_name = imageSettings[index],
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
          ));
    });
  }

final List<String> textSettings = [
  "Close Menu",
  "Delete Widget",
  "Change Name",
  "Height",
  "Width",
  "Border",
  "BG Fill",
  "Font Size",
  "Text Font",
  "Text Color"
];


Widget _buildInputTextBox(BuildContext context, int id) {
  return StatefulBuilder(builder: (context, setState) {
    late FocusNode inputFocus;
    inputFocus = FocusNode();
    return Positioned(
      left: DisplayedWidgets.dx[id],
      top: DisplayedWidgets.dy[id] - 70,
      child: Visibility(
          visible: DisplayedWidgets.input,
          child: SizedBox(
            width: 200,
            height: 70,
            child: InkWell(
                onTap: () => inputFocus.requestFocus(),
                onDoubleTap: () => {
                  inputFocus.unfocus(),
                  DisplayedWidgets.input_txt =
                      DisplayedWidgets.input_ctrl.text,
                  DisplayedWidgets.input_ctrl.text = "",
                  DisplayedWidgets.input = false,
                  if (DisplayedWidgets.input_name == "Change Name")
                    {
                      DisplayedWidgets.names[id] =
                          DisplayedWidgets.input_txt,
                      DisplayedWidgets.curr_settings_text_box[id][2] =
                      DisplayedWidgets.names[id],
                    }
                  else if (DisplayedWidgets.input_name == "Height")
                    {
                      DisplayedWidgets.height[id] =
                          double.parse(DisplayedWidgets.input_txt),
                      FlutterError.onError = (details) {
                        DisplayedWidgets.input_ctrl.text = "";
                        DisplayedWidgets.input = false;
                        updateDisplayed();
                      },
                      DisplayedWidgets.input_ctrl.text = "",
                      DisplayedWidgets.input = false,
                      DisplayedWidgets.curr_settings_text_box[id][3] =
                          DisplayedWidgets.height[id].toString(),
                    }
                  else if (DisplayedWidgets.input_name == "Width")
                      {
                        DisplayedWidgets.width[id] =
                            double.parse(DisplayedWidgets.input_txt),
                        FlutterError.onError = (details) {
                          DisplayedWidgets.input_ctrl.text = "";
                          DisplayedWidgets.input = false;
                          updateDisplayed();
                        },
                        DisplayedWidgets.input_ctrl.text = "",
                        DisplayedWidgets.input = false,
                        DisplayedWidgets.curr_settings_text_box[id][4] =
                            DisplayedWidgets.width[id].toString(),
                      }
                    else if (DisplayedWidgets.input_name == "Border")
                        {
                          DisplayedWidgets.border[id] =
                              double.parse(DisplayedWidgets.input_txt),
                          FlutterError.onError = (details) {
                            DisplayedWidgets.input_ctrl.text = "";
                            DisplayedWidgets.input = false;
                            updateDisplayed();
                          },
                          DisplayedWidgets.input_ctrl.text = "",
                          DisplayedWidgets.input = false,
                          DisplayedWidgets.curr_settings_text_box[id][5] =
                              DisplayedWidgets.border[id].toString(),
                        }
                      else if (DisplayedWidgets.input_name == "BG Fill")
                          {
                            DisplayedWidgets.bgFill[id] =
                            DisplayedWidgets.bgFill[id],
                            FlutterError.onError = (details) {
                              DisplayedWidgets.input_ctrl.text = "";
                              DisplayedWidgets.input = false;
                              updateDisplayed();
                            },
                            DisplayedWidgets.input_ctrl.text = "",
                            DisplayedWidgets.input = false,
                            DisplayedWidgets.curr_settings_text_box[id][6] =
                                DisplayedWidgets.bgFill[id].toString(),
                          }
                        else if (DisplayedWidgets.input_name == "Font Size")
                            {
                              DisplayedWidgets.fontSize[id] = double.parse(DisplayedWidgets.input_txt),
                              FlutterError.onError = (details) {
                                DisplayedWidgets.input_ctrl.text = "";
                                DisplayedWidgets.input = false;
                                updateDisplayed();
                              },
                              DisplayedWidgets.input_ctrl.text = "",
                              DisplayedWidgets.input = false,
                              DisplayedWidgets.curr_settings_text_box[id][6] =
                              DisplayedWidgets.fontSize[id].toString(),
                            },
                  updateDisplayed()
                },
                child: AbsorbPointer(
                    child: ListTile(
                      title: TextField(
                        controller: DisplayedWidgets.input_ctrl,
                        focusNode: inputFocus,
                        //keyboardType: TextInputType.multiline,
                        maxLines: 1,
                        decoration: InputDecoration(
                            labelText: DisplayedWidgets.input_name,
                            // Set border for enabled state (default)
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 3, color: Colors.blue),
                            ),
                            // Set border for focused state
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 3, color: Colors.red),
                            )),
                      ),
                    ))),
          )),
    );
  });
}




  Widget _buildTextBoxSettings(BuildContext context, int id) {
    return StatefulBuilder(builder: (context, setState) {
      //if(DisplayedWidgets.dx[id])
      return Positioned(
          left: DisplayedWidgets.dx[id] - 95,
          top: DisplayedWidgets.dy[id] - 65,
          child: Visibility(
            visible: DisplayedWidgets.visibilityValuesSettings[id],
            child: SizedBox(
              width: 100,
              height: (MediaQuery.of(context).size.height) - 150,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: ((context, index) {
                  if (index > 1) {
                    temp_name = Text(
                        '${textSettings[index]}\nCurrent: ${DisplayedWidgets.curr_settings_text_box[id][index]}');
                  } else {
                    temp_name = Text(textSettings[index]);
                  }
                  return ListTile(
                    shape: const ContinuousRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                    title: temp_name,
                    onTap: () => {
                      if (textSettings[index] == "Delete Widget")
                        {
                          if (DisplayedWidgets.editing == true)
                            {
                              for (var i = 0; i < DisplayedWidgets.displayed.length; i += 1) ...[
                                if (i != id) ...[
                                  DisplayedWidgets.visibilityValues[i] = !DisplayedWidgets.visibilityValues[i]
                                ],
                              ],
                            },
                          DisplayedWidgets.displayed.removeAt(id),
                          DisplayedWidgets.names.removeAt(id),
                          DisplayedWidgets.editing = false,
                          DisplayedWidgets.height.removeAt(id),
                          DisplayedWidgets.width.removeAt(id),
                          DisplayedWidgets.border.removeAt(id),
                          DisplayedWidgets.paths.removeAt(id),
                          DisplayedWidgets.dx.removeAt(id),
                          DisplayedWidgets.dy.removeAt(id),
                          DisplayedWidgets.visibilityValuesSettings[id] = false,
                          DisplayedWidgets.visibilityValuesSettings.removeAt(id),
                          DisplayedWidgets.visibilityValues[id] = true,
                          DisplayedWidgets.input = false,
                          DisplayedWidgets.visibilityValues.removeAt(id),
                          DisplayedWidgets.text.removeAt(id),
                          DisplayedWidgets.textControllers.removeAt(id),
                          DisplayedWidgets.details.removeAt(id),
                          DisplayedWidgets.curr_settings_text_box.removeAt(id),
                          updateDisplayed(),
                        }
                      else if (textSettings[index] == "Close Menu")
                        {
                          DisplayedWidgets.editing = false,
                          DisplayedWidgets.input = false,
                          DisplayedWidgets.dx[id] = temp_dx,
                          DisplayedWidgets.dy[id] = temp_dy,
                          DragUpdateDetails(
                              globalPosition: Offset(DisplayedWidgets.dx[id],
                                  DisplayedWidgets.dy[id])),
                          DisplayedWidgets.visibilityValuesSettings[id] = !DisplayedWidgets.visibilityValuesSettings[id],
                          for (var i = 0;
                          i < DisplayedWidgets.displayed.length;
                          i += 1)
                            {
                              if (i != id)
                                {
                                  DisplayedWidgets.visibilityValues[i] = !DisplayedWidgets.visibilityValues[i]
                                },
                            },
                          updateDisplayed(),
                        }
                      else
                        {
                          if (DisplayedWidgets.input == false)
                            {
                              DisplayedWidgets.input = true,
                            },
                          DisplayedWidgets.input_name = textSettings[index],
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
          ));
    });
  }

  Widget _buildTextBox(BuildContext context, int id) {
    return StatefulBuilder(builder: (context, setState) {
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
            onTap: _enabled ? _onTap : null,
            onPanUpdate: (DragUpdateDetails e) {
              setState(() {
                offset = Offset(
                    DisplayedWidgets.details[id].delta.dx + DisplayedWidgets.dx[id],
                    DisplayedWidgets.details[id].delta.dy + DisplayedWidgets.dy[id]);
                DisplayedWidgets.dx[id] += e.delta.dx;
                DisplayedWidgets.dy[id] += e.delta.dy;
                DisplayedWidgets.details[id] = DragUpdateDetails(
                    globalPosition: Offset(
                        DisplayedWidgets.dx[id], DisplayedWidgets.dy[id]));
                updateDisplayed();
              });
            },
            child: SizedBox(
              width: DisplayedWidgets.width[id],
              height: DisplayedWidgets.height[id],
              child: Stack(
                children: <Widget>[
                  InkWell(
                      onTap: () => myFocusNode.requestFocus(),
                      onDoubleTap: () => {
                        myFocusNode.unfocus(),
                        DisplayedWidgets.text[id] =
                            DisplayedWidgets.textControllers[id].text
                      },
                      onLongPress: () => {
                        // open menu
                        if (DisplayedWidgets.visibilityValuesSettings[id] == false) ...[
                          DisplayedWidgets.editing = true,
                          DisplayedWidgets.input = false,
                          temp_dx = DisplayedWidgets.dx[id],
                          temp_dy = DisplayedWidgets.dy[id],
                          DisplayedWidgets.dx[id] = 100,
                          DisplayedWidgets.dy[id] = 70,
                          DragUpdateDetails(
                              globalPosition: Offset(
                                  DisplayedWidgets.dx[id],
                                  DisplayedWidgets.dy[id])),
                        ],
                        // close menu
                        if (DisplayedWidgets.visibilityValuesSettings[id] ==
                            true) ...[
                          DisplayedWidgets.input = false,
                          DisplayedWidgets.editing = false,
                          DisplayedWidgets.dx[id] = temp_dx,
                          DisplayedWidgets.dy[id] = temp_dy,
                          DragUpdateDetails(
                              globalPosition: Offset(
                                  DisplayedWidgets.dx[id],
                                  DisplayedWidgets.dy[id])),
                        ],

                        DisplayedWidgets.visibilityValuesSettings[id] =
                        !DisplayedWidgets.visibilityValuesSettings[id],
                        for (var i = 0;
                        i < DisplayedWidgets.displayed.length;
                        i += 1) ...[
                          if (i != id) ...[
                            DisplayedWidgets.visibilityValues[i] =
                            !DisplayedWidgets.visibilityValues[i]
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
                                        width: DisplayedWidgets.border[id],
                                        color: Colors.blue),
                                  ),
                                  // Set border for focused state
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 3, color: Colors.red),
                                  )),
                              style: TextStyle(fontSize: DisplayedWidgets.fontSize[id]),
                            ),
                          ))),
                ],
              ),
            ),
          ),
        ),
      );
    });
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
            itemCount: 2,
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

                shape: const ContinuousRectangleBorder(
                  side: BorderSide(color: Colors.black, width: 1),
                ),
                dense: true,
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                leading: Image.asset(
                  'images/${widget.imageName}',
                  width: 50,
                  height: 50,
                ),
                title: Text(widget.widgetName,
                    style: const TextStyle(fontSize: 30)),
                subtitle: Text(widget.description,
                    style: const TextStyle(fontSize: 20)),
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

  static bool new_ = true;
  @override
  Widget build(BuildContext context) {
    //int numWidgets = 1;
    int id = 0;
    //length: numWidgets,
    return StatefulBuilder(builder: (context, setState) {
      return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("notes")
              .doc(widget.id)
              .snapshots(),
          builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            // Check for errors
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }
    // Otherwise, show something whilst waiting for initialization to complete
                if(snapshot.hasData && new_ == true){
                  String filename = snapshot.data!["name"];
                  List<String> displayed_fb = List<String>.from(snapshot.data!["displayed"]);
                  List<String> names_fb = List<String>.from(snapshot.data!["names"]);
                  List<String> dx_fb = List<String>.from(snapshot.data!["dx"]);
                  List<String> dy_fb = List<String>.from(snapshot.data!["dy"]);
                  List<String> text_fb = List<String>.from(snapshot.data!["text"]);
                  List<String> bgFill_fb = List<String>.from(snapshot.data!["bgFill"]);
                  List<String> textCol_fb = List<String>.from(snapshot.data!["textCol"]);
                  List<String> fontSize_fb = List<String>.from(snapshot.data!["fontSize"]);
                  List<String> width_fb = List<String>.from(snapshot.data!["width"]);
                  List<String> height_fb = List<String>.from(snapshot.data!["height"]);
                  List<String> border_fb = List<String>.from(snapshot.data!["border"]);
                  List<String> paths_fb = List<String>.from(snapshot.data!["paths"]);
                  for (var i = 0; i < displayed_fb.length; i += 1){

                    DisplayedWidgets.displayed.add(displayed_fb[i]);
                    DisplayedWidgets.text.add(text_fb[i]);
                    DisplayedWidgets.names.add(names_fb[i]);
                    DisplayedWidgets.width.add(double.parse(width_fb[i]));
                    DisplayedWidgets.height.add(double.parse(height_fb[i]));
                    DisplayedWidgets.border.add(double.parse(border_fb[i]));
                    DisplayedWidgets.bgFill.add("white");
                    DisplayedWidgets.textCol.add("black");
                    DisplayedWidgets.fontSize.add(double.parse(fontSize_fb[i]));
                    DisplayedWidgets.dx.add(double.parse(dx_fb[i]));
                    DisplayedWidgets.dy.add(double.parse(dy_fb[i]));
                    DisplayedWidgets.paths.add(paths_fb[i]);

                    DisplayedWidgets.visibilityValuesSettings.add(false);
                    DisplayedWidgets.visibilityValues.add(true);
                    DisplayedWidgets.textControllers.add(TextEditingController());

                    DisplayedWidgets.details.add(DragUpdateDetails(globalPosition: Offset(double.parse(dx_fb[i]), double.parse(dy_fb[i]))));
                    if(displayed_fb[i] == "text"){
                      DisplayedWidgets.textControllers[i].text = text_fb[i];
                      DisplayedWidgets.curr_settings_text_box.add([]);
                      DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add(""); //holder for close menu
                      DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add(""); //holder for delete widget
                      DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add("${names_fb[i]}"); //value of name
                      DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add("${double.parse(height_fb[i])}"); // value of height
                      DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add("${double.parse(width_fb[i])}"); //value of width
                      DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add("${double.parse(border_fb[i])}"); // value of Border
                      DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add("Colors.white"); //value of BG Fill
                      DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add("${double.parse(border_fb[i])}"); //value of Text Size
                      DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add(""); // value of Text Font
                      DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add("Colors.black"); // value of Text Color
                      _buildTextBoxSettings(context, i);
                      _buildInputTextBox(context, i);
                    }
                    if(displayed_fb[i] == "image"){
                      DisplayedWidgets.curr_settings_image.add([]);
                      DisplayedWidgets.curr_settings_image[DisplayedWidgets.displayed.length - 1].add(""); //holder for close menu
                      DisplayedWidgets.curr_settings_image[DisplayedWidgets.displayed.length - 1].add(""); //holder for delete widget
                      DisplayedWidgets.curr_settings_image[DisplayedWidgets.displayed.length - 1].add(""); //holder for delete widget
                      DisplayedWidgets.curr_settings_image[DisplayedWidgets.displayed.length - 1].add("${double.parse(height_fb[i])}"); // value of height
                      DisplayedWidgets.curr_settings_image[DisplayedWidgets.displayed.length - 1].add("${double.parse(width_fb[i])}");
                      _buildTextBoxSettings(context, i);
                      _buildInputTextBox(context, i);
                    }
                    updateDisplayed();
                    new_ = false;
                  }
                }

                return Scaffold(
                  appBar: AppBar(
                    actions: [
                      IconButton(
                        icon:
                        _isNew ? Icon(Icons.save_as_rounded) : Icon(Icons.done),
                        tooltip: 'Save changes',
                        onPressed: () {
                          final snackBarSaving = SnackBar(
                            content: Text('Saving...'),
                          );
                          final snackBarSaved = SnackBar(
                            content: Text('Note saved with success'),
                          );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBarSaving);
                          _saveChanges(widget.id);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBarSaved);
                        }
                      ),
                    ],
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
                        if (TabsConfig.tabs[index] == 'text.png' &&
                            DisplayedWidgets.editing == false) {
                          new_ = false;
                          DisplayedWidgets.displayed.add('text');
                          DisplayedWidgets.names.add('Text box ${DisplayedWidgets.displayed.length}');
                          DisplayedWidgets.width.add(150);
                          DisplayedWidgets.height.add(100);
                          DisplayedWidgets.border.add(3);
                          DisplayedWidgets.bgFill.add("white");
                          DisplayedWidgets.textCol.add("black");
                          DisplayedWidgets.fontSize.add(14);
                          DisplayedWidgets.dx.add(50.0);
                          DisplayedWidgets.dy.add(100.0);
                          DisplayedWidgets.visibilityValuesSettings.add(false);
                          DisplayedWidgets.visibilityValues.add(true);
                          DisplayedWidgets.text.add("");
                          DisplayedWidgets.textControllers.add(TextEditingController());
                          DisplayedWidgets.details.add(DragUpdateDetails(globalPosition: Offset(0.0,0.0)));
                          DisplayedWidgets.paths.add("");

                          DisplayedWidgets.curr_settings_image.add([]);
                          DisplayedWidgets.curr_settings_text_box.add([]);
                          DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add(""); //holder for close menu
                          DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add(""); //holder for delete widget
                          DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add('Text box ${DisplayedWidgets.displayed.length}'); //value of name
                          DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add("100"); // value of height
                          DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add("150"); //value of width
                          DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add("3"); // value of Border
                          DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add("Colors.white"); //value of BG Fill
                          DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add("14"); //value of Text Size
                          DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add(""); // value of Text Font
                          DisplayedWidgets.curr_settings_text_box[DisplayedWidgets.displayed.length - 1].add("Colors.black"); // value of Text Color
                          updateDisplayed();
                        }
                        if(TabsConfig.tabs[index] == 'image.png'&& DisplayedWidgets.editing == false) {
                          new_ = false;
                          DisplayedWidgets.displayed.add('image');
                          DisplayedWidgets.names.add('Image ${DisplayedWidgets.displayed.length}');
                          DisplayedWidgets.width.add(150);
                          DisplayedWidgets.height.add(100);
                          DisplayedWidgets.border.add(3);
                          DisplayedWidgets.bgFill.add("white");
                          DisplayedWidgets.textCol.add("black");
                          DisplayedWidgets.fontSize.add(14);
                          DisplayedWidgets.dx.add(50.0);
                          DisplayedWidgets.dy.add(100.0);
                          DisplayedWidgets.visibilityValuesSettings.add(false);
                          DisplayedWidgets.visibilityValues.add(true);
                          DisplayedWidgets.text.add("");
                          DisplayedWidgets.textControllers.add(TextEditingController());
                          DisplayedWidgets.details.add(DragUpdateDetails(globalPosition: Offset(0.0,0.0)));
                          DisplayedWidgets.paths.add("");

                          DisplayedWidgets.curr_settings_text_box.add([]);
                          DisplayedWidgets.curr_settings_image.add([]);
                          DisplayedWidgets.curr_settings_image[DisplayedWidgets.displayed.length - 1].add(""); //holder for close menu
                          DisplayedWidgets.curr_settings_image[DisplayedWidgets.displayed.length - 1].add(""); //holder for delete widget
                          DisplayedWidgets.curr_settings_image[DisplayedWidgets.displayed.length - 1].add(""); //holder for add pic
                          DisplayedWidgets.curr_settings_image[DisplayedWidgets.displayed.length - 1].add(""); //holder for add pic
                          DisplayedWidgets.curr_settings_image[DisplayedWidgets.displayed.length - 1].add("100"); // value of height
                          DisplayedWidgets.curr_settings_image[DisplayedWidgets.displayed.length - 1].add("150"); //value of width
                          updateDisplayed();
                        }
                      },
                      controller: controller,
                      isScrollable: true,
                      tabs: List.generate(
                        TabsConfig.tabs.length,
                            (index) =>
                            Image.asset(
                              'images/${TabsConfig.tabs[index]}',
                              width: 40,
                              height: 40,
                            ),
                      ),
                    ),
                    title: Text(widget.filename),
                  ),
                  body: SizedBox.expand(
                    //need to add firebase integration here to see if widget data already exists
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            for (var i = 0; i < DisplayedWidgets.displayed.length; i += 1) ...[
                              if (DisplayedWidgets.displayed[i] == 'text') ...[
                                _buildTextBox(context, i)
                              ]
                              else if (DisplayedWidgets.displayed[i] == 'image') ...[
                                _buildImagePicker(context, i),
                              ],
                              Center(
                                child: Stack(
                                  children: <Widget>[
                                    if (DisplayedWidgets.displayed[i] == 'text') ...[
                                      _buildTextBoxSettings(context, i),
                                      _buildInputTextBox(context, i),
                                    ],
                                    if (DisplayedWidgets.displayed[i] == 'image') ...[
                                      _buildImageSettings(context, i),
                                      _buildInputImage(context, i),
                                    ],



                                  ],
                                ),
                              )
                            ],
                          ],
                        ),
                      )),
                );
              }
              );
    });
  }
  void _saveChanges(id) {
    print("Saving...");
    List<String> dx_ts = [];
    List<String> dy_ts = [];
    List<String> fontSize_ts = [];
    List<String> width_ts = [];
    List<String> height_ts = [];
    List<String> border_ts = [];
    List<String> paths_ts = [];
    for (var e = 0; e < DisplayedWidgets.displayed.length; e += 1) {
      dx_ts.add(DisplayedWidgets.dx[e].toString());
      dy_ts.add(DisplayedWidgets.dy[e].toString());
      fontSize_ts.add(DisplayedWidgets.fontSize[e].toString());
      width_ts.add(DisplayedWidgets.width[e].toString());
      height_ts.add(DisplayedWidgets.height[e].toString());
      border_ts.add(DisplayedWidgets.border[e].toString());
      paths_ts.add(DisplayedWidgets.paths[e].toString());
    }
        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("notes").doc(widget.id).update({'displayed': DisplayedWidgets.displayed});
        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("notes").doc(widget.id).update({'names': DisplayedWidgets.names});
        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("notes").doc(widget.id).update({'dx': dx_ts});
        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("notes").doc(widget.id).update({'dy': dy_ts});
        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("notes").doc(widget.id).update({'text': DisplayedWidgets.text});
        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("notes").doc(widget.id).update({'bgFill': DisplayedWidgets.bgFill});
        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("notes").doc(widget.id).update({'textCol': DisplayedWidgets.textCol});
        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("notes").doc(widget.id).update({'fontSize': fontSize_ts});
        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("notes").doc(widget.id).update({'width': width_ts});
        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("notes").doc(widget.id).update({'height': height_ts});
        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("notes").doc(widget.id).update({'border': border_ts});
        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("notes").doc(widget.id).update({'paths': paths_ts});

    print("Saved !");
  }
}

//TODO: Create fruit object parameters
// and the constructor for fromJson and static method
// toJson

class Widgets {
  final String widgetName;
  final String imageName;
  final String description;
  final bool isFavourite;
  Widgets({required this.widgetName,
         required this.imageName,
         required this.description,
         required this.isFavourite});

  Widgets.fromJson(Map<String, dynamic> json):
        widgetName = json["widget name"],
        imageName = json["image name"],
        description = json["description"],
        isFavourite = json["isFavourite"];

  static toJson(Widgets widget ) => {
    "fruit name": widget.widgetName,
    "image name": widget.imageName,
    "description": widget.description,
    "isFavourite": widget.isFavourite,
  };
}

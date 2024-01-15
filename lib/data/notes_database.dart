import 'package:hive_flutter/adapters.dart';

class NotesDataBase {
  List notesList = [];

  final _myBox = Hive.box('myBox');

//Initial data in database
  void createInitialData() {
    notesList = [
      [
        "Lorem ipsum dolor sit amet,",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt consectetur adipiidit u t enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipitUt enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipitUt"
      ],
    ];
  }

  //load the data from database
  void loadData() {
    notesList = _myBox.get("NOTELIST");
  }

  //update the database
  void updateDatabase() {
    _myBox.put("NOTELIST", notesList);
  }
}

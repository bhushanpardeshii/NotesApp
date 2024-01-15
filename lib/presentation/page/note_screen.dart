import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notepad/data/notes_database.dart';
import 'package:notepad/presentation/page/addnote.dart';
import 'package:intl/intl.dart';
import 'package:notepad/presentation/page/note_detail.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _myBox = Hive.box('myBox');
  NotesDataBase db = NotesDataBase();
  final _controllerTitel = TextEditingController();
  final _controllerNote = TextEditingController();
  List<Color> tileColors = [
    const Color(0xFFE1EDF8),
    const Color(0xFFB8FECC),
    const Color(0xFFF8E996),
    const Color(0xFFF6BFC0)
  ];
  var dateMonth = DateFormat('MMMM').format(DateTime.now());
  @override
  void initState() {
    if (_myBox.get("NOTELIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  Color getColor() {
    Random random = Random();
    int randomIndex = random.nextInt(tileColors.length);
    return tileColors[randomIndex];
  }

  void updateNote(int index, String updatedNote, String updatedTitle) {
    // Removing the original note
    db.notesList.removeAt(index);

    // Adding the updated note
    db.notesList.insert(index, [updatedTitle, updatedNote]);

    // Updating the UI
    setState(() {});

    // Navigating back to the NoteScreen
    Navigator.pop(context);
  }

  void saveNewNote() {
    setState(() {
      db.notesList.add([_controllerTitel.text, _controllerNote.text]);
      _controllerTitel.clear();
      _controllerNote.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  void createNewNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNote(
          controllerTitel: _controllerTitel,
          controllerNote: _controllerNote,
          onSave: saveNewNote,
        ),
      ),
    );
  }

  void deleteNote(int index) {
    setState(() {
      if (db.notesList.length > 1) {
        db.notesList.removeAt(index + 1);
      } else {
        db.notesList.removeAt(index);
      }
    });
    db.updateDatabase();
  }

  void navigateToNoteDetailPage(String title, String note, int index) {
    Color tileColor = getColor();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailPage(
          title: title,
          note: note,
          index: index,
          tileColor: tileColor,
          deleteNote: deleteNote,
          onUpdate: (String updatedNote, String updatedTitle) {
            // Updating the note in the database
            db.notesList.removeWhere(
              (element) => element[0] == title && element[1] == note,
            );
            db.notesList.add([updatedTitle, updatedNote]);
            // db.notesList.add([updatedTitle, updatedNote]);
            db.updateDatabase();

            // Updating the UI
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<List<dynamic>> oddNotes = [];
    List<List<dynamic>> evenNotes = [];

    for (int i = 0; i < db.notesList.length; i++) {
      if (i % 2 == 0) {
        evenNotes.add(db.notesList[i]);
      } else {
        oddNotes.add(db.notesList[i]);
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(117, 244, 244, 244),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color.fromRGBO(244, 244, 244, 0.459),
        centerTitle: true,
        title: const Text(
          'Note',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            print('Left icon button pressed');
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              icon: Image.asset('assets/Images/Filter.jpg'),
              onPressed: () {
                print('Settings button pressed');
              },
            ),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: const Color.fromARGB(117, 244, 244, 244),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: const Color.fromARGB(249, 255, 255, 255),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    suffixIcon: Image.asset(
                      'assets/Images/Icon.jpg',
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 15),
              alignment: Alignment.centerLeft,
              child: Text(
                dateMonth,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Color(0xFF043E72),
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      height: double.infinity,
                      child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: 10),
                        itemCount: evenNotes.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10);
                        },
                        itemBuilder: (context, index) {
                          final note = evenNotes[index];
                          Color tileColor = getColor();
                          return ListTile(
                            onTap: () {
                              // Navigate to note detail page
                              navigateToNoteDetailPage(note[0], note[1], index);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            contentPadding: const EdgeInsets.only(
                                top: 20, bottom: 80, left: 15, right: 15),
                            tileColor: tileColor,
                            title: Text(note[0]),
                            subtitle: Text(note[1]),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        right: 10,
                        top: 10,
                      ),
                      height: double.infinity,
                      child: ListView.separated(
                        itemCount: oddNotes.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10);
                        },
                        itemBuilder: (context, index) {
                          final note = oddNotes[index];
                          Color tileColor =
                              tileColors[index % tileColors.length];
                          return ListTile(
                            onTap: () {
                              // Navigate to note detail page
                              navigateToNoteDetailPage(note[0], note[1], index);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            contentPadding: const EdgeInsets.only(
                                top: 20, bottom: 80, left: 15, right: 15),
                            tileColor: tileColor,
                            title: Text(note[0]),
                            subtitle: Text(note[1]),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        backgroundColor: const Color(0xFF043E72),
        onPressed: createNewNote,
        tooltip: 'Add note',
        child: const Icon(Icons.add),
      ),
    );
  }
}

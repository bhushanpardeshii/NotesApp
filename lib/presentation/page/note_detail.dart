import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:notepad/data/notes_database.dart';

// ignore: must_be_immutable
class NoteDetailPage extends StatefulWidget {
  String title;
  String note;
  int index;
  Color tileColor;
  final Null Function(String updatedNote, String updatedTitle) onUpdate;
  final void Function(int index) deleteNote;

  NoteDetailPage(
      {required this.title,
      required this.note,
      required this.onUpdate,
      required this.index,
      required this.deleteNote,
      required this.tileColor});

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  NotesDataBase db = NotesDataBase();
  final TextEditingController _editController = TextEditingController();
  final TextEditingController _edittitelController = TextEditingController();
  bool isTextFieldEnabled = false;
  bool isAdditionalSpeedDialVisible = false;
  var date = DateFormat('dd MMMM ,yyyy').format(DateTime.now());
  Color containerColor = Color(0xFFE1EDF8);

  @override
  void initState() {
    super.initState();
    _editController.text = widget.note;
    _edittitelController.text = widget.title;
    widget.tileColor = widget.tileColor;
  }

  void deleteNote() {
    int index = widget.index;
    setState(() {
      if (index % 2 == 0) {
        // If it's an even index, use index directly
        db.notesList.removeAt(index);
      } else {
        // If it's an odd index, adjust it to match the evenNotes list
        db.notesList.removeAt(index - 1);
      }
    });
    db.updateDatabase();
  }

  List<SpeedDialChild> buildAdditionalSpeedDials() {
    return [
      SpeedDialChild(
          elevation: 0,
          child: const Icon(Icons.circle),
          foregroundColor: const Color(0xFFB8FECC),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          onTap: () {
            setState(() {
              containerColor = const Color(0xFFB8FECC);
            });
          }),
      SpeedDialChild(
          elevation: 0,
          child: const Icon(Icons.circle),
          foregroundColor: const Color(0xFFF8E996),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          onTap: () {
            setState(() {
              containerColor = const Color(0xFFF8E996);
            });
          }),
      SpeedDialChild(
          elevation: 0,
          child: const Icon(Icons.circle),
          foregroundColor: const Color(0xFFF6BFC0),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          onTap: () {
            setState(() {
              containerColor = const Color(0xFFF6BFC0);
            });
          }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color.fromRGBO(244, 244, 244, 0.459),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                date,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Color(0xFF043E72),
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              SpeedDial(
                overlayOpacity: 0,
                elevation: 0,
                buttonSize: const Size.fromRadius(25),
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                foregroundColor: const Color(0xFF043E72),
                icon: Icons.more_vert_outlined,
                direction: SpeedDialDirection.down,
                children: [
                  SpeedDialChild(
                      elevation: 0,
                      child: const Icon(
                        Icons.share_outlined,
                      ),
                      foregroundColor: const Color(0xFF043E72),
                      backgroundColor:
                          const Color.fromARGB(255, 255, 255, 255)),
                  SpeedDialChild(
                      elevation: 0,
                      child: const Icon(Icons.mode_edit_outlined),
                      foregroundColor: const Color(0xFF043E72),
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      onTap: () {
                        setState(() {
                          isTextFieldEnabled = !isTextFieldEnabled;
                          widget.onUpdate(
                              _editController.text, _edittitelController.text);
                        });
                      }),
                  SpeedDialChild(
                      elevation: 0,
                      child: const Icon(Icons.circle),
                      foregroundColor: containerColor,
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      onTap: () {
                        setState(() {
                          isAdditionalSpeedDialVisible =
                              !isAdditionalSpeedDialVisible;
                        });
                      }),
                  if (isAdditionalSpeedDialVisible)
                    ...buildAdditionalSpeedDials(),
                  SpeedDialChild(
                    elevation: 0,
                    child: const Icon(Icons.delete_outline_outlined),
                    foregroundColor: const Color(0xFF043E72),
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    onTap: () {
                      widget.deleteNote(widget.index);
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            ]),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 10, bottom: 100),
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _edittitelController,
                      enabled: isTextFieldEnabled,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _editController,
                      enabled: isTextFieldEnabled,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      maxLines: null,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

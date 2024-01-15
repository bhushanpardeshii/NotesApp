import 'package:flutter/material.dart';

class AddNote extends StatelessWidget {
  final TextEditingController controllerTitel;
  final TextEditingController controllerNote;
  final VoidCallback onSave;
  const AddNote({
    Key? key,
    required this.controllerTitel,
    required this.controllerNote,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusNode noteFoucus = FocusNode();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                    controller: controllerTitel,
                    autofocus: true,
                    onSubmitted: (val) {
                      if (val != "") {
                        noteFoucus.requestFocus();
                      }
                    },
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        border: InputBorder.none,
                        hintText: "Title",
                        hintStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFD9D9D9))),
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Container(
                    height: 400,
                    alignment: Alignment.topRight,
                    child: ListView(
                      children: [
                        TextField(
                          controller: controllerNote,
                          focusNode: noteFoucus,
                          maxLines: null,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              border: InputBorder.none,
                              hintText: "Write your note",
                              hintStyle: TextStyle(
                                  fontSize: 20, color: Color(0xFFFFD9D9D9))),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onSave,
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFF043E72))),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 252, 252),
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

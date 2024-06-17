import 'package:flutter/material.dart';
import 'package:simple_note_app/db/sqldb.dart';

import 'home.dart';

class EditScreen extends StatefulWidget {
  final title;
  final note;
  final id;
  const EditScreen({super.key, this.title, this.note, this.id});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  GlobalKey<FormState> myKey = GlobalKey();
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();

  Sqflite sqflite = Sqflite();

  @override
  void initState() {
    title.text = widget.title;
    note.text = widget.note;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                int response = await sqflite.update(
                    'notes',
                    {'title': title.text, 'note': note.text},
                    'id=${widget.id}');

                if (response > 0) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                      (route) => false);
                }
                print("Response : $response");
              },
              icon: const Icon(
                Icons.check,
                size: 35,
              ))
        ],
        leading: IconButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 25,
          ),
        ),
        title: const Text(
          "Edit Note",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Form(
              key: myKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: title,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Title",
                        hintStyle: TextStyle(fontSize: 25)),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        child: TextFormField(
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          controller: note,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Type Something...",
                            hintStyle: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.w300),
                          ),
                          maxLines: null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

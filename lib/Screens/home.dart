import 'package:flutter/material.dart';
import 'package:simple_note_app/Screens/editNote.dart';
import 'package:simple_note_app/constant/colors.dart';

import '../db/sqldb.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Sqflite sqflite = Sqflite();
  color colors = color();
  List notes = [];
  List<int> selectedNotes = [];
  bool isLoading = true;
  bool isSelectionMode = false;

  Future ReadData() async {
    List<Map> response = await sqflite.select('notes');
    notes.addAll(response);
    isLoading = false;
    if (this.mounted) {
      setState(() {});
    }
    return response;
  }

  @override
  void initState() {
    ReadData();
    super.initState();
  }

  void toggleSelectionMode(bool enable) {
    setState(() {
      isSelectionMode = enable;
      if (!isSelectionMode) {
        selectedNotes.clear();
      }
    });
  }

  void toggleNoteSelection(int id) {
    setState(() {
      if (selectedNotes.contains(id)) {
        selectedNotes.remove(id);
      } else {
        selectedNotes.add(id);
      }
    });
  }

  void deleteSelectedNotes() async {
    for (int id in selectedNotes) {
      await sqflite.delete('notes', 'id=$id');
    }
    setState(() {
      notes.removeWhere((note) => selectedNotes.contains(note['id']));
      selectedNotes.clear();
      isSelectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Image(
            color: Color(0xff367183), image: AssetImage('assets/icon.png')),
        title: Text(
            isSelectionMode ? "${selectedNotes.length} Selected" : "Notes"),
        actions: [
          if (isSelectionMode)
            IconButton(
              onPressed: deleteSelectedNotes,
              icon: const Icon(
                Icons.delete_outline,
                size: 30,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff367183),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).pushNamed("writeNotes");
        },
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: Text("Loading......"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, i) {
                      final Color cardColor =
                          colors.cardColors[i % colors.cardColors.length];
                      final bool isSelected =
                          selectedNotes.contains(notes[i]['id']);
                      return GestureDetector(
                        onLongPress: () {
                          toggleSelectionMode(true);
                          toggleNoteSelection(notes[i]['id']);
                        },
                        onTap: () {
                          if (isSelectionMode) {
                            toggleNoteSelection(notes[i]['id']);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditScreen(
                                  title: notes[i]['title'],
                                  note: notes[i]['note'],
                                  id: notes[i]['id'],
                                ),
                              ),
                            );
                          }
                        },
                        child: Card(
                          color: isSelected ? Colors.grey[300] : cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: SizedBox(
                            height: 110,
                            child: Row(
                              children: [
                                Container(
                                  width: 5,
                                  color:
                                      colors.colors[i % colors.colors.length],
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${notes[i]['title']}',
                                              style: TextStyle(
                                                  fontSize: 23,
                                                  color: colors.colors[
                                                      i % colors.colors.length],
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            if (!isSelectionMode)
                                              IconButton(
                                                onPressed: () async {
                                                  int response =
                                                      await sqflite.delete(
                                                          'notes',
                                                          'id=${notes[i]['id']}');
                                                  if (response > 0) {
                                                    setState(() {
                                                      notes.removeWhere(
                                                          (element) =>
                                                              element['id'] ==
                                                              notes[i]['id']);
                                                    });
                                                  }
                                                },
                                                icon: const Image(
                                                    width: 20,
                                                    height: 20,
                                                    image: AssetImage(
                                                        "assets/delete.png")),
                                              ),
                                          ],
                                        ),
                                        Text(
                                          '${notes[i]['note']}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '${notes[i]['date']}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black45,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

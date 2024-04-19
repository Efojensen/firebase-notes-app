import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_notes_app/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController newNote = TextEditingController();

  void makeNewNote({String? docID}){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: newNote
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              if (docID == null){
                firestoreService.addNote(newNote.text);
              }else{
                firestoreService.updateNote(docID, newNote.text);
              }
              // Clearing the textEditing controller
              newNote.clear();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: makeNewNote,
        child: const Icon(Icons.add)
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          // If we have data to display, we do so...
          if(snapshot.hasData){
            List notesList = snapshot.data!.docs;
            // as a list
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index){
                DocumentSnapshot document = notesList[index];
                String docId = document.id;
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String noteText = data['note'];
                return ListTile(
                  title: Text(noteText),
                  trailing: IconButton(
                    onPressed: () => makeNewNote(docID: docId),
                    icon: const Icon(Icons.settings))
                );
              }
            );
          }
          else{
            return const Text("No data to be shown.");
          }
        }
      )
    );
  }
}
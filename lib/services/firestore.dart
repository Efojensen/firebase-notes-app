import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  // This section to get a collection of notes
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  // This section to create a new note
  Future<void> addNote(String note){
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now()
    });
  }

  // This section to read a note from the database
  Stream<QuerySnapshot> getNotesStream(){
    final notesStream = notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  // This section to update an existing note using it's id
  Future<void> updateNote(String docId, String newNote){
    return notes.doc(docId).update({
      'note': newNote,
      'timestamp': Timestamp.now()
    });
  }

  // This section to delete a note using it's id
}
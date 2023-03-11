// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class FbFireStoreController {
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
//
//   //CRUD
//   Future<bool> create({required Note note}) async {
//     return await _firebaseFirestore
//         .collection('Notes')
//         .add(note.toMap())
//         .then((DocumentReference value) {
//       print(value.id);
//       return true;
//     }).onError((error, stackTrace) => false);
//   }
//
//   Future<bool> delete({required String path}) async {
//     return await _firebaseFirestore
//         .collection('Notes')
//         .doc(path)
//         .delete()
//         .then((value) => true)
//         .onError((error, stackTrace) => false);
//   }
//
//   Future<bool> update({required Note updatedNote}) async {
//     return await _firebaseFirestore
//         .collection('Notes')
//         .doc(updatedNote.path)
//         .update(updatedNote.toMap())
//         .then((value) => true)
//         .onError((error, stackTrace) => false);
//   }
//
//   Stream<QuerySnapshot<Note>> read() async* {
//     // await _firebaseFirestore.collection('Notes').get();
//     // yield* _firebaseFirestore.collection('Notes').snapshots();
//     yield* _firebaseFirestore
//         .collection('Notes')
//         .withConverter<Note>(
//             fromFirestore: (snapshot, options) => Note.fromMap(snapshot.data()!),
//             toFirestore: (Note value, options) => value.toMap())
//         .snapshots();
//   }
// }

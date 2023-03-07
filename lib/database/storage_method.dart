import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class StorageMethodsClass {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method for adding image to firbase Storage
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool ispost) async {
    Reference ref = _storage.ref().child(childName).child(
        _auth.currentUser!.uid); // to make directories in  firbase Storage

    if (ispost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask =
        ref.putData(file); // to put the data in that direction
    TaskSnapshot snap = await uploadTask;
    var downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}

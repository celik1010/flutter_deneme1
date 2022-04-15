import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadMedia(File file, String directory) async {
    var uploadTask = _firebaseStorage
        .ref(directory)
        .child(
        "${DateTime.now().millisecondsSinceEpoch}.${file.path.split('.').last}")
        .putFile(file);

    uploadTask.snapshotEvents.listen((event) {});

    var storageRef = await uploadTask;

    return await storageRef.ref.getDownloadURL();
  }
}
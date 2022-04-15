import 'package:cloud_firestore/cloud_firestore.dart';

class GeneralService {
  setListToDocument(CollectionReference _refCollection, String docId,
      Map<String,dynamic> listMap) async {
    await _refCollection
        .doc(docId)
        .set(listMap, SetOptions(merge: true))
        .then((value) => print("ok"));
  }
}

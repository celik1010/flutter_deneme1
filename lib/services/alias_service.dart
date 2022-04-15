import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_deneme/constants/alias_field_names.dart';
import 'package:flutter_deneme/constants/type_enums.dart';
import 'package:flutter_deneme/model/alias.dart';
import 'package:flutter_deneme/util/response_model.dart';

class AliasService {
  final CollectionReference _aliasReference =
      FirebaseFirestore.instance.collection('aliasses');

  Future<ResponseEntity> createAlias(AliasModel aliasValues) async {
    ResponseEntity responseEntity = ResponseEntity(0, "", "");
    if (AliasType.ARTIST == aliasValues.type) {
      await isExistAliasName(aliasValues.aliasName).then((isExist) async {
        if (isExist) {
          responseEntity =
              ResponseEntity(404, "An Artist alias has to be unique", "");
        } else {
          await addAlias(aliasValues.toJson()).then((value) {
            responseEntity = value;
          }).catchError((onError) {
            responseEntity = ResponseEntity(200, "Failed to add alias", "");
          });
        }
      });
    } else {
      await addAlias(aliasValues.toJson()).then((value) {
        responseEntity = value;
      }).catchError((onError) {
        responseEntity = ResponseEntity(200, "Failed to add alias", "");
      });
    }
    return responseEntity;
  }

  Future<ResponseEntity> addAlias(aliasValues) async {
    ResponseEntity responseEntity = ResponseEntity(0, "", "");
    await _aliasReference.add(aliasValues).then((value) {
      responseEntity = ResponseEntity(200, "Alias Created", value);
    }).catchError((error) {
      responseEntity = ResponseEntity(200, "Failed to add alias", "");
    });
    return responseEntity;
  }

  Future<String?> changePrimaryAlias(newPrAliasId, oldPrAliasId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    print("new" + newPrAliasId);
    print("old" + oldPrAliasId);
    batch.update(_aliasReference.doc(newPrAliasId),
        {AliasFieldNames.ALIAS_ISPRIMARY: true});
    batch.update(_aliasReference.doc(oldPrAliasId),
        {AliasFieldNames.ALIAS_ISPRIMARY: false});
    batch.commit().then((value) {
      print("Primary alias was changed.");
      return "Primary alias was changed.";
    }).catchError((onError) {
      print("Primary alias could not changed.");
      return "Primary alias could not changed.";
    });
  }

  Future<ResponseEntity<List<AliasModel>>> getAliassesByUserId(userId) async {
    final aliasses = <AliasModel>[];
    QuerySnapshot qSnapshot = await _aliasReference
        .where(AliasFieldNames.ALIAS_USERID, isEqualTo: userId)
        .get();
    if (qSnapshot.size == 0) {
      return ResponseEntity(404, "Record Not Found", <AliasModel>[]);
    } else {
      for (int i = 0; i < qSnapshot.size; i++) {
        aliasses.add(AliasModel.fromSnapshot(qSnapshot.docs[i]));
      }
      return ResponseEntity(200, "Successful", aliasses);
    }
  }

  Future<ResponseEntity> getAliasProfileByAliasId(aliasId) async {
    DocumentSnapshot aliasDataSnapShot =
        await _aliasReference.doc(aliasId).get();
    if (aliasDataSnapShot.exists) {
      return ResponseEntity(
          200, "Successful", AliasModel.fromSnapshot(aliasDataSnapShot));
    } else {
      return ResponseEntity(404, "Record Not Found", "");
    }
  }

  Future<bool> isExistAliasName(String aliasName) async {
    QuerySnapshot qSnapshot = await _aliasReference
        .where(AliasFieldNames.ALIAS_ALIASNAME, isEqualTo: aliasName)
        .where(AliasFieldNames.ALIAS_TYPE, isEqualTo: AliasType.ARTIST) //
        .get();
    if (qSnapshot.size == 0) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> deleteAlias(String docId) async {
    //Primary İse silemezzz!
    bool result = false;
    await _aliasReference
        .doc(docId)
        .delete()
        .then((value) => result = true)
        .catchError((error) => result = true);
    return result;
  }

  Future<ResponseEntity> updateAlias(
      String aliasId, Map<String, dynamic> aliasValues) async {
    ResponseEntity responseEntity = ResponseEntity(0, "", "");

    await _aliasReference.doc(aliasId).update(aliasValues).then((value) {
      responseEntity = ResponseEntity(200, "Sucsessfully updated", aliasId);
    }).catchError((onError) {
      responseEntity = ResponseEntity(404, "Could not Updated", "");
    });
    return responseEntity;
  }

  Future<ResponseEntity<AliasModel?>> getIndustryProffAliasByUserId(
      String _userId) async {
    QuerySnapshot qSnapshot = await _aliasReference
        .where(AliasFieldNames.ALIAS_USERID, isEqualTo: _userId)
        .where(AliasFieldNames.ALIAS_TYPE, isEqualTo: 1)
        .get();
    if (qSnapshot.size == 0) {
      return ResponseEntity(404, "Record Not Found", null);
    } else {
      return ResponseEntity(
          200, "Successful", AliasModel.fromSnapshot(qSnapshot.docs[0]));
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_deneme/constants/alias_field_names.dart';
import 'package:flutter_deneme/constants/follow_field_names.dart';
import 'package:flutter_deneme/model/follow.dart';
import 'package:flutter_deneme/services/alias_service.dart';
import 'package:flutter_deneme/util/response_model.dart';

class FollowService {
  final CollectionReference _followReference = FirebaseFirestore.instance
      .collection(FollowFieldNames.FOLLOW_COLLECTION_NAME);
  final CollectionReference _aliasReference = FirebaseFirestore.instance
      .collection(AliasFieldNames.ALIAS_COLLECTION_NAME);

  Future<ResponseEntity> addFollow(FollowModel followValues) async {
    ResponseEntity responseEntity = ResponseEntity(0, "", "");
    await _followReference.add(followValues.toJson()).then((value) {
      responseEntity = ResponseEntity(200, "Successfully follo request", "");
    }).catchError(
        (onError) => responseEntity = ResponseEntity(404, "Error", ""));
    return responseEntity;
  }

  Future<ResponseEntity> removeFollow(String sourceId, String targetId) async {
    ResponseEntity responseEntity = ResponseEntity(0, "", "");
    await getFollowInfos(sourceId, targetId).then((valueFollowInfo) async {
      if (valueFollowInfo.status == 200) {
        if (valueFollowInfo.data.isRequest) {
          await deleteFollow(valueFollowInfo.data.followId)
              .then((value) => responseEntity = value)
              .catchError((onError) => print("Error"));
        } else {
          await AliasService().getAliasProfileByAliasId(targetId).then((value) {
            WriteBatch batch = FirebaseFirestore.instance.batch();
            print("Sayı : " + value.data.numOfFollowers.toString());
            batch.delete(_followReference.doc(valueFollowInfo.data.followId));
            batch.update(_aliasReference.doc(targetId), {
              AliasFieldNames.ALIAS_NUMOFFOLLWERS: value.data.numOfFollowers - 1
            });
            batch.commit().then((value) {
              responseEntity = ResponseEntity(200, "success unfollow", "");
            }).catchError((onError) => print("error"));
          }).catchError((onError) => print(onError));
        }
      }
    });

    return responseEntity;
  }

  Future<ResponseEntity> getFollowInfos(String sourceId, String targtId) async {
    QuerySnapshot qSnapshot = await _followReference
        .where(FollowFieldNames.FOLLOW_SOURCEID, isEqualTo: sourceId)
        .where(FollowFieldNames.FOLLOW_TARGETID, isEqualTo: targtId)
        .get();
    if (qSnapshot.size == 0) {
      return ResponseEntity(404, "Record Not Found", "");
    } else {
      return ResponseEntity(
          200, "Successful", FollowModel.fromSnapshot(qSnapshot.docs[0]));
    }
  }

  Future<ResponseEntity> acceptFollow(String followRefId) async {
    ResponseEntity responseEntity = ResponseEntity(0, "", "");
    await _followReference
        .doc(followRefId)
        .update({FollowFieldNames.FOLLOW_ISREQUEST: false}).then((value) {
      responseEntity = ResponseEntity(200, "Accepted", "");
    }).catchError((onError) {
      responseEntity = ResponseEntity(404, "Could not accepted", "");
    });
    return responseEntity;
  }

  Future<ResponseEntity> deleteFollow(String followDocId) async {
    ResponseEntity responseEntity = ResponseEntity(0, "", "");
    await _followReference
        .doc(followDocId)
        .delete()
        .then((value) =>
            responseEntity = ResponseEntity(200, "Successfully deleted", ""))
        .catchError(
            (onError) => responseEntity = ResponseEntity(404, "Error", ""));
    return responseEntity;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_deneme/constants/labelconstants/label_field_names.dart';
import 'package:flutter_deneme/constants/labelconstants/label_members_field_names.dart';
import 'package:flutter_deneme/model/labels/label.dart';
import 'package:flutter_deneme/model/labels/label_member.dart';
import 'package:flutter_deneme/model/labels/label_view.dart';
import 'package:flutter_deneme/services/alias_service.dart';
import 'package:flutter_deneme/services/label/label_member_service.dart';
import 'package:flutter_deneme/util/response_model.dart';
import 'package:uuid/uuid.dart';

class LabelService {
  var uuid = const Uuid();
  final AliasService _aliasService = AliasService();
  final CollectionReference _labelReference =
      FirebaseFirestore.instance.collection(LabelFieldNames.collectionName);
  final LabelMemberService _memberService = LabelMemberService();
  final CollectionReference _labelMembersReference = FirebaseFirestore.instance
      .collection(LabelMembersFieldNames.collectionName);

  Future<ResponseEntity> createNewLabel(
      LabelModel labelModel, String ownerAliasId) async {
    ResponseEntity responseEntity = ResponseEntity(0, "", "");
    await _isExistLabelName(labelModel.labelName).then((isExistResponse) async {
      if (isExistResponse.status == 200) {
        responseEntity = ResponseEntity(404, "Label name already exists", "");
      } else {
        WriteBatch batch = FirebaseFirestore.instance.batch();
        String labelId = uuid.v1();
        String labelMemberId = uuid.v1();
        LabelMemberModel labelMember = LabelMemberModel.withFields("", labelId,
            ownerAliasId, labelModel.userId, 0, false, DateTime.now());

        batch.set(_labelReference.doc(labelId), labelModel.toJson());
        batch.set(
            _labelMembersReference.doc(labelMemberId), labelMember.toJson());
        await batch.commit().then((value) {
          responseEntity = ResponseEntity(200, "succesfull", null);
        }).catchError((onError) {
          responseEntity = ResponseEntity(404, "error", null);
        });
      }
    });
    return responseEntity;
  }

  Future<ResponseEntity<List<LabelModel>?>> getLabelsByUser(
      String _userId) async {
    final labelviewmodels = <LabelViewModel>[];
    ResponseEntity<List<LabelModel>?> responseEntity =
        ResponseEntity(0, "", null);
    await _memberService.getMembershipsByUserId(_userId).then((value) async {
      if (value.status == 200) {
        List<LabelMemberModel> labelMembers = value.data;
        List<String> labelIdList = [];
        for (var member in labelMembers) {
          labelIdList.add(member.labelId);
        }
        QuerySnapshot qSnapshot = await _labelReference
            .where(FieldPath.documentId, whereIn: labelIdList)
            .get();
        if (qSnapshot.size == 0) {
          return ResponseEntity(404, "Record Not Found", <LabelMemberModel>[]);
        } else {
          for (int i = 0; i < qSnapshot.size; i++) {
            LabelModel labelModel = LabelModel.fromSnapshot(qSnapshot.docs[i]);
            int role = labelMembers
                .firstWhere((e) => e.labelId == labelModel.labelId)
                .memberRole;
            labelviewmodels.add(LabelViewModel.withFields(
                labelModel.userId,
                labelModel.labelId,
                labelModel.labelName,
                labelModel.profileImagePath,
                role));
            print(labelviewmodels[i].labelName +
                "/" +
                labelviewmodels[i].labelRole.toString());
          }
          return ResponseEntity(200, "Successful", labelviewmodels);
        }
      }
    });
    return responseEntity;
  }

  Future<ResponseEntity> _isExistLabelName(String _labelName) async {
    QuerySnapshot qSnapshot = await _labelReference
        .where(LabelFieldNames.labelName, isEqualTo: _labelName)
        .get();
    if (qSnapshot.size == 0) {
      return ResponseEntity(
          404,
          "LocaleKeys.alias_service_messages_primary_aliasname_not_exist.locale!",
          false);
    } else {
      return ResponseEntity(
          200,
          "LocaleKeys.alias_service_messages_primary_aliasname_exists.locale!",
          true);
    }
  }

  Future<ResponseEntity> updateLabel(
      String labelId, Map<String, dynamic> labelValues) async {
    ResponseEntity responseEntity = ResponseEntity(0,
        "LocaleKeys.general_messages_default_response_message.locale!", null);
    await _labelReference.doc(labelId).update(labelValues).then((value) {
      responseEntity = ResponseEntity(
          200,
          "LocaleKeys.general_messages_complated_successfully.locale!",
          labelId);
    }).catchError((onError) {
      responseEntity = ResponseEntity(
          404, "LocaleKeys.general_messages_general_error.locale!", null);
    });
    return responseEntity;
  }

  //Alias labeller listeleme ekranı
  Future<ResponseEntity<List<LabelModel>>> searchLabel(
      String labelName, bool isAllResult) async {
    final labels = <LabelModel>[];
    Query query = _labelReference.where(LabelFieldNames.labelName,
        isGreaterThanOrEqualTo: labelName);
    if (!isAllResult) {
      query = query.limit(5);
    }
    QuerySnapshot qSnapshot = await query.get();
    if (qSnapshot.size == 0) {
      return ResponseEntity(404, "Record Not Found", <LabelModel>[]);
    } else {
      for (int i = 0; i < qSnapshot.size; i++) {
        labels.add(LabelModel.fromSnapshot(qSnapshot.docs[i]));
      }
      return ResponseEntity(200, "Successful", labels);
    }
  }

  Future<ResponseEntity<bool>> deleteLabel(String labelId) async {
    ResponseEntity<bool> responseEntity = ResponseEntity(0, "", false);
    await _labelReference
        .doc(labelId)
        .delete()
        .then((value) => responseEntity = ResponseEntity(200, "", true))
        .catchError((error) => responseEntity = ResponseEntity(404, "", false));
    return responseEntity;
  }
}

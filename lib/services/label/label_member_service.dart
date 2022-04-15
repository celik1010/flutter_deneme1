import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_deneme/constants/labelconstants/label_members_field_names.dart';
import 'package:flutter_deneme/model/alias.dart';
import 'package:flutter_deneme/model/labels/label_member.dart';
import 'package:flutter_deneme/util/response_model.dart';
import 'package:uuid/uuid.dart';

class LabelMemberService {
  var uuid = const Uuid();
  final CollectionReference _labelMembersReference = FirebaseFirestore.instance
      .collection(LabelMembersFieldNames.collectionName);

  Future<ResponseEntity<List<LabelMemberModel>>> getMembershipsByUserId(
      String userId) async {
    final memberShips = <LabelMemberModel>[];
    QuerySnapshot qSnapshot = await _labelMembersReference
        .where(LabelMembersFieldNames.memberUserId, isEqualTo: userId)
        .where(LabelMembersFieldNames.memberRole,
            isNotEqualTo: 3) //sigatory olmayanlar
        .get();
    if (qSnapshot.size == 0) {
      return ResponseEntity(404, "Record Not Found", <LabelMemberModel>[]);
    } else {
      for (int i = 0; i < qSnapshot.size; i++) {
        memberShips.add(LabelMemberModel.fromSnapshot(qSnapshot.docs[i]));
      }
      return ResponseEntity(200, "Successful", memberShips);
    }
  }

  Future<ResponseEntity<List<LabelMemberModel>>> getMembershipsByLabelId(
      String _labelId, int _memberRole, bool _isRequest) async {
    //memberrole enum olacak
    final memberShips = <LabelMemberModel>[];
    QuerySnapshot qSnapshot = await _labelMembersReference
        .where(LabelMembersFieldNames.labelId, isEqualTo: _labelId)
        .where(LabelMembersFieldNames.memberRole, isEqualTo: _memberRole)
        .where(LabelMembersFieldNames.isRequest, isEqualTo: _isRequest)
        .get();
    if (qSnapshot.size == 0) {
      return ResponseEntity(404, "Record Not Found", <LabelMemberModel>[]);
    } else {
      for (int i = 0; i < qSnapshot.size; i++) {
        memberShips.add(LabelMemberModel.fromSnapshot(qSnapshot.docs[i]));
      }
      return ResponseEntity(200, "Successful", memberShips);
    }
  }

  Future<ResponseEntity<String?>> transferOwnerShip(
      String oldMemberId, String labelId, AliasModel newOwnerAlias) async {
    ResponseEntity<String?> responseEntity = ResponseEntity(0, "", "");
    WriteBatch batch = FirebaseFirestore.instance.batch();
    String newLabelMemberId = uuid.v1();
    LabelMemberModel labelMember = LabelMemberModel.withFields("", labelId,
        newOwnerAlias.aliasId, newOwnerAlias.userId, 0, false, DateTime.now());

    Map<String, dynamic> oldMemberRole = {};
    oldMemberRole[LabelMembersFieldNames.memberRole] = 1; //Staff enum olacak

    batch.set(_labelMembersReference.doc(oldMemberId), oldMemberRole);
    batch.set(
        _labelMembersReference.doc(newLabelMemberId), labelMember.toJson());
    await batch.commit().then((value) {
      responseEntity =
          ResponseEntity(200, "succesfull", newOwnerAlias.aliasName);
    }).catchError((onError) {
      responseEntity = ResponseEntity(404, "error", null);
    });
    return responseEntity;
  }
}

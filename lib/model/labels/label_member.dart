import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_deneme/constants/labelconstants/label_field_names.dart';
import 'package:flutter_deneme/constants/labelconstants/label_members_field_names.dart';

class LabelMemberModel {
  String labelMemberId = "";
  String labelId = "";
  String memberAliasId = "";
  String memberUserId = "";
  int memberRole = 0;
  bool isRequest = false;
  DateTime createdDate = DateTime.now();

  LabelMemberModel.withFields(this.labelMemberId, this.labelId,
      this.memberAliasId, this.memberUserId, this.memberRole,this.isRequest, this.createdDate);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[LabelMembersFieldNames.labelId] = labelId;
    data[LabelMembersFieldNames.memberAliasId] = memberAliasId;
    data[LabelMembersFieldNames.memberUserId] = memberUserId;
    data[LabelMembersFieldNames.isRequest] = isRequest;
    data[LabelMembersFieldNames.memberRole] = memberRole;
    data[LabelMembersFieldNames.createdDate] = createdDate;
    return data;
  }

  factory LabelMemberModel.fromSnapshot(DocumentSnapshot snapshot) {
    return LabelMemberModel.withFields(
        snapshot.id,
        snapshot[LabelMembersFieldNames.labelId],
        snapshot[LabelMembersFieldNames.memberAliasId],
        snapshot[LabelMembersFieldNames.memberUserId],
        snapshot[LabelMembersFieldNames.memberRole],
        snapshot[LabelMembersFieldNames.isRequest],
        (snapshot[LabelFieldNames.createdDate] as Timestamp).toDate());
  }
}

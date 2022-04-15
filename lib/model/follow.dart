import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_deneme/constants/follow_field_names.dart';

class FollowModel {
  String followId = "";
  String sourceId = "";
  String targetId = "";
  bool isRequest = true;
  DateTime createdDate = DateTime.now();

  FollowModel.withFields(this.followId, this.sourceId, this.targetId,
      this.isRequest, this.createdDate);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[FollowFieldNames.FOLLOW_SOURCEID] = sourceId;
    data[FollowFieldNames.FOLLOW_TARGETID] = targetId;
    data[FollowFieldNames.FOLLOW_ISREQUEST] = isRequest;
    data[FollowFieldNames.FOLLOW_CREATEDATE] = createdDate;
    return data;
  }

  factory FollowModel.fromSnapshot(DocumentSnapshot snapshot) {
    return FollowModel.withFields(
        snapshot.id,
        snapshot[FollowFieldNames.FOLLOW_SOURCEID],
        snapshot[FollowFieldNames.FOLLOW_TARGETID],
        snapshot[FollowFieldNames.FOLLOW_ISREQUEST],
        (snapshot[FollowFieldNames.FOLLOW_CREATEDATE] as Timestamp).toDate());
  }
}

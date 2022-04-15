import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_deneme/constants/labelconstants/label_field_names.dart';

class LabelModel {
  String userId = "";
  String labelId = "";
  String labelName = "";
  String bioDesc = "";
  String profileImagePath = "";
  int numOfTracks = 0;
  int numOfFollowers = 0;
  int numOfArtists = 0;
  DateTime createdDate = DateTime.now();

  LabelModel.withFields(
      this.userId,
      this.labelId,
      this.labelName,
      this.bioDesc,
      this.profileImagePath,
      this.numOfTracks,
      this.numOfFollowers,
      this.numOfArtists,
      this.createdDate);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[LabelFieldNames.userId] = userId;
    data[LabelFieldNames.labelName] = labelName;
    data[LabelFieldNames.bioDescription] = bioDesc;
    data[LabelFieldNames.labelProfileImagePath] = profileImagePath;
    data[LabelFieldNames.numOfTracks] = numOfTracks;
    data[LabelFieldNames.numOfFollowers] = numOfFollowers;
    data[LabelFieldNames.numOfArtists] = numOfArtists;
    data[LabelFieldNames.createdDate] = createdDate;
    return data;
  }

  factory LabelModel.fromSnapshot(DocumentSnapshot snapshot) {
    return LabelModel.withFields(
        snapshot[LabelFieldNames.userId],
        snapshot.id,
        snapshot[LabelFieldNames.labelName],
        snapshot[LabelFieldNames.bioDescription],
        snapshot[LabelFieldNames.labelProfileImagePath],
        snapshot[LabelFieldNames.numOfTracks],
        snapshot[LabelFieldNames.numOfFollowers],
        snapshot[LabelFieldNames.numOfArtists],
        (snapshot[LabelFieldNames.createdDate] as Timestamp).toDate());
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/alias_field_names.dart';

class AliasModel {
  String userId = "";
  String aliasId = "";
  String aliasName = "";
  int type = 0;
  bool isPrimary = false;
  bool isIncognito = false;
  String bioDesc = "";
  String profileImagePath = "";
  int numOfTracks = 0;
  int numOfFollowers = 0;
  int totalCredits = 0;
  DateTime createdDate = DateTime.now();

  AliasModel();

  AliasModel.withFields(
      this.userId,
      this.aliasId,
      this.aliasName,
      this.type,
      this.isPrimary,
      this.isIncognito,
      this.bioDesc,
      this.profileImagePath,
      this.numOfTracks,
      this.numOfFollowers,
      this.totalCredits,
      this.createdDate);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[AliasFieldNames.ALIAS_USERID] = userId;
    data[AliasFieldNames.ALIAS_ALIASNAME] = aliasName;
    data[AliasFieldNames.ALIAS_TYPE] = type;
    data[AliasFieldNames.ALIAS_ISPRIMARY] = isPrimary;
    data[AliasFieldNames.ALIAS_ISINCOGNITO] = isIncognito;
    data[AliasFieldNames.ALIAS_BIODESCRIPTION] = bioDesc;
    data[AliasFieldNames.ALIAS_PROFILEIMAGEPATH] = profileImagePath;
    data[AliasFieldNames.ALIAS_NUMOFTRACKS] = numOfTracks;
    data[AliasFieldNames.ALIAS_NUMOFFOLLWERS] = numOfFollowers;
    data[AliasFieldNames.ALIAS_TOTALCREDITS] = totalCredits;
    data[AliasFieldNames.ALIAS_CREATEDATE] = createdDate;
    return data;
  }

  factory AliasModel.fromSnapshot(DocumentSnapshot snapshot) {
    return AliasModel.withFields(
        snapshot[AliasFieldNames.ALIAS_USERID],
        snapshot.id,
        snapshot[AliasFieldNames.ALIAS_ALIASNAME],
        snapshot[AliasFieldNames.ALIAS_TYPE],
        snapshot[AliasFieldNames.ALIAS_ISPRIMARY],
        snapshot[AliasFieldNames.ALIAS_ISINCOGNITO],
        snapshot[AliasFieldNames.ALIAS_BIODESCRIPTION],
        snapshot[AliasFieldNames.ALIAS_PROFILEIMAGEPATH],
        snapshot[AliasFieldNames.ALIAS_NUMOFTRACKS],
        snapshot[AliasFieldNames.ALIAS_NUMOFFOLLWERS],
        snapshot[AliasFieldNames.ALIAS_TOTALCREDITS],
        (snapshot[AliasFieldNames.ALIAS_CREATEDATE] as Timestamp).toDate());
  }
}

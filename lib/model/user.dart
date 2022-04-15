import 'package:flutter_deneme/constants/user_field_names.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userId = "";
  String userName = "";
  String firstName = "";
  String middleName = "";
  String lastName = "";
  String email = "";
  DateTime birthOfDate = DateTime.now();
  int sex = 0;
  bool isVerified = false;
  DateTime createdDate = DateTime.now();
  String signatureImagePath = "";
  String nationality = "";
  String residency = "";

  UserModel();

  UserModel.WithFields(
      this.userId,
      this.userName,
      this.firstName,
      this.middleName,
      this.lastName,
      this.email,
      this.birthOfDate,
      this.sex,
      this.isVerified,
      this.createdDate,
      this.signatureImagePath,
      this.nationality,
      this.residency);

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json[UserFieldNames.USERS_USERID];
    userName = json[UserFieldNames.USERS_USERNAME];
    firstName = json[UserFieldNames.USERS_FIRSTNAME];
    middleName = json[UserFieldNames.USERS_MIDDLENAME];
    lastName = json[UserFieldNames.USERS_LASTNAME];
    email = json[UserFieldNames.USERS_EMAIL];
    birthOfDate = json[UserFieldNames.USERS_BIRTHOFDATE];
    sex = json[UserFieldNames.USERS_SEX];
    isVerified = json[UserFieldNames.USERS_ISVERIFIED];
    createdDate = json[UserFieldNames.USERS_CREATEDATE];
    signatureImagePath = json[UserFieldNames.USERS_SIGNATUREPATH];
    nationality = json[UserFieldNames.USERS_NATIONALITY];
    residency = json[UserFieldNames.USERS_RESIDENCY];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[UserFieldNames.USERS_USERID] = userId;
    data[UserFieldNames.USERS_USERNAME] = userName;
    data[UserFieldNames.USERS_FIRSTNAME] = firstName;
    data[UserFieldNames.USERS_MIDDLENAME] = middleName;
    data[UserFieldNames.USERS_LASTNAME] = lastName;
    data[UserFieldNames.USERS_EMAIL] = email;
    data[UserFieldNames.USERS_BIRTHOFDATE] = birthOfDate;
    data[UserFieldNames.USERS_SEX] = sex;
    data[UserFieldNames.USERS_ISVERIFIED] = isVerified;
    data[UserFieldNames.USERS_CREATEDATE] = createdDate;
    data[UserFieldNames.USERS_SIGNATUREPATH] = signatureImagePath;
    data[UserFieldNames.USERS_NATIONALITY] = nationality;
    data[UserFieldNames.USERS_RESIDENCY] = residency;
    return data;
  }

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    return UserModel.WithFields(
        snapshot[UserFieldNames.USERS_USERID],
        snapshot[UserFieldNames.USERS_USERNAME],
        snapshot[UserFieldNames.USERS_FIRSTNAME],
        snapshot[UserFieldNames.USERS_MIDDLENAME],
        snapshot[UserFieldNames.USERS_LASTNAME],
        snapshot[UserFieldNames.USERS_EMAIL],
        (snapshot[UserFieldNames.USERS_BIRTHOFDATE] as Timestamp).toDate(),
        snapshot[UserFieldNames.USERS_SEX],
        snapshot[UserFieldNames.USERS_ISVERIFIED],
        (snapshot[UserFieldNames.USERS_CREATEDATE] as Timestamp).toDate(),
        snapshot[UserFieldNames.USERS_SIGNATUREPATH],
        snapshot[UserFieldNames.USERS_NATIONALITY],
        snapshot[UserFieldNames.USERS_RESIDENCY]);
  }
}

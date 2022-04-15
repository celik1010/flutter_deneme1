import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_deneme/constants/social_media_field_names.dart';

class SocialMediaModel {
  String aliasId = "";
  int socialMediaType = 0;
  String link = "";

  SocialMediaModel();

  SocialMediaModel.withFields(this.aliasId, this.socialMediaType, this.link);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[SocialMediaFieldNames.SOCIALMEDIA_ALIASID] = aliasId;
    data[SocialMediaFieldNames.SOCIALMEDIA_SOCIALMEDIATYPE] = socialMediaType;
    data[SocialMediaFieldNames.SOCIALMEDIA_LINK] = link;
    return data;
  }

  factory SocialMediaModel.fromSnapshot(DocumentSnapshot snapshot) {
    return SocialMediaModel.withFields(
        snapshot.id,
        snapshot[SocialMediaFieldNames.SOCIALMEDIA_SOCIALMEDIATYPE],
        snapshot[SocialMediaFieldNames.SOCIALMEDIA_LINK]);
  }
}

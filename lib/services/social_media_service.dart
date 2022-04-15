import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_deneme/constants/alias_field_names.dart';
import 'package:flutter_deneme/constants/social_media_field_names.dart';
import 'package:flutter_deneme/model/social_media.dart';
import 'package:flutter_deneme/util/response_model.dart';

class AliasService {
  final CollectionReference _aliasReference = FirebaseFirestore.instance
      .collection(AliasFieldNames.ALIAS_COLLECTION_NAME);

  Future<void> setSocialMediaToAlias(SocialMediaModel socialMediaModel) async {
    CollectionReference _socialMediaReference = _aliasReference
        .doc(socialMediaModel.aliasId)
        .collection(SocialMediaFieldNames.SOCIALMEDIA_COLLECTION_NAME);
  }
}

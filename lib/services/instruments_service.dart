import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_deneme/constants/instruments_field_names.dart';
import 'package:flutter_deneme/model/alias_instruments.dart';
import 'package:flutter_deneme/model/general_service.dart';

class InstrumentsService {
  GeneralService _generalService = GeneralService();

  final CollectionReference _instrumentsReference = FirebaseFirestore.instance
      .collection(InstrumentsFieldNames.collectionName);

  setInstrumentsToAlias(InstrumentsModel _instrumentsModel) async {
    await _generalService
        .setListToDocument(_instrumentsReference, _instrumentsModel.aliasId,
            _instrumentsModel.toJson())
        .then((value) => print("ok"));
  }
}

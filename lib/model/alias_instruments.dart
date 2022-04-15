import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_deneme/constants/instruments_field_names.dart';

class InstrumentsModel {
  String aliasId = "";
  List<String> instruments = <String>[];

  InstrumentsModel.withFields(this.aliasId,this.instruments);

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[InstrumentsFieldNames.instruments] = instruments;
    return data;
  }

  factory InstrumentsModel.fromSnapshot(DocumentSnapshot snapshot) {
    return InstrumentsModel.withFields(
        snapshot.id,
        snapshot[InstrumentsFieldNames.instruments]
        );
  }
}

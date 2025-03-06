import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Alert with ChangeNotifier {
  String? id;
  bool above;
  String coinId;
  String coinImage;
  String coinSymbol;
  double targetPrice;
  DateTime createdAt;

  Alert(
      this.above,
      this.coinId,
      this.coinImage,
      this.coinSymbol,
      this.targetPrice,
      {DateTime? createdAt, this.id}) : createdAt = createdAt ?? DateTime.now();

  Alert.fromMap(Map<String, dynamic> map, String documentId)
      : above = map["above"],
        coinId = map["coinId"],
        coinImage = map["coinImage"],
        coinSymbol = map["coinSymbol"],
        targetPrice = map["targetPrice"],
        createdAt = (map["createdAt"] as Timestamp?)?.toDate() ?? DateTime.now(),
        id = documentId;

  Map<String, dynamic> toMap() {
    return {
      "above": above,
      "coinId": coinId,
      "coinImage": coinImage,
      "coinSymbol": coinSymbol,
      "targetPrice": targetPrice,
      "createdAt": Timestamp.fromDate(createdAt),
      "id": id,
    };
  }


}
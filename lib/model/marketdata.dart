import 'package:flutter/material.dart';

class Marketdata with ChangeNotifier{
  double marketCap;
  double volume24H;
  double dominance;

  Marketdata(
      this.marketCap,
      this.volume24H,
      this.dominance);

  Marketdata.fromMap(Map<String, dynamic> map)
      : marketCap = map["total_market_cap"]?["usd"],
        volume24H = map["total_volume"]?["usd"],
        dominance = map["market_cap_percentage"]?["btc"];

  Map<String, dynamic> toMap() {
    return {
      "marketCap": marketCap,
      "volume24H": volume24H,
      "dominance": dominance,
    };
  }



}
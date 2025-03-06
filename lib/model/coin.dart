import 'package:flutter/material.dart';

class Coin with ChangeNotifier{
  dynamic id;
  String symbol;
  String name;
  String imageUrl;
  double currentPrice;
  double marketCap;
  int marketCapRank;
  double totalVolume;
  double high24H;
  double low24H;
  double priceChangePercentage24H;
  double circulatingSupply;
  double totalSupply;
  double maxSupply;
  double ath;
  double atl;

  Coin(
      this.id,
      this.symbol,
      this.name,
      this.imageUrl,
      this.currentPrice,
      this.marketCap,
      this.marketCapRank,
      this.totalVolume,
      this.high24H,
      this.low24H,
      this.priceChangePercentage24H,
      this.circulatingSupply,
      this.totalSupply,
      this.maxSupply,
      this.ath,
      this.atl);

  Coin.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        symbol = map["symbol"],
        name = map["name"],
        imageUrl = map["image"],
        currentPrice = (map["current_price"] is int) ? (map["current_price"] as int).toDouble() : map["current_price"],
        marketCap = (map["market_cap"] is int) ? (map["market_cap"] as int).toDouble() : map["market_cap"],
        marketCapRank = map["market_cap_rank"],
        totalVolume = (map["total_volume"] is int) ? (map["total_volume"] as int).toDouble() : map["total_volume"],
        high24H = (map["high_24h"] is int) ? (map["high_24h"] as int).toDouble() : map["high_24h"],
        low24H = (map["low_24h"] is int) ? (map["low_24h"] as int).toDouble() : map["low_24h"],
        priceChangePercentage24H = (map["price_change_percentage_24h"] is int) ? (map["price_change_percentage_24h"] as int).toDouble() : map["price_change_percentage_24h"],
        circulatingSupply = (map["circulating_supply"] is int) ? (map["circulating_supply"] as int).toDouble() : map["circulating_supply"],
        totalSupply = (map["total_supply"] is int) ? (map["total_supply"] as int).toDouble() : map["total_supply"],
        maxSupply = (map["max_supply"] is int) ? (map["max_supply"] as int).toDouble() : map["max_supply"]?? 0.0,
        ath = (map["ath"] is int) ? (map["ath"] as int).toDouble() : map["ath"],
        atl = (map["atl"] is int) ? (map["atl"] as int).toDouble() : map["atl"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "symbol": symbol,
      "name": name,
      "image": imageUrl,
      "current_price": currentPrice,
      "market_cap": marketCap,
      "market_cap_rank": marketCapRank,
      "total_volume": totalVolume,
      "high_24h": high24H,
      "low_24h": low24H,
      "price_change_percentage_24h": priceChangePercentage24H,
      "circulating_supply": circulatingSupply,
      "total_supply": totalSupply,
      "max_supply": maxSupply,
      "ath": ath,
      "atl": atl,
    };
  }



}
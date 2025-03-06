import 'package:cryptocurrency_exchange/model/coin.dart';
import '../model/marketdata.dart';

abstract class CoinBase {
  Future<List<Coin>> getCoins(int currentPage, int perPage);
  Future<Marketdata> getGlobalMarketData();
  Future<Map<String,dynamic>> getCoinDetails(String id);
  Future<List<Map<String, dynamic>>> fetchCoinData(String coinId);
}
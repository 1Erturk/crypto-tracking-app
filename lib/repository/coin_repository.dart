import 'package:cryptocurrency_exchange/model/coin.dart';
import 'package:cryptocurrency_exchange/model/marketdata.dart';
import 'package:cryptocurrency_exchange/service/api/api_coin_service.dart';
import 'package:cryptocurrency_exchange/service/base/coin_service.dart';
import 'package:cryptocurrency_exchange/tools/locator.dart';
import '../base/coin_base.dart';

class CoinRepository implements CoinBase{
  final CoinService _service = locator<ApiCoinService>();

  Future<List<Coin>> getCoins(int currentPage, int perPage) async {
    return await _service.getCoins(currentPage, perPage);
  }

  Future<Marketdata> getGlobalMarketData() async {
    return await _service.getGlobalMarketData();
  }

  @override
  Future<Map<String, dynamic>> getCoinDetails(String id) async {
    return await _service.getCoinDetails(id);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchCoinData(String coinId) async {
    return await _service.fetchCoinData(coinId);
  }

}
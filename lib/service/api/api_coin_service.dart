import 'dart:convert';
import 'package:cryptocurrency_exchange/model/marketdata.dart';
import 'package:cryptocurrency_exchange/service/base/coin_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:cryptocurrency_exchange/model/coin.dart';

class ApiCoinService implements CoinService{
  final String _baseUrl = "https://api.coingecko.com/api/v3";
  final String _globalBaseUrl = "https://api.coingecko.com/api/v3/global";
  final String _apikey = dotenv.env['COIN_GECKO_API_KEY'] ?? '';


  @override
  Future<List<Coin>> getCoins(int currentPage, int perPage) async {
    final response = await http.get(Uri.parse("$_baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$perPage&page=$currentPage&x_cg_demo_api_key=$_apikey"));

    if(response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.take(50).map((coin) => Coin.fromMap(coin)).toList();
    } else {
      throw Exception("Failed to fetch coins: ${response.statusCode}");
    }
  }

  @override
  Future<Map<String, dynamic>> getCoinDetails(String id) async {
    final response = await http.get(Uri.parse("$_baseUrl/coins/$id?x_cg_demo_api_key=$_apikey"));

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception("Failed to fetch coins: ${response.statusCode}");
    }
  }

  @override
  Future<Marketdata> getGlobalMarketData() async {
    final response = await http.get(Uri.parse("$_globalBaseUrl?x_cg_demo_api_key=$_apikey"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final globalData = data['data'];

      if (globalData != null) {
        var marketCapVar = globalData['total_market_cap']?['usd'];
        var volume24HVar = globalData['total_volume']?['usd'];
        var dominance = globalData['market_cap_percentage']?['btc'];

        if(marketCapVar == null || volume24HVar == null || dominance == null) {
          throw Exception("Market cap or Volume data is null");
        }

        double marketCap = marketCapVar.toDouble();
        double volume24H = volume24HVar.toDouble();
        Map<String, dynamic> marketdataMap = {
          "total_market_cap": {"usd": marketCap},
          "total_volume": {"usd": volume24H},
          "market_cap_percentage": {"btc": dominance},
        };
        Marketdata marketdata = Marketdata.fromMap(marketdataMap);
        return marketdata;

      } else {
        throw Exception('Global data is null');
      }

    } else {
      throw Exception('Failed to load global market data');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchCoinData(String coinId) async {
    print("fetchCoinData");
    final url =
        'https://api.coingecko.com/api/v3/coins/$coinId/market_chart?vs_currency=usd&days=30&x_cg_demo_api_key=$_apikey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final prices = data['prices'] as List;

      // Veriyi TradingView formatına dönüştür
      return prices.map((entry) {
        final timestamp = entry[0] as int;
        final price = entry[1] as double;

        // Timestamp'i 'YYYY-MM-DD' formatına dönüştür
        //final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
        //final formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

        //print("Time: ${timestamp.toDouble()} and Price: $price");
        return {
          "time": timestamp.toDouble(),
          "price": price,
        };
      }).toList();
    } else {
      throw Exception('API çağrısı başarısız: ${response.statusCode}');
    }
  }

}
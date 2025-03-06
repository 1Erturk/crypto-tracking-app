import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../repository/coin_repository.dart';
import '../tools/locator.dart';

class CoinChartViewModel with ChangeNotifier {
  String _coinId = "";
  //late Future<List<FlSpot>> _chartData;
  late Future<List<FlSpot>> _chartData1d;
  late Future<List<FlSpot>> _chartData7d;
  late Future<List<FlSpot>> _chartData30d;
  late Future<List<FlSpot>> _chartData1y;
  final CoinRepository _coinRepository = locator<CoinRepository>();
  late Future<List<Map<String, dynamic>>> _coinData;
  late ScrollController _scrollController;
  double _maxScrollExtent = 0;

  String get coinId => _coinId;
  //Future<List<FlSpot>> get chartData => _chartData;
  Future<List<FlSpot>> get chartData1d => _chartData1d;
  Future<List<FlSpot>> get chartData7d => _chartData7d;
  Future<List<FlSpot>> get chartData30d => _chartData30d;
  Future<List<FlSpot>> get chartData1y => _chartData1y;
  ScrollController get scrollController => _scrollController;
  double get maxScrollExtent => _maxScrollExtent;

  void setCoinId(String coinId) {
    _coinId = coinId;
    _coinData = _coinRepository.fetchCoinData(coinId);
    notifyListeners();
  }

  set maxScrollExtent(double value) {
    _maxScrollExtent = value;
  }

  CoinChartViewModel(String coinId) {
    _coinId = coinId;
    _coinData = _coinRepository.fetchCoinData(coinId);
    //_chartData = getChartData();
    _chartData1d = _generateChartData(Duration(days: 1));
    _chartData7d = _generateChartData(Duration(days: 7));
    _chartData30d = _generateChartData(Duration(days: 30));
    _chartData1y = Future.value([]);
    _scrollController = ScrollController(initialScrollOffset: 0);
    _scrollController.addListener(_onScroll);
  }

  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _maxScrollExtent) {
      _scrollController.jumpTo(_maxScrollExtent);
    }
  }

  Future<List<FlSpot>> getChartData() async {
    try {
      //print("coinId: $coinId");

      List<Map<String, dynamic>> data = await _coinData;
      //print("Coin verisi: $data");
      // Verileri FlSpot formatına dönüştür
      List<FlSpot> spots = data.map((coin) {
        var x = coin['time'];  // Zaman (Unix timestamp gibi bir format olabilir)
        var y = coin['price'];  // Fiyat
        return FlSpot(x, y);
      }).toList();
      for(FlSpot spot in spots) {
        //print(spot.x + spot.y);
      }
      if (spots.isEmpty) {
        print("NNUULLL");
      }
      return spots;
    } catch (e) {
      debugPrint('Grafik verisi yüklenirken hata oluştu: $e');
      return [];
    }
  }

  Future<List<FlSpot>> _generateChartData(Duration duration) async {
    try {
      List<Map<String, dynamic>> data = await _coinData;

      // Belirtilen süreye göre filtrele
      DateTime now = DateTime.now();
      DateTime cutoffDate = now.subtract(duration);

      List<Map<String, dynamic>> filteredData = data.where((coin) {
        DateTime coinTime = DateTime.fromMillisecondsSinceEpoch(
            (coin['time']).toInt());
        return coinTime.isAfter(cutoffDate);
      }).toList();

      // Verileri FlSpot formatına dönüştür
      List<FlSpot> spots = filteredData.map((coin) {
        var x = coin['time']; // Unix timestamp
        var y = coin['price']; // Fiyat
        return FlSpot(x, y);
      }).toList();

      return spots;
    } catch (e) {
      debugPrint('Grafik verisi yüklenirken hata oluştu: $e');
      return [];
    }
  }

  void fetchDataFor1Y() {
    _chartData1y = Future.value([]); // Boş FlSpot listesi
    notifyListeners();
  }
}

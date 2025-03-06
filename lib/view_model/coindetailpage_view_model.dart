import 'package:cryptocurrency_exchange/repository/firestore_repository.dart';
import 'package:cryptocurrency_exchange/view_model/watchlist_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/coin.dart';
import '../model/marketdata.dart';
import '../repository/coin_repository.dart';
import '../tools/locator.dart';

class CoinDetailPageViewModel with ChangeNotifier {
  FirestoreRepository _firestoreRepository = locator<FirestoreRepository>();
  CoinRepository _coinRepository = locator<CoinRepository>();
  final Coin _coin;
  bool? _isFavorite;
  double _marketCap = 0;
  double _volume24H = 0;
  double _dominance = 0;
  String _description = "";
  String _website = "";
  String _whitepaper = "";
  String _community = "";
  String _genesisDate = "";
  double _priceChangePercentage7d = 0;
  double _priceChangePercentage30d = 0;
  double _priceChangePercentage1y = 0;
  List<dynamic> _tickers = [];
  String _selectedTime = "1W";
  bool _isLine = true;
  //Coin? coin;
  //void setCoin(Coin selectedCoin) {
    //coin = selectedCoin;
    //notifyListeners();
  //}

  Coin get coin => _coin;
  bool? get isFavorite => _isFavorite;
  double get marketCap => _marketCap;
  double get volume24H => _volume24H;
  double get dominance => _dominance;
  String get description => _description;
  String get website => _website;
  String get whitepaper => _whitepaper;
  String get community => _community;
  String get genesisDate => _genesisDate;
  double get priceChangePercentage7d => _priceChangePercentage7d;
  double get priceChangePercentage30d => _priceChangePercentage30d;
  double get priceChangePercentage1y => _priceChangePercentage1y;
  List<dynamic> get tickers => _tickers;
  String get selectedTime => _selectedTime;
  bool get isLine => _isLine;

  CoinDetailPageViewModel(this._coin) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isFavoriteCoin();
      //_getGlobalData();
      _getCoinDetails();
    });
  }

  Future<void> addFavoriteCoin(BuildContext context) async {
    await _firestoreRepository.addFavoriteCoin(coin);
    _isFavorite = true;
    notifyListeners();

    //Provider.of<WatchlistViewModel>(context, listen: false).getFavoriteCoinsStream();
    if (context.mounted) {
      Provider.of<WatchlistViewModel>(context, listen: false).getFavoriteCoinsStream();
    }
  }

  Future<void> deleteFavoriteCoin(BuildContext context) async {
    await _firestoreRepository.deleteFavoriteCoin(coin);
    _isFavorite = false;
    notifyListeners();

    Provider.of<WatchlistViewModel>(context, listen: false).getFavoriteCoinsStream();
    if (context.mounted) {
      Provider.of<WatchlistViewModel>(context, listen: false).getFavoriteCoinsStream();
    }
  }

  Future<void> isFavoriteCoin() async {
    _isFavorite = await _firestoreRepository.isFavoriteCoin(coin);
    notifyListeners();
  }

  Future<void> _getGlobalData() async {
    Marketdata globalData = await _coinRepository.getGlobalMarketData();
    _marketCap = globalData.marketCap;
    _volume24H = globalData.volume24H;
    _dominance = globalData.dominance;
    notifyListeners();
  }

  Future<void> _getCoinDetails() async {
    Map<String, dynamic> data = await _coinRepository.getCoinDetails(_coin.id);
    _description = data["description"]?["en"] ?? "";
    _website = data["links"]?["homepage"]?[0] ?? "";
    _whitepaper = data["links"]?["whitepaper"] ?? "";
    _community = data["links"]?["subreddit_url"] ?? "";
    _genesisDate = data["genesis_date"] ?? "";
    _priceChangePercentage7d = data["market_data"]?["price_change_percentage_7d"] ?? 0;
    _priceChangePercentage30d = data["market_data"]?["price_change_percentage_30d"] ?? 0;
    _priceChangePercentage1y = data["market_data"]?["price_change_percentage_1y"] ?? 0;
    _tickers = (data["tickers"] as List).take(100).toList();
    notifyListeners();
  }

  void changeTimeInterval(String time) {
    if(_selectedTime != time) {
      _selectedTime = time;
      if(_selectedTime == "1D") {
        _selectedTime = "1D";
        notifyListeners();
      } else if(_selectedTime == "1W") {
        _selectedTime = "1W";
        notifyListeners();
      } else if(_selectedTime == "1M") {
        _selectedTime = "1M";
        notifyListeners();
      } else if(_selectedTime == "1Y") {
        _selectedTime = "1Y";
        notifyListeners();
      }
    }
  }

  void changeChart() {
    if(_isLine == true) {
      _isLine = false;
      notifyListeners();
    } else {
      _isLine = true;
      notifyListeners();
    }
  }
}
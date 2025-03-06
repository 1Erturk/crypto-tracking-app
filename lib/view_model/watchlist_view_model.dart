import 'package:cryptocurrency_exchange/repository/coin_repository.dart';
import 'package:flutter/material.dart';
import '../model/coin.dart';
import '../repository/firestore_repository.dart';
import '../tools/NumberFormatter.dart';
import '../tools/locator.dart';

class WatchlistViewModel with ChangeNotifier {
  FirestoreRepository _firestoreRepository = locator<FirestoreRepository>();
  CoinRepository _coinRepository = locator<CoinRepository>();
  bool _isLoading = false;
  List<Coin> _watchlist = [];

  List<Coin> get watchlist => _watchlist;
  bool get isLoading => _isLoading;

  WatchlistViewModel() {
    /*
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //getFavoriteCoins();
      getFavoriteCoinsStream();
    });
     */
    _init();
  }

  void _init() {
    getFavoriteCoinsStream();
  }

  Future<void> getFavoriteCoins() async{
    if(_isLoading) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    _watchlist = await _firestoreRepository.getFavoriteCoins();

    _isLoading = false;
    notifyListeners();
  }

  void getFavoriteCoinsStream() {
    if(_isLoading) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    _firestoreRepository.getFavoriteCoinsStream().listen((coins) {
      _watchlist = coins;
      notifyListeners();
    });

    _isLoading = false;
    notifyListeners();
  }

  String formatMarketCap(double number) {
    return NumberFormatter.formatMarketCap(number);
  }

  String formatPrice(double number) {
    return NumberFormatter.formatPrice(number);
  }

  bool isHigherThan0(double priceChange) {
    if(priceChange > 0.00) {
      return true;
    } else {
      return false;
    }
  }

}
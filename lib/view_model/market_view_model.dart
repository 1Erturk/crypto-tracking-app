import 'dart:async';
import 'package:cryptocurrency_exchange/repository/coin_repository.dart';
import 'package:cryptocurrency_exchange/tools/NumberFormatter.dart';
import 'package:cryptocurrency_exchange/tools/locator.dart';
import 'package:cryptocurrency_exchange/view/market_view.dart';
import 'package:cryptocurrency_exchange/view/news_view.dart';
import 'package:cryptocurrency_exchange/view_model/news_view_model.dart';
import 'package:cryptocurrency_exchange/view_model/watchlist_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/coin.dart';
import '../model/marketdata.dart';
import '../view/watchlist_view.dart';

class MarketViewModel with ChangeNotifier {
  CoinRepository _coinRepository = locator<CoinRepository>();
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  List<Coin> _allCoins = [];
  List<Coin> _coins = [];
  List<Coin> _filteredCoins = [];
  List<Coin> _watchlist = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _selectedItem = 0;
  int _currentPage = 1;
  int _coinsPerPage = 50;
  double _marketCap = 0;
  double _volume24H = 0;
  double _dominance = 0;
  String _sortBy = "Rank (Default)";
  List<String> sortOptions = ["Rank (Default)", "Market Cap", "Price", "24HR (Volume)", "24HR (Change)"];
  Timer? _timer;

  ScrollController get scrollController => _scrollController;
  TextEditingController get searchController => _searchController;
  FocusNode get searchFocusNode => _searchFocusNode;
  List<Coin> get allCoins => _allCoins;
  List<Coin> get coins => _coins;
  List<Coin> get filteredCoins => _filteredCoins;
  List<Coin> get watchlist => _watchlist;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  int get selectedItem => _selectedItem;
  double get marketCap => _marketCap;
  double get volume24H => _volume24H;
  double get dominance => _dominance;
  String get sortBy => _sortBy;

  MarketViewModel() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getGlobalData();
      _getCoins();
      _scrollController.addListener(_onScroll);
      //_startTimer();
    });
  }

  /*
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      _getGlobalData();
      _getAllCoins();
    });
  }
   */

  /*
    Future<void> _ggetAllCoins() async {
    if (_coins.isEmpty) {

      _isLoading = true;
      notifyListeners();

      //_coins = await _coinRepository.getAllCoins();
      print("Coins:");
      for (Coin coin in _coins) {
        print("${coin.name}");
      }

      _isLoading = false;
      notifyListeners();
    }
  }
   */

  Future<void> _getCoins() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    final newCoins = await _coinRepository.getCoins(_currentPage, _coinsPerPage);
    _coins.addAll(newCoins);


    if (_filteredCoins.isEmpty) {
      _filteredCoins = List.from(_coins);
    }


    _isLoading = false;
    _currentPage++;
    notifyListeners();
  }

  Future<void> _fetchMoreCoins() async {

    if (_isFetchingMore) {
      return;
    }

    _isFetchingMore = true;
    notifyListeners();

    final newCoins = await _coinRepository.getCoins(_currentPage, _coinsPerPage);
    _coins.addAll(newCoins);
    _filteredCoins = _coins;


    if (newCoins.isEmpty) {
      _isFetchingMore = false;
      return;
    }

    /*
    if (_filteredCoins.isEmpty) {
      _filteredCoins = List.from(_coins);
    }
     */

    _isFetchingMore = false;
    _currentPage++;
    notifyListeners();

  }


  Future<void> _getGlobalData() async {
    Marketdata globalData = await _coinRepository.getGlobalMarketData();
    _marketCap = globalData.marketCap;
    _volume24H = globalData.volume24H;
    _dominance = globalData.dominance;
    notifyListeners();
  }

  void onItemTapped(BuildContext context, int index) {
    if(_selectedItem == index) {
      return;
    }
    _selectedItem = index;
    openSelectedPage(context);
    notifyListeners();
  }

  void openSelectedPage(BuildContext context) {
    MaterialPageRoute pageRoute;

    switch(_selectedItem) {
      case 0 :
        pageRoute = MaterialPageRoute(
          builder: (context) {
            return ChangeNotifierProvider(
              create: (context) => MarketViewModel(),
              child: MarketView(),
            );
          });
      case 1 :
        pageRoute = MaterialPageRoute(
            builder: (context) {
              return ChangeNotifierProvider(
                create: (context) => WatchlistViewModel(),
                child: WatchlistView(),
              );
            });
      case 2 :
        pageRoute = MaterialPageRoute(
            builder: (context) {
              return ChangeNotifierProvider(
                create: (context) => NewsViewModel(),
                child: NewsView(),
              );
            });
      case 3 :

      default :
        pageRoute = MaterialPageRoute(
            builder: (context) {
              return ChangeNotifierProvider(
                create: (context) => MarketViewModel(),
                child: MarketView(),
              );
            });
    }
    Navigator.pushReplacement(context, pageRoute);
  }

  void _onScroll() {
    if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isFetchingMore) {
      _fetchMoreCoins();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> filterCoins() async {
    String searchText = _searchController.text.toLowerCase();

    if (searchText.isEmpty) {
      _filteredCoins = List.from(_coins);
    } else {
      _filteredCoins = _coins.where((coin) => coin.symbol.toLowerCase().startsWith(searchText)).toList();
    }
    //List<Coin> _filterCoins = await _coinRepository.getAllCoins(_currentPage, _coinsPerPage);
    //_filteredCoins = _filterCoins.where((coin) => coin.symbol.toLowerCase().startsWith(searchText)).toList();
    //_coins = _filteredCoins;
    notifyListeners();
  }

  void setSortBy(String option) {
    _sortBy = option;
    notifyListeners();
  }

  void sortCoins() {
    print("Before sorting: $_filteredCoins");
    if (_sortBy == sortOptions[0]) {
      _filteredCoins.sort((a, b) => a.marketCapRank.compareTo(b.marketCapRank));
    } else if (_sortBy == sortOptions[1]) {
      _filteredCoins.sort((a, b) => b.marketCap.compareTo(a.marketCap));
    } else if (_sortBy == sortOptions[2]) {
      _filteredCoins.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
    } else if (_sortBy == sortOptions[3]) {
      _filteredCoins.sort((a, b) => b.totalVolume.compareTo(a.totalVolume));
    } else if (_sortBy == sortOptions[4]) {
      _filteredCoins.sort((a, b) => b.priceChangePercentage24H.compareTo(a.priceChangePercentage24H));
    }
    print("After sorting: $_filteredCoins");
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
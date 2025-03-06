import 'package:cryptocurrency_exchange/repository/firestore_repository.dart';
import 'package:cryptocurrency_exchange/repository/news_repository.dart';
import 'package:flutter/material.dart';
import '../model/news.dart';
import '../tools/locator.dart';

class NewsViewModel with ChangeNotifier {
  NewsRepository _newsRepository = locator<NewsRepository>();
  FirestoreRepository _firestoreRepository = locator<FirestoreRepository>();
  bool _isLoading = false;
  List<News> _news = [];
  List<News> _blockchainNews = [];
  List<News> _financeNews = [];
  List<News> _technologyNews = [];
  List<News> _economyNews = [];
  String _selectedCategory = "Blockchain";

  List<News> get news => _news;
  List<News> get blockchainNews => _blockchainNews;
  List<News> get financeNews => _financeNews;
  List<News> get technologyNews => _technologyNews;
  List<News> get economyNews => _economyNews;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;


  NewsViewModel() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //getBlockchainNews();
      _initializeNews();
    });
  }

  Future<void> _initializeNews() async {
    /*
    var currentTimestamp = DateTime.now();
    DateTime? lastUpdateTimeBlockchain = await _firestoreRepository.getLastUpdateTimeStamp("blockchainNews");
    DateTime? lastUpdateTimeEconomy = await _firestoreRepository.getLastUpdateTimeStamp("economyNews");
    DateTime? lastUpdateTimeFinance = await _firestoreRepository.getLastUpdateTimeStamp("financeNews");
    DateTime? lastUpdateTimeTechnology = await _firestoreRepository.getLastUpdateTimeStamp("technologyNews");

    if (lastUpdateTimeBlockchain == null || currentTimestamp.difference(lastUpdateTimeBlockchain).inHours >= 6
    || lastUpdateTimeEconomy == null || currentTimestamp.difference(lastUpdateTimeEconomy).inHours >= 6
    || lastUpdateTimeFinance == null || currentTimestamp.difference(lastUpdateTimeFinance).inHours >= 6
    || lastUpdateTimeTechnology == null || currentTimestamp.difference(lastUpdateTimeTechnology).inHours >= 6) {
      print("News are updated");
      updateNews();
    } else {
      print("News are fetched from database");
      _blockchainNews = await _firestoreRepository.getNewsCache("blockchainNews");
      _financeNews = await _firestoreRepository.getNewsCache("financeNews");
      _technologyNews = await _firestoreRepository.getNewsCache("technologyNews");
      _economyNews = await _firestoreRepository.getNewsCache("economyNews");
      _news = _blockchainNews;
    }
     */

    print("Cache");
    await getNewsFromCache();

    // _blockchainNews listesinin boş olup olmadığını kontrol et
    if (_blockchainNews.isEmpty ||_economyNews.isEmpty ||_financeNews.isEmpty ||_technologyNews.isEmpty) {
      // Eğer liste boşsa, güncelleme yapılması gerektiğini varsay
      print("List is empty. Fetching from Firestore...");
      await getNewsFromFirestore();
    } else {
      bool isNeed = await _firestoreRepository.isUpdateNeeded("blockchain_news", _blockchainNews[0].timestamp!);

      if (isNeed) {
        print("Firestore");
        await getNewsFromFirestore();
      } else {
        print("false");
      }
    }

  }

  Future<void> getNewsFromFirestore() async {
    _blockchainNews = await _firestoreRepository.getNews("blockchain_news");
    _financeNews = await _firestoreRepository.getNews("finance_news");
    _technologyNews = await _firestoreRepository.getNews("technology_news");
    _economyNews = await _firestoreRepository.getNews("economy_news");
    _news = _blockchainNews;
    await _firestoreRepository.clearNewsCache("blockchain_news");
    await _firestoreRepository.clearNewsCache("finance_news");
    await _firestoreRepository.clearNewsCache("technology_news");
    await _firestoreRepository.clearNewsCache("economy_news");
    await _firestoreRepository.addNewsCache(_blockchainNews, "blockchain_news");
    await _firestoreRepository.addNewsCache(_financeNews, "finance_news");
    await _firestoreRepository.addNewsCache(_technologyNews, "technology_news");
    await _firestoreRepository.addNewsCache(_economyNews, "economy_news");
  }

  Future<void> getNewsFromCache() async {
    _blockchainNews = await _firestoreRepository.getNewsCache("blockchain_news");
    _financeNews = await _firestoreRepository.getNewsCache("finance_news");
    _technologyNews = await _firestoreRepository.getNewsCache("technology_news");
    _economyNews = await _firestoreRepository.getNewsCache("economy_news");
    _news = _blockchainNews;
  }


  void changeCategory(String category) {
    if(_selectedCategory != category) {
      _selectedCategory = category;
      if(_selectedCategory == "Blockchain") {
        //getBlockchainNews();
        _news = _blockchainNews;
        notifyListeners();
      } else if(_selectedCategory == "Finance") {
        //getFinanceNews();
        _news = _financeNews;
        notifyListeners();
      } else if(_selectedCategory == "Technology") {
        //getTechnologyNews();
        _news = _technologyNews;
        notifyListeners();
      } else if(_selectedCategory == "Economy") {
        //getEconomyNews();
        _news = _economyNews;
        notifyListeners();
      }
    }
  }

  /*
  Future<void> updateNews() async {
    print("Update News");
    _isLoading = true;
    notifyListeners();

    try {
      await getAllNewsFromAPI();
    } catch (e) {
      print("Update ERROR: $e");
    }
    print("News are Updated");

    _isLoading = false;
    notifyListeners();
  }
  */


  /*
  Future<void> getAllNewsFromAPI() async {
    print("Gell All News From API");
    await getBlockchainNews();
    await getFinanceNews();
    await getTechnologyNews();
    await getEconomyNews();

    await _firestoreRepository.clearNewsCache("blockchainNews");
    await _firestoreRepository.clearNewsCache("financeNews");
    await _firestoreRepository.clearNewsCache("technologyNews");
    await _firestoreRepository.clearNewsCache("economyNews");
    await checkAndUpdateNews("blockchainNews", _blockchainNews);
    await checkAndUpdateNews("financeNews", _financeNews);
    await checkAndUpdateNews("technologyNews", _technologyNews);
    await checkAndUpdateNews("economyNews", _economyNews);

    _news = _blockchainNews;
    notifyListeners();
  }
   */

  /*
  Future<void> checkAndUpdateNews(String category, List<News> newsList) async {
    var currentTimestamp = DateTime.now();
    DateTime? lastUpdateTime = await _firestoreRepository.getLastUpdateTimeStamp(category);

    print(lastUpdateTime);

    if (lastUpdateTime == null || currentTimestamp.difference(lastUpdateTime).inHours >= 6) {
      print("Updating $category News...");
      //await _firestoreRepository.clearNewsCache(category);
      try {
        await _firestoreRepository.addNewsCache(newsList, category);
        print("$category News added successfully");
      } catch (e) {
        print("Error adding $category News: $e");
      }
    }
  }
   */


  /*
  Future<void> getBlockchainNews() async{
    /*
    if(_isLoading) {
      return;
    }
     */

    //_isLoading = true;
    //notifyListeners();

    //_news = await _newsRepository.getBlockchainNews();
    try {
      _blockchainNews = await _newsRepository.getBlockchainNews();
    } catch (e) {
      print("Error fetching blockchain news: $e");
    }

    _news = _blockchainNews;


    //_isLoading = false;
    //notifyListeners();
  }

  Future<void> getFinanceNews() async{
    /*
    if(_isLoading) {
      return;
    }
     */

    //_isLoading = true;
    //notifyListeners();

    //_news = await _newsRepository.getFinanceNews();
    try {
      _financeNews = await _newsRepository.getFinanceNews();
    } catch (e) {
      print("Error fetching finance news: $e");
    }

    _news = _financeNews;

    //_isLoading = false;
    //notifyListeners();
  }

  Future<void> getTechnologyNews() async{
    /*
    if(_isLoading) {
      return;
    }
     */

    //_isLoading = true;
    //notifyListeners();

    //_news = await _newsRepository.getTechnologyNews();
    try {
      _technologyNews = await _newsRepository.getTechnologyNews();
      _technologyNews = _technologyNews.where((news) => news.title != "Before you continue").toList();
    } catch (e) {
      print("Error fetching technology news: $e");
    }

    _news = _technologyNews;

    //_isLoading = false;
    //notifyListeners();
  }

  Future<void> getEconomyNews() async{
    /*
    if(_isLoading) {
      return;
    }
     */

    //_isLoading = true;
    //notifyListeners();

    //_news = await _newsRepository.getEconomyNews();
    try {
      _economyNews = await _newsRepository.getEconomyNews();
    } catch (e) {
      print("Error fetching economy news: $e");
    }
    _news = _economyNews;

    //_isLoading = false;
    //notifyListeners();
  }
   */



  String timeFormatter(String time) {
    final dateTime = DateTime.parse(
        '${time.substring(0, 8)} ${time.substring(9, 11)}:${time.substring(11, 13)}'
    );

    final month = dateTime.month;
    final day = dateTime.day;
    final hour = dateTime.hour;
    final minute = dateTime.minute;

    final monthName = _getMonthName(month);

    return "$hour:${minute.toString().padLeft(2, "0")}  -  $day $monthName";
  }

  String _getMonthName(int month) {
    final monthNames = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return monthNames[month];
  }
}

/*
import 'package:cryptocurrency_exchange/repository/firestore_repository.dart';
import 'package:cryptocurrency_exchange/repository/news_repository.dart';
import 'package:flutter/material.dart';
import '../model/news.dart';
import '../tools/locator.dart';

class NewsViewModel with ChangeNotifier {
  NewsRepository _newsRepository = locator<NewsRepository>();
  FirestoreRepository _firestoreRepository = locator<FirestoreRepository>();
  bool _isLoading = false;
  List<News> _news = [];
  List<News> _blockchainNews = [];
  List<News> _financeNews = [];
  List<News> _technologyNews = [];
  List<News> _economyNews = [];
  String _selectedCategory = "Blockchain";
  DateTime? _lastUpdateTimeBlockchain;
  DateTime? _lastUpdateTimeEconomy;
  DateTime? _lastUpdateTimeFinance;
  DateTime? _lastUpdateTimeTechnology;

  List<News> get news => _news;
  List<News> get blockchainNews => _blockchainNews;
  List<News> get financeNews => _financeNews;
  List<News> get technologyNews => _technologyNews;
  List<News> get economyNews => _economyNews;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  NewsViewModel() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //getBlockchainNews();
      _initializeNews();
    });
  }

  /*
  Future<void> _initializeNews() async {
    var currentTimestamp = DateTime.now();
    _lastUpdateTimeBlockchain = await _firestoreRepository.getLastUpdateTimeStamp("blockchainNews");
    _lastUpdateTimeEconomy = await _firestoreRepository.getLastUpdateTimeStamp("economyNews");
    _lastUpdateTimeFinance = await _firestoreRepository.getLastUpdateTimeStamp("financeNews");
    _lastUpdateTimeTechnology = await _firestoreRepository.getLastUpdateTimeStamp("technologyNews");

    if (_lastUpdateTimeBlockchain == null || currentTimestamp.difference(_lastUpdateTimeBlockchain!).inHours >= 2) {
      print("Blockchain News are updated");
      updateNews("Blockchain");
    } else {
      print("Blockchain News are fetched from database");
      _blockchainNews = await _firestoreRepository.getNewsCache("blockchainNews");
      //_financeNews = await _firestoreRepository.getNewsCache("financeNews");
      //_technologyNews = await _firestoreRepository.getNewsCache("technologyNews");
      //_economyNews = await _firestoreRepository.getNewsCache("economyNews");
      _news = _blockchainNews;
    }
    if (_lastUpdateTimeEconomy == null || currentTimestamp.difference(_lastUpdateTimeEconomy!).inHours >= 2) {
      print("Economy News are updated");
      updateNews("Economy");
    } else {
      print("Economy News are fetched from database");
      _economyNews = await _firestoreRepository.getNewsCache("economyNews");
    }
    if (_lastUpdateTimeFinance == null || currentTimestamp.difference(_lastUpdateTimeFinance!).inHours >= 2) {
      print("Finance News are updated");
      updateNews("Finance");
    } else {
      print("Finance News are fetched from database");
      _financeNews = await _firestoreRepository.getNewsCache("financeNews");
    }
    if (_lastUpdateTimeTechnology == null || currentTimestamp.difference(_lastUpdateTimeTechnology!).inHours >= 2) {
      print("Technology News are updated");
      updateNews("Technology");
    } else {
      print("Technology News are fetched from database");
      _technologyNews = await _firestoreRepository.getNewsCache("technologyNews");
    }
  }
   */

  Future<void> _initializeNews() async {
    var currentTimestamp = DateTime.now();
    _lastUpdateTimeBlockchain = await _firestoreRepository.getLastUpdateTimeStamp("blockchainNews");
    _lastUpdateTimeEconomy = await _firestoreRepository.getLastUpdateTimeStamp("economyNews");
    _lastUpdateTimeFinance = await _firestoreRepository.getLastUpdateTimeStamp("financeNews");
    _lastUpdateTimeTechnology = await _firestoreRepository.getLastUpdateTimeStamp("technologyNews");

    // Her kategori için güncelleme yapılacaksa
    await _updateCategoryNews("Blockchain", currentTimestamp);
    await _updateCategoryNews("Economy", currentTimestamp);
    await _updateCategoryNews("Finance", currentTimestamp);
    await _updateCategoryNews("Technology", currentTimestamp);
  }

  Future<void> _updateCategoryNews(String category, DateTime currentTimestamp) async {
    DateTime? lastUpdateTime;

    if (category == "Blockchain") {
      lastUpdateTime = _lastUpdateTimeBlockchain;
    } else if (category == "Economy") {
      lastUpdateTime = _lastUpdateTimeEconomy;
    } else if (category == "Finance") {
      lastUpdateTime = _lastUpdateTimeFinance;
    } else if (category == "Technology") {
      lastUpdateTime = _lastUpdateTimeTechnology;
    }

    if (lastUpdateTime == null || currentTimestamp.difference(lastUpdateTime).inHours >= 2) {
      print("$category News are updated");
      await updateNews(category);
    } else {
      print("$category News are fetched from database");
      await _fetchNewsFromDatabase(category);
    }
  }

  Future<void> _fetchNewsFromDatabase(String category) async {
    if (category == "Blockchain") {
      _blockchainNews = await _firestoreRepository.getNewsCache("blockchainNews");
      _news = _blockchainNews;
    } else if (category == "Economy") {
      _economyNews = await _firestoreRepository.getNewsCache("economyNews");
    } else if (category == "Finance") {
      _financeNews = await _firestoreRepository.getNewsCache("financeNews");
    } else if (category == "Technology") {
      _technologyNews = await _firestoreRepository.getNewsCache("technologyNews");
    }
    notifyListeners();
  }



  void changeCategory(String category) {
    if(_selectedCategory != category) {
      _selectedCategory = category;
      if(_selectedCategory == "Blockchain") {
        //getBlockchainNews();
        _news = _blockchainNews;
        notifyListeners();
      } else if(_selectedCategory == "Finance") {
        //getFinanceNews();
        _news = _financeNews;
        notifyListeners();
      } else if(_selectedCategory == "Technology") {
        //getTechnologyNews();
        _news = _technologyNews;
        notifyListeners();
      } else if(_selectedCategory == "Economy") {
        //getEconomyNews();
        _news = _economyNews;
        notifyListeners();
      }
    }
  }

  Future<void> updateNews(String category) async {
    print("Update News");
    _isLoading = true;
    notifyListeners();

    try {
      // 1 await getAllNewsFromAPI();
      // 2 await getNewsFromAPI(category);
      if (category == "Blockchain") {
        await getBlockchainNews();
        await _firestoreRepository.clearNewsCache("blockchainNews");
        await checkAndUpdateNews("blockchainNews", _blockchainNews);
      } else if (category == "Finance") {
        await getFinanceNews();
        await _firestoreRepository.clearNewsCache("financeNews");
        await checkAndUpdateNews("financeNews", _financeNews);
      } else if (category == "Technology") {
        await getTechnologyNews();
        await _firestoreRepository.clearNewsCache("technologyNews");
        await checkAndUpdateNews("technologyNews", _technologyNews);
      } else if (category == "Economy") {
        await getEconomyNews();
        await _firestoreRepository.clearNewsCache("economyNews");
        await checkAndUpdateNews("economyNews", _economyNews);
      }
      _news = category  == "Blockchain" ? _blockchainNews
          : category  == "Finance" ? _financeNews
          : category  == "Technology" ? _technologyNews
          : _economyNews;
      notifyListeners();
    } catch (e) {
      print("Update ERROR: $e");
    }
    print("News are Updated");

    _isLoading = false;
    notifyListeners();
  }

  /*
  Future<void> getNewsFromAPI(String category) async {
    print("Gell All News From API");
    if (category == "Blockchain") {
      await getBlockchainNews();
      await _firestoreRepository.clearNewsCache("blockchainNews");
      await checkAndUpdateNews("blockchainNews", _blockchainNews);
    } else if (category == "Finance") {
      await getFinanceNews();
      await _firestoreRepository.clearNewsCache("financeNews");
      await checkAndUpdateNews("financeNews", _financeNews);
    } else if (category == "Technology") {
      await getTechnologyNews();
      await _firestoreRepository.clearNewsCache("technologyNews");
      await checkAndUpdateNews("technologyNews", _technologyNews);
    } else if (category == "Economy") {
      await getEconomyNews();
      await _firestoreRepository.clearNewsCache("economyNews");
      await checkAndUpdateNews("economyNews", _economyNews);
    }
    _news = _blockchainNews;
    notifyListeners();
  }
   */


  /*
  Future<void> getAllNewsFromAPI() async {
    print("Gell All News From API");
    await getBlockchainNews();
    await getFinanceNews();
    await getTechnologyNews();
    await getEconomyNews();

    await _firestoreRepository.clearNewsCache("blockchainNews");
    await _firestoreRepository.clearNewsCache("financeNews");
    await _firestoreRepository.clearNewsCache("technologyNews");
    await _firestoreRepository.clearNewsCache("economyNews");
    await checkAndUpdateNews("blockchainNews", _blockchainNews);
    await checkAndUpdateNews("financeNews", _financeNews);
    await checkAndUpdateNews("technologyNews", _technologyNews);
    await checkAndUpdateNews("economyNews", _economyNews);

    _news = _blockchainNews;
    notifyListeners();
  }
   */

  Future<void> checkAndUpdateNews(String category, List<News> newsList) async {
    var currentTimestamp = DateTime.now();
    DateTime? lastUpdateTime;
    if (category == "blockchainNews") {
      lastUpdateTime = _lastUpdateTimeBlockchain;
    } else if (category == "financeNews") {
      lastUpdateTime = _lastUpdateTimeFinance;
    } else if (category == "technologyNews") {
      lastUpdateTime = _lastUpdateTimeTechnology;
    } else if (category == "economyNews") {
      lastUpdateTime = _lastUpdateTimeEconomy;
    }
    //DateTime? lastUpdateTime = await _firestoreRepository.getLastUpdateTimeStamp(category);

    print(lastUpdateTime);

    if (lastUpdateTime == null || currentTimestamp.difference(lastUpdateTime).inHours >= 2) {
      print("Updating $category News...");
      //await _firestoreRepository.clearNewsCache(category);
      try {
        await _firestoreRepository.addNewsCache(newsList, category);
        print("$category News added successfully");
      } catch (e) {
        print("Error adding $category News: $e");
      }
    }
  }


  Future<void> getBlockchainNews() async{
    /*
    if(_isLoading) {
      return;
    }
     */

    //_isLoading = true;
    //notifyListeners();

    //_news = await _newsRepository.getBlockchainNews();
    try {
      _blockchainNews = await _newsRepository.getBlockchainNews();
    } catch (e) {
      print("Error fetching blockchain news: $e");
    }

    _news = _blockchainNews;


    //_isLoading = false;
    //notifyListeners();
  }

  Future<void> getFinanceNews() async{
    /*
    if(_isLoading) {
      return;
    }
     */

    //_isLoading = true;
    //notifyListeners();

    //_news = await _newsRepository.getFinanceNews();
    try {
      _financeNews = await _newsRepository.getFinanceNews();
    } catch (e) {
      print("Error fetching finance news: $e");
    }

    _news = _financeNews;

    //_isLoading = false;
    //notifyListeners();
  }

  Future<void> getTechnologyNews() async{
    /*
    if(_isLoading) {
      return;
    }
     */

    //_isLoading = true;
    //notifyListeners();

    //_news = await _newsRepository.getTechnologyNews();
    try {
      _technologyNews = await _newsRepository.getTechnologyNews();
      _technologyNews = _technologyNews.where((news) => news.title != "Before you continue").toList();
    } catch (e) {
      print("Error fetching technology news: $e");
    }

    _news = _technologyNews;

    //_isLoading = false;
    //notifyListeners();
  }

  Future<void> getEconomyNews() async{
    /*
    if(_isLoading) {
      return;
    }
     */

    //_isLoading = true;
    //notifyListeners();

    //_news = await _newsRepository.getEconomyNews();
    try {
      _economyNews = await _newsRepository.getEconomyNews();
    } catch (e) {
      print("Error fetching economy news: $e");
    }
    _news = _economyNews;

    //_isLoading = false;
    //notifyListeners();
  }




  String timeFormatter(String time) {
    final dateTime = DateTime.parse(
        '${time.substring(0, 8)} ${time.substring(9, 11)}:${time.substring(11, 13)}'
    );

    final month = dateTime.month;
    final day = dateTime.day;
    final hour = dateTime.hour;
    final minute = dateTime.minute;

    final monthName = _getMonthName(month);

    return "$hour:${minute.toString().padLeft(2, "0")}  -  $day $monthName";
  }

  String _getMonthName(int month) {
    final monthNames = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return monthNames[month];
  }
}
 */

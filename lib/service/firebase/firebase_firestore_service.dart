import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:cryptocurrency_exchange/model/coin.dart';
import 'package:cryptocurrency_exchange/model/news.dart';
import 'package:cryptocurrency_exchange/service/base/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/alert.dart';
import '../../tools/DeviceIdHelper.dart';

class FirebaseFirestoreService implements FirestoreService {
  //var favoriteCoins = FirebaseFirestore.instance.collection("FavoriteCoins");
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _deviceId;

  FirebaseFirestoreService() {
    _initDeviceId();
  }

  Future<void> _initDeviceId() async {
    //_deviceId = await DeviceIdHelper.getDeviceId();
  }

  Future<CollectionReference> get _userFavorites async {
    if (_deviceId == null) {
      await _initDeviceId();
    }
    return _firestore.collection("FavoriteCoins").doc(_deviceId).collection("Coins");
  }

  Future<CollectionReference> get _userAlerts async {
    if (_deviceId == null) {
      await _initDeviceId();
    }
    return _firestore.collection("alerts").doc(_deviceId).collection("alerts");
  }

  @override
  Future<void> addFavoriteCoin(Coin coin) async {
    //Map<String, dynamic> favoriteCoin = coin.toMap(); 2
    //await favoriteCoins.add(favoriteCoin); 1
    //await _userFavorites.doc(coin.id).set(favoriteCoin); 2
    Map<String, dynamic> favoriteCoin = coin.toMap();
    final userFavorites = await _userFavorites;
    await userFavorites.doc(coin.id).set(favoriteCoin);
  }

  @override
  Future<void> deleteFavoriteCoin(Coin coin) async {
    /*
    final favoriteCoin = await favoriteCoins.where('id', isEqualTo: coin.id).get();

    if (favoriteCoin.docs.isNotEmpty) {
      await favoriteCoin.docs.first.reference.delete();
    }
    1
     */
    //await _userFavorites.doc(coin.id).delete(); 2
    final userFavorites = await _userFavorites;
    await userFavorites.doc(coin.id).delete();
  }

  @override
  Future<List<Coin>> getFavoriteCoins() async {
    //final favCoins = await favoriteCoins.get(); 1
    /*
    final favCoins = await _userFavorites.get();
    return favCoins.docs.map((doc) {
      return Coin.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
    2
     */
    final userFavorites = await _userFavorites;
    final favCoins = await userFavorites.get();
    return favCoins.docs.map((doc) => Coin.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Stream<List<Coin>> getFavoriteCoinsStream() async* {
    /*
    return favoriteCoins.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Coin.fromMap(doc.data())).toList();
    });
    1
     */
    /*
    return _userFavorites.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Coin.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
    2
     */
    final userFavorites = await _userFavorites;
    yield* userFavorites.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Coin.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  @override
  Future<void> addAlert(Alert alert) async {
    /*
    Map<String, dynamic> addedAlert = alert.toMap();
    final userAlerts = await _userAlerts;
    await userAlerts.doc(alert.coinSymbol).set(addedAlert);
     */
    final userAlerts = await _userAlerts;
    DocumentReference docRef = userAlerts.doc();

    Alert newAlert = Alert(alert.above, alert.coinId, alert.coinImage, alert.coinSymbol, alert.targetPrice, id: docRef.id);

    await docRef.set(newAlert.toMap());
  }

  @override
  Future<void> deleteAlert(String alertId) async {
    final userAlerts = await _userAlerts;
    await userAlerts.doc(alertId).delete();
  }

  Stream<List<Alert>> getAlertsStream() async* {
    final userAlerts = await _userAlerts;
    yield* userAlerts.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Alert.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  Future<bool> isFavoriteCoin(Coin coin) async {
    /*
    final favCoin = await favoriteCoins.where('id', isEqualTo: coin.id).get();
    return favCoin.docs.isNotEmpty;
    1
     */
    /*
    final favCoin = await _userFavorites.doc(coin.id).get();
    return favCoin.exists;
    2
     */
    final userFavorites = await _userFavorites;
    final favCoin = await userFavorites.doc(coin.id).get();
    return favCoin.exists;
  }

  @override
  Future<List<News>> getNewsFromFirestore(String category) async {
    final news = await FirebaseFirestore.instance.collection(category).get();
    return news.docs.map((doc) => News.fromMap(doc.data())).toList();
  }

  @override
  Future<List<News>> getNews(String collection) async {
    try {
      final news = await FirebaseFirestore.instance.collection(collection).get();
      return news.docs.map((doc) => News.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('News could not be fetch from the database : $e');
    }
  }

  @override
  Future<void> addNews(List<News> newList, String collection) async {
    print("_firestoreRepository addNews()");
    try {
      for (var news in newList) {

        Map<String, dynamic> newsData = news.toMap();
        newsData["timestamp"] = FieldValue.serverTimestamp();
        //print(news.title);

        await FirebaseFirestore.instance.collection(collection).add(newsData);
      }
    } catch (e) {
      throw Exception('News could not be saved to the database : $e');
    }
  }

  @override
  Future<void> clearNews(String collection) async {
    print("_firestoreRepository clearNews()");
    try {
      final allNews = await FirebaseFirestore.instance.collection(collection).get();
      for (var news in allNews.docs) {
        await news.reference.delete();
      }
    } catch (e) {
      throw Exception('News could not be clear from the database : $e');
    }
  }

  @override
  Future<List<News>> getNewsCache(String collection) async {
    try {
      // Cache'den haberleri oku
      var newsCollection = FirebaseFirestore.instance.collection(collection);
      var snapshot = await newsCollection.get(GetOptions(source: Source.cache));  // Cache'den oku

      if (snapshot.docs.isEmpty) {
        print("${collection} CACHE IS EMPTY !!!!");
        // Eğer cache'de veri yoksa, Firestore'dan normal olarak oku
        snapshot = await newsCollection.get(GetOptions(source: Source.server));
      }

      return snapshot.docs.map((doc) => News.fromMap(doc.data())).toList();
    } catch (e) {
      print("Error fetching news from Firestore: $e");
      return [];
    }
  }

  @override
  Future<void> addNewsCache(List<News> newList, String collection) async {
    try {
      var newsCollection = FirebaseFirestore.instance.collection(collection);
      for (var news in newList) {
        Map<String, dynamic> newsData = news.toMap();
        newsData["timestamp"] = FieldValue.serverTimestamp();  // Zaman damgası ekle

        await newsCollection.add(newsData);
      }

      // Cache'i etkinleştir ve güncelle
      FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,);  // Cache'i etkinleştir

    } catch (e) {
      print("Error adding news to Firestore: $e");
    }

  }

  @override
  Future<void> clearNewsCache(String collection) async {
    try {
      /*
      final allNews = await FirebaseFirestore.instance.collection(collection).get();
      for (var news in allNews.docs) {
        await news.reference.delete();
      }
       */

      await FirebaseFirestore.instance.terminate();
      await FirebaseFirestore.instance.clearPersistence();
      await FirebaseFirestore.instance.enableNetwork();
    } catch (e) {
      throw Exception('News could not be clear from the database : $e');
    }
  }

  @override
  Future<DateTime?> getLastUpdateTimeStamp(String collection) async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection(collection)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var lastDoc = snapshot.docs.first;
        var timestamp = lastDoc['timestamp'] as Timestamp?;
        return timestamp?.toDate();
      } else {
        return DateTime(1970, 1, 1);
      }
    } catch (e) {
      throw Exception('Could not fetch the last update timestamp: $e');
    }
  }

  @override
  Future<bool> isUpdateNeeded(String collection, DateTime currentTimestamp) async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection(collection)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var lastDoc = snapshot.docs.first;
        var lastUpdateTimestamp = lastDoc['timestamp'] as Timestamp?;

        if (lastUpdateTimestamp != null) {
          DateTime lastUpdateTime = lastUpdateTimestamp.toDate();
          Duration difference = lastUpdateTime.difference(currentTimestamp);
          print(difference.inHours);
          return difference.inHours >= 24;
        }
      }
      return true;
    } catch (e) {
      print("Error checking last update timestamp: $e");
      return true;
    }
  }

}
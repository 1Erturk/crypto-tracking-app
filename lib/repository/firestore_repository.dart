import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptocurrency_exchange/base/firestore_base.dart';
import 'package:cryptocurrency_exchange/model/alert.dart';
import 'package:cryptocurrency_exchange/model/coin.dart';
import 'package:cryptocurrency_exchange/model/news.dart';
import 'package:cryptocurrency_exchange/service/base/firestore_service.dart';
import 'package:cryptocurrency_exchange/service/firebase/firebase_firestore_service.dart';
import '../tools/locator.dart';

class FirestoreRepository implements FirestoreBase {
  final FirestoreService _service = locator<FirebaseFirestoreService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addFavoriteCoin(Coin coin) async {
    return await _service.addFavoriteCoin(coin);
  }

  @override
  Future<void> deleteFavoriteCoin(Coin coin) async {
    return await _service.deleteFavoriteCoin(coin);
  }

  @override
  Future<List<Coin>> getFavoriteCoins() async {
    return await _service.getFavoriteCoins();
  }

  @override
  Stream<List<Coin>> getFavoriteCoinsStream() {
    return _service.getFavoriteCoinsStream();
  }

  @override
  Future<bool> isFavoriteCoin(Coin coin) async {
    return await _service.isFavoriteCoin(coin);
  }

  @override
  Future<void> addAlert(Alert alert) async {
    return await _service.addAlert(alert);
  }

  @override
  Future<void> deleteAlert(String alertId) async {
    return await _service.deleteAlert(alertId);
  }

  @override
  Stream<List<Alert>> getAlertsStream() {
    return _service.getAlertsStream();
  }

  @override
  Future<List<News>> getNewsFromFirestore(String category) async {
    return await _service.getNewsFromFirestore(category);
  }

  @override
  Future<List<News>> getNews(String collection) async {
    return await _service.getNews(collection);
  }

  @override
  Future<void> addNews(List<News> newList, String collection) async {
    return await _service.addNews(newList, collection);
  }

  @override
  Future<void> clearNews(String collection) async {
    return await _service.clearNews(collection);
  }

  @override
  Future<DateTime?> getLastUpdateTimeStamp(String collection) async {
    return await _service.getLastUpdateTimeStamp(collection);
  }

  @override
  Future<List<News>> getNewsCache(String collection) async {
    return await _service.getNewsCache(collection);
  }

  @override
  Future<void> addNewsCache(List<News> newList, String collection) async{
    return await _service.addNewsCache(newList, collection);
  }

  @override
  Future<void> clearNewsCache(String collection) async {
    return await _service.clearNewsCache(collection);
  }

  @override
  Future<bool> isUpdateNeeded(String collection, DateTime currentTimestamp) async {
    return await _service.isUpdateNeeded(collection, currentTimestamp);
  }



}
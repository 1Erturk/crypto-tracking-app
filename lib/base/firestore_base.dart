import 'package:cryptocurrency_exchange/model/coin.dart';
import '../model/alert.dart';
import '../model/news.dart';

abstract class FirestoreBase {
  Future<List<Coin>> getFavoriteCoins();
  Stream<List<Coin>> getFavoriteCoinsStream();
  Future<List<News>> getNewsFromFirestore(String category);
  Future<void> addFavoriteCoin(Coin coin);
  Future<void> deleteFavoriteCoin(Coin coin);
  Future<bool> isFavoriteCoin(Coin coin);
  Future<void> addAlert(Alert alert);
  Future<void> deleteAlert(String alertId);
  Stream<List<Alert>> getAlertsStream();
  Future<List<News>> getNews(String collection);
  Future<void> addNews(List<News> newList, String collection);
  Future<void> clearNews(String collection);
  Future<List<News>> getNewsCache(String collection);
  Future<void> addNewsCache(List<News> newList, String collection);
  Future<void> clearNewsCache(String collection);
  Future<DateTime?> getLastUpdateTimeStamp(String collection);
  Future<bool> isUpdateNeeded(String collection, DateTime currentTimestamp);
}
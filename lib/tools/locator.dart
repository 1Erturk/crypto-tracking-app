import 'package:cryptocurrency_exchange/repository/firestore_repository.dart';
import 'package:cryptocurrency_exchange/repository/news_repository.dart';
import 'package:cryptocurrency_exchange/service/api/api_news_service.dart';
import 'package:cryptocurrency_exchange/service/firebase/firebase_firestore_service.dart';
import 'package:get_it/get_it.dart';
import 'package:cryptocurrency_exchange/repository/coin_repository.dart';
import 'package:cryptocurrency_exchange/service/api/api_coin_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => CoinRepository());
  locator.registerLazySingleton(() => ApiCoinService());
  locator.registerLazySingleton(() => NewsRepository());
  locator.registerLazySingleton(() => ApiNewsService());
  locator.registerLazySingleton(() => FirestoreRepository());
  locator.registerLazySingleton(() => FirebaseFirestoreService());
}

import '../model/news.dart';

abstract class NewsBase {
  Future<List<News>> getBlockchainNews();
  Future<List<News>> getFinanceNews();
  Future<List<News>> getTechnologyNews();
  Future<List<News>> getEconomyNews();
}
import 'package:cryptocurrency_exchange/model/news.dart';
import 'package:cryptocurrency_exchange/service/api/api_news_service.dart';
import 'package:cryptocurrency_exchange/service/base/news_service.dart';
import 'package:cryptocurrency_exchange/tools/locator.dart';
import '../base/news_base.dart';

class NewsRepository implements NewsBase{
  final NewsService _service = locator<ApiNewsService>();

  Future<List<News>> getBlockchainNews() async {
    return await _service.getBlockchainNews();
  }

  Future<List<News>> getEconomyNews() async {
    return await _service.getEconomyNews();
  }

  Future<List<News>> getFinanceNews() async {
    return await _service.getFinanceNews();
  }

  Future<List<News>> getTechnologyNews() async {
    return await _service.getTechnologyNews();
  }

}
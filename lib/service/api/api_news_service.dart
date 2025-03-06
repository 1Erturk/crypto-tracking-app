import 'dart:convert';
import 'package:cryptocurrency_exchange/model/news.dart';
import 'package:cryptocurrency_exchange/service/base/news_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiNewsService implements NewsService {
  final String _baseUrl = "https://www.alphavantage.co/query?function=NEWS_SENTIMENT";
  final String _apiKey = dotenv.env['ALPHA_VANTAGE_API_KEY'] ?? '';

  @override
  Future<List<News>> getBlockchainNews() async {
    final response = await http.get(Uri.parse("$_baseUrl&topics=blockchain&sort=LATEST&limit=50&apikey=$_apiKey"));

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> dataNews = data["feed"] ?? [];
      if(dataNews.isEmpty) {
        //print("data is empty");
      } else {
        //print("DATA IS NOT EMPTY");
        //print(dataNews[0]["title"]);
      }
      return dataNews.map((news) => News.fromMap(news)).toList();
    } else {
      throw Exception("Failed to fetch coins: ${response.statusCode}");
    }
  }

  @override
  Future<List<News>> getEconomyNews() async {
    final response = await http.get(Uri.parse("$_baseUrl&topics=economy_monetary&sort=LATEST&limit=50&apikey=$_apiKey"));

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> dataNews = data["feed"] ?? [];
      return dataNews.map((news) => News.fromMap(news)).toList();
    } else {
      throw Exception("Failed to fetch coins: ${response.statusCode}");
    }
  }

  @override
  Future<List<News>> getFinanceNews() async {
    final response = await http.get(Uri.parse("$_baseUrl&topics=finance&sort=LATEST&limit=50&apikey=$_apiKey"));

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> dataNews = data["feed"] ?? [];
      return dataNews.map((news) => News.fromMap(news)).toList();
    } else {
      throw Exception("Failed to fetch coins: ${response.statusCode}");
    }
  }

  @override
  Future<List<News>> getTechnologyNews() async {
    final response = await http.get(Uri.parse("$_baseUrl&topics=technology&sort=LATEST&limit=50&apikey=$_apiKey"));

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> dataNews = data["feed"] ?? [];
      return dataNews.map((news) => News.fromMap(news)).toList();
    } else {
      throw Exception("Failed to fetch coins: ${response.statusCode}");
    }
  }

}
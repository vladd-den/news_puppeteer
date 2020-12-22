import 'package:flutter_news_app/src/helpers/constants.dart';
import 'package:flutter_news_app/src/models/newsResponseModel.dart';
import 'package:http/http.dart';

class NewsApiProvider {
  Client client = Client();
  final _apiKey = Constant.newsApiKey;
  int counter = 0;
  Future<List<Article>> fetchNewsList({String category = ''}) async {
    var url =
        "${Constant.baseUrl}${Constant.topHeadLine}?country=in&apiKey=$_apiKey&category=$category";
    // print("entered Url : $url");
    final response = await client.get(url);
    // print(response.body.toString());
    if (response.statusCode == 200) {
      print("Test passed");
      counter++;
      // If the call to the server was successful, parse the JSON
      return NewsApiResonse.fromRawJson(response.body).articles;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
  void main(){
    NewsApiProvider api = new NewsApiProvider();
    api.fetchNewsList();
  }
}
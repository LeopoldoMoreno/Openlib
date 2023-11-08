import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;

class ListBookData {
  final String? title;
  final String? thumbnail;
  ListBookData({this.title, this.thumbnail});
}

class OpenLibrary {
  String url = "https://openlibrary.org/trending/daily";

  List<ListBookData> _parser(data) {
    var document = parse(data.toString());
    var bookList = document.querySelectorAll('li[class="searchResultItem"]');
    List<ListBookData> trendingBooks = [];
    for (var element in bookList) {
      if (element.querySelector('h3[class="booktitle"]')?.text != null &&
          element.querySelector('img[itemprop="image" ]')?.attributes['src'] !=
              null) {
        String? thumbnail =
            element.querySelector('img[itemprop="image" ]')?.attributes['src'];
        trendingBooks.add(
          ListBookData(
              title:
                  element.querySelector('h3[class="booktitle"]')?.text.trim(),
              thumbnail: 'https:${thumbnail.toString()}'),
        );
      }
    }
    return trendingBooks;
  }

  Future<List<ListBookData>> trendingBooks() async {
    try {
      final dio = Dio();
      final response = await dio.get(url,
          options: Options(
              sendTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 20)));
      final response2 = await dio.get(
          "https://openlibrary.org/trending/daily?page=2",
          options: Options(
              sendTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 20)));
      return _parser('${response.data.toString()}${response2.data.toString()}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        throw "socketException";
      }
      rethrow;
    }
  }
}

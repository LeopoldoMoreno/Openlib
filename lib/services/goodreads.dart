import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import 'package:openlib/services/open_library.dart';

class GoodReads {
  String url = "https://www.goodreads.com/book/most_read";

  List<ListBookData> _listparser(data) {
    var document = parse(data.toString());
    var bookList =
        document.querySelectorAll('tr[itemType="http://schema.org/Book"]');
    List<ListBookData> trendingBooks = [];
    for (var element in bookList) {
      var bookTitle = element.querySelector('a[class="bookTitle"]');
      var bookImage = element.querySelector('img[itemprop="image" ]');
      if (bookTitle?.text != null && bookImage?.attributes['src'] != null) {
        String? thumbnail = bookImage?.attributes['src'];
        trendingBooks.add(
          ListBookData(
              title: bookTitle?.text.trim(),
              thumbnail: thumbnail.toString().replaceAll(
                  RegExp(r'\._SY75_|._SX50_|._SX80_|._SX160_'), '')),
        );
      }
    }
    return trendingBooks;
  }

  List<ListBookData> _curatedparser(data) {
    var document = parse(data.toString());
    var bookList = document.querySelectorAll('article[class="BookListItem"]');

    List<ListBookData> trendingBooks = [];
    for (var element in bookList) {
      var bookTitle = element.querySelector('a[data-testid="bookTitle"]');
      var bookImage = element.querySelector('img[class="ResponsiveImage"]');
      if (bookTitle?.text != null && bookImage?.attributes['srcset'] != null) {
        String? thumbnail = bookImage?.attributes['src'];
        trendingBooks.add(
          ListBookData(
              title: bookTitle?.text.trim(),
              thumbnail: thumbnail.toString().replaceAll(
                  RegExp(r'\._SY75_|._SX50_|._SX80_|._SX160_'), '')),
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
      return _listparser(response.data.toString());
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        throw "socketException";
      }
      rethrow;
    }
  }

  Future<List<ListBookData>> bookTok() async {
    try {
      url =
          "https://www.goodreads.com/list/show/164964.BookTok_Recommendations_TikTok";
      final dio = Dio();
      final response = await dio.get(url,
          options: Options(
              sendTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 20)));
      return _listparser(response.data.toString());
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        throw "socketException";
      }
      rethrow;
    }
  }

  Future<List<ListBookData>> newReleases() async {
    try {
      // Get the current date
      DateTime now = DateTime.now();

      // Extract the year and month from the current date
      int currentYear = now.year;
      int currentMonth = now.month;

      // Create the URL
      url =
          "https://www.goodreads.com/book/popular_by_date/$currentYear/$currentMonth";
      final dio = Dio();
      final response = await dio.get(url,
          options: Options(
              sendTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 20)));
      return _curatedparser(response.data.toString());
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        throw "socketException";
      }
      rethrow;
    }
  }
}

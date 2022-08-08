import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ott/http/API/Api_url.dart';
import 'package:ott/http/models/Categoriesmodels.dart';
import 'package:ott/http/models/Channelmodels.dart';
import 'package:ott/http/models/Coinmodels.dart';
import 'package:ott/http/models/Gamemodels.dart';
import 'package:ott/http/models/LikeModel.dart';
import 'package:ott/http/models/Trendingmodels.dart';
import 'package:ott/http/models/Viewdetails.dart';
import 'package:ott/http/models/Watchlistmodels.dart';
import 'package:ott/http/models/searchvideo.dart';
import 'package:ott/http/models/slidermodels.dart';
import 'package:ott/http/models/videodetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Remoteservices {
  // Future<SearchVideo>? resFromServer;

  Future<Like?> getlikeapi() async {
    Map<String, String> body = {"user_id": "3", "show_id": "0"};
    var client = http.Client();

    var uri = Uri.parse(API.like);

    var response = await client.post(uri, body: body);

    if (response.statusCode == 200) {
      var json = response.body;
      print(json);
      return likeFromJson(json);
    }
    return null;
  }

  Future<Watchlistmodels?> getWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userid = prefs.getInt('userid');
    print(userid);
    Map<String, dynamic> body = {"user_id": "$userid"};
    http.Response response;
    response = await http.post(Uri.parse(API.getWatchlist), body: body);
    print(response.body);
    if (response.statusCode == 200) {
      Watchlistmodels watchlistmodels =
          Watchlistmodels.fromJson(jsonDecode(response.body));
      print(watchlistmodels);
      return watchlistmodels;
    } else {
      return null;
    }
  }

  Future<Trendingmodels?> gettreanding() async {
    try {
      http.Response response;
      response = await http.get(Uri.parse(API.gettrending));
      print("this is home page" + response.body);
      if (response.statusCode == 200) {
        Trendingmodels trendingmodels =
            Trendingmodels.fromJson(jsonDecode(response.body));
        print(trendingmodels);
        return trendingmodels;
      } else {
        return null;
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<Viewdetails?> getViewdetails() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userid = prefs.getInt('userid');
    print(userid);
    Map<String, dynamic> body = {"user_id": "$userid"};
    http.Response response;
    response = await http.post(Uri.parse(API.getViewlist), body: body);
    print(response.body);
    if (response.statusCode == 200) {
      Viewdetails viewdetails = Viewdetails.fromJson(jsonDecode(response.body));
      print(viewdetails);
      return viewdetails;
    } else {
      return null;
    }
  }

  Future<Coinmodels?> getcoin() async {
    http.Response response;
    response = await http.get(Uri.parse(API.colors));
    print(response.body);
    if (response.statusCode == 200) {
      Coinmodels coinmodels = Coinmodels.fromJson(jsonDecode(response.body));
      print(coinmodels);
      return coinmodels;
    } else {
      return null;
    }
  }

  Future<Videodetailsmodels?> getVideodetails(String showid) async {
    http.Response response;
    response = await http.get(
        Uri.parse('https://bholiwood.in/mobileapp/api/videoDetails/$showid'));
    print(response.body);
    if (response.statusCode == 200) {
      Videodetailsmodels videodetailsmodels =
          Videodetailsmodels.fromJson(jsonDecode(response.body));
      print(videodetailsmodels);
      return videodetailsmodels;
    } else {
      return null;
    }
  }

  Future<Slidermodels?> getslider() async {
    http.Response response;
    response = await http.get(
      Uri.parse(API.getslider),
    );
    print(response.body);
    if (response.statusCode == 200) {
      Slidermodels slidermodels =
          Slidermodels.fromJson(jsonDecode(response.body));
      print(slidermodels);
      return slidermodels;
    } else {
      return null;
    }
  }

  Future<Gamemodel?> getgame() async {
    http.Response response;
    response = await http.get(
      Uri.parse(API.BASE_game_URL),
    );
    print(response.body);
    if (response.statusCode == 200) {
      Gamemodel gamemodel = Gamemodel.fromJson(jsonDecode(response.body));
      print(gamemodel);
      return gamemodel;
    } else {
      return null;
    }
  }

  Future<Channelmodels?> getChannel() async {
    http.Response response;
    response = await http.get(
      Uri.parse(API.channels),
    );
    print(response.body);
    if (response.statusCode == 200) {
      Channelmodels channelmodels =
          Channelmodels.fromJson(jsonDecode(response.body));
      print(channelmodels);
      return channelmodels;
    } else {
      return null;
    }
  }

  Future<Categoriesmodels?> getCategories(String categorieid) async {
    http.Response response;
    response = await http.get(
      Uri.parse(
          "https://bholiwood.in/mobileapp/api/display-alldata/$categorieid"),
    );
    print(response.body);
    if (response.statusCode == 200) {
      Categoriesmodels channelmodels =
          Categoriesmodels.fromJson(jsonDecode(response.body));
      print(channelmodels);
      return channelmodels;
    } else {
      return null;
    }
  }

  // Future<SearchVideo>? emptyList;
  // Future<SearchVideo>? getBooks2(String query) async {
  //   final url = Uri.parse(API.searchvideo);
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     SearchVideo resFromServer =
  //         SearchVideo.fromJson(jsonDecode(response.body));

  //     print("resFromServer  ${resFromServer.data![0].showId}");
  //     return resFromServer;
  //   }
  //   return emptyList;
  // }

  static Future<List<Searching>> getBooks(String query) async {
    final url = Uri.parse(API.searchvideo);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List videolist = json.decode(response.body);
      return videolist.map((json) => Searching.fromJson(json)).where((video) {
        final titleLower = video.videoTitle.toString().toLowerCase();
        final authorLower = video.videoName.toString().toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower) ||
            authorLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}

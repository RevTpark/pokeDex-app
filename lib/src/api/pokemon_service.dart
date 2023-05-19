import 'package:dio/dio.dart';

import 'package:pokedex_mobile_app/src/config/constants.dart';
import '../models/pokemon.dart';

class PokemonService{

  Future<Pokemon> getPokemonDetails(int id) async{
    String url = "${Const.baseUrl}/api/pokemon/$id";
    Map<String, dynamic> requestHeaders = {
      'Content-Type': 'application/json'
    };
    BaseOptions options = BaseOptions(
      receiveTimeout: Duration(seconds: 5),
      connectTimeout: Duration(seconds: 5),
      headers: requestHeaders,
    );

    try {
      final response = await Dio(options).get(url);
      return Pokemon.fromJson(response.data);
    }
    on DioError catch (e) {
      print(e);
      throw Exception("Get Pokemon Details Failed!!");
    }
  }

  Future<List<Pokemon>> getAllPokemon() async{
    String url = "${Const.baseUrl}/api/pokemon/all";
    Map<String, dynamic> requestHeaders = {
      'Content-Type': 'application/json'
    };
    BaseOptions options = BaseOptions(
      receiveTimeout: Duration(seconds: 5),
      connectTimeout: Duration(seconds: 5),
      headers: requestHeaders,
    );

    try {
      final response = await Dio(options).get(url);
      Iterable list = response.data;
      return list.map((item) => Pokemon.fromJson(item)).toList();
    }
    on DioError catch (e) {
      print(e);
      throw Exception("Get All Pokemon Failed!!");
    }
  }

  Future<Map> getTeamRank(List<int> ids) async{
    String url = "${Const.baseUrl}/api/team-strength";
    Map<String, dynamic> requestHeaders = {
      'Content-Type': 'application/json'
    };
    BaseOptions options = BaseOptions(
      receiveTimeout: Duration(seconds: 5),
      connectTimeout: Duration(seconds: 5),
      headers: requestHeaders,
    );

    try {
      Map data = {};
      for(int id=0; id < ids.length; id++){
        data["poke${id+1}"] = ids[id];
      }
      final response = await Dio(options).post(url, data: data);
      return response.data;
    }
    on DioError catch (e) {
      print(e);
      throw Exception("Post Team Ranked Failed!!");
    }
  }

  Future<List<Pokemon>> searchPokemonByName(String query) async{
    String url = "${Const.baseUrl}/api/search/$query";
    Map<String, dynamic> requestHeaders = {
      'Content-Type': 'application/json'
    };
    BaseOptions options = BaseOptions(
      receiveTimeout: Duration(seconds: 5),
      connectTimeout: Duration(seconds: 5),
      headers: requestHeaders,
    );

    try {
      final response = await Dio(options).get(url);
      Iterable list = response.data;
      return list.map((item) => Pokemon.fromJson(item)).toList();
    }
    on DioError catch (e) {
      print(e);
      throw Exception("Search Pokemon By Name Failed!!");
    }
  }

  Future<List<Pokemon>> searchPokemonByType(String type1, String type2) async{
    String url = "${Const.baseUrl}/api/search?type1=$type1&type2=$type2";
    Map<String, dynamic> requestHeaders = {
      'Content-Type': 'application/json'
    };
    BaseOptions options = BaseOptions(
      receiveTimeout: Duration(seconds: 5),
      connectTimeout: Duration(seconds: 5),
      headers: requestHeaders,
    );

    try {
      final response = await Dio(options).get(url);
      Iterable list = response.data;
      return list.map((item) => Pokemon.fromJson(item)).toList();
    }
    on DioError catch (e) {
      print(e);
      throw Exception("Search Pokemon By Type Failed!!");
    }
  }

}
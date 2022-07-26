import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokedex_mobile_app/src/config/enums.dart';
import 'package:pokedex_mobile_app/src/provider/rate_team_provider.dart';
import 'package:pokedex_mobile_app/src/widgets/menu_textbox.dart';
import 'package:provider/provider.dart';

import '../api/pokemon_service.dart';
import '../models/pokemon.dart';

class RateMyTeamDisplay extends StatefulWidget {
  const RateMyTeamDisplay({Key? key}) : super(key: key);

  @override
  State<RateMyTeamDisplay> createState() => _RateMyTeamDisplayState();
}

class _RateMyTeamDisplayState extends State<RateMyTeamDisplay> {
  int _currentIndex = 0;
  String _currentImageUrl = "";

  Future<List<Pokemon>> getPokemonList(RateTeamProvider provider) async {
    final List<Pokemon> pokemonList = await PokemonService().getAllPokemon();
    provider.initPokeTeam(pokemonList[0]);
    return pokemonList;
  }

  List<Widget> makeRowList(data, RateTeamProvider provider) {
    return provider.teamList
        .asMap()
        .map((idx, item) {
          return MapEntry(
            idx,
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = idx;
                  _currentImageUrl = item.image;
                });
              },
              child: Container(
                  margin: EdgeInsets.all(10),
                  width: 75,
                  decoration: BoxDecoration(
                      color: _currentIndex == idx ? Colors.lightBlue.shade100 : Colors.white24,
                    border: Border.all(
                      color: _currentIndex == idx ? Colors.lightBlue : Colors.white,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))
                  ),
                  child: Image.network(
                      item.image,
                      errorBuilder: (context, exception, stackTrace) {
                    return Image.asset(
                      "assets/images/pokeball_loader.png",
                    );
                  })),
            ),
          );
        }).values.toList();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    RateTeamProvider provider =
        Provider.of<RateTeamProvider>(context, listen: false);
    // print(provider.teamList);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder<List<Pokemon>>(
            future: getPokemonList(provider),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  height: height * 0.5.w,
                  margin: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Container(
                        height: height * 0.15.w,
                        // color: Colors.white,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: makeRowList(snapshot.data, provider),
                          ),
                        ),
                      ),
                      Container(
                        height: height * 0.35.w,
                        // width: width.w,
                        // color: Colors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: width*0.45.w,
                              child: Image.network(
                                  _currentImageUrl,
                                  errorBuilder: (context, exception, stackTrace) {
                                  return Image.asset(
                                    "assets/images/pokeball_loader.png",
                                  );
                                }
                              ),
                            ),
                            SizedBox(
                              width: width * 0.5.w,
                              child: ListWheelScrollView(
                                  itemExtent: 50,
                                  children: [
                                    Container(
                                      color: Colors.blueGrey,
                                      child: Text("Bulbasauor"),
                                    ),
                                    Container(
                                      color: Colors.blueGrey,
                                      child: Text("Bulbasauor"),
                                    ),
                                    Container(
                                      color: Colors.blueGrey,
                                      child: Text("Bulbasauor"),
                                    ),
                                    Container(
                                      color: Colors.blueGrey,
                                      child: Text("Bulbasauor"),
                                    ),
                                  ]
                              ),
                            )
                          ],
                        )
                      )
                    ],
                  ),
                );
              } else {
                return Container(
                    padding: const EdgeInsets.all(10.0),
                    child: const CircularProgressIndicator());
              }
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const[
            MenuTextBox(title: "Home", changeTo: ScreenLayout.home, widthFactor: 0.45,),
            MenuTextBox(title: "Get Ranked", changeTo: ScreenLayout.home, widthFactor: 0.45,)
          ],
        )
      ],
    );
  }
}

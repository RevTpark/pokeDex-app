import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokedex_mobile_app/src/api/pokemon_service.dart';
import 'package:pokedex_mobile_app/src/config/enums.dart';
import 'package:pokedex_mobile_app/src/widgets/menu_textbox.dart';
import 'package:pokedex_mobile_app/src/models/pokemon.dart';

class PokeDexList extends StatefulWidget {
  const PokeDexList({Key? key}) : super(key: key);

  @override
  State<PokeDexList> createState() => _PokeDexListState();
}

class _PokeDexListState extends State<PokeDexList> {
  String imageUrl = "";
  int _currentIndex = 0;

  Future<List<Pokemon>> getPokemonList() async {
    final List<Pokemon> pokemonList = await PokemonService().getAllPokemon();
    return pokemonList;
  }

  List<Widget> getList(data, width) {
    return data
        .map<Widget>((Pokemon item) => Container(
        decoration: BoxDecoration(
            color: imageUrl == item.image?
                      Color.fromRGBO(20, 220, 244, 1):
                      Color.fromRGBO(57, 173, 219, 0.8),
            border: Border.all(
                color: Color.fromRGBO(192, 253, 254, 1),
                width: 2
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8.0))
        ),
        width: width,
        margin: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${item.dexId}",
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,),
                Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: item.name.length > 14? 10: 14
                  )
                )
              ]
          ),
        )))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder<List<Pokemon>>(
          future: getPokemonList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Row(children: [
                SizedBox(
                  height: height * 0.45.w,
                  width: width * 0.45.w,
                  child: Image.network(
                      imageUrl,
                      errorBuilder: (context, exception, stackTrace) {
                    return Image.asset(
                      "assets/images/pokeball_loader.png",
                    );
                  }),
                ),
                Container(
                  height: height * 0.45.w,
                  width: width * 0.5.w,
                  margin: const EdgeInsets.only(bottom: 15),
                  child: ListWheelScrollView(
                      itemExtent: 75,
                      // magnification: 1.1,
                      // useMagnifier: true,
                      diameterRatio: 2.0,
                      squeeze: 1.4,
                      physics: FixedExtentScrollPhysics(),
                      overAndUnderCenterOpacity: 0.5,
                      onSelectedItemChanged: (index) => {
                            setState(() {
                              _currentIndex = index;
                              imageUrl = snapshot.data![index].image;
                            })
                          },
                      children: getList(snapshot.data, width)
                  ),
                ),
              ]);
            } else {
              return Container(
                  padding: const EdgeInsets.all(10.0),
                  child: const CircularProgressIndicator()
              );
            }
          },
        ),
        const MenuTextBox(title: "Home", changeTo: ScreenLayout.home)
      ],
    );
  }
}

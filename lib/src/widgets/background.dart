import 'package:flutter/material.dart';
import 'package:pokedex_mobile_app/src/widgets/pokedex.dart';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg.png"),
              fit: BoxFit.cover
          )
      ),
      child: const PokeDexFrame(),
    );
  }
}

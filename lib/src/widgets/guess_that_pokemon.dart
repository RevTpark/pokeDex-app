import 'package:flutter/material.dart';
import 'package:pokedex_mobile_app/src/config/enums.dart';
import 'package:pokedex_mobile_app/src/widgets/menu_textbox.dart';

class GuessThatPokemonDisplay extends StatefulWidget {
  const GuessThatPokemonDisplay({Key? key}) : super(key: key);

  @override
  State<GuessThatPokemonDisplay> createState() => _GuessThatPokemonDisplayState();
}

class _GuessThatPokemonDisplayState extends State<GuessThatPokemonDisplay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MenuTextBox(title: "Home", changeTo: ScreenLayout.home)
      ],
    );
  }
}

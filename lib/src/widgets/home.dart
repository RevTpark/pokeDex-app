import 'package:flutter/material.dart';

import '../config/enums.dart';
import 'menu_textbox.dart';

class HomeDisplay extends StatelessWidget {
  const HomeDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        MenuTextBox(title: "Guess That Pokemon!",changeTo: ScreenLayout.guessThatPokemon),
        MenuTextBox(title: "Pokedex", changeTo: ScreenLayout.pokedex),
        MenuTextBox(title: "Rate My Team", changeTo: ScreenLayout.rateMyTeam)
      ],
    );
  }
}

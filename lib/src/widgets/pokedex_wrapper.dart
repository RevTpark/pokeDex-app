import 'package:flutter/material.dart';
import 'package:pokedex_mobile_app/src/widgets/background.dart';

class PokedexWrapper extends StatelessWidget {
  const PokedexWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      body: Background(),
    );
  }
}

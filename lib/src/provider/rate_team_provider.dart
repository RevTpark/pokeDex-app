import 'package:flutter/material.dart';

import '../models/pokemon.dart';

class RateTeamProvider extends ChangeNotifier{
  late List<Pokemon> _teamList;
  bool _isInit = false;

  initPokeTeam(Pokemon poke){
    if(!_isInit){
      _teamList = List.generate(6, (i) => poke);
      _isInit = true;
    }
  }

  List<Pokemon> get teamList => _teamList;

  void updateTeamMember(int index, Pokemon newPoke){
    _teamList[index] = newPoke;
  }

}
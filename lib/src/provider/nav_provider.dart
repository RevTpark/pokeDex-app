import 'package:flutter/material.dart';
import 'package:pokedex_mobile_app/src/config/enums.dart';

class NavProvider extends ChangeNotifier{
  ScreenLayout _currentScreen = ScreenLayout.home;

  void changeLayout(ScreenLayout newScreen){
    _currentScreen = newScreen;
    notifyListeners();
  }

  getCurrentScreen(){
    ScreenLayout currentScreen = _currentScreen;
    return currentScreen;
  }
}
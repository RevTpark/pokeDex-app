import 'package:flutter/material.dart';
import 'package:pokedex_mobile_app/src/config/enums.dart';

class NavProvider extends ChangeNotifier{
  ScreenLayout _currentScreen = ScreenLayout.home;
  bool _isLoading = false;

  void updateLoading(){
    _isLoading = !_isLoading;
    notifyListeners();
  }

  bool loadingStatus(){
    bool isLoading = _isLoading;
    return isLoading;
  }

  void changeLayout(ScreenLayout newScreen){
    _currentScreen = newScreen;
    _isLoading = false;
    notifyListeners();
  }

  ScreenLayout getCurrentScreen(){
    ScreenLayout currentScreen = _currentScreen;
    return currentScreen;
  }
}
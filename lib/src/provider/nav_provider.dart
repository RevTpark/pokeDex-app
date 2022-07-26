import 'package:flutter/material.dart';
import 'package:pokedex_mobile_app/src/config/enums.dart';

class NavProvider extends ChangeNotifier{
  ScreenLayout _currentScreen = ScreenLayout.home;
  bool _isLoading = false;

  void updateLoading(){
    _isLoading = !_isLoading;
    notifyListeners();
  }

  bool get loadingStatus => _isLoading;

  void changeLayout(ScreenLayout newScreen){
    _currentScreen = newScreen;
    _isLoading = false;
    notifyListeners();
  }

  ScreenLayout get currentScreen => _currentScreen;
}
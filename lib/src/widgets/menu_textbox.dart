import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokedex_mobile_app/src/config/enums.dart';
import 'package:pokedex_mobile_app/src/provider/nav_provider.dart';
import 'package:provider/provider.dart';
import 'package:simple_shadow/simple_shadow.dart';

class MenuTextBox extends StatelessWidget {
  const MenuTextBox({Key? key, required this.title, required this.changeTo, this.widthFactor=0.85}) : super(key: key);
  final String title;
  final ScreenLayout changeTo;
  final double widthFactor;

  void handleClick(BuildContext context) async {
    NavProvider provider = Provider.of<NavProvider>(context, listen: false);
    provider.updateLoading();
    await Future.delayed(const Duration(seconds: 3), () {
      provider.changeLayout(changeTo);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => { handleClick(context) },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: SimpleShadow(
          opacity: 1,
          color: const Color.fromRGBO(29, 214, 255, 0.84),
          offset: Offset(0, 0), // Default: Offset(2, 2)
          sigma: 14,
          child: Container(
            width: width*widthFactor.w,
            margin: EdgeInsets.only(bottom: 25.w),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(47, 188, 245, 1),
                border: Border.all(
                    width: 4,
                    color: Colors.white
                ),
                borderRadius: const BorderRadius.all(Radius.circular(16.0))
            ),
            child: Container(
              padding: EdgeInsets.all(15.w),
              child: Center(
                child: SimpleShadow(
                  opacity: 0.8,
                  color: Colors.white,
                  offset: Offset(0, 0),
                  sigma: 4,
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

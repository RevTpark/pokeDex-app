import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokedex_mobile_app/src/provider/provider_list.dart';
import 'package:pokedex_mobile_app/src/widgets/pokedex_wrapper.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      builder: (context, child) {
        return MultiProvider(
          providers: ProviderList.getProviders(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            // theme: CustomTheme.getTheme(context),
            home: PokedexWrapper(),
            builder: (context, child) {
              int width = MediaQuery.of(context).size.width.toInt();
              return MediaQuery(
                data:
                    MediaQuery.of(context).copyWith(textScaleFactor: width / 414),
                child: child ?? Container(),
              );
            },
          ),
        );
      },
    );
  }
}

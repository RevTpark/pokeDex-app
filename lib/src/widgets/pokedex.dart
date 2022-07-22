import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokedex_mobile_app/src/widgets/guess_that_pokemon.dart';
import 'package:pokedex_mobile_app/src/widgets/home.dart';
import 'package:provider/provider.dart';

import '../provider/nav_provider.dart';

class PokeDexFrame extends StatefulWidget {
  const PokeDexFrame({Key? key}) : super(key: key);

  @override
  State<PokeDexFrame> createState() => _PokeDexFrameState();
}

class _PokeDexFrameState extends State<PokeDexFrame> with TickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,)
      ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<Widget> pages = <Widget>[
      const HomeDisplay(),
      const GuessThatPokemonDisplay(),
      const GuessThatPokemonDisplay(),
      const GuessThatPokemonDisplay()
    ];
    NavProvider provider = Provider.of<NavProvider>(context, listen: true);

    return Container(
      width: width,
      padding: EdgeInsets.fromLTRB(20.w, 40.w, 20.w, 40.w),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: AnimatedContainer(
                duration: const Duration(seconds: 2),
                height: provider.loadingStatus? height*0.4: height*0.7,
                width: width,
                margin: EdgeInsets.only(left: 10.w, right: 10.w),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(173, 236, 255, 0.49)
                ),
                child: provider.loadingStatus? null: pages[provider.currentScreen.index],
              ),
            ),
          ),
          provider.loadingStatus?
          RotationTransition(
            turns: _animationController,
            child: SizedBox(
              width: 82.w,
              child: Image.asset("assets/images/pokeball_loader.png"),
            ),
          ):Container(),
          AnimatedPositioned(
              top: provider.loadingStatus? height/4: 0,
              duration: const Duration(seconds: 2),
              child: SizedBox(
                width: 374.w,
                child: Image.asset(
                  "assets/images/dexframe_top.png",
                ),
              )
          ),
          AnimatedPositioned(
              bottom: provider.loadingStatus? height/4: 0,
              duration: const Duration(seconds: 2),
              child: SizedBox(
                width: 374.w,
                child: Image.asset(
                  "assets/images/dexframe_bottom.png",
                ),
              )
          ),
        ],
      ),
    );
  }
}

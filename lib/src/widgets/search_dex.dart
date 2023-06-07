import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/enums.dart';
import 'menu_textbox.dart';

class SearchDex extends StatefulWidget {
  const SearchDex({super.key});

  @override
  State<SearchDex> createState() => _SearchDexState();
}

class _SearchDexState extends State<SearchDex> {
  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width.w,
          height: height * 0.2.w,
          child: Row(
            children: [
              GestureDetector(
                child: Container(
                  width: width * 0.2.w,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(130, 179, 229, 252),
                      border: Border.all(
                        color: Colors.lightBlue
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))
                  ),
                  margin: EdgeInsets.fromLTRB(10.w, 5.w, 0, 0),
                  padding: EdgeInsets.all(10.w),
                  child: const Text("Name", textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                ),
              ),
              Container(
                width: width * 0.7.w,
                padding: EdgeInsets.all(15.w),
                child: TextField(
                    controller: _searchController,
                    decoration:
                        const InputDecoration(labelText: "Search Pokemon")),
              ),
            ],
          ),
        ),
        MenuTextBox(
          title: "Home",
          changeTo: ScreenLayout.home,
        ),
      ],
    );
  }
}

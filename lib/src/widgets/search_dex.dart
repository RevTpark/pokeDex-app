import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokedex_mobile_app/src/widgets/text_classifier.dart';
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final TextEditingController _controller = TextEditingController();
    final TextClassifier _classifier = TextClassifier();
     String review = "";
    List<double> predictions = [];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width.w,
          height: height * 0.2.w,
          child: Row(
            children: [
              Container(
                width: width * 0.7.w,
                padding: EdgeInsets.all(15.w),
                child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(labelText: "Put Pokemon")),
              ),
              TextButton(
                onPressed: (){
                  setState(() {
                      review = _controller.text;
                      predictions = _classifier.classify(review);
                    });
                    print(predictions);
                }, 
                child: const Text("Submit")
              )
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

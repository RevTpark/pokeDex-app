import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:pokedex_mobile_app/src/config/enums.dart';
import 'package:pokedex_mobile_app/src/widgets/menu_textbox.dart';

class GuessThatPokemonDisplay extends StatefulWidget {
  const GuessThatPokemonDisplay({Key? key}) : super(key: key);

  @override
  State<GuessThatPokemonDisplay> createState() =>
      _GuessThatPokemonDisplayState();
}

class _GuessThatPokemonDisplayState extends State<GuessThatPokemonDisplay> {
  static const modelPath = 'assets/model/model.tflite';
  static const labelsPath = 'assets/model/labels.txt';

  final ImagePicker imagePicker = ImagePicker();
  String? imagePath;
  Map<String, int>? classification;

  @override
  void initState() {
    super.initState();

    loadModel();
  }

  void loadModel() async {
    String? res = await Tflite.loadModel(
        model: modelPath,
        labels: labelsPath,
        numThreads: 1, // defaults to 1
        isAsset:true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:false // defaults to false, set to true to use GPU delegate
      );
  }

  void cleanResult() {
    setState(() {
      imagePath = null;
      classification = null;
    });
  }

  Future<void> processImage() async {
    if (imagePath != null) {
      try{
        print(imagePath);
        var recognitions = await Tflite.runModelOnImage(
            path: imagePath!, // required
            numResults: 10, // defaults to 5
            threshold: 0.01, // defaults to 0.1
            asynch: true // defaults to true
            );
        print("=======>$recognitions");
      }
      catch(e){
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // imagePath != null?Image.file(File(imagePath!)):Container(),
        Column(
          children: [
            if (classification != null)
              ...(classification!.entries.toList()
                    ..sort(
                      (a, b) => a.value.compareTo(b.value),
                    ))
                  .reversed
                  .map(
                    (e) => Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.orange.withOpacity(0.3),
                      child: Row(
                        children: [
                          Text('${e.key}: ${e.value}'),
                        ],
                      ),
                    ),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () async {
                    cleanResult();
                    final result = await imagePicker.pickImage(
                      source: ImageSource.camera,
                    );

                    setState(() {
                      imagePath = result?.path;
                    });
                    processImage();
                  },
                  icon: const Icon(
                    Icons.camera,
                    size: 64,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    cleanResult();
                    final result = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );

                    setState(() {
                      imagePath = result?.path;
                    });
                    processImage();
                  },
                  icon: const Icon(
                    Icons.photo,
                    size: 64,
                  ),
                ),
              ],
            )
          ],
        ),
        MenuTextBox(title: "Home", changeTo: ScreenLayout.home)
      ],
    );
  }
}

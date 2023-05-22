import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:pokedex_mobile_app/src/api/pokemon_service.dart';
import 'package:pokedex_mobile_app/src/widgets/upload_header.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:pokedex_mobile_app/src/config/enums.dart';
import 'package:pokedex_mobile_app/src/widgets/menu_textbox.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'classifer.dart';
import '../models/pokemon.dart';

class GuessThatPokemonDisplay extends StatefulWidget {
  const GuessThatPokemonDisplay({Key? key}) : super(key: key);

  @override
  State<GuessThatPokemonDisplay> createState() => _GuessThatPokemonDisplayState();
}

class _GuessThatPokemonDisplayState extends State<GuessThatPokemonDisplay> {
  static const modelPath = 'model/model.tflite';
  static const labelsPath = 'assets/model/labels.txt';
  final PokemonService service = PokemonService();

  late final List<String> labels;
  late final ClassifierModel model;

  final ImagePicker imagePicker = ImagePicker();
  String? imagePath;
  Pokemon? classification;

  @override
  void initState() {
    super.initState();

    _loadModel(modelPath);
    _loadLabels(labelsPath);
  }

  Future<void> _loadModel(String modelFileName) async {
    // #1
    final interpreter = await Interpreter.fromAsset(modelFileName);

    // #2
    final inputShape = interpreter.getInputTensor(0).shape;
    final outputShape = interpreter.getOutputTensor(0).shape;

    // #3
    final inputType = interpreter.getInputTensor(0).type;
    final outputType = interpreter.getOutputTensor(0).type;

    setState(() {
      model = ClassifierModel(
        interpreter: interpreter,
        inputShape: inputShape,
        outputShape: outputShape,
        inputType: inputType,
        outputType: outputType,
      );
    });
  }

  Future<void> _loadLabels(String labelsFileName) async {
    // #1
    final rawLabels = await rootBundle.loadString(labelsFileName);

    // #2
    final tempLabels = rawLabels.split('\n');
    setState(() {
      labels = tempLabels;
    });
  }

  TensorImage _preProcessInput(img.Image image) {
    // #1
    final inputTensor = TensorImage(model.inputType);
    inputTensor.loadImage(image);

    // #2
    final shapeLength = model.inputShape[1];
    final resizeOp = ResizeOp(shapeLength, shapeLength, ResizeMethod.BILINEAR);


    // #3
    final imageProcessor = ImageProcessorBuilder()
        .add(resizeOp)
        .build();

    imageProcessor.process(inputTensor);

    return inputTensor;
  }

  List<dynamic> _postProcessOutput(TensorBuffer outputBuffer) {
    // #1
    final probabilityProcessor = TensorProcessorBuilder().build();

    probabilityProcessor.process(outputBuffer);

    // #2
    final labelledResult = TensorLabel.fromList(labels, outputBuffer);

    // #3
    final categoryList = [];
    labelledResult.getMapWithFloatValue().forEach((key, value) {
      final category = [key, value];
      categoryList.add(category);
    });

    // #4
    categoryList.sort((a, b) => (b[1] > a[1] ? 1 : -1));

    return categoryList;
  }

  void predict(img.Image image) async {
    // Load the image and convert it to TensorImage for TensorFlow Input
    final inputImage = _preProcessInput(image);

    // Define the output buffer
    final outputBuffer = TensorBuffer.createFixedSize(
      model.outputShape,
      model.outputType,
    );

    // Run inference
    model.interpreter.run(inputImage.buffer, outputBuffer.buffer);

    // Post Process the outputBuffer
    final resultCategories = _postProcessOutput(outputBuffer);
    final topResult = resultCategories.first;

    final List<Pokemon> tempList = await service.searchPokemonByName(topResult[0]);
    setState(() {
      classification = tempList.first;
    });
  }

  void cleanResult() {
    setState(() {
      imagePath = null;
      classification = null;
    });
  }

  void processImage() {
    if (imagePath != null) {
      // Read image bytes from file
      final rawImage = File(imagePath!);

      final image = img.decodeImage(rawImage.readAsBytesSync())!;
      predict(image);
    }
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // imagePath != null?Image.file(File(imagePath!)):Container(),
        Column(
          children: [
            Container(
                height: height * 0.25.w,
                width: width,
                margin: EdgeInsets.fromLTRB(25.w, 5.w, 25.w, 0.w),
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                    color: Colors.white24,
                    border: Border.all(color: Colors.lightBlue),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(10))),
                child: classification == null?
                SizedBox(
                  width: width,
                  child: const Center(
                    child: Text("Select an image from gallery or click a picture of the pokemon\n\nCurrently able to classify the first 151 pokemon but don't worry more coming soon!", 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
                  ),
                )
                :Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("I CHOOSE YOU ${classification?.name.toUpperCase()}!", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900),),
                    Row(
                      children: [
                        SizedBox(
                          width: width*0.33.w,
                          child: Image.network("${classification?.image}", width: 125, height: 125, errorBuilder:
                                    (context, exception, stackTrace) {
                                  return Image.asset(
                                    "assets/images/pokeball_loader.png",
                                    width: 100,
                                    height: 100
                                  );
                                }),
                        ),
                        SizedBox(
                          width: width*0.45.w,
                          child: Text("${classification?.description}", 
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500), maxLines: 5, overflow: TextOverflow.ellipsis,)
                        )
                      ],
                    )
                  ],
                )
            ),
            Container(
              margin: EdgeInsets.all(15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   UploadHeader(
                    child: IconButton(
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
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                  UploadHeader(
                    child: IconButton(
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
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        MenuTextBox(title: "Home", changeTo: ScreenLayout.home)
      ],
    );
  }
}

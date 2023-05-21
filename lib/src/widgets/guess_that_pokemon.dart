import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:pokedex_mobile_app/src/config/enums.dart';
import 'package:pokedex_mobile_app/src/widgets/menu_textbox.dart';
import 'dart:typed_data';

class GuessThatPokemonDisplay extends StatefulWidget {
  const GuessThatPokemonDisplay({Key? key}) : super(key: key);

  @override
  State<GuessThatPokemonDisplay> createState() => _GuessThatPokemonDisplayState();
}

class _GuessThatPokemonDisplayState extends State<GuessThatPokemonDisplay> {
    static const modelPath = 'model/model-quant1.tflite';
    static const labelsPath = 'assets/model/labels.txt';

    late final Interpreter interpreter;
    late final List<String> labels;
    Tensor? inputTensor;
    Tensor? outputTensor;

    final ImagePicker imagePicker = ImagePicker();
    String? imagePath;
    img.Image? image;
    Map<String, int>? classification;

    @override
  void initState() {
    super.initState();

    loadModel();
    loadLabels();
  }

  Future<void> loadModel() async{
    try{
    final options = InterpreterOptions();

    if(Platform.isAndroid){
      options.addDelegate(GpuDelegateV2());
    }
    interpreter = await Interpreter.fromAsset(modelPath, options: options);
      inputTensor = interpreter.getInputTensors().first;
      // Get tensor output shape [1, 1001]
      outputTensor = interpreter.getOutputTensors().first;
    setState(() {}); 

    print("done with model");
    }
    catch(e){
      print("${e}");
    }
  }

  Future<void> loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  void cleanResult() {
    setState(() {
      imagePath = null;
      image = null;
      classification = null;
    });
  }

  Future<void> processImage() async {
    if (imagePath != null) {
      // Read image bytes from file
      final imageData = File(imagePath!).readAsBytesSync();

      // Decode image using package:image/image.dart (https://pub.dev/image)
      setState(() {
        image = img.decodeImage(imageData);
      });
      
      // Resize image for model input (Mobilenet use [224, 224])
      final imageInput = img.copyResize(
        image!,
        width: 180,
        height: 180,
      );

      final imageMatrix = List.generate(
        imageInput.height,
        (y) => List.generate(
          imageInput.width,
          (x) {
            final pixel = imageInput.getPixel(x, y);
            return [pixel.r, pixel.g, pixel.b];
          },
        ),
      );

      // Run model inference
      runInference(imageMatrix);
    }
  }

    Future<void> runInference(var imageMatrix,) async {
    // Set tensor input [1, 224, 224, 3]
    final input = [imageMatrix];
    // Set tensor output [1, 10001]
    final output = [List<double>.filled(151, 0.0)];

    // Run inference
    interpreter.run(input, output);

    // Get first output tensor
    final result = output.first;

    // Set classification map {label: points}
    classification = <String, int>{};

    for (var i = 0; i < result.length; i++) {
      if (result[i] != 0) {
        
        // classification![labels[i]] = result[i];
      }
    }

    setState(() {});
  }

  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // imagePath != null?Image.file(File(imagePath!)):Container(),
        Column(
          children: [
            Text(
              'Input: (shape: ${inputTensor?.shape} type: ${inputTensor?.type})',
            ),
            Text(
              'Output: (shape: ${outputTensor?.shape} type: ${outputTensor?.type})',
            ),
            if (image != null) ...[
                Text('Num channels: ${image?.numChannels}'),
                Text(
                    'Bits per channel: ${image?.bitsPerChannel}'),
                Text('Height: ${image?.height}'),
                Text('Width: ${image?.width}'),
            ],
            if (classification != null)
              ...(classification!.entries.toList()
                  ..sort(
                    (a, b) =>
                        a.value.compareTo(b.value),
                  ))
                .reversed
                .map(
                  (e) => Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.orange
                        .withOpacity(0.3),
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

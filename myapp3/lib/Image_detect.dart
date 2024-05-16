import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp3/Home_screen.dart'; // Import the HomeScreen class

void main() {
  runApp(const pokemondetect());
}

class pokemondetect extends StatelessWidget {
  const pokemondetect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pokemon Detect'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()), // Navigate to the HomeScreen
              );
            },
          ),
        ),
        body: const ImageAndTextLabelling(),
      ),
    );
  }
}

class ImageAndTextLabelling extends StatefulWidget {
  const ImageAndTextLabelling({Key? key}) : super(key: key);

  @override
  State<ImageAndTextLabelling> createState() => _ImageAndTextLabellingState();
}

class _ImageAndTextLabellingState extends State<ImageAndTextLabelling> {
  File? _pickedImage;
  final ImagePicker _imagePicker = ImagePicker();
  final ImageLabeler _imageLabeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.8));
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  String _labelsText = '';
  String _recognizedText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_pickedImage != null)
              Image.file(
                _pickedImage!,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 300,
                color: Colors.black,
                width: double.infinity,
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_labelsText, style: const TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_recognizedText, style: const TextStyle(fontSize: 16)),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                child: const Text('Pick Image'),
                onPressed: pickImageFromGallery,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImageFromGallery() async {
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _pickedImage = File(image.path);
    });

    final inputImage = InputImage.fromFile(_pickedImage!);
    identifyImage(inputImage);
    recognizeText(inputImage);
  }

  Future<void> identifyImage(InputImage inputImage) async {
    final List<ImageLabel> labels = await _imageLabeler.processImage(inputImage);
    setState(() {
      _labelsText = labels.map((label) => 'Label: ${label.label}, Confidence: ${label.confidence.toStringAsFixed(2)}').join('\n');
    });
  }

  Future<void> recognizeText(InputImage inputImage) async {
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
    setState(() {
      _recognizedText = recognizedText.text;
    });
  }

  @override
  void dispose() {
    _imageLabeler.close();
    _textRecognizer.close();
    super.dispose();
  }
}


import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'preview_page.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class CameraPage extends StatefulWidget {
  const CameraPage({
    Key? key,
    required this.responses,
    required this.organ,
}) : super(key: key);
  final List responses;
  final String organ;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {

  File? _image;
  final picker = ImagePicker();

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print("Image picked");
        //widget.imgUrl = null;
      }
      else {
        print("No Image Picked");
      }
    });
  }

  // Future pickImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.camera);
  //     if(image == null) return;
  //     final imageTemp = File(image.path);
  //     setState(() {
  //       this._image = imageTemp;
  //       print("Picture taken");
  //     });
  //   } on PlatformException catch(e) {
  //     print('Failed to pick image: $e');
  //   }
  // }

  late final model = GenerativeModel(
      apiKey: dotenv.env['OPENAI_API_KEY']!, model: 'gemini-pro-vision');
  String textResponse = '';
  String diagnosis = '';
  String advice = '';
  int diagnoseButtonClicked = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    // gptFunctionCalling();
    //geminiFunctionCalling();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  // Generate AI questions and responses
  void geminiFunctionCalling() async {
    setState(() {
      diagnoseButtonClicked = 1;
    });
    final prompt = TextPart("Act as a doctor specifically for dancers. Analyze the image, provide an assessment of my injury and give me some advice.\n"
        "Take note of the following answers to some questions to check for symptoms of the injury: ${widget.responses}"
        'Return the assessment and advice in a JSON object. The length of the assessment should be 100 words and advice should be 150 words.'
        "DO NOT type anything at the beginning or end of the json. The json should look like {'assessment': <assessment>, 'advice': <advice>}"
    //"Please only return the result in a JSON object like this {'diagnosis': 'diagnosis': <diagnosis>, 'advice': <advice>}"
    );

    final imageBytes = await _image?.readAsBytes();
    if (imageBytes != null) {
      final imagePart = [DataPart('image/jpeg', await imageBytes)];

      final response = await model.generateContent([
        Content.multi([prompt, ...imagePart])
      ]);

      if (response != null) {
        textResponse = response.text!;
        print(textResponse);

        try {
          // setState(() {
          //   diagnosis = textResponse;
          // });
          // print(diagnosis);

          String cleanedResponse = response.text!.replaceAll('```json', '');
          cleanedResponse = cleanedResponse.replaceAll('```JSON', '').trim();
          cleanedResponse = cleanedResponse.replaceAll('```', '').trim();

          Map<String, dynamic> output = jsonDecode(cleanedResponse);
          print(output['assessment']);
          print(output['advice']);

          setState(() {
            diagnosis = output['assessment'];
            advice = output['advice'];
          });

          //final jsonResponse = jsonDecode(textResponse);
          // if (jsonResponse is Map<String, dynamic>) {
          //   setState(() {
          //     diagnosis = jsonResponse['diagnosis'];
          //     advice = jsonResponse['advice'];
          //   });
          //   print(jsonResponse['diagnosis']);
          //   print(jsonResponse['advice']);
          //
          // } else {
          //   print("Warning: Response may not be in expected JSON format");
          // }
        } on FormatException {
          print("Warning: Could not parse response as JSON");
        }
      } else {
        print("Error: Could not receive response from the model");
      }
    } else {
      print("Error reading file when trying to send data to google gen AI");
    }


    // String systemPrompt =
    //     'act as a doctor specifically for dancers. Provide an assessment of my injury and give me some advices';
    // String userPrompt =
    //     'Analyze the image and provide the diagnosis of my injury as a json format'
    //     ' to assess my health. Please only return the json file. DO NOT type '
    //     'anything at the beginning or end of the json. The json should look like '
    //     'this {"diagnosis":"diagnosis": <diagnosis>, "advice": <advice>}';
    //
    //
    // final chat = model.startChat(history: [
    //   Content.text(userPrompt),
    //   Content.model([TextPart(systemPrompt)]),
    // ]);
    //
    //
    // final message = userPrompt;
    //
    //
    // final response = await chat.sendMessage(Content.text(message));
    //
    //
    // if (!mounted) return;
    //
    //
    // setState(() {
    //   Map<String, dynamic> result = jsonDecode(response.text!);
    //   questions = result['questions'];
    //   responses = List.generate(questions.length, (index) => "No");
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Image Picker Example"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                MaterialButton(
                    color: Colors.blue,
                    child: const Text(
                        "Pick Image from Gallery",
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.bold
                        )
                    ),
                    onPressed: () {
                      getImageGallery();
                    }
                ),
                // MaterialButton(
                //     color: Colors.blue,
                //     child: const Text(
                //         "Pick Image from Camera",
                //         style: TextStyle(
                //             color: Colors.white70, fontWeight: FontWeight.bold
                //         )
                //     ),
                //     onPressed: () {
                //       //pickImage();
                //     }
                // ),
                Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _image != null
                    ? Image.file(
                    _image!.absolute,
                    fit: BoxFit.cover,
                    )
                    : Center(
                    child: Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 30,
                    ),
                  )
                ),
                MaterialButton(
                    color: Colors.blue,
                    child: const Text(
                        "Diagnose Injury",
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.bold
                        )
                    ),
                    onPressed: geminiFunctionCalling
                ),
                diagnosis != '' ?
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 30,),
                          Text('Diagnosis: $diagnosis'),
                          SizedBox(height: 20,),
                          Text('Advice $advice')
                        ],
                      ),
                    )
                : diagnoseButtonClicked == 0 ?
                    Container() :
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 30,),
                      CircularProgressIndicator()],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
  /*late CameraController? _cameraController;
  bool _isRearCameraSelected = true;


  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    if (widget.cameras != null && widget.cameras!.isNotEmpty) {
      initCamera(widget.cameras![0]);
    } else {
     debugPrint("No cameras found");
    }
  }


  Future takePicture() async {
    if (_cameraController?.value.isInitialized != true) {
      return null;
    }
    if (_cameraController?.value.isTakingPicture == true) {
      return null;
    }
    try {
      await _cameraController?.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController!.takePicture();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewPage(
                picture: picture,
              )));
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }


  Future initCamera(CameraDescription cameraDescription) async {
    if (widget.cameras == null || widget.cameras!.isEmpty) {
      // Handle the case where there are no cameras available
      debugPrint('No cameras found');
      return;
    }
    _cameraController = CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController?.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('DanceWell', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body:
      SafeArea(
          child: Stack(children: [
            (_cameraController!.value.isInitialized)
                ? CameraPreview(_cameraController!)
                : Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator())),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      color: Colors.black),
                  child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Expanded(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 30,
                          icon: Icon(
                              _isRearCameraSelected
                                  ? CupertinoIcons.switch_camera
                                  : CupertinoIcons.switch_camera_solid,
                              color: Colors.white),
                          onPressed: () {
                            setState(
                                    () => _isRearCameraSelected = !_isRearCameraSelected);
                            initCamera(widget.cameras![_isRearCameraSelected ? 0 : 1]);
                          },
                        )),
                    Expanded(
                        child: IconButton(
                          onPressed: takePicture,
                          iconSize: 50,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.circle, color: Colors.white),
                        )),
                    const Spacer(),
                  ]),
                )),
          ]),
        )
    );
  } */
}
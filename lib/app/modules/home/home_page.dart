import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum sourcePicture { camera, gallery }
enum AppState {
  free,
  cropped,
}

class _HomePageState extends State<HomePage> {
  late AppState state;
  File image = File('');
  File? file;
  bool preloaded = false;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image Gallery'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: Container(
            child: Row(
              children: [
                new IconButton(
                    onPressed: () {
                      _imageSelected(sourcePicture.camera);
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    )),
                Text(
                  '|',
                  style: TextStyle(fontSize: 22),
                ),
                new IconButton(
                    onPressed: () {
                      _imageSelected(sourcePicture.gallery);
                    },
                    icon: Icon(
                      Icons.photo_library,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        ),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              /* Center(
                  child: Text('Running on: $_platformVersion\n'),
                ), */
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    preloaded
                        ? Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Imagem Fonte:",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    gradient: LinearGradient(
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        colors: [
                                          Colors.red.withOpacity(0.6),
                                          Colors.red.withOpacity(0.6),
                                        ],
                                        stops: [
                                          0.0,
                                          1.0
                                        ])),
                                width: MediaQuery.of(context).size.width,
                                /* height: MediaQuery.of(context).size.height*0.5, */
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.file(image),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 40),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                gradient: LinearGradient(
                                    begin: FractionalOffset.topCenter,
                                    end: FractionalOffset.bottomCenter,
                                    colors: [
                                      Colors.red.withOpacity(0.6),
                                      Colors.red,
                                    ],
                                    stops: [
                                      0.0,
                                      1.0
                                    ])),
                            width: 300,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () => {},
                                      icon: Icon(
                                        Icons.visibility_off,
                                        color: Colors.white,
                                      )),
                                  Text(
                                    "Nenhuma Imagem Selecionada",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _imageSelected(sourcePicture sourceImage) async {
    XFile? image2 = await ImagePicker().pickImage(
        source: sourceImage == sourcePicture.camera
            ? ImageSource.camera
            : ImageSource.gallery);

    if (image2 != null) {
      File? croppedImage = await ImageCropper.cropImage(
          sourcePath: image2.path,
          aspectRatioPresets: Platform.isAndroid
              ? [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9
                ]
              : [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio5x3,
                  CropAspectRatioPreset.ratio5x4,
                  CropAspectRatioPreset.ratio7x5,
                  CropAspectRatioPreset.ratio16x9
                ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cortador',
              toolbarColor: Colors.red,
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: Colors.red,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false));

      setState(() {
        image = croppedImage!;
        file = croppedImage;
        preloaded = true;
      });

      _afterCropImage();
    } else {
      return;
    }
  }

  void _afterCropImage() {
    setState(() {
      state = AppState.cropped;
    });
    //intervalStatusPages();
    //Navigator.of(context).pop();
  }

  void emptyValues() {
    setState(() {
      preloaded = false;
      image = File('');
      state = AppState.free;
    });
  }
}

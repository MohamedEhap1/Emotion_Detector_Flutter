import 'package:camera/camera.dart';
import 'package:emotion_detector/main.dart';
import 'package:emotion_detector/widgets/social_services.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow_lite_flutter/tensorflow_lite_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CameraController? cameraController;
  String output = '';
  double percent = 0;
  int swapCamera = 0;
  loadCamera() {
    cameraController =
        CameraController(cameras![swapCamera], ResolutionPreset.max);
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        //capture frame
        setState(() {
          cameraController!.startImageStream((image) {
            runModel(image);
          });
        });
      }
    });
  }

  runModel(CameraImage? image) async {
    if (image != null) {
      var recognitions = await Tflite.runModelOnFrame(
          bytesList: image.planes.map((plane) {
            return plane.bytes;
          }).toList(), // required
          imageHeight: image.height,
          imageWidth: image.width,
          imageMean: 127.5, // defaults to 127.5
          imageStd: 127.5, // defaults to 127.5
          rotation: 90, // defaults to 90, Android only
          numResults: 2, // defaults to 5
          threshold: 0.1, // defaults to 0.1
          asynch: true // defaults to true
          );
      // ignore: avoid_function_literals_in_foreach_calls
      recognitions!.forEach(
        (element) {
          setState(() {
            output = element['label'];
            percent = element['confidence'];
            percent *= 100;
          });
        },
      );
    }
  }

  loadModel() async {
    // await Tflite.close();
    await Tflite.loadModel(
        model: 'assets/model/model_unquant.tflite',
        labels: 'assets/model/labels.txt');
  }

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadModel();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Emotion Detector'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //here the camera
            Expanded(
              child: SizedBox(
                // height: MediaQuery.of(context).size.height * 0.70,
                width: MediaQuery.of(context).size.width,
                //width: double.infinity,
                // child: !cameraController!.value.isInitialized
                child: !cameraController!.value.isInitialized
                    ? Container()
                    : CameraPreview(cameraController!),
                // ? Container()
                //: AspectRatio(
                //  aspectRatio: cameraController!.value.aspectRatio,
                //child: CameraPreview(cameraController!),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  swapCamera = swapCamera == 0 ? 1 : 0;
                  loadCamera();
                });
              },
              child: SizedBox(
                width: 50,
                height: 50,
                child: Image(
                  image: AssetImage('assets/images/_camera_change-512.webp'),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '$output %${(percent).toInt()}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Don\'t forget to contact me on social media'),
            const SizedBox(
              height: 15,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SocialServices(
                  image: 'assets/images/whatsapp.png',
                  url: 'https://wa.me/qr/4WEUBSKUPRULO1',
                ),
                SocialServices(
                  image: 'assets/images/facebook.png',
                  url:
                      'https://www.facebook.com/profile.php?id=100033929641761&mibextid=ZbWKwL',
                ),
                SocialServices(
                  image: 'assets/images/linkedin.png',
                  url:
                      'https://www.linkedin.com/in/mohamed-ehap-017385271?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app',
                ),
                SocialServices(
                  image: 'assets/images/instagram.png',
                  url:
                      'https://www.instagram.com/mohamebehap_2004?igsh=MTlmc3hkc2J6YnFjcw==',
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ));
  }
}

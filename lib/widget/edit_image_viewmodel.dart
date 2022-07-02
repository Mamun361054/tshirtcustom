import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import '../edit_image_screen.dart';
import '../model/shirt_info.dart';
import '../model/text_info.dart';
import '../utils/utils.dart';
import 'default_button.dart';
import 'home_main_menu.dart';

abstract class EditImageViewModel extends State<EditImageScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorController = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();

  ShirtInfo shirtInfo = ShirtInfo(shirtColor: Colors.white,textInfos: [],templates: [],side: TemplateSide.front);
  int currentIndex = 0;
  Menu menu = Menu.image;

  setCurrentIndex(BuildContext context, index) {
    setState(() {
      currentIndex = index;
      menu = Menu.text;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
      'Selected for styling',
      style: TextStyle(
        fontSize: 16.0,
      ),
    )));
  }

  frontSide(){
    shirtInfo.side = TemplateSide.front;
    setState(() {});
  }

  backSide(){
    shirtInfo.side = TemplateSide.back;
    setState(() {});
  }

  alignLeft() {
    setState(() {
      shirtInfo.textInfos![currentIndex].textAlign = TextAlign.left;
    });
  }

  alignRight() {
    setState(() {
      shirtInfo.textInfos![currentIndex].textAlign = TextAlign.right;
    });
  }

  alignCenter() {
    setState(() {
      shirtInfo.textInfos![currentIndex].textAlign = TextAlign.center;
    });
  }

  increaseFontSize() {
    setState(() {
      shirtInfo.textInfos![currentIndex].fontSize += 2;
    });
  }

  decreaseFontSize() {
    setState(() {
      shirtInfo.textInfos![currentIndex].fontSize -= 2;
    });
  }

  italicText() {
    setState(() {
      if (shirtInfo.textInfos![currentIndex].fontStyle == FontStyle.italic) {
        shirtInfo.textInfos![currentIndex].fontStyle = FontStyle.normal;
      } else {
        shirtInfo.textInfos![currentIndex].fontStyle = FontStyle.italic;
      }
    });
  }

  boldText() {
    setState(() {
      if (shirtInfo.textInfos![currentIndex].fontWeight == FontWeight.bold) {
        shirtInfo.textInfos![currentIndex].fontWeight = FontWeight.normal;
      } else {
        shirtInfo.textInfos![currentIndex].fontWeight = FontWeight.bold;
      }
    });
  }

  removeText(BuildContext context) {
    setState(() {
      shirtInfo.textInfos!.removeAt(currentIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
      'Deleted',
      style: TextStyle(fontSize: 16.0),
    )));
  }

  changeTextColor(Color color) {
    setState(() {
      shirtInfo.textInfos![currentIndex].color = color;
    });
  }

  changeShirtColor(Color color) {
    setState(() {
      shirtInfo.shirtColor = color;
    });
  }

  addLinesToText() {
    setState(() {
      if (shirtInfo.textInfos![currentIndex].text.contains('\n')) {
        shirtInfo.textInfos![currentIndex].text =
            shirtInfo.textInfos![currentIndex].text.replaceAll('\n', ' ');
      } else {
        shirtInfo.textInfos![currentIndex].text =
            shirtInfo.textInfos![currentIndex].text.replaceAll(' ', '\n');
      }
    });
  }

  saveToGallery(BuildContext context) {
    if (shirtInfo.textInfos!.isNotEmpty) {
      screenshotController.capture().then((Uint8List? image) {
        saveImage(image!);
        const SnackBar(content: Text('Image saved to gallery.'));
      }).catchError((error) => print(error));
    }
  }

  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = 'screenshot_$time';
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  addNewDialog(context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add New Text'),
              content: TextField(
                controller: textEditingController,
                maxLines: 5,
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.edit),
                    filled: true,
                    hintText: 'Your Text here...'),
              ),
              actions: [
                DefaultButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Back'),
                  color: Colors.white,
                  textColor: Colors.black,
                ),
                DefaultButton(
                  onPressed: () => addNewText(context),
                  child: const Text('Add Text'),
                  color: Colors.red,
                  textColor: Colors.white,
                )
              ],
            ));
  }

  addNewText(BuildContext context) {
    setState(() {
      menu = Menu.text;
      shirtInfo.textInfos!.add(TextInfo(
          text: textEditingController.text,
          left: 0,
          top: 0,
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          fontSize: 20,
          textAlign: TextAlign.left));
    });
    Navigator.of(context).pop();
  }

  final templates = [
    'assets/t-shirt/crew_front.png',
    'assets/t-shirt/crew_back.png'
  ];

}

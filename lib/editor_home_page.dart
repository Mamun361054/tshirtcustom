import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'edit_image_screen.dart';

class EditorHomePage extends StatefulWidget {
  const EditorHomePage({Key? key}) : super(key: key);

  @override
  State<EditorHomePage> createState() => _EditorHomePageState();
}

class _EditorHomePageState extends State<EditorHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          icon: const Icon(Icons.upload_file),
          onPressed: () async {
            XFile? file = await ImagePicker().pickImage(
              source: ImageSource.gallery,
            );

            if (file != null) {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditImageScreen(selectedImage: file.path,)));
            }
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:tshirtcustom/widget/edit_image_viewmodel.dart';
import 'package:tshirtcustom/widget/home_main_menu.dart';
import 'package:tshirtcustom/widget/image_text.dart';

import 'model/shirt_info.dart';

class EditImageScreen extends StatefulWidget {

  const EditImageScreen({Key? key}) : super(key: key);

  // final String selectedImage;
  //
  // const EditImageScreen({Key? key, required this.selectedImage})
  //     : super(key: key);

  @override
  State<EditImageScreen> createState() => _EditImageScreenState();
}

class _EditImageScreenState extends EditImageViewModel {

  @override
  Widget build(BuildContext context) {

    shirtInfo.templates = templates;

    return Scaffold(
      appBar: _appBar,
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                const SizedBox(width: 8.0,),
                HomeMainTemplate(title: 'Font',template: templates[0],pressed: (){
                  frontSide();
                },isSelected: shirtInfo.side == TemplateSide.front,),
                const SizedBox(width: 8.0,),
                HomeMainTemplate(title: 'Back',template: templates[1],pressed: (){
                  backSide();
                },isSelected: shirtInfo.side == TemplateSide.back,),
              ],
            ),
          ),
          Expanded(child: Screenshot(
            controller: screenshotController,
            child: SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Stack(
                  children: [
                    _selectedImage,
                    for (int i = 0; i < shirtInfo.textInfos!.length; i++)
                      Positioned(
                        left: shirtInfo.textInfos![i].left,
                        top: shirtInfo.textInfos![i].top,
                        child: GestureDetector(
                          onLongPress: () {
                            setState(() {
                              currentIndex = i;
                              removeText(context);
                            });
                          },
                          onTap: () => setCurrentIndex(context, i),
                          child: Draggable(
                            feedback: ImageText(textInfo: shirtInfo.textInfos![i]),
                            child: ImageText(textInfo: shirtInfo.textInfos![i]),
                            onDragEnd: (drag) {
                              final renderBox =
                              context.findRenderObject() as RenderBox;
                              Offset offset = renderBox.globalToLocal(drag.offset);
                              setState(() {
                                shirtInfo.textInfos![i].top = offset.dy - 90;
                                shirtInfo.textInfos![i].left = offset.dx;
                              });
                            },
                          ),
                        ),
                      ),
                    creatorController.text.isNotEmpty
                        ? Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: Text(
                        creatorController.text,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.3)),
                      ),
                    )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          )),
          SizedBox(
            height: 95.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                const SizedBox(height: 8.0,),
                HomeMainMenu(title: 'Text',icon: Icons.text_fields_rounded,menu: Menu.text,pressed: (){
                  addNewDialog(context);
                },isSelected: menu == Menu.text,),
                const SizedBox(height: 8.0,),
                HomeMainMenu(title: 'Sticker',icon: Icons.image,menu: Menu.text,pressed: (){
                  menu = Menu.image;
                  setState(() {});
                },isSelected: menu == Menu.image),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: _addNewTextFab,
    );
  }

  Widget get _addNewTextFab => FloatingActionButton(
        onPressed: () => addNewDialog(context),
        backgroundColor: Colors.white,
        tooltip: 'Add new Text',
        child: const Icon(
          Icons.edit,
          color: Colors.black,
        ),
      );

  Widget get _selectedImage => Center(
    child: ColorFiltered(
      colorFilter: ColorFilter.mode(shirtInfo.shirtColor!, BlendMode.srcOut),
      child: Image.asset(
        shirtInfo.side == TemplateSide.front ? templates[0]: templates[1],
        fit: BoxFit.cover,
      ),
    ),
  );

  // Widget get _selectedImage => Center(
  //   child: ColorFiltered(
  //     colorFilter: ColorFilter.mode(shirtInfo.textInfos!.isNotEmpty ? shirtInfo.textInfos![currentIndex].shirtColor:Colors.black, BlendMode.srcOut),
  //     child: Image.file(
  //       File(widget.selectedImage),
  //       fit: BoxFit.cover,
  //     ),
  //   ),
  // );

  AppBar get _appBar => AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: SizedBox(
          height: 50.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Visibility(
                visible: menu == Menu.text,
                child: IconButton(
                  onPressed: () => saveToGallery(context),
                  icon: const Icon(Icons.save),
                  color: Colors.black,
                  tooltip: 'Save Image',
                ),
              ),
              Visibility(
                visible: menu == Menu.text,
                child: IconButton(
                  onPressed: increaseFontSize,
                  icon: const Icon(Icons.add),
                  color: Colors.black,
                  tooltip: 'Increase font size',
                ),
              ),
              Visibility(
                visible: menu == Menu.text,
                child: IconButton(
                  onPressed: decreaseFontSize,
                  icon: const Icon(Icons.remove),
                  color: Colors.black,
                  tooltip: 'Decrease font size',
                ),
              ),
              Visibility(
                visible: menu == Menu.text,
                child: IconButton(
                  onPressed: alignLeft,
                  icon: const Icon(Icons.format_align_left),
                  color: Colors.black,
                  tooltip: 'Align left',
                ),
              ),
              Visibility(
                visible: menu == Menu.text,
                child: IconButton(
                  onPressed: alignCenter,
                  icon: const Icon(Icons.format_align_center),
                  color: Colors.black,
                  tooltip: 'Align center',
                ),
              ),
              Visibility(
                visible: menu == Menu.text,
                child: IconButton(
                  onPressed: alignRight,
                  icon: const Icon(Icons.format_align_right),
                  color: Colors.black,
                  tooltip: 'Align right',
                ),
              ),
              Visibility(
                visible: menu == Menu.text,
                child: IconButton(
                  onPressed: boldText,
                  icon: const Icon(Icons.format_bold),
                  color: Colors.black,
                  tooltip: 'Bold',
                ),
              ),
              Visibility(
                visible: menu == Menu.text,
                child: IconButton(
                  onPressed: addLinesToText,
                  icon: const Icon(Icons.space_bar),
                  color: Colors.black,
                  tooltip: 'italic',
                ),
              ),
              Visibility(
                visible: menu == Menu.text,
                child: IconButton(
                  onPressed: italicText,
                  icon: const Icon(Icons.format_italic),
                  color: Colors.black,
                  tooltip: 'Add New Line',
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    border: Border.all(color: Colors.black)
                ),
                child: Tooltip(
                  message: 'Red',
                  child: GestureDetector(
                    onTap: () => menu == Menu.text ? changeTextColor(Colors.red) : changeShirtColor(Colors.red),
                    child: const CircleAvatar(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    border: Border.all(color: Colors.black)
                ),
                child: Tooltip(
                  message: 'White',
                  child: GestureDetector(
                    onTap: () => menu == Menu.text ? changeTextColor(Colors.white) : changeShirtColor(Colors.white),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    border: Border.all(color: Colors.black)
                ),
                child: Tooltip(
                  message: 'Black',
                  child: GestureDetector(
                    onTap: () => menu == Menu.text ? changeTextColor(Colors.black) : changeShirtColor(Colors.black),
                    child: const CircleAvatar(
                      backgroundColor: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    border: Border.all(color: Colors.black)
                ),
                child: Tooltip(
                  message: 'Blue',
                  child: GestureDetector(
                    onTap: () => menu == Menu.text ? changeTextColor(Colors.amber) : changeShirtColor(Colors.amber),
                    child: const CircleAvatar(
                      backgroundColor: Colors.amber,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    border: Border.all(color: Colors.black)
                ),
                child: Tooltip(
                  message: 'Orange',
                  child: GestureDetector(
                    onTap: () => menu == Menu.text ? changeTextColor(Colors.orange) : changeShirtColor(Colors.orange),
                    child: const CircleAvatar(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    border: Border.all(color: Colors.black)
                ),
                child: Tooltip(
                  message: 'Pink',
                  child: GestureDetector(
                    onTap: () => menu == Menu.text ? changeTextColor(Colors.pink) : changeShirtColor(Colors.pink),
                    child: const CircleAvatar(
                      backgroundColor: Colors.pink,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
            ],
          ),
        ),
      );
}

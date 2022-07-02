import 'package:flutter/material.dart';
import 'package:tshirtcustom/model/text_info.dart';

enum TemplateSide{front,back}

class ShirtInfo{

   Color? shirtColor;
   List<TextInfo>? textInfos;
   List<String> templates;
   TemplateSide side;

  ShirtInfo({this.shirtColor, this.textInfos,required this.templates,required this.side});
}
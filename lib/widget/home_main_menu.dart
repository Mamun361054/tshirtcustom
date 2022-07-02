import 'package:flutter/material.dart';

enum Menu{text,image}

class HomeMainMenu extends StatelessWidget {

  final String? title;
  final IconData? icon;
  final Menu? menu;
  final bool? isSelected;
  final VoidCallback pressed;

   const HomeMainMenu({required this.title, required this.icon, required this.menu,required this.pressed,required this.isSelected,Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: pressed,
      child: Container(
        width: 120.0,
        decoration:  BoxDecoration(
            color: isSelected!  ? Colors.deepOrange : Colors.white,
            boxShadow: const [
              BoxShadow(color: Colors.black12,offset: Offset(2,2),blurRadius: 8.0,spreadRadius: -2.0),
              BoxShadow(color: Colors.black12,offset: Offset(-2,-2),blurRadius: 8.0),
            ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(
               icon,
              size: 35.0,
               color: isSelected! ? Colors.white : Colors.black,
            ),
            Text(title!,style: TextStyle(color: isSelected! ? Colors.white : Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
          ],
        ),
      ),
    );
  }
}

class HomeMainTemplate extends StatelessWidget {

  final String? title;
  final String? template;
  final bool? isSelected;
  final VoidCallback pressed;

  const HomeMainTemplate({required this.title, required this.template,required this.pressed,required this.isSelected,Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: pressed,
      child: Container(
        width: 80.0,
        decoration:  BoxDecoration(
            color: Colors.white,
            border: Border.all(color: isSelected!  ? Colors.deepOrange : Colors.white),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              template??'',
              fit: BoxFit.cover,
              height: 50.0,
            ),
            Text(title!,style: const TextStyle(color: Colors.black,fontSize: 13.0),maxLines: 1,overflow: TextOverflow.ellipsis,),
          ],
        ),
      ),
    );
  }
}

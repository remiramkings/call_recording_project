import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {

  void Function()? onTap;
       IconData icon;
       String title;
      bool visibility=false;

   IconTextButton({this.onTap, required this.icon,
     required this.title,
     this.visibility=false});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibility,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),

        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.all(Radius.circular(5))
            ),
            height: 55,
            width: (MediaQuery
                .of(context)
                .size
                .width / 5),
            //  width: (MediaQuery.of(context).size.width / 5) + 10,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 8,),
                  Icon(
                    icon,
                    color: Colors.black,
                    size: 22,
                  ),
                  Text(
                    title,
                    style: TextStyle(color: Colors.black, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }

}

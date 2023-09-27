
import 'package:flutter/cupertino.dart';

class EmptyListImg extends StatelessWidget {
  const EmptyListImg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          decoration: const BoxDecoration(
              image:
              DecorationImage(image: AssetImage("images/noresult.png"))),
        ));
  }
}

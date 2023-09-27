

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ToDoLoadingIndicator extends StatelessWidget {
  Color loadingClr;
   ToDoLoadingIndicator({this.loadingClr = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        margin:const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child:const LoadingIndicator(
            indicatorType: Indicator.lineScalePulseOutRapid,
              // color:loadingClr ,
            /// Required, The loading type of the widget
            colors:  [
              Colors.red,
              Colors.yellow,
              Colors.blue,
              Colors.green,
              Colors.orange
            ],

            // /// Optional, The color collections
            // strokeWidth: 4,
            //
            // /// Optional, The stroke of the line, only applicable to widget which contains line
            // backgroundColor: Colors.white,
            //
            // /// Optional, Background of the widget
            // pathBackgroundColor: Colors.white
            //
            // /// Optional, the stroke backgroundColor
            ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            fit: BoxFit.fitHeight,
            image: AssetImage('assets/images/w_icon.png'),
          ),
          RichText(
            textAlign: TextAlign.justify,
            textDirection: TextDirection.ltr,
            softWrap: true,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'The things that really change the world, according to Chaos theory, are the tiny things. A butterfly flaps its wings in the Amazonian jungle, and subsequently a storm ravages half of Europe.” “Ideas that require people to reorganize their picture of the world provoke hostility.”',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )
              ]
            )
          )
        ],
      ),
    );
  }
}

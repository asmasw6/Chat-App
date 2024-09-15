import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String name;
  final double height;
  final double width;
  final Function onPressed;

  const RoundedButton(
      {required this.height,
      required this.name,
      required this.onPressed,
      required this.width,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height*.25) ,color: Color.fromRGBO(13, 65, 154, 1)

      ),
      child: TextButton(
          onPressed: () {},
          child: Text(
            name,
            style:
                const TextStyle(fontSize: 22, color: Colors.white, height: 1.3),
          )),
    );
  }
}

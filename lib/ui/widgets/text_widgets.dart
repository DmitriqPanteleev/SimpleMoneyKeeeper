import 'package:flutter/material.dart';
import 'package:money_keeper/color_palette.dart';

class HeadLineText extends StatelessWidget {
  const HeadLineText({Key? key, required this.title, this.color})
      : super(key: key);

  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: "SFUI",
        fontWeight: FontWeight.w300,
        fontSize: 30,
        color: color ?? CustomColors.black,
      ),
    );
  }
}

class DescText extends StatelessWidget {
  final String title;
  final Color? color;
  const DescText({Key? key, required this.title, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: "SFUI",
        fontSize: 24,
        fontWeight: FontWeight.w200,
        color: color ?? CustomColors.black,
      ),
    );
  }
}

class ButtonText extends StatelessWidget {
  final String title;
  final Color? color;
  final double? size;
  const ButtonText({Key? key, required this.title, this.color, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: "SFUI",
        fontSize: size ?? 20,
        fontWeight: FontWeight.w200,
        color: color ?? CustomColors.black,
      ),
    );
  }
}

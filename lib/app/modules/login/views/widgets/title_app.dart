import 'package:flutter/material.dart';
import 'package:hallo_doctor_client/app/utils/styles/styles.dart';

class TitleApp extends StatelessWidget {
  const TitleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/Psikomorfosa.png',
          width: 100,
          height: 100,
        ),
        SizedBox(
          height: 10,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Psikomorfosa',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(163, 144, 201, 1)),
          ),
        ),
      ],
    );
  }
}

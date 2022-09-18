import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/utils/styles/styles.dart';

Widget submitButton({required VoidCallback onTap, required String text}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          gradient: LinearGradient(
               begin: Alignment.centerLeft,
               end: Alignment.centerRight,
              colors: [
                Color.fromRGBO(150, 149, 238, 1),
                Color.fromRGBO(251, 199, 212, 1),
              ]
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          // gradient: LinearGradient(
          //     colors: [Styles.secondaryBlueColor, Styles.primaryBlueColor])
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ),
  );
}

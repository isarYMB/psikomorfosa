import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/utils/constants/style_constants.dart';

import '../controllers/doctor_category_controller.dart';

class DoctorCategoryView extends GetView<DoctorCategoryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Color.fromRGBO(163, 144, 201, 1),
        elevation: 0,
        title: Text(
          'Spesialis Psikolog'.tr,
          style: TextStyle(
              color: Color.fromRGBO(163, 144, 201, 1),
              fontWeight: FontWeight.bold,
              fontFamily: "Nunito"),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: controller.obx((listCategory) => GridView.builder(
                  itemCount: listCategory!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.toNamed('/list-doctor',
                            arguments: listCategory[index]);
                      },
                      child: Container(
                          child: Column(
                        children: [
                          // Expanded(
                          //     child: Container(
                          //   decoration: BoxDecoration(
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(10)),
                          //       color: Colors.blue[200]),
                          //   padding: const EdgeInsets.all(8.0),
                          //   // child: CachedNetworkImage(
                          //   //     imageUrl: listCategory[index].iconUrl!),
                          // )),
                          SizedBox(
                            height: 5,
                          ),
                          // FittedBox(
                          //   fit: BoxFit.fitWidth,
                          //   child: Text(
                          //     listCategory[index].categoryName!,
                          //     style: doctorCategoryTextStyle,
                          //   ),
                          // ),
                          Container(
                            width: 260.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(150, 149, 238, 1),
                                Color.fromRGBO(251, 199, 212, 1),
                              ]),
                            ),
                            child: Center(
                              child: Text(
                                listCategory[index].categoryName!,
                                // style: doctorCategoryTextStyle,
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 16,
                                  color: Colors.white,
                                  height: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 3,
                          )
                        ],
                      )),
                    );
                  })),
            ),
          ),
        ],
      ),
    );
  }
}

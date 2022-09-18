import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/models/doctor_model.dart';
import 'package:hallo_doctor_client/app/utils/constants/style_constants.dart';

class DoctorCard extends StatelessWidget {
  final String? doctorName;
  final List<dynamic>? doctorSpecialty;
  final String? imageUrl;
  // final String? doctorSpecialty;
  final VoidCallback onTap;
  const DoctorCard(
      {Key? key,
      // this.selectedDoctor,
      this.doctorName,
      this.doctorSpecialty,
      this.imageUrl,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 100,
            width: double.maxFinite,
            padding: EdgeInsets.fromLTRB(18, 3, 18, 3),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.network(imageUrl!),
                  ),
                  Container(
                    // height: 10,
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            doctorName!,
                            style: doctorNameTextStyle,
                          ),
                        ),
                        Container(
                          height: 12,
                          width: 200,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: doctorSpecialty?.length,
                              itemBuilder: (_, i) {
                                return Text(
                                  doctorSpecialty?[i] + ', ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.grey),
                                );
                              }),
                        ),
                        // Text(
                        //   doctorSpecialty!,
                        //   style: specialistTextStyle,
                        // ),
                        // ListView.builder(
                        //     itemCount: doctorName!.length,
                        //     itemBuilder: (_, i) {
                        //       return Padding(
                        //           padding: EdgeInsets.all(10.0),
                        //           child: Center(
                        //               child: Text(
                        //             doctorName![i],
                        //             textAlign: TextAlign.center,
                        //             style: TextStyle(
                        //               fontSize: 25.0,
                        //               color: Colors.white,
                        //             ),
                        //           )));
                        //     }),
                        RatingBarIndicator(
                            rating: 4.5,
                            itemCount: 5,
                            itemSize: 20.0,
                            itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                        onTap: onTap,
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                          colors: [
                          Color.fromRGBO(150, 149, 238, 1),
                            Color.fromRGBO(251, 199, 212, 1),
                            ]
                        )),
                          child: Text(
                            "Pilih".tr,
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

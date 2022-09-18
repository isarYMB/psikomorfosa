import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/utils/constants/style_constants.dart';

class DoctorCard extends StatelessWidget {
  final String doctorPhotoUrl;
  final String doctorName;
  final String doctorHospital;
  final String doctorPrice;
  final List<dynamic>? doctorCategory;
  final VoidCallback onTap;
  const DoctorCard(
      {Key? key,
      required this.doctorPhotoUrl,
      required this.doctorName,
      required this.doctorHospital,
      required this.doctorPrice,
      required this.doctorCategory,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: IntrinsicHeight(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(doctorPhotoUrl)),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    // Text(
                    //   'Price'.tr,
                    //   style: priceTextStyle,
                    // ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    // Text(
                    //   doctorPrice,
                    //   style: priceNumberTextStyle,
                    // )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                doctorName,
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          // TextWithIcon(
                          //   text: doctorCategory,
                          //   imageAsset: 'assets/icons/Stethoscope.png',
                          // ),
                          Container(
                            height: 20,
                            width: 200,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: doctorCategory?.length,
                                itemBuilder: (_, i) {
                                  return Text(
                                    doctorCategory?[i],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.grey),
                                  );
                                }),
                          ),
                          // SizedBox(height: 5),
                          // TextWithIcon(
                          //   text: doctorHospital,
                          //   imageAsset: 'assets/icons/hospital_icon.png',
                          // ),
                          SizedBox(
                            height: 5,
                          ),
                          RatingBarIndicator(
                              rating: 4.5,
                              itemCount: 5,
                              itemSize: 20,
                              itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ))
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: onTap,
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 100,
                        margin: EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(150, 149, 238, 1),
                                  Color.fromRGBO(251, 199, 212, 1),
                                ]
                            )),
                        child: Text(
                          'Pilih'.tr,
                          style: TextStyle(color: Colors.white,fontFamily: "Nunito"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextWithIcon extends StatelessWidget {
  const TextWithIcon({Key? key, required this.text, required this.imageAsset})
      : super(key: key);

  final String text;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Image.asset(
              imageAsset,
              height: 20,
              width: 20,
            ),
          ),
          WidgetSpan(
              child: SizedBox(
            width: 6,
          )),
          TextSpan(
              text: text,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

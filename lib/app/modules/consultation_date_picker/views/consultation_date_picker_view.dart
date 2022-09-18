import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hallo_doctor_client/app/utils/constants/style_constants.dart';
import 'package:intl/intl.dart';
import '../controllers/consultation_date_picker_controller.dart';

class ConsultationDatePickerView
    extends GetView<ConsultationDatePickerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Color.fromRGBO(163, 144, 201, 1),
        title: Text('Chose Timeslot'.tr,style: TextStyle(fontFamily: "Nunito",fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Chose Date'.tr,
               style: TextStyle(fontFamily: "Nunito",fontSize: 15,fontWeight: FontWeight.w700,color:Color.fromRGBO(163, 144, 201, 1) ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: DatePicker(
              DateTime.now(),
              initialSelectedDate: DateTime.now(),
              daysCount: 10,
              selectionColor: secondaryColor,
              onDateChange: (date) {
                controller.updateScheduleAtDate(
                    date.day, date.month, date.year);
              },
            ),
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Chose Time'.tr,
              style: TextStyle(fontFamily: "Nunito",fontSize: 15,fontWeight: FontWeight.w700,color:Color.fromRGBO(163, 144, 201, 1) ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: controller.obx(
                (timeSlot) => GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: timeSlot!.length,
                  itemBuilder: (BuildContext ctx, index) {
                    var timeStartFormat =
                        DateFormat.Hm().format(timeSlot[index].timeSlot!);
                    var timeEnd = timeSlot[index]
                        .timeSlot!
                        .add(Duration(minutes: timeSlot[index].duration!));
                    var timeEndFormat = DateFormat.Hm().format(timeEnd);
                    String? metodeKonseling = timeSlot[index].metodeKonseling;
                    if (timeSlot[index].available!) {
                      return InkWell(
                        onTap: () {
                          controller.selectedTimeSlot.value = timeSlot[index];
                        },
                        child: Obx(
                          () => Container(
                            alignment: Alignment.center,
                            child: Text(
                              '${metodeKonseling!}\n$timeStartFormat - $timeEndFormat',
                              textAlign: TextAlign.center,
                            ),
                            decoration: (controller.selectedTimeSlot.value ==
                                    timeSlot[index])
                                ? BoxDecoration(
                                    color: Colors.deepPurple[100],
                                    border: Border.all(
                                        color: Color.fromRGBO(163, 144, 201, 1), width: 5),
                                    borderRadius: BorderRadius.circular(15),
                                  )
                                : BoxDecoration(
                                    color: Colors.deepPurple[400],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        alignment: Alignment.center,
                        child: Text(
                          '${metodeKonseling!}\n$timeStartFormat - $timeEndFormat',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(15),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                if (controller.selectedTimeSlot.value.timeSlotId == null) {
                  Fluttertoast.showToast(msg: 'Please select time slot'.tr);
                } else {
                  controller.confirm();
                }
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                    gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(150, 149, 238, 1),
                          Color.fromRGBO(251, 199, 212, 1),
                        ]
                    )
                ),
                child: Text(
                  'Lihat Total Harga'.tr,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

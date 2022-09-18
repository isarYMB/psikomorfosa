import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/modules/widgets/empty_list.dart';

import '../controllers/appointment_controller.dart';
import 'package:intl/intl.dart';

class AppointmentView extends GetView<AppointmentController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Color.fromRGBO(163, 144, 201, 1),
        title: Text('Riwayat Konseling'.tr,style: TextStyle(color: Color.fromRGBO(163, 144, 201, 1),fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return controller.getListAppointment();
        },
        child: Container(
          height: Get.height,
          child: controller.obx(
            (listTimeslot) => ListView.builder(
              itemCount: listTimeslot!.length,
              shrinkWrap: true,
              itemBuilder: (contex, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Get.toNamed('/appointment-detail',
                          arguments: listTimeslot[index]);
                    },
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          listTimeslot[index].doctor!.doctorPicture!),
                    ),
                    title: Text('Appointment with '.tr +
                        listTimeslot[index].doctor!.doctorName!),
                    subtitle: Text(
                      'at '.tr +
                          DateFormat('EEEE, dd, MMMM')
                              .format(listTimeslot[index].timeSlot!),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            ),
            onEmpty: Center(
              child: EmptyList(msg: 'Anda Belum Melakukan Konseling'.tr),
            ),
          ),
        ),
      ),
    );
  }
}

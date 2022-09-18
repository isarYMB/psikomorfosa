import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/modules/appointment/views/appointment_view.dart';
import 'package:hallo_doctor_client/app/modules/doctor_category/views/doctor_category_view.dart';
import 'package:hallo_doctor_client/app/modules/edukasi/views/edukasi_views.dart';
import 'package:hallo_doctor_client/app/modules/home/views/home_view.dart';
import 'package:hallo_doctor_client/app/modules/list_chat/views/list_chat_view.dart';
import 'package:hallo_doctor_client/app/modules/profile/views/profile_view.dart';
import 'package:hallo_doctor_client/modules/auth/pages/home.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  final List<Widget> bodyContent = [
    HomePage(),
    HomeView(),
    AppointmentView(),
    // ListChatView(),
    // ProfileView()
    EdukasiView()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
        selectedItemColor:  Color.fromRGBO(163, 144, 201, 1),
        unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.group,
                    color: Color.fromRGBO(163, 144, 201, 1),
                  ),
                  label: "UpCerita".tr),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.contacts,
                    color: Color.fromRGBO(163, 144, 201, 1),
                  ),
                  label: "Konseling".tr),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.video_camera_front,
                    color: Color.fromRGBO(163, 144, 201, 1),
                  ),
                  label: "Riwayat".tr),
              // BottomNavigationBarItem(
              //     icon: Icon(
              //       Icons.message,
              //       color: Colors.blue[500],
              //     ),
              //     label: "Psikolog".tr),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.book,
                    color: Color.fromRGBO(163, 144, 201, 1),
                  ),
                  label: "Edukasi".tr),
            ],
            currentIndex: controller.selectedIndex,
            onTap: (index) {
              controller.selectedIndex = index;
            },
          )),
      body: Obx(
        () => Center(
          child: IndexedStack(
              index: controller.selectedIndex, children: bodyContent),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hallo_doctor_client/app/models/time_slot_model.dart';
// import 'package:hallo_doctor_client/app/modules/detail_order/controllers/detail_order_controller.dart';
// import 'package:hallo_doctor_client/app/service/order_service.dart';

// class MidtransPaymentController extends GetxController {
//   var transactionRedirectUrl = ''.obs;
//   OrderService orderService = Get.find();
//   var idFromFirstController =
//       Get.find<DetailOrderController>().selectedTimeSlot;

//   @override
//   void onInit() {
//     super.onInit();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Future.delayed(
//           Duration(seconds: 6),
//           () => orderService.getToken(idFromFirstController).then((value) {
//                 transactionRedirectUrl.value = value.transactionRedirectUrl!;
//                 update();
//               }));
//     });
//   }

//   @override
//   void onReady() async {
//     super.onReady();
//     update();
//   }

//   @override
//   void onClose() {}
// }

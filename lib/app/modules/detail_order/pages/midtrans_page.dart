import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/models/time_slot_model.dart';
import 'package:hallo_doctor_client/app/modules/detail_order/controllers/detail_order_controller.dart';
import 'package:hallo_doctor_client/app/modules/midtrans_payment/controller/midtrans_payment_controller.dart';
import 'package:hallo_doctor_client/app/service/order_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

// TimeSlot selectedTimeSlot = Get.arguments[0];

// listImageCarousel = await CarouselService().getListCarouselUrl();

class MidtransPage extends GetView<DetailOrderController> {
  // late WebViewController controllerWeb;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Melakukan Pembayaran"),
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),

          // actions: [
          //   IconButton(
          //       onPressed: () => Get.offAllNamed('/midtrans-payment'),
          //       icon: Icon(Icons.refresh))
          // ],
        ),
        body: Obx(
          () => WebView(
            initialUrl: controller.transactionRedirectUrl.value,
            javascriptMode: JavascriptMode.unrestricted,
          ),
          // body: Obx(
          //   () => Text(
          //     controller.transactionRedirectUrl.value,
          //     textAlign: TextAlign.center,
          //     // overflow: TextOverflow.ellipsis,
          //     style: const TextStyle(fontWeight: FontWeight.bold),
          //   ),
          // )
        ));
  }
}

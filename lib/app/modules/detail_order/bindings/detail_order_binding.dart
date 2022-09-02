import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/modules/midtrans_payment/controller/midtrans_payment_controller.dart';
import 'package:hallo_doctor_client/app/service/order_service.dart';
import 'package:hallo_doctor_client/app/service/payment_service.dart';

import '../controllers/detail_order_controller.dart';

class DetailOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailOrderController>(
      () => DetailOrderController(),
    );
    Get.lazyPut<PaymentService>(
      () => PaymentService(),
    );
    // Get.lazyPut<MidtransPaymentController>(() => MidtransPaymentController());
  }
}

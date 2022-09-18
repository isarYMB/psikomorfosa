import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/models/doctor_model.dart';
import 'package:hallo_doctor_client/app/models/order_detail_model.dart';
import 'package:hallo_doctor_client/app/models/time_slot_model.dart';
import 'package:hallo_doctor_client/app/modules/appointment/controllers/appointment_controller.dart';
import 'package:hallo_doctor_client/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hallo_doctor_client/app/service/notification_service.dart';
import 'package:hallo_doctor_client/app/service/payment_service.dart';
import 'package:hallo_doctor_client/app/service/user_service.dart';
import 'package:hallo_doctor_client/app/utils/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:hallo_doctor_client/app/modules/detail_order/pages/kuisioner_view.dart';

class DetailOrderController extends GetxController {
  final username = ''.obs;
  final UserService userService = Get.find();
  List<OrderDetailModel> orderDetail = List.empty();
  TimeSlot selectedTimeSlot = Get.arguments[0];
  Doctor doctor = Get.arguments[1];
  PaymentService paymentService = Get.find();
  UpdateCeritaService updateCeritaService = Get.find();
  NotificationService notificationService = Get.find<NotificationService>();
  late String clientSecret;

  late String ceritaClient;

  var valuekejadian = ''.obs;
  var valuedampak = ''.obs;
  var valuejenisKelamin = ''.obs;
  var valueumur = ''.obs;
  var valueKronologi = ''.obs;
  var valuePerubahan = ''.obs;

  String? selectedGender;
  final List<String> gender = ["Pria", "Wanita"];

  String? select;

  @override
  void onInit() {
    super.onInit();
    userService.getUsername().then((value) {
      username.value = value;
    });
  }

  @override
  void onClose() {}

  // toKuisioner() {
  //   Get.to(() => Kuisioner());
  // }

  OrderDetailModel buildOrderDetail() {
    var formatter = DateFormat('yyyy-MM-dd hh:mm');
    var time = formatter.format(selectedTimeSlot.timeSlot!);

    var orderDetail = OrderDetailModel(
        itemId: selectedTimeSlot.timeSlotId!,
        itemName: 'Melakukan Konseling Bersama ' + doctor.doctorName!,
        time: selectedTimeSlot.metodeKonseling!,
        duration: selectedTimeSlot.duration.toString() + ' minute',
        price: currencySign + selectedTimeSlot.price.toString());
    return orderDetail;
  }

  void makePayment() async {
    EasyLoading.show();
    try {
      var clientSecret = await paymentService.getClientSecret(
          selectedTimeSlot.timeSlotId!, userService.getUserId());
      if (clientSecret.isEmpty) return;

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        applePay: true,
        googlePay: true,
        testEnv: true,
        merchantCountryCode: 'US',
        merchantDisplayName: 'Helo Doctor',
        paymentIntentClientSecret: clientSecret,
      ));
      EasyLoading.dismiss();
      await Stripe.instance.presentPaymentSheet();

      Get.off(Kuisioner(), arguments: selectedTimeSlot);
      //selectedTimeSlot.timeSlot
      notificationService
          .setNotificationAppointment(selectedTimeSlot.timeSlot!);
    } on StripeException catch (err) {
      Fluttertoast.showToast(msg: err.error.message!);
      return null;
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
      return null;
    } finally {}
  }

  void kejadian(String kejadian) async {
    // selected.value = value;
    try {
      EasyLoading.show();
      UserService().kejadian(kejadian).then((value) {
        // Get.back();
        this.valuekejadian.value = kejadian;
        update();
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void dampak(String dampak) async {
    // if (!(await checkGoogleLogin())) return;
    try {
      EasyLoading.show();
      UserService().dampak(dampak).then((value) {
        // Get.back();
        this.valuedampak.value = dampak;
        update();
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void goHome() {
    Get.offAllNamed('dashboard');
    Get.find<DashboardController>().selectedIndex = 2;
    Get.find<AppointmentController>().getListAppointment();
  }

  void Kronologi(String Kronologi) async {
    // if (!(await checkGoogleLogin())) return;
    try {
      EasyLoading.show();
      UserService().Kronologi(Kronologi).then((value) {
        // Get.back();
        this.valueKronologi.value = Kronologi;
        update();
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void Perubahan(String Perubahan) async {
    // if (!(await checkGoogleLogin())) return;
    try {
      EasyLoading.show();
      UserService().Perubahan(Perubahan).then((value) {
        // Get.back();
        this.valuePerubahan.value = Perubahan;
        update();
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void jenisKelamin(String jenisKelamin) async {
    // print(jenisKelamin);

    // update();
    try {
      select = jenisKelamin;
      EasyLoading.show();
      UserService().jenisKelamin(jenisKelamin).then((value) {
        // Get.back();
        this.valuejenisKelamin.value = jenisKelamin;
        update();
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void umur(String umur) async {
    // if (!(await checkGoogleLogin())) return;
    try {
      EasyLoading.show();
      UserService().umur(umur).then((value) {
        // Get.back();
        this.valueumur.value = umur;
        update();
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void updateCeritaClient() async {
    // EasyLoading.show();
    try {
      var ceritaClient = await updateCeritaService.getCeritaClient(
          selectedTimeSlot.timeSlotId!, userService.getUserId());
      if (ceritaClient.isEmpty) return;

      // EasyLoading.dismiss();
      // await Stripe.instance.presentPaymentSheet();

      // Get.offNamed('/dashboard', arguments: selectedTimeSlot);
      //selectedTimeSlot.timeSlot
      // notificationService
      //     .setNotificationAppointment(selectedTimeSlot.timeSlot!);
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
      return null;
    } finally {}
  }
}

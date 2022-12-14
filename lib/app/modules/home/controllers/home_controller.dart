import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hallo_doctor_client/app/service/auth_service.dart';
import 'package:hallo_doctor_client/app/service/carousel_service.dart';
import 'package:hallo_doctor_client/app/service/user_service.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final caoruselIndex = 0.obs;
  get getcaoruselIndex => caoruselIndex.value;
  AuthService authService = Get.find();
  UserService userService = Get.find();
  var userPicture = ''.obs;
  List<String?> listImageCarousel = [];
  var profilePic = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    EasyLoading.instance.maskType = EasyLoadingMaskType.black;
    userPicture.value = userService.getProfilePicture()!;
    listImageCarousel = await CarouselService().getListCarouselUrl();
    print('jumlah image carousel : ' + listImageCarousel.length.toString());
    update();
  }

  @override
  void onReady() {
    super.onReady();
    profilePic.value = userService.getProfilePicture()!;
  }

  @override
  void onClose() {}
  void carouselChange(int index) {
    caoruselIndex.value = index;
  }

  void logout() async {
    authService.logout().then((value) => Get.toNamed('/login'));
  }

  void toDoctorCategory() {
    Get.toNamed('/doctor-category');
  }

  void toAppointment() {
    Get.toNamed('/appointment');
  }

  void toSearchDoctor() {
    Get.toNamed('/search-doctor');
  }
}

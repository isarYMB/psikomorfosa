import 'package:countries/countries.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
// ignore: depend_on_referenced_packages
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../imports.dart';
import '../../data/phone.dart';
import '../widgets/auth_header.dart';
import 'verification.dart';
import 'widgets/phone_form.dart';

class PhoneLoginPage extends StatefulWidget {
  @override
  _PhoneLoginPageState createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final formKey = GlobalKey<FormState>();

  // Phone Number Controllers
  final codeController = TextEditingController();
  final phoneController = TextEditingController();
  final country = CountriesRepo.getCountryByIsoCode('ID').obs;

  final isLoading = false.obs;

  final error = ''.obs;
  String get phoneNumber => '+${codeController.text}${phoneController.text}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: FocusScope.of(context).unfocus,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AuthTopHeader(),
              SizedBox(height: 8),
              PhoneFormWidget(
                codeController: codeController,
                phoneController: phoneController,
                country: country,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Obx(
                  () => Text(
                    error(),
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: context.height / 4,
                child: Center(
                  child: Obx(
                    () => AppButton(
                      t.Next,
                      suffixIcon: Icon(
                        Icons.chevron_right,
                        color: context.theme.scaffoldBackgroundColor,
                      ),
                      isLoading: isLoading(),
                      onTap: getValidationCode,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getValidationCode() async {
    if (!phoneNumber.isPhoneNumber) {
      BotToast.showText(text: t.InvalidPhone);
      return;
    }
    isLoading(true);
    error('');
    appPrefs.prefs.setString('country', country().name);
    if (kIsWeb) {
      final confResult = await FirebaseAuth.instance.signInWithPhoneNumber(
        phoneNumber,
        RecaptchaVerifier(
          container: 'recaptcha',
          size: RecaptchaVerifierSize.compact,
          theme: RecaptchaVerifierTheme.dark,
          onSuccess: () {
            Get.to(
              () => OTPVerificationPage(phoneNumber: phoneNumber, verID: ''),
            );
          },
          auth: FirebaseAuthPlatform.instance,
        ),
      );
      Get.put<ConfirmationResult>(confResult);
    } else {
      PhoneRepository.verifyPhone(
        phoneNumber,
        onCodeSent: (id) => Get.to(
          () => OTPVerificationPage(phoneNumber: phoneNumber, verID: id),
        ),
        onFailed: (e) {
          error(e.message);
          isLoading(false);
        },
      );
    }
    6.delay(() => isLoading(false));
  }

  @override
  void initState() {
    codeController.text = country().phoneCode;
    super.initState();
  }
}

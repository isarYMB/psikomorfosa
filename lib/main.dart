import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hallo_doctor_client/Helper/Demo_Localization.dart';
import 'package:hallo_doctor_client/app/modules/appointment/bindings/appointment_binding.dart';
import 'package:hallo_doctor_client/app/modules/appointment/controllers/appointment_controller.dart';
import 'package:hallo_doctor_client/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:hallo_doctor_client/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hallo_doctor_client/app/modules/detail_order/bindings/detail_order_binding.dart';
import 'package:hallo_doctor_client/app/modules/detail_order/controllers/detail_order_controller.dart';
import 'package:hallo_doctor_client/app/modules/detail_order/pages/kuisioner_view.dart';
import 'package:hallo_doctor_client/app/service/notification_service.dart';
import 'package:hallo_doctor_client/app/utils/environment.dart';
import 'package:hallo_doctor_client/app/utils/localization.dart';
import 'package:hallo_doctor_client/modules/notifications/provider.dart';
import 'app/routes/app_pages.dart';
import 'app/service/firebase_service.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'components/connectivity.dart';
import 'firebase_options.dart';
import 'imports.dart';
import 'modules/auth/pages/home.dart';
import 'package:form_builder_validators/localization/l10n.dart';

bool isUserLogin = false;
RxBool anonimGroup = false.obs;
void toggleGroup() => anonimGroup.value = anonimGroup.value ? false : true;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await Firebase.initializeApp();
  DashboardBinding().dependencies();
  AppointmentBinding().dependencies();
  // DetailOrderBinding().dependencies();

  Get.put(DashboardController());
  Get.put(NotificationProvider());
  Get.put(AppointmentController());
  // Get.put(DetailOrderController());

  // Get.put(DetailOrderController());
  MobileAds.instance.initialize();

  // NotificationService notificationService = NotificationService();

  // Get.put(NotificationProvider());
  // Initalize Fierbase Core for app, necessary for firebase to work
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  LocaleSettings.useDeviceLocale();

  // Initalize Fierbase Core for app, necessary for firebase to work

  isUserLogin = await FirebaseService().checkUserAlreadyLogin();
  Stripe.publishableKey = Environment.stripePublishableKey;
  // initializeDateFormatting('en', null);
  FirebaseChatCore.instance
      .setConfig(FirebaseChatCoreConfig(null, 'Rooms', 'users'));
  // bool isUserLogin = await FirebaseService().checkUserAlreadyLogin();
  NotificationService();
  //Load App Configs
  await AppConfigs.init();
  // Initialize app preferences and settings
  await AppPreferences.init();
  // Initialize Authentication, check if user logged In
  await AuthProvider.init();
  // Report uncaught errors to Firebase
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // final DashboardController controller = Get.put(DashboardController());
  final ads = Get.put(AdsHelper());
  @override
  Widget build(BuildContext context) {
    // initializeDateFormatting('en', null);
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: isUserLogin ? AppPages.DASHBOARD : AppPages.INTRO,
        getPages: AppPages.routes,
        title: t.AppName,
        builder: (context, myWidget) {
          //  myWidget = DevicePreview.appBuilder(context, myWidget);
          myWidget = BotToastInit()(context, myWidget);
          myWidget = EasyLoading.init()(context, myWidget);
          return myWidget;
        },
        // builder: (_, w) => ConnectivityWidget(
        //   builder: (_, __) => BotToastInit()(_, w),
        // ),

        navigatorObservers: [
          BotToastNavigatorObserver(),
          appPrefs.routeObserver,
        ],
        themeMode: appPrefs.isDarkMode() ? ThemeMode.light : ThemeMode.light,
        theme: AppStyles.lightTheme,
        darkTheme: AppStyles.darkTheme,
        // home: Kuisioner(),
        localizationsDelegates: const [
          DemoLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FormBuilderLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: LocalizationService.locale,
        translations: LocalizationService(),
        supportedLocales: LocaleSettings.supportedLocales,
      ),
    );
  }

  @override
  void dispose() {
    ads.dispose();
    super.dispose();
  }
}

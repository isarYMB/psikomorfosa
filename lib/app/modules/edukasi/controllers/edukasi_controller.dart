import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hallo_doctor_client/app/modules/edukasi/views/components/NewsDetails.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:hallo_doctor_client/Helper/Color.dart';
import 'package:hallo_doctor_client/Helper/Constant.dart';
import 'package:hallo_doctor_client/Helper/Session.dart';
import 'package:hallo_doctor_client/Helper/String.dart';
import 'package:hallo_doctor_client/Model/News.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Helper/PushNotificationService.dart';
import '../../../../Model/Category.dart';
import '../controllers/edukasi_controller.dart';

import '../../../../main.dart';
import '../views/components/SubHome.dart';

class EdukasiController extends GetxController
    with GetSingleTickerProviderStateMixin {
  ScrollController controller = new ScrollController();
  ScrollController controller1 = new ScrollController();
  bool isRecentLoadMore = true;
  int offsetRecent = 0;
  int totalRecent = 0;
  int offsetUser = 0;
  int totalUser = 0;
  String? catId = "";
  bool isUserLoadMore = true;
  bool isBreakLoading = true;
  bool isUserLoading = true;
  var selectSubCat = 0.obs;

  List<Category> tempCatList = [];
  // List<Category> catList = [];
  RxList<Category> catList = RxList<Category>();

  TabController? tc;
  bool isTab = true;

  bool isRecentLoading = true;
  bool _isLoading = true;
  bool _isLoadingMore = true;
  bool _isNetworkAvail = true;
  var tcIndex = 0.obs;

  List<News> tempList = [];
  List<News> userNewsList = [];

  RxList<Map<String, dynamic>> tabs = RxList<Map<String, dynamic>>();
  // List<Map<String, dynamic>> tabs = [];

  List<News> tempUserNews = [];
  List<News> recentNewsList = [];

  get index => null;

  @override
  void onInit() {
    controller.addListener(_scrollListener);
    controller1.addListener(_scrollListener1);

    callApi();

    super.onInit();
  }

  @override
  void onClose() {}

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (Get.routing.current == "/edukasi") {
        isRecentLoadMore = true;
        if (offsetRecent < totalRecent) getNews();
      }
    }
  }

  _scrollListener1() {
    if (controller1.offset >= controller1.position.maxScrollExtent &&
        !controller1.position.outOfRange) {
      if (Get.routing.current == "/edukasi") {
        isUserLoadMore = true;

        if (offsetUser < totalUser) getUserByCatNews();
      }
    }
  }

  Future<void> callApi() async {
    getSetting();

    // await getLiveNews();
    // await getBreakingNews();
    await getNews();
    await getUserByCatNews();
    await getCat();
    // await _getBookmark();
  }

  //get user selected category newslist
  Future<void> getUserByCatNews() async {
    if (CUR_USERID != "" && CATID != "") {
      _isNetworkAvail = await isNetworkAvailable();
      if (_isNetworkAvail) {
        try {
          var param = {
            ACCESS_KEY: access_key,
            CATEGORY_ID: CATID,
            USER_ID: CUR_USERID,
            LIMIT: perPage.toString(),
            OFFSET: offsetUser.toString(),
          };
          http.Response response = await http
              .post(Uri.parse(getNewsByUserCatApi),
                  body: param, headers: headers)
              .timeout(Duration(seconds: timeOut));
          if (response.statusCode == 200) {
            var getData = json.decode(response.body);
            String error = getData["error"];
            if (error == "false") {
              totalUser = int.parse(getData["total"]);
              if ((offsetUser) < totalUser) {
                tempUserNews.clear();
                var data = getData["data"];
                tempUserNews = (data as List)
                    .map((data) => new News.fromJson(data))
                    .toList();
                userNewsList.addAll(tempUserNews);
                offsetUser = offsetUser + perPage;
              }
            } else {
              isUserLoadMore = false;
            }
            if (Get.routing.current == "/edukasi") isUserLoading = false;
          }
        } on TimeoutException catch (_) {
          Get.snackbar('Gagal', 'Terdapat Kesalahan',
              snackPosition: SnackPosition.BOTTOM);
          isUserLoading = false;
          isUserLoadMore = false;
        }
      } else {
        Get.snackbar('Gagal', 'Terdapat Kesalahan',
            snackPosition: SnackPosition.BOTTOM);
        isUserLoading = false;
        isUserLoadMore = false;
      }
    }
  }

  //get latest news data list
  Future<void> getNews() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      isRecentLoading = true;
      isRecentLoadMore = true;
      try {
        var param = {
          ACCESS_KEY: access_key,
          LIMIT: perPage.toString(),
          OFFSET: offsetRecent.toString(),
          USER_ID: CUR_USERID != "" ? CUR_USERID : "0"
        };

        http.Response response = await http
            .post(Uri.parse(getNewsApi), body: param, headers: headers)
            .timeout(Duration(seconds: timeOut));

        if (response.statusCode == 200) {
          var getData = json.decode(response.body);

          String error = getData["error"];
          if (error == "false") {
            totalRecent = int.parse(getData["total"]);

            if ((offsetRecent) < totalRecent) {
              tempList.clear();
              var data = getData["data"];
              tempList = (data as List)
                  .map((data) => new News.fromJson(data))
                  .toList();

              recentNewsList.addAll(tempList);

              offsetRecent = offsetRecent + perPage;
            }
          } else {
            isRecentLoadMore = false;
          }
          if (Get.routing.current == "/edukasi") isRecentLoading = false;
        }
      } on TimeoutException catch (_) {
        Get.snackbar('Gagal', 'Terdapat Kesalahan',
            snackPosition: SnackPosition.BOTTOM);
        isRecentLoading = false;
        isRecentLoadMore = false;
      }
    } else {
      Get.snackbar('Gagal', 'Terdapat Kesalahan',
          snackPosition: SnackPosition.BOTTOM);
      isRecentLoading = false;
      isRecentLoadMore = false;
    }
  }

  //get settings api
  Future<void> getSetting() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var param = {
          ACCESS_KEY: access_key,
        };
        http.Response response = await http
            .post(Uri.parse(getSettingApi), body: param, headers: headers)
            .timeout(Duration(seconds: timeOut));
        if (response.statusCode == 200) {
          var getData = json.decode(response.body);
          String error = getData["error"];
          if (error == "false") {
            var data = getData["data"];
            category_mode = data[CATEGORY_MODE];
            comments_mode = data[COMM_MODE];
            breakingNews_mode = data[BREAK_NEWS_MODE];
            liveStreaming_mode = data[LIVE_STREAM_MODE];
            subCategory_mode = data[SUBCAT_MODE];
            print(
                "fb ads check****${data.toString().contains(FB_REWARDED_ID)}");

            if (data["in_app_ads_mode"] != "0") {
              if (data.toString().contains(FB_REWARDED_ID)) {
                fbRewardedVideoId = data[FB_REWARDED_ID];
              }
              if (data.toString().contains(FB_INTER_ID)) {
                fbInterstitialId = data[FB_INTER_ID];
              }
              if (data.toString().contains(FB_BANNER_ID)) {
                fbBannerId = data[FB_BANNER_ID];
              }
              if (data.toString().contains(FB_NATIVE_ID)) {
                fbNativeUnitId = data[FB_NATIVE_ID];
              }
              if (data.toString().contains(GO_REWARDED_ID)) {
                goRewardedVideoId = data[GO_REWARDED_ID];
              }
              if (data.toString().contains(GO_INTER_ID)) {
                goInterstitialId = data[GO_INTER_ID];
              }
              if (data.toString().contains(GO_BANNER_ID)) {
                goBannerId = data[GO_BANNER_ID];
              }
              if (data.toString().contains(GO_NATIVE_ID)) {
                goNativeUnitId = data[GO_NATIVE_ID];
              }
            }
            if (data["ios_in_app_ads_mode"] != "0") {
              if (data.toString().contains(IOS_FB_REWARDED_ID)) {
                iosFbRewardedVideoId = data[IOS_FB_REWARDED_ID];
              }
              if (data.toString().contains(IOS_FB_INTER_ID)) {
                iosFbInterstitialId = data[IOS_FB_INTER_ID];
              }
              if (data.toString().contains(IOS_FB_BANNER_ID)) {
                iosFbBannerId = data[IOS_FB_BANNER_ID];
              }
              if (data.toString().contains(IOS_FB_NATIVE_ID)) {
                iosFbNativeUnitId = data[IOS_FB_NATIVE_ID];
              }

              if (data.toString().contains(IOS_GO_REWARDED_ID)) {
                iosGoRewardedVideoId = data[IOS_GO_REWARDED_ID];
              }
              if (data.toString().contains(IOS_GO_INTER_ID)) {
                iosGoInterstitialId = data[IOS_GO_INTER_ID];
              }
              if (data.toString().contains(IOS_GO_BANNER_ID)) {
                iosGoBannerId = data[IOS_GO_BANNER_ID];
              }
              if (data.toString().contains(IOS_GO_NATIVE_ID)) {
                iosGoNativeUnitId = data[IOS_GO_NATIVE_ID];
              }
            }
          }
        }
      } on TimeoutException catch (_) {
        Get.snackbar('Gagal', 'Terdapat Kesalahan',
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar('Gagal', 'Terdapat Kesalahan',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  //get all category using api
  Future<void> getCat() async {
    if (category_mode == "1") {
      _isNetworkAvail = await isNetworkAvailable();
      if (_isNetworkAvail) {
        try {
          _isLoading = true;
          var param = {
            ACCESS_KEY: access_key,
          };

          http.Response response = await http
              .post(Uri.parse(getCatApi), body: param, headers: headers)
              .timeout(Duration(seconds: timeOut));
          var getData = json.decode(response.body);

          String error = getData["error"];
          if (error == "false") {
            tempCatList.clear();
            var data = getData["data"];
            tempCatList = (data as List)
                .map((data) => new Category.fromJson(data))
                .toList();
            catList.addAll(tempCatList);
            for (int i = 0; i < catList.length; i++) {
              if (catList[i].subData!.length != 0) {
                catList[i]
                    .subData!
                    .insert(0, SubCategory(id: "0", subCatName: "Semua"));
              }
            }

            tabs.clear();
            addInitailTab();
          }
          if (Get.routing.current == "/edukasi") _isLoading = false;
        } on TimeoutException catch (_) {
          Get.snackbar('Gagal', 'Terdapat Kesalahan',
              snackPosition: SnackPosition.BOTTOM);
          _isLoading = false;
          _isLoadingMore = false;
        }
      } else {
        Get.snackbar('Gagal', 'Terdapat Kesalahan',
            snackPosition: SnackPosition.BOTTOM);
        _isLoading = false;
        _isLoadingMore = false;
      }
    } else {
      _isLoading = false;
      _isLoadingMore = false;
    }
  }

  //add tab bar category title
  void addInitailTab() async {
    for (int i = 0; i < catList.length; i++) {
      tabs.add({
        'text': catList[i].categoryName,
      });
      catId = catList[i].id;
    }

    tc = TabController(
      vsync: this,
      length: tabs.length,
    )..addListener(() {
        isTab = true;

        tcIndex.value = tc!.index;
        selectSubCat.toInt();
      });
  }
}

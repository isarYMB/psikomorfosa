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
import 'package:hallo_doctor_client/app/modules/edukasi/controllers/edukasi_controller.dart';
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
import 'components/NewsDetails.dart';
import 'components/SubHome.dart';
import '../../../../main.dart';

// class EdukasiView extends StatefulWidget {
//   @override
//   EdukasiViewState createState() => EdukasiViewState();
// }

// class EdukasiViewState extends State<EdukasiView>
//     with TickerProviderStateMixin {
class EdukasiView extends StatelessWidget {
  final EdukasiController c = Get.put(EdukasiController());
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // List<BreakingNewsModel> tempBreakList = [];
  // List<BreakingNewsModel> breakingNewsList = [];
  // WeatherData? weatherData;
  loc.Location _location = new loc.Location();
  String? error;
  var isTab = true.obs;
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  final TextEditingController textController = TextEditingController();

  List<News> recenttempList = [];

  // bool weatherLoad = true;

  var scrollController = ScrollController();
  // List bookMarkValue = [];
  // List<News> bookmarkList = [];
  List<String> allImage = [];
  final _pageController = PageController();
  int _curSlider = 0;

  bool isFirst = false;
  // var isliveNews;

  List<News> newsList = [];
  List<News> tempNewsList = [];
  int offset = 0;
  int total = 0;
  bool enabled = true;

  SubHome subHome = SubHome();

  catShimmer() {
    return Container(
        child: Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.4),
            highlightColor: Colors.grey.withOpacity(0.4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: [0, 1, 2, 3, 4, 5, 6]
                      .map((i) => Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: i == 0 ? 0 : 15),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.grey),
                            height: 32.0,
                            width: 110.0,
                          )))
                      .toList()),
            )));
  }

  tabBarData() {
    return TabBar(
      //indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: ThemeData.light().textTheme.subtitle1?.copyWith(
            fontWeight: FontWeight.w600,
          ),
      unselectedLabelColor:
          ThemeData.light().colorScheme.fontColor.withOpacity(0.8),
      isScrollable: true,
      indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          // Creates border
          color: Colors.deepPurple[200]),
      tabs: c.tabs
          .map((tab) => Container(
              height: 32,
              padding: EdgeInsetsDirectional.only(top: 5.0, bottom: 5.0),
              child: Tab(
                text: tab['text'],
              )))
          .toList(),
      labelColor: Color.fromARGB(255, 255, 255, 255),
      controller: c.tc,
      unselectedLabelStyle: ThemeData.light().textTheme.subtitle1?.copyWith(),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Color.fromRGBO(163, 144, 201, 1),
          title: Text('Edukasi'.tr,style: TextStyle(fontFamily: "Nunito",fontWeight: FontWeight.bold),),
          centerTitle: true,

        ),
        key: _scaffoldKey,
        body: SafeArea(
            child: Padding(
          padding: EdgeInsetsDirectional.only(
              top: 10.0, start: 15.0, end: 15.0, bottom: 10.0),
          child: Obx(() => NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    toolbarHeight: 0,
                    titleSpacing: 0,
                    pinned: true,
                    bottom: c.catList.length != 0
                        ? PreferredSize(
                            preferredSize: Size.fromHeight(
                                c.catList[c.tc!.index].subData!.length != 0
                                    ? 43
                                    : 50),
                            child: Column(children: [tabBarData()]))
                        : PreferredSize(
                            preferredSize: Size.fromHeight(34),
                            child: catShimmer()),
                    backgroundColor: Color(0xFFFAFAFA),
                    elevation: 2,
                    floating: true,
                  )
                ];
              },
              body: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: () async {
                  return Future<void>.delayed(const Duration(seconds: 0));
                },
                child: c.catList.length != 0
                    ? TabBarView(
                        controller: c.tc,
                        //key: _key,
                        children:
                            List<Widget>.generate(c.tc!.length, (int index) {
                          //return viewContent();
                          return isTab.value
                              ? SubHome(
                                  curTabId: c.catList[index].id,
                                  isSubCat: false,
                                  scrollController: scrollController,
                                  catList: c.catList,
                                  subCatId: "0",
                                  index: index,
                                )
                              : subHome;
                        }))
                    : contentShimmer(context),
              ))),
        )));
  }
}

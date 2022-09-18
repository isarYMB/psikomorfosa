import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';
// import 'package:facebook_audience_network/facebook_audience_network.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hallo_doctor_client/Helper/AdHelper.dart';
import 'package:hallo_doctor_client/Helper/FbAdHelper.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:hallo_doctor_client/Helper/Color.dart';
import 'package:provider/provider.dart';
import '../../../../../Helper/Constant.dart';
import '../../../../../Helper/Session.dart';
import '../../../../../Helper/String.dart';
import '../../../../../Model/Category.dart';
import '../../../../../Model/News.dart';
import 'NewsDetails.dart';

class SubHome extends StatefulWidget {
  SubHome({
    this.scrollController,
    this.catList,
    this.curTabId,
    this.isSubCat,
    this.index,
    this.subCatId,
  });

  ScrollController? scrollController;

  List<Category>? catList;
  String? curTabId;
  bool? isSubCat;
  int? index;
  String? subCatId;

  SubHomeState createState() => new SubHomeState();
}

class SubHomeState extends State<SubHome> {
  // static final AdRequest request = AdRequest(
  //   keywords: <String>['foo', 'bar'],
  //   contentUrl: 'http://foo.com/bar.html',
  //   nonPersonalizedAds: true,
  // );
  Key _key = new PageStorageKey({});
  bool _innerListIsScrolled = false;
  final GlobalKey<ScaffoldState> _scaffoldKey2 = GlobalKey<ScaffoldState>();
  bool _isNetworkAvail = true;
  bool enabled = true;

  List<News> tempList = [];
  List<News> newsList = [];
  double progress = 0;
  String fileSave = "";
  String otherImageSave = "";
  var isDarkTheme;
  List<News> tempNewsList = [];
  int offset = 0;
  int total = 0;
  int? from;
  String? curTabId;
  bool isFirst = false;
  bool _isLoading = true;
  bool _isLoadingMore = true;

  List<News> questionList = [];
  String? optId;
  int desiIndex = 3;
  int fbAdIndex = 5;
  int goAdIndex = 2;
  List<News> queResultList = [];
  List<News> tempResult = [];
  bool isClickable = false;
  List<News> comList = [];
  bool isFrom = false;

  void _updateScrollPosition() {
    if (!_innerListIsScrolled &&
        widget.scrollController!.position.extentAfter == 0.0) {
      setState(() {
        _innerListIsScrolled = true;
      });
    } else if (_innerListIsScrolled &&
        widget.scrollController!.position.extentAfter > 0.0) {
      setState(() {
        _innerListIsScrolled = false;
        // Reset scroll positions of the TabBarView pages
        _key = new PageStorageKey({});
      });
    }
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // Unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // Unique ID on Android
    }
  }

  @override
  void initState() {
    // fbInit();
    getUserDetails();

    if (!widget.isSubCat!) {
      getNews();
    }

    callApi();
    super.initState();
  }

  callApi() async {}

  // fbInit() async {
  //   String? deviceId = await _getId();
  //   FacebookAudienceNetwork.init(
  //       iOSAdvertiserTrackingEnabled: true, testingId: deviceId);
  // }

  Future<void> getUserDetails() async {
    CUR_USERID = (await getPrefrence(ID)) ?? "";

    setState(() {});
  }

  @override
  void dispose() {
    widget.scrollController!.removeListener(_updateScrollPosition);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SubHome oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subCatId != widget.subCatId) {
      setState(() {
        updateData();
      });
    }
  }

  updateData() async {
    setState(() {
      _isLoading = true;
      newsList.clear();
      comList.clear();
      tempList.clear();
      _isLoadingMore = true;
      offset = 0;
      total = 0;
      getNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey2,
        body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async {
            updateData();
            return Future<void>.delayed(const Duration(seconds: 0));
          },
          child: viewContent(),
        ));
  }

  void loadMoreNews() {
    if (this.mounted) {
      setState(() {
        _isLoadingMore = true;
        if (offset < total) getNews();
      });
    }
  }

  viewContent() {
    return _isLoading
        ? contentShimmer(context)
        : newsList.length == 0
            ? Center(
                child: Text(getTranslated(context, 'no_news')!,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .fontColor
                            .withOpacity(0.8))))
            : Padding(
                padding: EdgeInsetsDirectional.only(
                  top: 15.0,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      (offset < total) ? comList.length + 1 : comList.length,
                  itemBuilder: (context, index) {
                    return (index == comList.length && _isLoadingMore)
                        ? Center(child: CircularProgressIndicator())
                        : newsItem(index);
                  },
                ));
  }

  updateEdukasiView() {
    setState(() {});
  }

//show snackbar msg
  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.fontColor),
      ),
      backgroundColor: isDark! ? colors.tempdarkColor : colors.bgColor,
      elevation: 1.0,
    ));
  }

//get latest news data list
  Future<void> getNews() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var param = {
          ACCESS_KEY: access_key,
          LIMIT: perPage.toString(),
          OFFSET: offset.toString(),
          USER_ID: CUR_USERID != "" ? CUR_USERID : "0",
        };

        if (widget.catList![widget.index!].subData!.length != 0) {
          if (widget.subCatId == "0") {
            param[CATEGORY_ID] = widget.curTabId!;
          } else {
            param[SUBCAT_ID] = widget.subCatId!;
          }
        } else {
          param[CATEGORY_ID] = widget.curTabId!;
        }

        Response response = await post(Uri.parse(getNewsByCatApi),
                body: param, headers: headers)
            .timeout(Duration(seconds: timeOut));
        if (response.statusCode == 200) {
          var getData = json.decode(response.body);

          String error = getData["error"];
          if (error == "false") {
            total = int.parse(getData["total"]);
            if ((offset) < total) {
              tempList.clear();
              var data = getData["data"];
              tempList = (data as List)
                  .map((data) => new News.fromJson(data))
                  .toList();
              newsList.addAll(tempList);

              offset = offset + perPage;

              await getQuestion();
            }
          } else {
            if (this.mounted)
              setState(() {
                _isLoadingMore = false;
                _isLoading = false;
              });
          }
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!);
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    } else {
      setSnackbar(getTranslated(context, 'internetmsg')!);
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  //get all category using api
  Future<void> getQuestion() async {
    if (CUR_USERID != "") {
      _isNetworkAvail = await isNetworkAvailable();
      if (_isNetworkAvail) {
        try {
          var param = {ACCESS_KEY: access_key, USER_ID: CUR_USERID};

          Response response =
              await post(Uri.parse(getQueApi), body: param, headers: headers)
                  .timeout(Duration(seconds: timeOut));
          var getData = json.decode(response.body);

          String error = getData["error"];
        } on TimeoutException catch (_) {
          setSnackbar(getTranslated(context, 'somethingMSg')!);
        }
      } else {
        setSnackbar(getTranslated(context, 'internetmsg')!);
      }
    } else {
      combineList();
      if (this.mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  combineList() {
    comList.clear();
    int cur = 0;
    for (int i = 0; i < newsList.length; i++) {
      if (i != 0 && i % desiIndex == 0) {
        if (questionList.length != 0 && questionList.length > cur) {
          comList.add(questionList[cur]);

          cur++;
        }
      }

      comList.add(newsList[i]);
    }
  }

  // _setQueResult(String queId, String optId, int index) async {
  //   _isNetworkAvail = await isNetworkAvailable();
  //   if (_isNetworkAvail) {
  //     var param = {
  //       ACCESS_KEY: access_key,
  //       USER_ID: CUR_USERID,
  //       QUESTION_ID: queId,
  //       OPTION_ID: optId
  //     };

  //     Response response =
  //         await post(Uri.parse(setQueResultApi), body: param, headers: headers)
  //             .timeout(Duration(seconds: timeOut));

  //     var getData = json.decode(response.body);

  //     String error = getData["error"];

  //     if (error == "false") {
  //       setSnackbar(getTranslated(context, 'survey_sub_succ')!);
  //       setState(() {
  //         questionList.removeWhere((item) => item.id == queId);
  //         _getQueResult(queId, index);
  //       });
  //     }
  //   } else {
  //     setSnackbar(getTranslated(context, 'internetmsg')!);
  //   }
  // }

  //get Question result list using api
  // Future<void> _getQueResult(String queId, int index) async {
  //   _isNetworkAvail = await isNetworkAvailable();
  //   if (_isNetworkAvail) {
  //     try {
  //       var param = {ACCESS_KEY: access_key, USER_ID: CUR_USERID};

  //       Response response = await post(Uri.parse(getQueResultApi),
  //               body: param, headers: headers)
  //           .timeout(Duration(seconds: timeOut));

  //       var getdata = json.decode(response.body);

  //       String error = getdata["error"];
  //     } on TimeoutException catch (_) {
  //       setSnackbar(getTranslated(context, 'somethingMSg')!);
  //     }
  //   } else {
  //     setSnackbar(getTranslated(context, 'internetmsg')!);
  //   }
  // }

  newsItem(int index) {
    List<String> tagList = [];
    DateTime time1 = DateTime.parse(comList[index].date!);
    if (comList[index].tagName! != "") {
      final tagName = comList[index].tagName!;
      tagList = tagName.split(',');
    }

    List<String> tagId = [];

    if (comList[index].tagId! != "") {
      tagId = comList[index].tagId!.split(",");
    }
    return Padding(
        padding: EdgeInsetsDirectional.only(top: index == 0 ? 0 : 15.0),
        child: Column(children: [
          fbNativeUnitId != "" &&
                  iosFbNativeUnitId != "" &&
                  index != 0 &&
                  index % fbAdIndex == 0
              ? _isNetworkAvail
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: Container(
                          padding: EdgeInsets.all(7.0),
                          height: 320,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.boxColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: FacebookNativeAd(
                            backgroundColor:
                                Theme.of(context).colorScheme.boxColor,
                            placementId: FbAdHelper.nativeAdUnitId,
                            adType: Platform.isAndroid
                                ? NativeAdType.NATIVE_AD
                                : NativeAdType.NATIVE_AD_VERTICAL,
                            width: double.infinity,
                            height: 320,
                            keepAlive: true,
                            keepExpandedWhileLoading: false,
                            expandAnimationDuraion: 300,
                            listener: (result, value) {
                              print("Native Ad: $result --> $value");
                            },
                          )))
                  : Container()
              : Container(),
          AbsorbPointer(
            absorbing: !enabled,
            child: Hero(
              tag: comList[index].id!,
              child: InkWell(
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: FadeInImage.assetNetwork(
                          image: comList[index].image!,
                          height: 320.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: placeHolder,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return errorWidget(320, double.infinity);
                          },
                        )),
                    Positioned.directional(
                        textDirection: Directionality.of(context),
                        bottom: 10.0,
                        start: 10,
                        end: 10,
                        height: 123,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color:
                                        colors.tempboxColor.withOpacity(0.85),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        convertToAgo(time1, 0)!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            ?.copyWith(
                                                color: colors.tempdarkColor,
                                                fontSize: 13.0),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 6.0),
                                          child: Text(
                                            comList[index].title!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                ?.copyWith(
                                                    color: colors.tempdarkColor
                                                        .withOpacity(0.9),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                    height: 1.0),
                                            maxLines: 3,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(top: 6.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              comList[index].tagName! != ""
                                                  ? SizedBox(
                                                      height: 23.0,
                                                      child: ListView.builder(
                                                          physics:
                                                              ClampingScrollPhysics(),
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          shrinkWrap: true,
                                                          itemCount: tagList
                                                                      .length >=
                                                                  3
                                                              ? 3
                                                              : tagList.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Padding(
                                                                padding: EdgeInsetsDirectional.only(
                                                                    start:
                                                                        index ==
                                                                                0
                                                                            ? 0
                                                                            : 4),
                                                                child: InkWell(
                                                                  child: Container(
                                                                      height: 23.0,
                                                                      width: 65,
                                                                      alignment: Alignment.center,
                                                                      padding: EdgeInsetsDirectional.only(start: 3.0, end: 3.0, top: 2.5, bottom: 2.5),
                                                                      decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(3.0),
                                                                        color: Color(0xFF0d9cf4)
                                                                            .withOpacity(0.08),
                                                                      ),
                                                                      child: Text(
                                                                        tagList[
                                                                            index],
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyText2
                                                                            ?.copyWith(
                                                                              color: Color(0xFF0d9cf4),
                                                                              fontSize: 12,
                                                                            ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        softWrap:
                                                                            true,
                                                                      )),
                                                                ));
                                                          }))
                                                  : Container(),
                                              Spacer(),
                                            ],
                                          ))
                                    ],
                                  ),
                                )))),
                  ],
                ),
                onTap: () {
                  setState(() {
                    enabled = false;
                  });

                  News model = comList[index];
                  List<News> recList = [];
                  recList.addAll(newsList);
                  recList.removeWhere(
                      (element) => element.id == comList[index].id);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => NewsDetails(
                            model: model,
                            index: index,
                            updateParent: updateEdukasiView,
                            id: model.id,
                            isFav: false,
                            isDetails: true,
                            news: recList,
                          )));
                  setState(() {
                    enabled = true;
                  });
                },
              ),
            ),
          )
        ]));
  }
}

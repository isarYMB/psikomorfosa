import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

//import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:facebook_audience_network/ad/ad_rewarded.dart';
// import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart';
// import 'package:id/Helper/FbAdHelper.dart';
import 'package:hallo_doctor_client/Model/News.dart';
import 'package:hallo_doctor_client/app/modules/edukasi/views/components/NewsVideo.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../Helper/AdHelper.dart';
import '../../../../../Helper/Color.dart';
import '../../../../../Helper/Constant.dart';
import '../../../../../Helper/Session.dart';
import '../../../../../Helper/String.dart';

class NewsDetails extends StatefulWidget {
  final News? model;
  final int? index;
  Function? updateParent;
  final String? id;
  final bool? isFav;
  final bool? isDetails;
  final List<News>? news;
  final model1;
  final news1;

  NewsDetails(
      {Key? key,
      this.model,
      this.index,
      this.updateParent,
      this.id,
      this.isFav,
      this.isDetails,
      this.news,
      this.model1,
      this.news1})
      : super(key: key);

  @override
  NewsDetailsState createState() => NewsDetailsState();
}

class NewsDetailsState extends State<NewsDetails> {
  // static final AdRequest request = AdRequest(
  //   keywords: <String>['foo', 'bar'],
  //   contentUrl: 'http://foo.com/bar.html',
  //   nonPersonalizedAds: true,
  // );
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isNetworkAvail = true;
  List<News> tempList = [];
  bool _isLoading = true;
  bool isLoadingmore = true;
  int offset = 0;
  int total = 0;
  int _curSlider = 0;
  final PageController pageController = PageController();
  bool isScroll = false;
  bool _isInterstitialAdLoaded = false;
  // RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;
  // InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  @override
  void initState() {
    // fbInit();
    getUserDetails();
    // _loadInterstitialAd();
    // // _createRewardedAd();
    // _createInterstitialAd();
    super.initState();
  }

  // fbInit() async {
  //   String? deviceId = await _getId();

  //   FacebookAudienceNetwork.init(
  //       iOSAdvertiserTrackingEnabled: true, testingId: deviceId);
  // }

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

  // void _createRewardedAd() {
  //   if (goRewardedVideoId != null && iosGoRewardedVideoId != null) {
  //     RewardedAd.load(
  //         adUnitId: AdHelper.rewardAdUnitId,
  //         request: request,
  //         rewardedAdLoadCallback: RewardedAdLoadCallback(
  //           onAdLoaded: (RewardedAd ad) {
  //             print('$ad loaded.');
  //             _rewardedAd = ad;
  //             _numRewardedLoadAttempts = 0;
  //           },
  //           onAdFailedToLoad: (LoadAdError error) {
  //             print('RewardedAd failed to load: $error');
  //             _rewardedAd = null;
  //             _numRewardedLoadAttempts += 1;
  //             if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
  //               _createRewardedAd();
  //             }
  //           },
  //         ));
  //   }
  // }

  // void _showGoogleRewardedAd() {
  //   if (_rewardedAd == null) {
  //     print('Warning: attempt to show rewarded before loaded.');
  //     return;
  //   }
  //   _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (RewardedAd ad) =>
  //         print('ad onAdShowedFullScreenContent.'),
  //     onAdDismissedFullScreenContent: (RewardedAd ad) {
  //       print('$ad onAdDismissedFullScreenContent.');
  //       ad.dispose();
  //       _createRewardedAd();
  //     },
  //     onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
  //       print('$ad onAdFailedToShowFullScreenContent: $error');
  //       ad.dispose();
  //       _createRewardedAd();
  //     },
  //   );

  //   _rewardedAd!.setImmersiveMode(true);
  //   _rewardedAd!.show(
  //       onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
  //     print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
  //   });
  //   _rewardedAd = null;
  // }

  getUserDetails() async {
    CUR_USERID = await getPrefrence(ID) ?? "";
    setState(() {});
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.fontColor),
      ),
      backgroundColor: isDark!
          ? Color.fromARGB(255, 255, 255, 255)
          : Color.fromARGB(255, 255, 255, 255),
      elevation: 1.0,
    ));
  }

  // void _createInterstitialAd() {
  //   if (goInterstitialId != null && iosGoInterstitialId != null) {
  //     InterstitialAd.load(
  //         adUnitId: AdHelper.interstitialAdUnitId,
  //         request: request,
  //         adLoadCallback: InterstitialAdLoadCallback(
  //           onAdLoaded: (InterstitialAd ad) {
  //             print('$ad loaded now****');
  //             _interstitialAd = ad;
  //             _numInterstitialLoadAttempts = 0;
  //             _interstitialAd!.setImmersiveMode(true);
  //           },
  //           onAdFailedToLoad: (LoadAdError error) {
  //             print('InterstitialAd failed to load: $error.');
  //             _numInterstitialLoadAttempts += 1;
  //             _interstitialAd = null;
  //             if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
  //               _createInterstitialAd();
  //             }
  //           },
  //         ));
  //   }
  // }

  // void _showGoogleInterstitialAd() {
  //   if (_interstitialAd == null) {
  //     print('Warning: attempt to show interstitial before loaded.');
  //     return;
  //   }
  //   _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (InterstitialAd ad) =>
  //         print('ad onAdShowedFullScreenContent.'),
  //     onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //       print('$ad onAdDismissedFullScreenContent.');
  //       ad.dispose();
  //       _createInterstitialAd();
  //     },
  //     onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
  //       print('$ad onAdFailedToShowFullScreenContent: $error');
  //       ad.dispose();
  //       _createInterstitialAd();
  //     },
  //   );
  //   _interstitialAd!.show();
  //   _interstitialAd = null;
  // }

  // _showInterstitialAd() {
  //   if (iosFbInterstitialId != "" && fbInterstitialId != "") {
  //     if (_isInterstitialAdLoaded == true)
  //       FacebookInterstitialAd.showInterstitialAd();
  //     else
  //       print("Interstial Ad not yet loaded!");
  //   }
  // }

  // void _loadInterstitialAd() {
  //   if (iosFbInterstitialId != "" && fbInterstitialId != "") {
  //     FacebookInterstitialAd.loadInterstitialAd(
  //       placementId: FbAdHelper.interstitialAdUnitId,
  //       listener: (result, value) {
  //         print(">> FAN > Interstitial Ad: $result --> $value");
  //         if (result == InterstitialAdResult.LOADED)
  //           _isInterstitialAdLoaded = true;

  //         if (result == InterstitialAdResult.DISMISSED &&
  //             value["invalidated"] == true) {
  //           _isInterstitialAdLoaded = false;
  //           _loadInterstitialAd();
  //         }
  //       },
  //     );
  //   }
  // }

  //page slider news list data
  Widget _slider1() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
        height: height,
        width: width,
        child: PageView.builder(
            controller: pageController,
            onPageChanged: (index) async {
              setState(() {
                _curSlider = index;
              });
              _isNetworkAvail = await isNetworkAvailable();
              if (_isNetworkAvail) {
                // if (index % 2 == 0) {
                //   if (iosFbInterstitialId != "" && fbInterstitialId != "") {
                //     _showInterstitialAd();
                //   }
                // }
                if (index % 3 == 0) {
                  if (goInterstitialId != null && iosGoInterstitialId != null) {
                    // _showGoogleInterstitialAd();
                  }
                }
                if (index % 5 == 0) {
                  if (goRewardedVideoId != null &&
                      iosGoRewardedVideoId != null) {
                    // _showGoogleRewardedAd();
                  }
                }
              }
            },
            itemCount: widget.news1!.length == 0 ? 1 : widget.news1!.length + 1,
            itemBuilder: (context, index) {
              return index == 0
                  ? NewsSubDetails(
                      model1: widget.model1,
                      index: widget.index,
                      updateParent: widget.updateParent,
                      id: widget.id,
                      isDetails: widget.isDetails,
                    )
                  : NewsSubDetails(
                      model1: widget.news1![index - 1],
                      index: index - 1,
                      updateParent: widget.updateParent,
                      id: widget.news1![index - 1].id,
                      isDetails: widget.isDetails,
                    );
            }));
  }

  //page slider news list data
  Widget _slider() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
        height: height,
        width: width,
        child: PageView.builder(
            controller: pageController,
            onPageChanged: (index) async {
              setState(() {
                _curSlider = index;
              });
              _isNetworkAvail = await isNetworkAvailable();
              if (_isNetworkAvail) {
                if (index % 2 == 0) {
                  if (goRewardedVideoId != null &&
                      iosGoRewardedVideoId != null) {
                    // _showGoogleRewardedAd();
                  }
                }
                if (index % 3 == 0) {
                  if (iosFbInterstitialId != "" && fbInterstitialId != "") {
                    // _showInterstitialAd();
                  }
                }
                if (index % 5 == 0) {
                  if (goInterstitialId != null && iosGoInterstitialId != null) {
                    // _showGoogleInterstitialAd();
                  }
                }
              }
            },
            itemCount: widget.news!.length == 0 ? 1 : widget.news!.length + 1,
            itemBuilder: (context, index) {
              return index == 0
                  ? NewsSubDetails(
                      model: widget.model,
                      index: widget.index,
                      updateParent: widget.updateParent,
                      id: widget.id,
                      isDetails: widget.isDetails,
                    )
                  : NewsSubDetails(
                      model: widget.news![index - 1],
                      index: index - 1,
                      updateParent: widget.updateParent,
                      id: widget.news![index - 1].id,
                      isDetails: widget.isDetails,
                    );
            }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
        key: _scaffoldKey, body: !widget.isDetails! ? _slider1() : _slider());
  }
}

class NewsSubDetails extends StatefulWidget {
  final News? model;
  final int? index;
  final Function? updateParent;
  final String? id;
  final bool? isDetails;
  final model1;

  const NewsSubDetails(
      {Key? key,
      this.model,
      this.index,
      this.updateParent,
      this.id,
      this.isDetails,
      this.model1})
      : super(key: key);

  @override
  NewsSubDetailsState createState() => NewsSubDetailsState();
}

class NewsSubDetailsState extends State<NewsSubDetails> {
  List<String> allImage = [];
  String? profile;
  bool _isNetworkAvail = true;
  int _fontValue = 15;
  int offset = 0;
  int total = 0;
  String comTotal = "";
  bool _isLoadNews = true;
  bool _isLoadMoreNews = true;
  List<News> tempList = [];
  List<News> newsList = [];
  bool _isLoading = true;
  bool isLoadingmore = true;
  bool comBtnEnabled = false;
  bool replyComEnabled = false;
  final _pageController = PageController();
  int _curSlider = 0;
  bool comEnabled = false;
  bool isReply = false;
  int? replyComIndex;
  FlutterTts? _flutterTts;
  bool isPlaying = false;
  bool isFirst = false;

  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  String? lanCode;
  int offsetNews = 0;
  int totalNews = 0;
  ScrollController controller = new ScrollController();
  ScrollController controller1 = new ScrollController();
  // late BannerAd _bannerAd;

  // TODO: Add _isBannerAdReady
  bool _isBannerAdReady = false;

  @override
  void initState() {
    getUserDetails();
    initializeTts();
    callApi();
    allImage.clear();
    if (widget.isDetails!) {
      allImage.add(widget.model!.image!);
      if (widget.model!.imageDataList!.length != 0) {
        for (int i = 0; i < widget.model!.imageDataList!.length; i++) {
          allImage.add(widget.model!.imageDataList![i].otherImage!);
        }
      }
    } else {
      allImage.add(widget.model1!.image!);
    }

    // _createBottomBannerAd();
    controller.addListener(_scrollListener);
    controller1.addListener(_scrollListener1);
    super.initState();
  }

  callApi() async {}

  @override
  void dispose() {
    if (widget.isDetails!) {
      isPlaying = false;
      _flutterTts!.stop();
    }
    // _bannerAd.dispose();
    super.dispose();
  }

  // void _createBottomBannerAd() {
  //   if (goBannerId != "" && iosGoBannerId != "") {
  //     _bannerAd = BannerAd(
  //       adUnitId: AdHelper.bannerAdUnitId,
  //       request: AdRequest(),
  //       size: AdSize.fullBanner,
  //       listener: BannerAdListener(
  //         onAdLoaded: (_) {
  //           setState(() {
  //             _isBannerAdReady = true;
  //           });
  //         },
  //         onAdFailedToLoad: (ad, err) {
  //           _isBannerAdReady = false;
  //           ad.dispose();
  //         },
  //       ),
  //     );

  //     _bannerAd.load();
  //   }
  // }

  //get prefrences
  getUserDetails() async {
    profile = await getPrefrence(PROFILE) ?? "";
    lanCode = await getPrefrence(LANGUAGE_CODE);

    getLocale().then((locale) {
      lanCode = locale.languageCode;
    });

    setState(() {});
  }

  initializeTts() {
    if (widget.isDetails!) {
      _flutterTts = FlutterTts();

      _flutterTts!.setStartHandler(() async {
        if (this.mounted)
          setState(() {
            isPlaying = true;
          });

        var max = await _flutterTts!.getMaxSpeechInputLength;
      });

      _flutterTts!.setCompletionHandler(() {
        if (this.mounted) {
          setState(() {
            isPlaying = false;
          });
        }
      });

      _flutterTts!.setErrorHandler((err) {
        if (this.mounted) {
          setState(() {
            print("error occurred: " + err);
            isPlaying = false;
          });
        }
      });
    }
  }

  _speak(String Description) async {
    if (Description != null && Description.isNotEmpty) {
      await _flutterTts!.setVolume(volume);
      await _flutterTts!.setSpeechRate(rate);
      await _flutterTts!.setPitch(pitch);
      await _flutterTts!.getLanguages;
      List<dynamic> languages = await _flutterTts!.getLanguages;
      print(languages);
      await _flutterTts!.setLanguage(() {
        if (lanCode == "en") {
          print("en-US");
          return "es-US";
        } else if (lanCode == "es") {
          print("en-ES");
          return "es-ES";
        } else if (lanCode == "hi") {
          print("hi-IN");
          return "hi-IN";
        } else if (lanCode == "tr") {
          print("tr-TR");
          return "tr-TR";
        } else if (lanCode == "pt") {
          print("pt-PT");
          return "pt-PT";
        } else {
          print("en-US");
          return "en-US";
        }
      }());
      int length = Description.length;
      if (length < 4000) {
        setState(() {
          isPlaying = true;
        });
        await _flutterTts!.speak(Description);
        _flutterTts!.setCompletionHandler(() {
          setState(() {
            _flutterTts!.stop();
            isPlaying = false;
          });
        });
      } else if (length < 8000) {
        String temp1 = Description.substring(0, length ~/ 2);
        print(temp1.length);
        await _flutterTts!.speak(temp1);
        _flutterTts!.setCompletionHandler(() {
          setState(() {
            isPlaying = true;
          });
        });

        String temp2 = Description.substring(temp1.length, Description.length);
        await _flutterTts!.speak(temp2);
        _flutterTts!.setCompletionHandler(() {
          setState(() {
            isPlaying = false;
          });
        });
      } else if (length < 12000) {
        String temp1 = Description.substring(0, 3999);
        await _flutterTts!.speak(temp1);
        _flutterTts!.setCompletionHandler(() {
          setState(() {
            isPlaying = true;
          });
        });
        String temp2 = Description.substring(temp1.length, 7999);
        await _flutterTts!.speak(temp2);
        _flutterTts!.setCompletionHandler(() {
          setState(() {});
        });
        String temp3 = Description.substring(temp2.length, Description.length);
        await _flutterTts!.speak(temp3);
        _flutterTts!.setCompletionHandler(() {
          setState(() {
            isPlaying = false;
            print("execution complete");
          });
        });
      }
    }
  }

  Future _stop() async {
    var result = await _flutterTts!.stop();
    if (result == 1)
      setState(() {
        isPlaying = false;
      });
  }

  Future _pause() async {
    var result = await _flutterTts!.pause();
    if (result == 1)
      setState(() {
        isPlaying = false;
      });
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  //set not comment of news text
  Widget getNoItem() {
    return Text(
      getTranslated(context, 'com_nt_avail')!,
      textAlign: TextAlign.center,
    );
  }

  //set snackbar msg
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

  imageView() {
    return Container(
        height: deviceHeight! * 0.42,
        width: double.infinity,
        child: widget.isDetails!
            ? PageView.builder(
                itemCount: allImage.length,
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _curSlider = index;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  return Hero(
                    tag: widget.model!.id!,
                    child: InkWell(
                      child: FadeInImage(
                          fadeInDuration: Duration(milliseconds: 150),
                          image: CachedNetworkImageProvider(allImage[index]),
                          fit: BoxFit.fill,
                          height: deviceHeight! * 0.42,
                          width: double.infinity,
                          imageErrorBuilder: (context, error, stackTrace) =>
                              errorWidget(
                                  deviceHeight! * 0.42, double.infinity),
                          placeholder: AssetImage(
                            placeHolder,
                          )),
                    ),
                  );
                })
            : Hero(
                tag: widget.model1!.id!,
                child: FadeInImage(
                    fadeInDuration: Duration(milliseconds: 150),
                    image: CachedNetworkImageProvider(widget.isDetails!
                        ? widget.model!.image!
                        : widget.model1!.image!),
                    fit: BoxFit.fill,
                    height: deviceHeight! * 0.42,
                    width: double.infinity,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        errorWidget(deviceHeight! * 0.42, double.infinity),
                    placeholder: AssetImage(
                      placeHolder,
                    )),
              ));
  }

  imageSliderDot() {
    return widget.isDetails!
        ? allImage.length <= 1
            ? Container()
            : Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: EdgeInsets.only(top: deviceHeight! / 2.6 - 23),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: map<Widget>(
                        allImage,
                        (index, url) {
                          return Container(
                              width: _curSlider == index ? 10.0 : 8.0,
                              height: _curSlider == index ? 10.0 : 8.0,
                              margin: EdgeInsets.symmetric(horizontal: 1.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _curSlider == index
                                    ? colors.bgColor
                                    : colors.bgColor.withOpacity((0.5)),
                              ));
                        },
                      ),
                    )))
        : Container();
  }

  backBtn() {
    return Positioned.directional(
        textDirection: Directionality.of(context),
        top: 50.0,
        start: 10.0,
        child: InkWell(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: 35,
                    width: 35,
                    padding: EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: Colors.transparent.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SvgPicture.asset(
                      "assets/images/back_icon.svg",
                      semanticsLabel: 'back icon',
                    ),
                  ))),
          onTap: () {
            Navigator.pop(context);
          },
        ));
  }

  videoBtn() {
    return widget.isDetails!
        ? widget.model!.contentType == "video_upload" ||
                widget.model!.contentType == "video_youtube" ||
                widget.model!.contentType == "video_other"
            ? Positioned.directional(
                textDirection: Directionality.of(context),
                top: 50.0,
                end: 10.0,
                child: InkWell(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            height: 35,
                            width: 35,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.transparent.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: SvgPicture.asset(
                              "assets/images/video_icon.svg",
                              semanticsLabel: 'video icon',
                            ),
                          ))),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsVideo(
                            model: widget.model,
                          ),
                        ));
                  },
                ))
            : Container()
        : Container();
  }

  changeFontSizeSheet() {
    showModalBottomSheet<dynamic>(
        context: context,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50))),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setStater) {
            return Container(
                padding: EdgeInsetsDirectional.only(
                    bottom: 20.0, top: 5.0, start: 20.0, end: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              "assets/images/textsize_icon.svg",
                              semanticsLabel: 'textsize',
                              height: 23.0,
                              width: 23.0,
                              color: Theme.of(context).colorScheme.darkColor,
                            ),
                            Padding(
                                padding:
                                    EdgeInsetsDirectional.only(start: 15.0),
                                child: Text(
                                  getTranslated(context, 'txtSize_lbl')!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .fontColor),
                                )),
                          ],
                        )),
                    SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.red[700],
                          inactiveTrackColor: Colors.red[100],
                          trackShape: RoundedRectSliderTrackShape(),
                          trackHeight: 4.0,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 12.0),
                          thumbColor: Colors.redAccent,
                          overlayColor: Colors.red.withAlpha(32),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 28.0),
                          tickMarkShape: RoundSliderTickMarkShape(),
                          activeTickMarkColor: Colors.red[700],
                          inactiveTickMarkColor: Colors.red[100],
                          valueIndicatorShape:
                              PaddleSliderValueIndicatorShape(),
                          valueIndicatorColor: Colors.redAccent,
                          valueIndicatorTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        child: Slider(
                          label: '${_fontValue}',
                          value: _fontValue.toDouble(),
                          activeColor: colors.primary,
                          min: 15,
                          max: 40,
                          divisions: 10,
                          onChanged: (value) {
                            setStater(() {
                              setState(() {
                                _fontValue = value.round();
                                setPrefrence(font_value, _fontValue.toString());
                              });
                            });
                          },
                        )),
                  ],
                ));
          });
        });
  }

  allRowBtn() {
    return widget.isDetails!
        ? Row(
            children: [
              Padding(
                  padding: EdgeInsetsDirectional.only(start: 9.0),
                  child: InkWell(
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          "assets/images/textsize_icon.svg",
                          semanticsLabel: 'textsize',
                          height: 16.0,
                          width: 16.0,
                          color: Theme.of(context).colorScheme.darkColor,
                        ),
                        Padding(
                            padding: EdgeInsetsDirectional.only(top: 4.0),
                            child: Text(
                              getTranslated(context, 'txtSize_lbl')!,
                              style: Theme.of(this.context)
                                  .textTheme
                                  .caption
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor
                                          .withOpacity(0.8),
                                      fontSize: 9.0),
                            ))
                      ],
                    ),
                    onTap: () {
                      changeFontSizeSheet();
                    },
                  )),
              Padding(
                  padding: EdgeInsetsDirectional.only(start: 9.0),
                  child: InkWell(
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          "assets/images/speakloud_icon.svg",
                          semanticsLabel: 'speakloud',
                          height: 16.0,
                          width: 16.0,
                          color: isPlaying
                              ? colors.primary
                              : Theme.of(context).colorScheme.darkColor,
                        ),
                        Padding(
                            padding: EdgeInsetsDirectional.only(top: 4.0),
                            child: Text(
                              getTranslated(context, 'speakLoud_lbl')!,
                              style: Theme.of(this.context)
                                  .textTheme
                                  .caption
                                  ?.copyWith(
                                      color: isPlaying
                                          ? colors.primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .fontColor
                                              .withOpacity(0.8),
                                      fontSize: 9.0),
                            ))
                      ],
                    ),
                    onTap: () {
                      if (isPlaying) {
                        _stop();
                      } else {
                        final document = parse(widget.model!.desc);
                        String parsedString =
                            parse(document.body!.text).documentElement!.text;
                        _speak(parsedString);
                      }
                    },
                  )),
            ],
          )
        : Container();
  }

  dateView() {
    DateTime? time1;
    if (widget.isDetails!) {
      time1 = DateTime.parse(widget.model!.date!);
    }
    return widget.isDetails!
        ? !isReply
            ? !comEnabled
                ? Padding(
                    padding: EdgeInsetsDirectional.only(top: 8.0),
                    child: Text(
                      convertToAgo(time1!, 0)!,
                      style: Theme.of(this.context).textTheme.caption?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .fontColor
                              .withOpacity(0.8),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                : Container()
            : Container()
        : Container();
  }

  tagView() {
    List<String> tagList = [];
    if (widget.isDetails!) {
      if (widget.model!.tagName! != "") {
        final tagName = widget.model!.tagName!;
        tagList = tagName.split(',');
      }
    }
    List<String> tagId = [];
    if (widget.isDetails!) {
      if (widget.model!.tagId! != "") {
        tagId = widget.model!.tagId!.split(",");
      }
    }
    return widget.isDetails!
        ? !isReply
            ? !comEnabled
                ? widget.model!.tagName! != ""
                    ? Padding(
                        padding: EdgeInsetsDirectional.only(top: 8.0),
                        child: SizedBox(
                            height: 20.0,
                            child: Row(
                              children: List.generate(tagList.length, (index) {
                                return Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        start: index == 0 ? 0 : 7),
                                    child: InkWell(
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(3.0),
                                          child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 30, sigmaY: 30),
                                              child: Container(
                                                  height: 20.0,
                                                  width: 65,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsetsDirectional
                                                      .only(
                                                          start: 3.0,
                                                          end: 3.0,
                                                          top: 2.5,
                                                          bottom: 2.5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3.0),
                                                    color: Color(0xFF0d9cf4)
                                                        .withOpacity(0.03),
                                                  ),
                                                  child: Text(
                                                    tagList[index],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        ?.copyWith(
                                                          color:
                                                              Color(0xFF0d9cf4),
                                                          fontSize: 11,
                                                        ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  )))),
                                    ));
                              }),
                            )))
                    : Container()
                : Container()
            : Container()
        : Container();
  }

  titleView() {
    return !isReply
        ? !comEnabled
            ? Padding(
                padding: EdgeInsetsDirectional.only(top: 6.0),
                child: Text(
                  widget.isDetails!
                      ? widget.model!.title!
                      : widget.model1!.title!,
                  style: Theme.of(this.context).textTheme.subtitle1?.copyWith(
                      color: Theme.of(context).colorScheme.fontColor,
                      fontWeight: FontWeight.w600),
                ),
              )
            : Container()
        : Container();
  }

  descView() {
    return !isReply
        ? !comEnabled
            ? Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Html(
                  data: widget.isDetails!
                      ? widget.model!.desc
                      : widget.model1!.desc,
                  shrinkWrap: true,
                  style: {
                    // tables will have the below background color
                    "div": Style(
                      color: ThemeData.light()
                          .colorScheme
                          .fontColor
                          .withOpacity(0.8),
                      fontSize: FontSize((_fontValue - 3).toDouble()),
                    ),
                    "p": Style(
                        color: Theme.of(context).colorScheme.fontColor,
                        fontSize: FontSize(_fontValue.toDouble())),
                    "b ": Style(
                        color: Theme.of(context).colorScheme.fontColor,
                        fontSize: FontSize(_fontValue.toDouble())),
                  },
                  onLinkTap: (String? url,
                      RenderContext context,
                      Map<String, String> attributes,
                      dom.Element? element) async {
                    if (await canLaunch(url!)) {
                      await launch(
                        url,
                        forceSafariVC: false,
                        forceWebView: false,
                      );
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ))
            : Container()
        : Container();
  }

  allDetails() {
    return Padding(
        padding: EdgeInsets.only(top: deviceHeight! / 2.6),
        child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding:
                  EdgeInsetsDirectional.only(top: 20.0, start: 20.0, end: 20.0),
              width: deviceWidth,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  color: Color(0xFFFAFAFA)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    allRowBtn(),
                    dateView(),
                    tagView(),
                    titleView(),
                    descView(),
                    // widget.index! % 2 == 0
                    // ? fbBannerId != null && iosFbBannerId != null
                    //     ? Container(
                    //         alignment: Alignment(0.5, 1),
                    //         padding: EdgeInsets.only(bottom: 15.0),
                    //         child: FacebookBannerAd(
                    //           placementId: FbAdHelper.bannerAdUnitId,
                    //           bannerSize: BannerSize.STANDARD,
                    //           listener: (result, value) {
                    //             switch (result) {
                    //               case BannerAdResult.ERROR:
                    //                 print("Error: $value");
                    //                 break;
                    //               case BannerAdResult.LOADED:
                    //                 print("Loaded: $value");
                    //                 break;
                    //               case BannerAdResult.CLICKED:
                    //                 print("Clicked: $value");
                    //                 break;
                    //               case BannerAdResult.LOGGING_IMPRESSION:
                    //                 print("Logging Impression: $value");
                    //                 break;
                    //             }
                    //           },
                    //         )
                    //         )
                    //     : Container()
                    // : goBannerId != "" && iosGoBannerId != ""
                    //     ? _isNetworkAvail
                    //         ? Padding(
                    //             padding: EdgeInsets.only(bottom: 15.0),
                    //             child: _isBannerAdReady
                    //                 ? Container(
                    //                     width:
                    //                         _bannerAd.size.width.toDouble(),
                    //                     height: _bannerAd.size.height
                    //                         .toDouble(),
                    //                     child: AdWidget(ad: _bannerAd))
                    //                 : null)
                    // : Container()
                    // : Container(),
                    // viewRelatedContent()
                  ]),
            )));
  }

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (this.mounted) {
        setState(() {
          _isLoadMoreNews = true;

          // if (offsetNews < totalNews) getRelatedNews();
        });
      }
    }
  }

  _scrollListener1() {
    if (controller1.offset >= controller1.position.maxScrollExtent &&
        !controller1.position.outOfRange) {
      if (this.mounted) {
        setState(() {
          isLoadingmore = true;

          // if (offset < total) _getComment();
        });
      }
    }
  }

  newsShimmer() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.6),
        highlightColor: Colors.grey,
        child: SingleChildScrollView(
          //padding: EdgeInsetsDirectional.only(start: 5.0, top: 20.0),
          scrollDirection: Axis.horizontal,
          child: Row(
              children: [0, 1, 2, 3, 4, 5, 6]
                  .map((i) => Padding(
                      padding: EdgeInsetsDirectional.only(
                          top: 15.0, start: i == 0 ? 0 : 6.0),
                      child: Stack(children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey.withOpacity(0.6)),
                          height: 240.0,
                          width: 195.0,
                        ),
                        Positioned.directional(
                            textDirection: Directionality.of(context),
                            bottom: 7.0,
                            start: 7,
                            end: 7,
                            height: 99,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey,
                              ),
                            )),
                      ])))
                  .toList()),
        ));
  }

  newsItem(int index) {
    DateTime time1 = DateTime.parse(newsList[index].date!);

    return Padding(
      padding: EdgeInsetsDirectional.only(
          top: 15.0, start: index == 0 ? 0 : 6.0, bottom: 15.0),
      child: Hero(
        tag: newsList[index].id!,
        child: InkWell(
          child: Stack(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: FadeInImage(
                      fadeInDuration: Duration(milliseconds: 150),
                      image: CachedNetworkImageProvider(newsList[index].image!),
                      height: 250.0,
                      width: 193.0,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) =>
                          errorWidget(250, 193),
                      placeholder: AssetImage(
                        placeHolder,
                      ))),
              Positioned.directional(
                  textDirection: Directionality.of(context),
                  bottom: 7.0,
                  start: 7,
                  end: 7,
                  height: 99,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: colors.tempboxColor.withOpacity(0.85),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  convertToAgo(time1, 0)!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      ?.copyWith(
                                          color: colors.tempdarkColor,
                                          fontSize: 10.0),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      newsList[index].title!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          ?.copyWith(
                                              color: colors.tempdarkColor
                                                  .withOpacity(0.9),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12.5,
                                              height: 1.0),
                                      maxLines: 3,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                              ],
                            ),
                          )))),
            ],
          ),
          onTap: () {
            News model = newsList[index];
            List<News> recList = [];
            recList.addAll(newsList);
            recList.removeAt(index);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => NewsDetails(
                      model: model,
                      index: index,
                      updateParent: updateEdukasiView,
                      id: model.id,
                      isFav: false,
                      isDetails: true,
                      news: recList,
                      //updateHome: updateHome,
                    )));
          },
        ),
      ),
    );
  }

  updateEdukasiView() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: deviceWidth,
        child: SingleChildScrollView(
            child: Stack(children: <Widget>[
          imageView(),
          imageSliderDot(),
          backBtn(),
          videoBtn(),
          allDetails(),
          // likeBtn(),
        ])));
  }
}

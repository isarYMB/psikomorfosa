import 'package:firebase_core/firebase_core.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/modules/login/views/login_view.dart';
import 'package:hallo_doctor_client/app/splashscreen.dart';
import 'package:hallo_doctor_client/modules/auth/pages/phone/index.dart';
import 'package:lottie/lottie.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        color: Colors.purpleAccent,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      );
  //
  }
}

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Container(
          height:  mediaQueryHeight ,
          width:   mediaQueryWidth,
          padding: EdgeInsets.only(left: 30.0, right: 30.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(251, 199, 212, 1),
                Color.fromRGBO(150, 149, 238, 1),
                // Color.fromRGBO(251, 199, 212, 1),
              ],
            ),
          ),
          child : SingleChildScrollView (
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: mediaQueryHeight * 0.09),
                SizedBox(
                  height: context.height / 2.5,
                  child : Positioned(
                    child: Lottie.asset(
                      tabs[_currentIndex].lottieFile,
                      width: 600,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
                Align(
                  // alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 350,
                    child: Column(
                      children: [
                        Flexible(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: tabs.length,
                            itemBuilder: (BuildContext context, int index) {
                              OnboardingModel tab = tabs[index];
                              return Column(
                                children: [
                                  Text(

                                    tab.title,
                                    style: const TextStyle(
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                    textAlign: TextAlign.left
                                    ,
                                  ),
                                  SizedBox(height: 20),
                                  // SizedBox( height: context.height / 2.3,
                                  Text(
                                    tab.subtitle,
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                      color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.left
                                    ,
                                  ),
                                  // )
                                ],
                              );
                            },
                            onPageChanged: (value) {
                              _currentIndex = value;
                              setState(() {});
                            },
                          ),
                        ),
                        // SizedBox(height: 50,),
                        SizedBox(height: context.height / 5,
                          child : Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                height: mediaQueryHeight * 0.07,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                        children: [
                                          for (int index = 0; index < tabs.length; index++)
                                            _DotIndicator(isSelected: index == _currentIndex)
                                        ]
                                    ),

                                    _currentIndex < 2 ? TextButton(onPressed: () {
                                      _pageController.jumpToPage(2);
                                    }, child: Text("Skip", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold , color: Colors.white),)) : ElevatedButton(onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginView()));
                                    }, child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Mulai", style:  TextStyle(color: Color.fromRGBO(150, 149, 238, 1),)),
                                        SizedBox(
                                          width: 45,

                                        ),
                                        Icon( // <-- Icon
                                          Icons.arrow_forward_ios,
                                          color:  Color.fromRGBO(150, 149, 238, 1),
                                          size: 18.0,
                                        ),
                                      ],
                                    ),
                                      style:  ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all<Color> (Color.fromRGBO(
                                            255, 255, 255, 1.0),),
                                        shadowColor:
                                        MaterialStateProperty.all(Colors.transparent),
                                        shape:
                                        MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ),


        )

    );
  }
}

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path orangeArc = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - 170)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, size.height - 170)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(orangeArc, Paint()..color = Colors.orange);

    Path whiteArc = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(0.0, size.height - 185)
      ..quadraticBezierTo(
          size.width / 2, size.height - 70, size.width, size.height - 185)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(whiteArc, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _DotIndicator extends StatelessWidget {
  final bool isSelected;

  const _DotIndicator({Key? key, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 10.0,
        width: 10.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ?Color.fromRGBO(240, 191, 220, 1) : Colors.white,
        ),
      ),
    );
  }
}

class OnboardingModel {
  final String lottieFile;
  final String title;
  final String subtitle;

  OnboardingModel(this.lottieFile, this.title, this.subtitle);
}

List<OnboardingModel> tabs = [
  OnboardingModel(
    'assets/lottie1.json',
    'Selamat Datang Di Aplikasi AyoCerita!',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit,sed do eiusmod tempor incididunt ut laboreet dolore magna aliqua',
  ),
  OnboardingModel(
    'assets/interaction.json',
    'Bagikan Cerita Kamu Dengan Sesama Melalui UpCerita',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit,sed do eiusmod tempor incididunt ut laboreet dolore magna aliqua',
  ),
  OnboardingModel(
    'assets/mentaltherapy.json',
    'Atau Ceritakan Masalahmu Bersama Konselor Profesional Kami',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit,sed do eiusmod tempor incididunt ut laboreet dolore magna aliqua.',
  ),
];
//   int _currentPage = 0;
//   PageController _controller = PageController();
//
//   List<Widget> _pages = [
//     SliderPage(
//       title: "Selamat Datang Di Aplikasi AyoCerita!",
//       description:
//       "Lorem ipsum dolor sit amet, consectetur adipiscing elit,sed do eiusmod tempor incididunt ut laboreet dolore magna aliqua.",
//       lottie: "assets/lottie1.json",
//     ),
//     SliderPage(
//       title: "Bagikan Cerita Kamu Dengan Sesama Melalui UpCerita",
//       description:
//       "Lorem ipsum dolor sit amet, consectetur adipiscing elit,sed do eiusmod tempor incididunt ut laboreet dolore magna aliqua.",
//       lottie: "assets/interaction.json"
//     ),
//     SliderPage(
//       title: "Atau Ceritakan Masalahmu Bersama Konselor Profesional Kami",
//       description:
//       "Lorem ipsum dolor sit amet, consectetur adipiscing elit,sed do eiusmod tempor incididunt ut laboreet dolore magna aliqua.",
//       lottie: "assets/mentaltherapy.json"
//     ),
//   ];
//
//   _onchanged(int index) {
//     setState(() {
//       _currentPage = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           final width = constraints.biggest.width;
//           final height = constraints.biggest.height;
//
//           return Column(
//             children: <Widget>[
//               Container(
//                 height: height,
//                 // color: Colors.red,
//                 decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topRight,
//                       end: Alignment.bottomLeft,
//                       colors: [
//                         Colors.blue,
//                         Colors.red,
//                       ],
//                     )
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Center(
//                       child: Text('hello world! $width $height'),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           );
//         },
//       )
//     );
//   }
// }
//
// class SliderPage extends StatelessWidget {
//   SliderPage(
//       {required this.title, required this.description, required this.lottie});
//
//   final String title;
//   final String description;
//   final String lottie;
//
//
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery
//         .of(context)
//         .size
//         .width;
//     double height = MediaQuery
//         .of(context)
//         .size
//         .height;
//
//     return Container(
//       color: Colors.white,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Lottie.asset(
//             lottie,
//             width: 500,
//             height: 300,
//           ),
//           SizedBox(
//             height: 60,
//           ),
//           Text(
//             title,
//             style: TextStyle(fontFamily: "Nunito",
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold),
//             textAlign: TextAlign.left,
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30),
//             child: Text(
//               description,
//               style: TextStyle(
//                 height: 1.5,
//                 fontWeight: FontWeight.normal,
//                 fontSize: 14,
//                 letterSpacing: 0.7,
//               ),
//               textAlign: TextAlign.left,
//             ),
//           ),
//           SizedBox(
//             height: 60,
//           ),
//         ],
//       ),
//     );
//   }
// }
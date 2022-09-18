import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../imports.dart';


  @override
  Future<void>? to_WelcomeState() => Get.to(() => _WelcomeState());


class _WelcomeState extends StatelessWidget {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Color.fromRGBO(163, 144, 201, 1),
          centerTitle: true,
          title: Text(t.Terms,
              style: TextStyle(
                  fontFamily: "Nunito",
                  color: Color.fromRGBO(163, 144, 201, 1),fontWeight: FontWeight.bold
              )),
        ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
        children: <Widget>[
    const SizedBox(height: 50),
    const Text(
    'Daily UI Term Of Services',
    style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    ),
    ),
          Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              SizedBox(
                height: 28,
              ),
              Container(
                padding: EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Privasi Polisi',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Nunito"
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      'Psikomorfosa App is owned by Lembaga Layanan Psikologi Psikomorfosa, which is a data controller of your personal data.\n\n'
                      'We have adopted this Privacy Policy, which determines how we are processing the information collected by Psikomorfosa App, which also provides the reasons why we must collect certain personal data about you. Therefore, you must read this Privacy Policy before using Psikomorfosa App.\n\n'
                      'We take care of your personal data and undertake to guarantee its confidentiality and security.',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Nunito"
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      'Personal information we collect:',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Nunito"
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      'When you visit the Psikomorfosa App, we automatically collect certain information about your device, including information about your web browser, IP address, time zone, and some of the installed cookies on your device. Additionally, as you browse the Site, we collect information about the individual web pages or products you view, what application s or search terms referred you to the Site, and how you interact with the Site. We refer to this automatically-collected information as “Device Information.” Moreover, we might collect the personal data you provide to us (including but not limited to Name, Surname, Address, payment information, etc.) during registration to be able to fulfill the agreement.',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Nunito"
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      'Why do we process your data?',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Nunito"
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      'Our top priority is customer data security, and, as such, we may process only minimal user data, only as much as it is absolutely necessary to maintain the application . Information collected automatically is used only to identify potential cases of abuse and establish statistical information regarding application  usage. This statistical information is not otherwise aggregated in such a way that it would identify any particular user of the system./n/n'
                          'You can visit the application  without telling us who you are or revealing any information, by which someone could identify you as a specific, identifiable individual. If, however, you wish to use some of the application ’s features, or you wish to receive our newsletter or provide other details by filling a form, you may provide personal data to us, such as your email, first name, last name, city of residence, organization, telephone number. You can choose not to provide us with your personal data, but then you may not be able to take advantage of some of the application ’s features. For example, you won’t be able to receive our Newsletter or contact us directly from the application . Users who are uncertain about what information is mandatory are welcome to contact us via psikomorfosa@gmail.com.',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Nunito"
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      'Your rights:',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Nunito"
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                    'If you are a Indonesian resident, you have the following rights related to your personal data:\n\n'
                        '• The right to be informed.\n'
                        '• The right of access.\n'
                        '• The right to rectification.\n'
                        '• The right to erasure.\n'
                        '• The right to erasure.\n'
                        '• The right to data portability.\n'
                        '• The right to object.\n'
                        '• Rights in relation to automated decision-making and profiling.\n\n'
                        'If you would like to exercise this right, please contact us through the contact information below.\n\n'
                        'Additionally, if you are a Indonesian resident, we note that we are processing your information in order to fulfill contracts we might have with you (for example, if you make an order through the Site), or otherwise to pursue our legitimate business interests listed above. Additionally, please note that your information might be transferred outside of Europe, including Canada and the United States.',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Nunito"
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      'Links to other application:',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Nunito"
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      'Our application  may contain links to other application s that are not owned or controlled by us. Please be aware that we are not responsible for such other application s or third parties privacy practices. We encourage you to be aware when you leave our application  and read the privacy statements of each application  that may collect personal information.',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Nunito"
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      'Information security:',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Nunito"
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      'We secure information you provide on computer servers in a controlled, secure environment, protected from unauthorized access, use, or disclosure. We keep reasonable administrative, technical, and physical safeguards to protect against unauthorized access, use, modification, and personal data disclosure in its control and custody. However, no data transmission over the Internet or wireless network can be guaranteed.',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Nunito"
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      'Legal disclosure:',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Nunito"
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      'We will disclose any information we collect, use or receive if required or permitted by law, such as to comply with a subpoena or similar legal process, and when we believe in good faith that disclosure is necessary to protect our rights, protect your safety or the safety of others, investigate fraud, or respond to a government request.',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Nunito"
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      'Contact information:',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Nunito"
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      'If you would like to contact us to understand more about this Policy or wish to contact us concerning any matter relating to individual rights and your Personal Information, you may send an email to psikomorfosa@gmail.com.',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Nunito"
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              // Container(
              //   margin:  EdgeInsets.symmetric(horizontal: 0.035),
              //   child: Row(
              //     children: [
              //       Expanded(child:
              //       TermsButton(title: "Decline" , onTap: (){}
              //       ),
              //       ),
              //       SizedBox(
              //         width: size.width * 0.015,
              //       ),
              //       Expanded(child:
              //       TermsButton(title: "Accept", onTap: (){
              //         print("Click");
              //       }
              //       ),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
        ]
      ,
    )
    )
    );
  }
}

// class TermsButton extends StatelessWidget {
//   final String title;
//   final bool isAccepted;
//   final VoidCallback onTap;
//   const TermsButton({required this.title, required this.onTap, this.isAccepted = false});
//
//
// Widget build(BuildContext context) {
//   return GestureDetector(
//     child : InkWell(
//       onTap: () => onTap(),
//       splashColor: Colors.black.withOpacity(0.15),
//         child : Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(20),
//           clipBehavior: Clip.antiAliasWithSaveLayer,
//           decoration:  BoxDecoration(
//               border: Border.all(
//                 color: Colors.black,
//               ),
//               borderRadius: BorderRadius.circular(20),
//               color:  isAccepted  ? Color.fromRGBO(163, 144, 201, 1) : Colors.white
//           ),
//           child: Text("$title",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: "Nunito",
//                 fontWeight: FontWeight.bold,
//                 color: isAccepted ?  Colors.white : Color.fromRGBO(163, 144, 201, 1),
//               )),
//
//         )
//     ),
//
//
//
//   );
//
// }
// }
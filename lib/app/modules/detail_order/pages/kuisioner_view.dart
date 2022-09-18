import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/modules/detail_order/controllers/detail_order_controller.dart';
// import 'package:hallo_doctor_client/app/modules/profile/controllers/profile_controller.dart';
import 'package:hallo_doctor_client/app/modules/widgets/submit_button.dart';

class Kuisioner extends GetView<DetailOrderController> {
  final DetailOrderController formCerita = Get.put(DetailOrderController());
  final _formKey = GlobalKey<FormBuilderState>();

  Kuisioner({Key? key}) : super(key: key);

  Row addRadioButton(int btnIndex, String jenisKelamin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GetBuilder<DetailOrderController>(
          builder: (_) => Radio(
              value: formCerita.gender[btnIndex],
              groupValue: formCerita.select,
              onChanged: (value) => formCerita.jenisKelamin(jenisKelamin)),
        ),
        Text(jenisKelamin)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Update Coba'.tr,
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Ceritakan Tentang Dirimu'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(40, 40, 40, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // FormBuilderTextField(
                          //   // Handles Form Validation for First Name
                          //   validator: ((value) {
                          //     if (value!.length < 3) {
                          //       return 'Name must be more than two characters'.tr;
                          //     } else {
                          //       return null;
                          //     }
                          //   }),
                          //   decoration: InputDecoration(labelText: 'Jenis Kelamin'),
                          //   name: 'jenisKelamin',
                          //   // keyboardType: TextInputType.emailAddress,
                          // ),
                          // Row(
                          //   children: [
                          //     Text('Jenis Kelamin: '),
                          //     addRadioButton(0, "Pria"),
                          //     addRadioButton(1, "Wanita"),
                          //   ],
                          // ),
                          FormBuilderTextField(
                            // Handles Form Validation for First Name
                            validator: ((value) {
                              if (value!.length > 2) {
                                return 'Age must be no more than two characters'
                                    .tr;
                              } else {
                                return null;
                              }
                            }),
                            decoration: InputDecoration(labelText: 'Umur'),
                            name: 'umur',
                            // keyboardType: TextInputType.emailAddress,
                          ),
                          // FormBuilderTextField(
                          //   // Handles Form Validation for First Name
                          //   validator: ((value) {
                          //     if (value!.length < 3) {
                          //       return 'Name must be more than two characters'
                          //           .tr;
                          //     } else {
                          //       return null;
                          //     }
                          //   }),
                          //   decoration: InputDecoration(
                          //       labelText: 'Kapan Kejadian Tersebut Terjadi?'),
                          //   name: 'kejadian',
                          //   // keyboardType: TextInputType.emailAddress,
                          // ),
                          FormBuilderTextField(
                            // Handles Form Validation for First Name
                            validator: ((value) {
                              if (value!.length < 3) {
                                return 'Name must be more than two characters'
                                    .tr;
                              } else {
                                return null;
                              }
                            }),
                            decoration: InputDecoration(
                                labelText: 'Deskripsikan Masalah Anda'),
                            name: 'Kronologi',
                            // keyboardType: TextInputType.emailAddress,
                          ),
                          FormBuilderTextField(
                            // Handles Form Validation for First Name
                            validator: ((value) {
                              if (value!.length < 3) {
                                return 'Name must be more than two characters'
                                    .tr;
                              } else {
                                return null;
                              }
                            }),
                            decoration: InputDecoration(
                                labelText:
                                    'Apa Penyebab Masalah Itu?'),
                            name: 'dampak',
                            // keyboardType: TextInputType.emailAddress,
                          ),
                          FormBuilderTextField(
                            // Handles Form Validation for First Name
                            validator: ((value) {
                              if (value!.length < 3) {
                                return 'Name must be more than two characters'
                                    .tr;
                              } else {
                                return null;
                              }
                            }),
                            decoration: InputDecoration(
                                labelText:
                                    'Harapan Anda dari Konseling'),
                            name: 'Perubahan',
                            // keyboardType: TextInputType.emailAddress,
                          ),
                          // Padding(
                          //   padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                          //   child: Column(
                          //     children: [
                          //       Text('Kapan Kejadian Tersebut: '),
                          //       Obx(
                          //         () => DropdownButton<String>(
                          //           value: formCerita.valuekejadian.value,
                          //           items: <String>[
                          //             'Seminggu ini',
                          //             'Kurang dari 1 Bulan',
                          //             'Sebulan ini',
                          //             'Lebih dari 1 Bulan '
                          //           ].map<DropdownMenuItem<String>>(
                          //               (String value) {
                          //             return DropdownMenuItem<String>(
                          //               value: value,
                          //               child: Text(value),
                          //             );
                          //           }).toList(),
                          //           onChanged: (String? newValue) {
                          //             formCerita.kejadian(newValue!);
                          //           },
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // )
                        ])),
                Padding(
                  padding: EdgeInsets.only(top: 150, left: 20, right: 20),
                  child: submitButton(
                      onTap: () {
                        _formKey.currentState!.save();
                        if (_formKey.currentState!.validate()) {
                          formCerita.Kronologi(
                              _formKey.currentState!.value['Kronologi']);
                          formCerita.Perubahan(
                              _formKey.currentState!.value['Perubahan']);
                          // formCerita.kejadian(
                          //     _formKey.currentState!.value['kejadian']);
                          formCerita
                              .dampak(_formKey.currentState!.value['dampak']);
                          // formCerita.jenisKelamin(
                          //     _formKey.currentState!.value['jenisKelamin']);
                          formCerita.umur(_formKey.currentState!.value['umur']);
                          formCerita.goHome();
                          formCerita.updateCeritaClient();
                        } else {
                          print("validation failed");
                        }
                      },
                      text: 'Save'),
                )
              ],
            ),
          ),
        ])));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hallo_doctor_client/app/models/order_model.dart';
import 'package:hallo_doctor_client/app/models/time_slot_model.dart';
import 'package:hallo_doctor_client/app/service/user_service.dart';

class OrderService {
  Future<Order> getSuccessOrder(TimeSlot timeSlot) async {
    try {
      var orderSnapshot = await FirebaseFirestore.instance
          .collection('Order')
          .where('timeSlotId', isEqualTo: timeSlot.timeSlotId)
          .where('status', isEqualTo: 'payment_success')
          .limit(1)
          .get();
      var data = orderSnapshot.docs.elementAt(0).data();
      data['orderId'] = orderSnapshot.docs.elementAt(0).reference.id;
      Order order = Order.fromMap(data);
      return order;
    } on FirebaseException catch (e) {
      return Future.error(e.message!);
    }
  }

  Future<Order> getOrder(TimeSlot timeSlot) async {
    try {
      var orderData = await FirebaseFirestore.instance
          .collection('Order')
          .where('userId', isEqualTo: UserService().getUserId())
          .where('timeSlotId', isEqualTo: timeSlot.timeSlotId)
          .get();
      print('order length : ' + orderData.docs.length.toString());
      var data = orderData.docs.elementAt(0).data();
      data['orderId'] = orderData.docs.elementAt(0).reference.id;
      Order order = Order.fromMap(data);
      return order;
    } on Exception catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<Order> getToken(TimeSlot timeSlot) async {
    try {
      // var data;
      var tokenData = await FirebaseFirestore.instance
          .collection('Order')
          .where('userId', isEqualTo: UserService().getUserId())
          .where('timeSlotId', isEqualTo: timeSlot.timeSlotId)
          .get();
      print('order length : ' + tokenData.docs.length.toString());
      var data = tokenData.docs.elementAt(0).data();
      data['orderId'] = tokenData.docs.elementAt(0).reference.id;
      Order token = Order.fromMap(data);
      return token;
    } on Exception catch (e) {
      return Future.error(e.toString());
    }
  }

  // var data = doc.data();
  // data['timeSlotId'] = doc.reference.id;
  // TimeSlot timeSlot = TimeSlot.fromJson(data);
  // return timeSlot;

  // Future<Order> getToken(TimeSlot timeSlot) async {
  //   try {
  //     var orderData = await FirebaseFirestore.instance
  //         .collection('Order')
  //         .where('userId', isEqualTo: UserService().getUserId())
  //         .where('timeSlotId', isEqualTo: timeSlot.timeSlotId)
  //         .get();
  //     print('order length : ' + orderData.docs.length.toString());
  //     var data = orderData.docs.elementAt(0).data();
  //     data['orderId'] = orderData.docs.elementAt(0).reference.id;
  //     Order order = Order.fromMap(data);
  //     return order;
  //   } on Exception catch (e) {
  //     return Future.error(e.toString());
  //   }
  // }

  Future confirmOrder(TimeSlot timeSlot) async {
    try {
      var order = await getOrder(timeSlot);
      return setOrderToComplete(order);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> setOrderToComplete(Order order) async {
    await FirebaseFirestore.instance
        .collection("Order")
        .doc(order.orderId)
        .update({'status': 'success'});
  }
}

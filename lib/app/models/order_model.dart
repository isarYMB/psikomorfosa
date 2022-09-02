class Order {
  Order(
      {this.orderId,
      this.status,
      this.currency,
      this.amount,
      this.timeSlotId,
      this.transactionRedirectUrl});
  String? orderId;
  String? status;
  String? currency;
  int? amount;
  String? timeSlotId;
  String? transactionRedirectUrl;
  static const String _orderId = 'orderId';
  static const String _status = 'status';
  static const String _currency = 'currency';
  static const String _amount = 'amount';
  static const String _timeSlotId = 'timeSlotId';
  static const String _transactionRedirectUrl = 'transactionRedirectUrl';
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
        orderId: map[_orderId],
        status: map[_status],
        currency: map[_currency],
        amount: map[_amount],
        timeSlotId: map[_timeSlotId],
        transactionRedirectUrl: map[_transactionRedirectUrl]);
  }

  get value => null;
}

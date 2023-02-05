class Coupon {
  final String? coupon;
  final int? id;
  final bool? isUsed;
  Coupon({
    required this.coupon,
    required this.id,
    required this.isUsed,
  });

  factory Coupon.fromJSON({required Map data}) {
    return Coupon(
      id: data["id"],
      coupon: data["coupon"],
      isUsed: (data["isUsed"] == "false") ? false : true,
    );
  }
}

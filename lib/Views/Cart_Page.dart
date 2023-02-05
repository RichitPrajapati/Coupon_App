import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/Modals/Coupon.dart';
import 'package:shopping_app/Providers/Cart_Providers.dart';
import 'package:shopping_app/Views/SnackBar.dart';

import '../../helpers/db_helper.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Provider.of<AddToCartProvider>(context, listen: false).removeCoupon();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<AddToCartProvider>(context, listen: false).removeCoupon();
  }

  TextEditingController couponController = TextEditingController();
  String coupon = "";
  int? id;

  @override
  Widget build(BuildContext context) {
    var addToCartProvider = Provider.of<AddToCartProvider>(context).products;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Cart"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: addToCartProvider.length,
                itemBuilder: (context, i) {
                  return Container(
                    padding: const EdgeInsets.all(5),
                    margin:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    color: Colors.white.withOpacity(0.5),
                    height: 110,
                    child: Row(
                      children: [
                        Image.network(
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                          "${addToCartProvider[i].image}",
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${addToCartProvider[i].title}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${addToCartProvider[i].category}",
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Price : ${addToCartProvider[i].price} \$",
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      Provider.of<AddToCartProvider>(context,
                                          listen: false)
                                          .removeProduct(
                                          product: addToCartProvider[i]);
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: couponController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        hintText: "Enter Coupon Hear",
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      List<Coupon> coupons =
                      await DBHelper.dbHelper.fetchAllRecords();

                      coupons.forEach((e) {
                        if (e.coupon == couponController.text &&
                            e.isUsed == false) {
                          coupon = e.coupon!;
                          id = e.id!;
                        }
                      });

                      if (coupon != "") {
                        Provider.of<AddToCartProvider>(context, listen: false)
                            .applyCoupon();

                        snackBar(
                            context: context,
                            message: "Coupon Apply Successful",
                            color: Colors.green,
                            icon: Icons.verified);
                      } else {
                        snackBar(
                            context: context,
                            message: "Coupon Not Found",
                            color: Colors.red,
                            icon: Icons.dangerous_sharp);
                      }
                    },
                    child: const Text("Apply",
                        style: TextStyle(fontSize: 18,color: Colors.red)),
                  ),
                ],
              ),
            ),
            (Provider.of<AddToCartProvider>(context).couponApply)
                ? Text(
              "$coupon is Applied",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            )
                : Container(),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  "Total Quantity",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  "${Provider.of<AddToCartProvider>(context).totalQuantity}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  "Total Price",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  "${(Provider.of<AddToCartProvider>(context).couponApply) ? Provider.of<AddToCartProvider>(context).discountPrice : Provider.of<AddToCartProvider>(context).totalPrice} \$",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.all(12),
                    ),
                    onPressed: () async {
                      if (coupon != "") {
                        await DBHelper.dbHelper.updateRecord(id: id!);
                      }
                      snackBar(
                          context: context,
                          message: "Order Successful",
                          color: Colors.green,
                          icon: Icons.shopping_cart);
                      Provider.of<AddToCartProvider>(context, listen: false)
                          .emptyCart();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("/", (route) => false);
                    },
                    child:
                    const Text("Checkout",
                        style: TextStyle(fontSize: 17)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

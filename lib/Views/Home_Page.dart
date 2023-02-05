import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/Helpers/Product_Helper.dart';
import 'package:shopping_app/Providers/Cart_Providers.dart';
import 'package:shopping_app/Modals/Products.dart';
import 'package:shopping_app/Providers/Theame_Providers.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: const Text("Products"),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).changeTheme();
            },
            icon: const Icon(Icons.light_mode),
          ),
          Align(
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("cart_page");
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.black,
                  child: Text(
                      "${Provider.of<AddToCartProvider>(context).totalQuantity}"),
                )
              ],
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: FutureBuilder(
        future: ProductApiHelper.productApiHelper.getProducts(),
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            return Center(
              child: Text("${snapShot.error}"),
            );
          } else if (snapShot.hasData) {
            List<Product>? data = snapShot.data;
            return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, i) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  color: Colors.white.withOpacity(0.4),
                  height: 110,
                  child: Row(
                    children: [
                      Image.network(
                        height: 90,
                        width: 90,
                        fit: BoxFit.fill,
                        "${data[i].image}",
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${data[i].title}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${data[i].category}",
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Price : ${data[i].price} \$",
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    Provider.of<AddToCartProvider>(context,
                                        listen: false)
                                        .addProduct(product: data[i]);
                                  },
                                  icon: const Icon(Icons.add),
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
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/Helpers/DB_Helper.dart';
import 'package:shopping_app/Providers/Cart_Providers.dart';
import 'package:shopping_app/Providers/Theame_Providers.dart';
import 'package:shopping_app/Views/Cart_Page.dart';
import 'package:shopping_app/Views/Home_Page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.dbHelper.insertRecord();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AddToCartProvider()),
      ],
      builder: (context, _) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: (Provider.of<ThemeProvider>(context).isDark)
              ? ThemeMode.dark
              : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          routes: {
            "/": (context) => const HomePage(),
            "cart_page": (context) => const CartPage(),
          },
        );
      },
    ),
  );
}
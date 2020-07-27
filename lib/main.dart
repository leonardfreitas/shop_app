import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/views/product_form_screen.dart';

import './utils/apps_routes.dart';

import './providers/cart.dart';
import './providers/products.dart';
import './providers/orders.dart';

import './views/auth_screen.dart';
import './views/products_overview_screen.dart';
import './views/cart_screen.dart';
import './views/product_detail_screen.dart';
import './views/orders_screen.dart';
import './views/products_screen.dart';
import './views/product_form_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Orders(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
          textTheme: TextTheme(headline1: TextStyle(color: Colors.red)),
        ),
        // home: ProductOverViewScreen(),
        routes: {
          AppRoutes.AUTH: (ctx) => AuthScreen(),
          AppRoutes.HOME: (ctx) => ProductOverViewScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrdersScreen(),
          AppRoutes.PRODUCTS: (ctx) => ProductsScreen(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormScreen(),
        },
      ),
    );
  }
}

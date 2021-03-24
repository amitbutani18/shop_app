import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';

import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';
import 'package:shop_app/theme/app_theme.dart';
//amit change
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
//          ChangeNotifierProvider<ProductsProvider>.value(
//          value: ProductsProvider(),
//          ),
          ChangeNotifierProxyProvider<Auth, ProductsProvider>(
            update: (ctx, auth, previousProducts) => ProductsProvider(
                auth.token,
                previousProducts == null ? [] : previousProducts.items,
                auth.userId),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) => Orders(
                auth.token,
                previousOrders == null ? [] : previousOrders.orders,
                auth.userId),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Flutter Demo',
            theme: AppTheme.lightTheme.copyWith(primaryColor: Colors.purple),
            darkTheme: AppTheme.darkTheme.copyWith(primaryColor: Colors.blue),
//      theme: ThemeData.dark().copyWith(
//
//        primaryColor: Colors.black,
//        accentColor: Colors.white,
//        fontFamily: 'Lato',
//        visualDensity: VisualDensity.adaptivePlatformDensity,
//      ),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryToLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
//          '/': (context) => ProductOverviewScreen(),
              ProductDetailsScreen.routeName: (context) =>
                  ProductDetailsScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrderScreen.routeName: (context) => OrderScreen(),
              UserProductScreen.routeName: (context) => UserProductScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen(),
            },
          ),
        ));
  }
}

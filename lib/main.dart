// @dart=2.9

import 'package:app_tcc/models/contact.dart';
import 'package:app_tcc/models/contact_manager.dart';
import 'package:app_tcc/models/finances_manager.dart';
import 'package:app_tcc/models/order.dart';
import 'package:app_tcc/models/order_manager.dart';
import 'package:app_tcc/models/order_product_manager.dart';
import 'package:app_tcc/screens/checkout/checkout_screen.dart';
import 'package:app_tcc/screens/contact/contact_screen.dart';
import 'package:app_tcc/screens/edit_contact/edit_contact_screen.dart';
import 'package:app_tcc/screens/edit_product/edit_product_screen.dart';
import 'package:app_tcc/screens/finance/finance_screen.dart';
import 'package:app_tcc/screens/new_order/cart/cart_screen.dart';
import 'package:app_tcc/screens/order/orders_screen.dart';
import 'package:app_tcc/screens/product/product_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app_tcc/models/user_manager.dart';
import 'package:app_tcc/models/product_manager.dart';
import 'package:app_tcc/models/product.dart';
import 'package:app_tcc/screens/base_screen.dart';
import 'package:app_tcc/screens/login/login_screen.dart';
import 'package:app_tcc/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ContactManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        /*ChangeNotifierProxyProvider<ContactManager, OrderProductManager>(
          create: (_) => OrderProductManager(),
          lazy: false,
          update: (_, contactManager, cartManager) =>
              cartManager..updateContact(contactManager),
        ),*/
        ChangeNotifierProvider(
          create: (_) => OrderProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => OrderManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => Order(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => FinancesManager(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'Donanja Gestão de Vendas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 60, 120, 161),
          scaffoldBackgroundColor: Color.fromARGB(255, 60, 120, 161),
          appBarTheme: const AppBarTheme(
            elevation: 0,
          ),
        ),
        onGenerateRoute: (settings) {
          print(settings.name);
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(
                builder: (_) => LoginScreen(),
              );
            case '/signup':
              return MaterialPageRoute(
                builder: (_) => SignUpScreen(),
              );
            case '/contact':
              return MaterialPageRoute(
                builder: (_) => ContactScreen(settings.arguments as Contact),
              );
            case '/edit_contact':
              return MaterialPageRoute(
                builder: (_) => EditContactScreen(settings.arguments as Contact),
              );
            case '/product':
              return MaterialPageRoute(
                builder: (_) => ProductScreen(settings.arguments as Product),
              );
            case '/edit_product':
              return MaterialPageRoute(
                builder: (_) => EditProductScreen(settings.arguments as Product),
              );
            case '/orders':
              return MaterialPageRoute(
                builder: (_) => OrdersScreen(),
                settings: settings,
              );
            /*case '/order':
              return MaterialPageRoute(
                builder: (_) => OrderScreen(settings.arguments as OrderProduct),
              );*/
            case '/new_order':
              return MaterialPageRoute(builder: (_) => CartScreen(), settings: settings);
            case '/checkout':
              return MaterialPageRoute(builder: (_) => CheckoutScreen());
            case '/finances':
              return MaterialPageRoute(builder: (_) => FinanceScreen());
            case '/':
            default:
              return MaterialPageRoute(
                builder: (_) => BaseScreen(),
              );
          }
        },
      ),
    );
  }
}

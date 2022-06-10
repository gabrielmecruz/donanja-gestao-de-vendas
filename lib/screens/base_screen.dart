import 'package:app_tcc/models/user_manager.dart';
import 'package:app_tcc/screens/customers/contacts_screen.dart';
import 'package:app_tcc/screens/finance/finance_screen.dart';
import 'package:app_tcc/screens/home/home_screen.dart';
import 'package:app_tcc/screens/login/login_screen.dart';
import 'package:app_tcc/screens/order/orders_screen.dart';
import 'package:app_tcc/screens/stock/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_tcc/models/page_manager.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(builder: (_, userManager, __) {
      return !userManager.isLoggedIn
          ? userManager.initLoading
              ? Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: Image.asset('assets/image_login.png'),
                        ),
                        SizedBox(height: 20),
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              : LoginScreen()
          : Provider(
              create: (_) => PageManager(pageController),
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  HomeScreen(),
                  ContactsScreen(),
                  ProductsScreen(),
                  OrdersScreen(),
                  FinanceScreen(),
                ],
              ),
            );
    });
  }
}

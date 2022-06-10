import 'package:flutter/material.dart';
import 'package:app_tcc/models/user_manager.dart';
import 'package:provider/provider.dart';

class CustomDrawerFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 32, 8, 0),
      child: Consumer<UserManager>(
        builder: (_, userManager, __) {
          return userManager.isLoggedIn
              ? Container(
                  child: GestureDetector(
                    onTap: () {
                      if (userManager.isLoggedIn) {
                        userManager.signOut();
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (_) => false);
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Sair',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(
                                Icons.exit_to_app,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Text('Nothing');
        },
      ),
    );
  }
}

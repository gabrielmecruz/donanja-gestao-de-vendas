import 'package:app_tcc/commom/custom_drawer/custom_drawer_footer.dart';
import 'package:flutter/material.dart';
import 'package:app_tcc/models/user_manager.dart';
import 'package:provider/provider.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 16, 0),
      height: 140,
      child: Consumer<UserManager>(
        builder: (_, userManager, __) {
          return userManager.isLoggedIn
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${userManager.user?.name ?? ''}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${userManager.user?.email ?? ''}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    CustomDrawerFooter(),
                  ],
                )
              : Text('Nothing');
        },
      ),
    );
  }
}

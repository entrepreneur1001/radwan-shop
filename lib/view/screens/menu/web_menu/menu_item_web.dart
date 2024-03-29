
import 'package:flutter/material.dart';
import '../../../../helper/route_helper.dart';
import '../../../../localization/language_constraints.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/profile_provider.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/styles.dart';
import 'menu_screen_web.dart';
import '../widget/sign_out_confirmation_dialog.dart';
import 'package:provider/provider.dart';

class MenuItemWeb extends StatelessWidget {
  final MenuModel menu;
  const MenuItemWeb({Key? key, required this.menu}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    bool isLogin = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return InkWell(
      borderRadius: BorderRadius.circular(32.0),
      onTap: () {
        if(menu.route == 'version') {

        }else if (menu.title == getTranslated('profile', context)){
          if(isLogin){
            Navigator.pushNamed(context, RouteHelper.getProfileEditRoute(Provider.of<ProfileProvider>(context, listen: false).userInfoModel));
          }else {
            Navigator.pushNamed(context, RouteHelper.getLoginRoute());
          }
        }else if(menu.route == 'auth'){
          isLogin ? showDialog(
            context: context, barrierDismissible: false, builder: (context) => const SignOutConfirmationDialog(),
          ) : Navigator.pushNamed(context, RouteHelper.getLoginRoute());
        }else{
          Navigator.pushNamed(context, menu.route!);
        }
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.04), borderRadius: BorderRadius.circular(32.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            menu.iconWidget != null ? menu.iconWidget!
                : Image.asset(menu.icon, width: 50, height: 50, color: Theme.of(context).textTheme.bodyLarge!.color),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Text(menu.title!, style: poppinsRegular),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../helper/responsive_helper.dart';
import '../../../helper/route_helper.dart';
import '../../../localization/language_constraints.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/cart_provider.dart';
import '../../../provider/location_provider.dart';
import '../../../provider/profile_provider.dart';
import '../../../provider/splash_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../../../utill/styles.dart';
import '../../base/web_app_bar/web_app_bar.dart';
import 'main_screen.dart';
import 'web_menu/menu_screen_web.dart';
import 'widget/custom_drawer.dart';
import 'widget/sign_out_confirmation_dialog.dart';
import '../notification/notification_screen.dart';
import '../profile/profile_screen.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);


  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final CustomDrawerController _drawerController = CustomDrawerController();

  @override
  void initState() {
    super.initState();
    final bool isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo();
      Provider.of<LocationProvider>(context, listen: false).initAddressList();

    } else{
      Provider.of<CartProvider>(context, listen: false).getCartData();
    }
  }

  @override
  Widget build(BuildContext context) {
   return CustomDrawer(
      controller: _drawerController,
      menuScreen: MenuWidget(drawerController: _drawerController),
      mainScreen: MainScreen(drawerController: _drawerController),
      showShadow: false,
      angle: 0.0,
      borderRadius: 30,
      slideWidth: MediaQuery.of(context).size.width * (CustomDrawer.isRTL(context) ? 0.45 : 0.70),
    );
  }
}

class MenuWidget extends StatelessWidget {
  final CustomDrawerController? drawerController;

  const MenuWidget({Key? key,  this.drawerController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();



    return WillPopScope(
      onWillPop: () async {
        if (drawerController!.isOpen()) {
          drawerController!.toggle();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor:  Provider.of<ThemeProvider>(context).darkTheme || ResponsiveHelper.isDesktop(context)
          ? Theme.of(context).hintColor.withOpacity(0.1) : Theme.of(context).primaryColor,


        appBar: ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBar()) : null,
        body: SafeArea(
          child: ResponsiveHelper.isDesktop(context)? MenuScreenWeb(isLoggedIn: isLoggedIn) : SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: 1170,
                child: Consumer<SplashProvider>(
                  builder: (context, splash, child) {
                    return Column(
                        children: [
                     !ResponsiveHelper.isDesktop(context) ? Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(Icons.close,
                              color: Provider.of<ThemeProvider>(context).darkTheme
                              ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)
                              : ResponsiveHelper.isDesktop(context)? Theme.of(context).canvasColor: Theme.of(context).canvasColor),
                          onPressed: () => drawerController!.toggle(),
                        ),
                      ):const SizedBox(),
                      Consumer<ProfileProvider>(
                        builder: (context, profileProvider, child) => Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).pushNamed(RouteHelper.profile, arguments: const ProfileScreen());
                                },
                                leading: ClipOval(
                                  child: isLoggedIn ?Provider.of<SplashProvider>(context, listen: false).baseUrls != null ?
                                  Builder(
                                    builder: (context) {
                                      return FadeInImage.assetNetwork(
                                        placeholder: Images.placeholder(context),
                                        image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/'
                                            '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.image : ''}',
                                        height: 50, width: 50, fit: BoxFit.cover,
                                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), height: 50, width: 50, fit: BoxFit.cover),
                                      );
                                    }
                                  ) : const SizedBox() : Image.asset(Images.placeholder(context), height: 50, width: 50, fit: BoxFit.cover),
                                ),
                                title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                  isLoggedIn ? profileProvider.userInfoModel != null ? Text(
                                    '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}',
                                    style: poppinsRegular.copyWith(color: Provider.of<ThemeProvider>(context).darkTheme
                                        ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)
                                        : ResponsiveHelper.isDesktop(context)? ColorResources.getDarkColor(context): Theme.of(context).canvasColor,),
                                  ) : Container(height: 10, width: 150, color: ResponsiveHelper.isDesktop(context)? ColorResources.getDarkColor(context): Theme.of(context).canvasColor) : Text(
                                    getTranslated('guest', context)!,
                                    style: poppinsRegular.copyWith( color: Provider.of<ThemeProvider>(context).darkTheme
                                        ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)
                                        : ResponsiveHelper.isDesktop(context)? ColorResources.getDarkColor(context): Theme.of(context).canvasColor,),
                                  ),
                                  if(isLoggedIn) const SizedBox(height: Dimensions.paddingSizeSmall),

                                  if(isLoggedIn && profileProvider.userInfoModel != null ) Text(
                                    profileProvider.userInfoModel!.phone ?? '',
                                    style: poppinsRegular.copyWith(color: Provider.of<ThemeProvider>(context).darkTheme
                                        ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)
                                        : ResponsiveHelper.isDesktop(context)? ColorResources.getDarkColor(context): Theme.of(context).canvasColor,)
                                  ),
                                ]),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.notifications,
                                  color: Provider.of<ThemeProvider>(context).darkTheme
                                      ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)
                                      : ResponsiveHelper.isDesktop(context)? ColorResources.getDarkColor(context):  Theme.of(context).canvasColor),
                              onPressed: () {
                                Navigator.pushNamed(context, RouteHelper.notification, arguments: const NotificationScreen());
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),

                    if(!ResponsiveHelper.isDesktop(context))
                      Column(children: screenList.map((model) => ListTile(
                          onTap: (){
                            if(!ResponsiveHelper.isDesktop(context)) {
                              splash.setPageIndex(screenList.indexOf(model));
                            }
                            drawerController!.toggle();
                        },
                        selected: splash.pageIndex == screenList.indexOf(model),
                        selectedTileColor: Colors.black.withAlpha(30),
                        leading: Image.asset(
                          model.icon, color: ResponsiveHelper.isDesktop(context)
                            ? ColorResources.getDarkColor(context) : Colors.white,
                          width: 25, height: 25,
                        ),
                        title: Text(getTranslated(model.title, context)!, style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Provider.of<ThemeProvider>(context).darkTheme
                              ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)
                              : ResponsiveHelper.isDesktop(context)? ColorResources.getDarkColor(context): Theme.of(context).canvasColor,
                        )),
                      )).toList()),


                      ListTile(
                        onTap: () {
                          if(isLoggedIn) {
                            showDialog(context: context, barrierDismissible: false, builder: (context) => const SignOutConfirmationDialog());
                          }else {
                            Provider.of<SplashProvider>(context, listen: false).setPageIndex(0);
                            Navigator.pushNamedAndRemoveUntil(context, RouteHelper.getLoginRoute(), (route) => false);
                          }
                        },
                        leading: Image.asset(isLoggedIn ? Images.logOut : Images.appLogo,
                            color: ResponsiveHelper.isDesktop(context)? ColorResources.getDarkColor(context):  Colors.white,
                          width: 25, height: 25,
                        ),
                        title: Text(
                          getTranslated(isLoggedIn ? 'log_out' : 'login', context)!,
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Provider.of<ThemeProvider>(context).darkTheme
                                ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)
                                : ResponsiveHelper.isDesktop(context)
                                ? ColorResources.getDarkColor(context)
                                : Theme.of(context).canvasColor,
                          ),
                        ),
                      ),
                    ]);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class MenuButton {
  final String routeName;
  final String icon;
  final String title;
  final IconData? iconData;
  MenuButton({required this.routeName, required this.icon, required this.title, this.iconData});
}
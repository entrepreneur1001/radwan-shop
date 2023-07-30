
import 'package:flutter/material.dart';
import '../../../helper/responsive_helper.dart';
import '../../../localization/app_localization.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/order_provider.dart';
import '../../../utill/dimensions.dart';
import '../../base/app_bar_base.dart';
import '../../base/custom_loader.dart';
import '../../base/not_login_screen.dart';
import '../../base/web_app_bar/web_app_bar.dart';
import 'widget/order_button.dart';
import 'widget/order_view.dart';
import 'package:provider/provider.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final bool isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(isLoggedIn) {
      Provider.of<OrderProvider>(context, listen: false).getOrderList(context);
    }
    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone()
          ? null: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBar())
          : const AppBarBase()) as PreferredSizeWidget?,

      body: SafeArea(
        child: isLoggedIn ? Scrollbar(
          child: Center(
            child: Consumer<OrderProvider>(
              builder: (context, orderProvider, child)
              => orderProvider.runningOrderList != null ? Column(
                children: [
                  SizedBox(
                    width: 1170,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OrderButton(title: 'active'.tr, isActive: true),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          OrderButton(title: 'past_order'.tr, isActive: false),
                        ],
                      ),
                    ),
                  ),

                  Expanded(child: OrderView(isRunning: orderProvider.isActiveOrder ? true : false))
                ],
              ) : Center(child: CustomLoader(color: Theme.of(context).primaryColor)),
            ),
          ),
        ) : const NotLoggedInScreen(),
      ),
    );
  }
}
// Provider.of<OrderProvider>(context, listen: false).runningOrderList != null ? ResponsiveHelper.isDesktop(context) ? FooterView() : SizedBox() : SizedBox(),





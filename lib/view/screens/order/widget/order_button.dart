import 'package:flutter/material.dart';
import '../../../../provider/order_provider.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/styles.dart';
import '../../../base/custom_directionality.dart';
import 'package:provider/provider.dart';

class OrderButton extends StatelessWidget {
  final String? title;
  final bool isActive;
  const OrderButton({Key? key, required this.isActive, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<OrderProvider>(builder: (context, orderProvider, child) {
        return InkWell(
          onTap: () {
            orderProvider.changeActiveOrderStatus(isActive);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 11),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: orderProvider.isActiveOrder == isActive ? Theme.of(context).primaryColor : ColorResources.getGreyColor(context),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$title',
                  style: poppinsRegular.copyWith(color: orderProvider.isActiveOrder == isActive
                      ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyLarge!.color),
                ),

                CustomDirectionality(
                  child: Text(
                    '(${isActive ? orderProvider.runningOrderList!.length : orderProvider.historyOrderList!.length})',
                    style: poppinsRegular.copyWith(color: orderProvider.isActiveOrder == isActive
                        ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../helper/price_converter.dart';
import '../../../../localization/language_constraints.dart';
import '../../../../provider/order_provider.dart';
import '../../../../provider/splash_provider.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/styles.dart';
import '../../../base/custom_directionality.dart';
import 'package:provider/provider.dart';

class DeliveryOptionButton extends StatelessWidget {
  final String value;
  final String? title;
  final bool kmWiseFee;
  final bool freeDelivery;
  const DeliveryOptionButton({Key? key, required this.value, required this.title, required this.kmWiseFee, this.freeDelivery = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        return InkWell(
          onTap: () => order.setOrderType(value),
          child: Row(
            children: [
              Radio(
                value: value,
                groupValue: order.orderType,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (String? value) => order.setOrderType(value),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Text(title!, style: poppinsRegular),
              const SizedBox(width: 5),

              freeDelivery ? CustomDirectionality(child: Text('(${getTranslated('free', context)})', style: poppinsMedium))
                  :  kmWiseFee  ? const SizedBox() : Text('(${value == 'delivery' && !freeDelivery
                  ? PriceConverter.convertPrice(context, Provider.of<SplashProvider>(context, listen: false).configModel!.deliveryCharge)
                  : getTranslated('free', context)})', style: poppinsMedium,
              ),

            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../../data/model/response/order_details_model.dart';
import '../../../data/model/response/order_model.dart';
import '../../../helper/responsive_helper.dart';
import '../../../localization/language_constraints.dart';
import '../../../provider/order_provider.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/styles.dart';
import '../../base/custom_app_bar.dart';
import 'widget/deliver_man_review_widget.dart';
import 'widget/product_review_widget.dart';
import 'package:provider/provider.dart';
import '../../base/web_app_bar/web_app_bar.dart';

class RateReviewScreen extends StatefulWidget {
  final List<OrderDetailsModel> orderDetailsList;
  final DeliveryMan? deliveryMan;
  const RateReviewScreen(
      {Key? key, required this.orderDetailsList, required this.deliveryMan})
      : super(key: key);

  @override
  State<RateReviewScreen> createState() => _RateReviewScreenState();
}

class _RateReviewScreenState extends State<RateReviewScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: widget.deliveryMan == null ? 1 : 2,
        initialIndex: 0,
        vsync: this);
    Provider.of<OrderProvider>(context, listen: false)
        .initRatingData(widget.orderDetailsList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(120), child: WebAppBar())
              : CustomAppBar(title: getTranslated('rate_review', context)))
          as PreferredSizeWidget?,
      body: Column(children: [
        Container(
          color: Theme.of(context).cardColor,
          child: TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).textTheme.bodyLarge!.color,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 3,
            unselectedLabelStyle: poppinsRegular.copyWith(
                color: Theme.of(context).hintColor.withOpacity(0.6),
                fontSize: Dimensions.fontSizeSmall),
            labelStyle:
                poppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
            tabs: widget.deliveryMan != null
                ? [
                    Tab(
                        text: getTranslated(
                            widget.orderDetailsList.length > 1
                                ? 'items'
                                : 'item',
                            context)),
                    Tab(text: getTranslated('delivery_man', context)),
                  ]
                : [
                    Tab(
                        text: getTranslated(
                            widget.orderDetailsList.length > 1
                                ? 'items'
                                : 'item',
                            context)),
                  ],
          ),
        ),
        Expanded(
            child: TabBarView(
          controller: _tabController,
          children: widget.deliveryMan != null
              ? [
                  ProductReviewWidget(
                      orderDetailsList: widget.orderDetailsList),
                  DeliveryManReviewWidget(
                      deliveryMan: widget.deliveryMan,
                      orderID: widget.orderDetailsList[0].orderId.toString()),
                ]
              : [
                  ProductReviewWidget(
                      orderDetailsList: widget.orderDetailsList),
                ],
        )),
      ]),
    );
  }
}

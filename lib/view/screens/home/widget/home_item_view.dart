import 'package:flutter/material.dart';
import '../../../../data/model/response/product_model.dart';
import '../../../../helper/product_type.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../provider/flash_deal_provider.dart';
import '../../../../provider/product_provider.dart';
import '../../../../utill/dimensions.dart';
import '../../../base/product_widget.dart';
import '../../../base/web_product_shimmer.dart';
import 'package:provider/provider.dart';

class HomeItemView extends StatelessWidget {
  final List<Product>? productList;

  const HomeItemView({Key? key, this.productList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<FlashDealProvider>(builder: (context, flashDealProvider, child) {
        return Consumer<ProductProvider>(builder: (context, productProvider, child) {

          return productList != null ? Column(children: [

            ResponsiveHelper.isDesktop(context) ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio:  (1 / 1.1),
                crossAxisCount: 5,
                mainAxisSpacing: 13,
                crossAxisSpacing: 13,
              ),
              itemCount: productList!.length >= 10 ? 10 : productList!.length,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall,
                vertical: Dimensions.paddingSizeLarge,
              ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context,index){
                return ProductWidget(
                  isGrid: true,
                  product: productList![index],
                  productType: ProductType.dailyItem,
                );
                },
            ) :
            SizedBox(
              height: 290,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                itemCount: productList!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: 195,
                    padding: const EdgeInsets.all(5),
                    child: ProductWidget(
                      isGrid: true,
                      product: productList![index],
                      productType: ProductType.dailyItem,
                    ),
                  );
                  },
              ),
            ),

          ]) : ResponsiveHelper.isDesktop(context) ?
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio:  (1 / 1.3),
              crossAxisCount: 5,
              mainAxisSpacing: 13,
              crossAxisSpacing: 13,
            ),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) => const WebProductShimmer(isEnabled: true),
          ) :
          SizedBox(
            height: 250,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 195,
                  padding: const EdgeInsets.all(5),
                  child: const WebProductShimmer(isEnabled: true),
                );
              },
            ),
          );
        });
      }
    );
  }
}




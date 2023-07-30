import 'package:flutter/material.dart';
import '../../../../data/model/response/language_model.dart';
import '../../../../helper/product_type.dart';
import '../../../../localization/app_localization.dart';
import '../../../../provider/category_provider.dart';
import '../../../../provider/language_provider.dart';
import '../../../../provider/product_provider.dart';
import '../../../../utill/app_constants.dart';
import '../../text_hover.dart';
import 'package:provider/provider.dart';

import '../../../../../provider/localization_provider.dart';
import '../../../../../utill/color_resources.dart';
import '../../../../../utill/dimensions.dart';
import '../../custom_snackbar.dart';

class LanguageHoverWidget extends StatefulWidget {
  final List<LanguageModel> languageList;
  const LanguageHoverWidget({Key? key, required this.languageList}) : super(key: key);

  @override
  State<LanguageHoverWidget> createState() => _LanguageHoverWidgetState();
}

class _LanguageHoverWidgetState extends State<LanguageHoverWidget> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
          child: Column(
              children: widget.languageList.map((language) => InkWell(
                onTap: () async {
                  if(languageProvider.languages.isNotEmpty && languageProvider.selectIndex != -1) {
                    Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
                        language.languageCode!, language.countryCode
                    ));
                    Provider.of<ProductProvider>(context, listen: false).getItemList(
                      '1', true, AppConstants.languages[languageProvider.selectIndex].languageCode,
                      ProductType.popularProduct,
                    );
                    Provider.of<ProductProvider>(context, listen: false).getLatestProductList( '1', true);
                    Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
                      context,  AppConstants.languages[languageProvider.selectIndex].languageCode,true
                    );
                  }else {
                    showCustomSnackBar('select_a_language'.tr);
                  }

                },
                child: TextHover(
                    builder: (isHover) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(color: isHover ? ColorResources.getGreyColor(context) : Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(language.languageName!, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: Dimensions.fontSizeSmall),),
                          ],
                        ),
                      );
                    }
                ),
              )).toList()
            // [
            //   Text(_categoryList[5].name),
            // ],
          ),
        );
      }
    );
  }
}
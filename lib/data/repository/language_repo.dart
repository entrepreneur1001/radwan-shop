import 'package:flutter/material.dart';
import '../model/response/language_model.dart';
import '../../utill/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstants.languages;
  }
}

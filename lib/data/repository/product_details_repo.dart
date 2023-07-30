import 'dart:io';

import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/body/review_body.dart';
import '../model/response/base/api_response.dart';
import '../../utill/app_constants.dart';
import 'package:http/http.dart' as http;

class ProductDetailsRepo {
  final DioClient? dioClient;

  ProductDetailsRepo({required this.dioClient});

  Future<ApiResponse> getProduct(String productID) async {
    try {
      final response = await dioClient!.get(AppConstants.productDetailsUri + productID);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> submitReview(ReviewBody reviewBody, File file, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.submitReviewUri}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    request.files.add(http.MultipartFile('fileUpload[0]', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
    request.fields.addAll(<String, String>{'product_id': reviewBody.productId!, 'comment': reviewBody.comment!, 'rating': reviewBody.rating!});
    http.StreamedResponse response = await request.send();
    return response;
  }
}

import 'package:flutter/material.dart';
import '../data/model/response/base/api_response.dart';
import '../data/model/response/product_model.dart';
import '../data/repository/search_repo.dart';
import '../helper/api_checker.dart';
import 'localization_provider.dart';
import 'package:provider/provider.dart';

class SearchProvider with ChangeNotifier {
  final SearchRepo? searchRepo;

  SearchProvider({required this.searchRepo});

  int _filterIndex = 0;
  double _lowerValue = 0;
  double _upperValue = 0;
  List<String?> _historyList = [];

  int get filterIndex => _filterIndex;
  double get lowerValue => _lowerValue;
  double get upperValue => _upperValue;

  List<Product>? _searchProductList;
  List<Product>? _filterProductList;
  bool _isClear = true;
  String _searchText = '';
  bool _isSearch = true;

  List<Product>? get searchProductList => _searchProductList;

  List<Product>? get filterProductList => _filterProductList;

  bool get isClear => _isClear;
  bool get isSearch => _isSearch;

  String get searchText => _searchText;
  List<String?> get historyList => _historyList;

  final List<Product> _categoryProductList = [];
  List<Product> get categoryProductList => _categoryProductList;


  List<String?> _allSortBy = [];

  List<String?> get allSortBy => _allSortBy;
  TextEditingController _searchController = TextEditingController();
  TextEditingController  get searchController=> _searchController;
  int _searchLength = 0;
  int get searchLength => _searchLength;

  searchDone(){
    _isSearch = !_isSearch;
    notifyListeners();
  }

  getSearchText(String searchText){
    _searchController = TextEditingController(text: searchText);
    _searchLength = searchText.length;
    notifyListeners();
  }

  void setFilterIndex(int index) {
    _filterIndex = index;
    notifyListeners();
  }

  initializeAllSortBy({bool notify = true}) {
    if (_allSortBy.isEmpty) {
      _allSortBy = [];
      _allSortBy = searchRepo!.getAllSortByList();
    }
    _filterIndex = -1;
    if(notify) {
      notifyListeners();
    }
  }

  void setLowerAndUpperValue(double lower, double upper) {
    _lowerValue = lower;
    _upperValue = upper;
    notifyListeners();
  }

  void setSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }

  void cleanSearchProduct() {
    _searchProductList = [];
    _isClear = true;
    _searchText = '';
    notifyListeners();
  }

  void searchProduct(String query, BuildContext context, {bool isUpdate = true}) async {
    _searchText = query;
    _isClear = false;
    _searchProductList = null;
    _filterProductList = null;
    _upperValue = 0;
    _lowerValue = 0;
    if(isUpdate){
      notifyListeners();
    }

    ApiResponse apiResponse = await searchRepo!.getSearchProductList(
      query, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
    );
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if (query.isEmpty) {
        _searchProductList = [];
      } else {
        _searchProductList = [];
        _searchProductList!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        _filterProductList = [];
        _filterProductList!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    notifyListeners();
  }



  void sortSearchList() {
    _searchProductList= [];
    _searchProductList!.addAll(_filterProductList!);
    if(upperValue > 0 ) {
      _searchProductList!.removeWhere((product) =>
      product.price! <= _lowerValue || product.price! >= _upperValue);
    }

    if (_filterIndex == 0) {
      _searchProductList!.sort((product1, product2) => product1.price!.compareTo(product2.price!));
    } else if (_filterIndex == 1) {
      _searchProductList!.sort((product1, product2) => product1.price!.compareTo(product2.price!));
      Iterable iterable = _searchProductList!.reversed;
      _searchProductList = iterable.toList() as List<Product>?;
      } else if (_filterIndex == 2) {
      _searchProductList!.sort((product1, product2) => product1.name!.toLowerCase().compareTo(product2.name!.toLowerCase()));
    } else if (_filterIndex == 3) {
      _searchProductList!.sort((product1, product2) => product1.name!.toLowerCase().compareTo(product2.name!.toLowerCase()));
      Iterable iterable = _searchProductList!.reversed;
      _searchProductList = iterable.toList() as List<Product>?;
    }
    notifyListeners();
  }


  void initHistoryList() {
    _historyList = [];
    _historyList.addAll(searchRepo!.getSearchAddress());
  }

  void saveSearchAddress(String? searchAddress,{bool isUpdate = true}) async {
    if (!_historyList.contains(searchAddress)) {
      _historyList.add(searchAddress);
      searchRepo!.saveSearchAddress(searchAddress);
     if(isUpdate){
       notifyListeners();
     }
    }
  }

  void clearSearchAddress() async {
    searchRepo!.clearSearchAddress();
    _historyList = [];
    notifyListeners();
  }
}

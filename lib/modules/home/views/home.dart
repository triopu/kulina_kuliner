import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'package:kulinakuliner/modules/home/components/cart_dialog.dart';
import 'package:kulinakuliner/modules/home/models/product.dart';
import 'package:kulinakuliner/modules/home/components/item.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:flutter/widgets.dart';
import 'package:kulinakuliner/utils/local_storage_service.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatePickerController _controller = DatePickerController();
  DateTime _selectedValue = DateTime.now();
  DateTime _slideDate = DateTime.now();
  List<DateTime> days = [];
  String _selectedDay = '';
  bool isLoading = true;
  List<ProductData> _products = [];
  List<ProductData> _cart = [];
  int _page = 0;

  int _numberProduct = 0;
  int _totalPrice = 0;
  double _padding = 0.0;

  DbHelper dbHelper = DbHelper();

  _getDate() {
    initializeDateFormatting();
    final DateTime now = _selectedValue;
    final DateFormat formatter = DateFormat.yMMMMEEEEd("id_ID");
    final String formatted = formatter.format(now.toLocal());
    setState(() {
      _selectedDay = formatted;
      _getDatabase();
    });
  }

  _loadProducts() async {
    setState(() {
      EasyLoading.show();
      isLoading = true;
      _page += 1;
    });

    final response = await http
        .get('https://kulina-recruitment.herokuapp.com/products?_page=$_page');
    if (response.statusCode == 200) {
      var productsResponse = json.decode(response.body);
      var items = productsResponse as List;
      if (items.length > 0) {
        for (var i = 0; i < items.length; i++) {
          ProductData prod = ProductData.fromJson(items[i]);
          _products.add(prod);
        }
      }
      _getDatabase();
    }

    setState(() {
      EasyLoading.dismiss();
      isLoading = false;
    });
  }

  _matchProduct() {
    _products.asMap().forEach((index, value) {
      bool checked = false;
      _cart.asMap().forEach((idx, val) {
        if (val.id == value.id) {
          _products[index] = val;
          checked = true;
        }
      });
      if (!checked && value.amount > 0) _products[index].amount = 0;
    });

    if (_cart.length == 0) {
      _products.asMap().forEach((key, value) {
        _products[key].amount = 0;
      });
    }
    setState(() {});
  }

  _upProduct(ProductData data, String status) async {
    if (status == 'minus' && data.amount == 0) await dbHelper.delete(data);
    if (status == 'minus' && data.amount > 0) await dbHelper.update(data);
    if (data.amount == 1 && status == 'plus') {
      data.date = DateTime(
              _selectedValue.year, _selectedValue.month, _selectedValue.day)
          .toString();
      await dbHelper.insert(data);
    }
    if (data.amount > 1 && status == 'plus') await dbHelper.update(data);
    _getDatabase();
  }

  _countProduct() {
    var price = 0;
    var total = 0;
    for (var i = 0; i < _cart.length; i++) {
      price += _cart[i].amount * _cart[i].price;
      total += _cart[i].amount;
    }
    setState(() {
      _totalPrice = price;
      _numberProduct = total;
      _padding = _numberProduct > 0 ? 50 : 0.0;
    });
  }

  _getDatabase() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<ProductData>> cartListFuture = dbHelper.cart();
      cartListFuture.then((cartList) {
        setState(() {
          List<ProductData> _dataCart = [];
          cartList.forEach((element) {
            if (element.date ==
                DateTime(_selectedValue.year, _selectedValue.month,
                        _selectedValue.day)
                    .toString()) _dataCart.add(element);
          });
          _cart = _dataCart;
          _countProduct();
          _matchProduct();
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getDate();
    _loadProducts();
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(Duration(days: 48));
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      DateTime day = startDate.add(Duration(days: i));
      if (day.weekday == 7 || day.weekday == 6) {
        days.add(day);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.lightBlue,
    ));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(
            Icons.restaurant,
            size: 30,
            color: Colors.lightBlue,
          )),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Alamat Pengantaran",
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                  SizedBox(
                      height: 10,
                      width: 10,
                      child: new IconButton(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        icon: Icon(
                          CupertinoIcons.chevron_down,
                          size: 10,
                          color: Colors.black,
                        ),
                        iconSize: 10,
                        onPressed: () {},
                      ))
                ],
              ),
              Text("Kulina",
                  style: TextStyle(color: Colors.black45, fontSize: 15)),
            ],
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: DatePicker(
                      DateTime.now(),
                      width: 60,
                      height: 80,
                      controller: _controller,
                      initialSelectedDate: DateTime.now(),
                      selectionColor: Colors.lightBlue,
                      selectedTextColor: Colors.white,
                      inactiveDates: days,
                      daysCount: 30,
                      onDateChange: (date) {
                        setState(() {
                          _selectedValue = date;
                          _getDate();
                        });
                      },
                    ),
                  ),
                  Container(
                    height: 80,
                    padding: EdgeInsets.all(0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                icon: Icon(
                                  CupertinoIcons.chevron_left_circle_fill,
                                  color: Colors.black45,
                                ),
                                onPressed: () {
                                  _controller.animateToDate(
                                      _slideDate.subtract(Duration(days: 4)));
                                  setState(() {
                                    if (!_slideDate.isBefore(DateTime.now())) {
                                      _slideDate = _slideDate
                                          .subtract(Duration(days: 4));
                                    }
                                  });
                                }),
                            IconButton(
                                icon: Icon(
                                  CupertinoIcons.chevron_right_circle_fill,
                                  color: Colors.black45,
                                ),
                                onPressed: () {
                                  _controller.animateToDate(
                                      _slideDate.add(Duration(days: 7)));
                                  setState(() {
                                    if (!_slideDate.isAfter(DateTime.now()
                                        .add(Duration(days: 48)))) {
                                      _slideDate =
                                          _slideDate.add(Duration(days: 7));
                                    }
                                  });
                                }),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        '$_selectedDay',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: _padding,
                    ),
                    child: LazyLoadScrollView(
                      isLoading: isLoading,
                      onEndOfPage: () => _loadProducts(),
                      child: GridView.builder(
                          itemCount: _products.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) => ItemCard(
                                product: _products[index],
                                press: () => {},
                                notifyParent: _upProduct,
                              )),
                    ),
                  ),
                  if (_numberProduct > 0)
                    CartDialog(
                      price: _totalPrice,
                      total: _numberProduct,
                      date: _selectedValue,
                      updateParent: _getDatabase,
                    ),
                ]),
              ),
            ],
          ),
        ));
  }
}

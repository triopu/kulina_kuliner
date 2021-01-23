import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kulinakuliner/modules/cart/components/cart_dialog.dart';
import 'package:kulinakuliner/modules/cart/components/item.dart';
import 'package:kulinakuliner/modules/home/models/product.dart';
import 'package:kulinakuliner/utils/local_storage_service.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:sqflite/sqflite.dart';

class CartView extends StatefulWidget {
  final DateTime date;
  const CartView({
    Key key,
    this.date,
  }) : super(key: key);
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  String _selectedDay = '';
  DbHelper dbHelper = DbHelper();
  List<ProductData> _cart = [];
  int _numberProduct = 0;
  int _totalPrice = 0;
  bool isLoading = true;

  _getDate(DateTime date) {
    initializeDateFormatting();
    final DateFormat formatter = DateFormat.yMMMMEEEEd("id_ID");
    final String formatted = formatter.format(date.toLocal());
    setState(() {
      _selectedDay = formatted;
    });
  }

  @override
  void initState() {
    super.initState();
    _getDate(widget.date);
    _getDatabase();
  }

  _getDatabase() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<ProductData>> cartListFuture = dbHelper.cart();
      cartListFuture.then((cartList) {
        setState(() {
          _cart = cartList;
          _countProduct();
        });
      });
    });
  }

  _upProduct(ProductData data, String status) async {
    if (status == 'delete') await dbHelper.delete(data.id);
    if (status == 'minus' && data.amount == 0) await dbHelper.delete(data.id);
    if (status == 'minus' && data.amount > 0) await dbHelper.update(data);
    if (data.amount == 1 && status == 'plus') await dbHelper.insert(data);
    if (data.amount > 1 && status == 'plus') await dbHelper.update(data);
    _getDatabase();
    _countProduct();
  }

  _delAll() {
    _cart.forEach((element) {
      dbHelper.delete(element.id);
    });
    _getDatabase();
    _countProduct();
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
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Balasan',
            style: TextStyle(color: Colors.black, fontSize: 15)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ),
      body: Container(
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daftar Pesanan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        child: Text(
                          'Hapus Pesanan',
                          style: TextStyle(color: Colors.black45),
                        ),
                        onPressed: () {
                          _delAll();
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  '$_selectedDay',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              Expanded(
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: LazyLoadScrollView(
                      isLoading: isLoading,
                      onEndOfPage: () {},
                      child: GridView.builder(
                          itemCount: _cart.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 5,
                            childAspectRatio: 3,
                          ),
                          itemBuilder: (context, index) => ItemCard(
                                product: _cart[index],
                                press: () => {},
                                notifyParent: _upProduct,
                              )),
                    ),
                  ),
                  CartDialog(
                    price: _totalPrice,
                    total: _numberProduct,
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

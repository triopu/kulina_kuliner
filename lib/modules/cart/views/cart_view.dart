import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kulinakuliner/modules/cart/components/cart_dialog.dart';
import 'package:kulinakuliner/modules/cart/components/empty_cart.dart';
import 'package:kulinakuliner/modules/cart/components/item.dart';
import 'package:kulinakuliner/modules/home/models/product.dart';
import 'package:kulinakuliner/utils/local_storage_service.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:sqflite/sqflite.dart';
import 'package:grouped_list/grouped_list.dart';

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
  DbHelper dbHelper = DbHelper();
  List<ProductData> _cart = [];
  int _numberProduct = 0;
  int _totalPrice = 0;
  bool isLoading = true;

  _getDate(String dateStr) {
    initializeDateFormatting();
    DateTime date = DateTime.parse(dateStr);
    final DateFormat formatter = DateFormat.yMMMMEEEEd("id_ID");
    final String formatted = formatter.format(date.toLocal());
    return formatted;
  }

  @override
  void initState() {
    super.initState();
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
    if (status == 'delete') await dbHelper.delete(data);
    if (status == 'minus' && data.amount == 0) await dbHelper.delete(data);
    if (status == 'minus' && data.amount > 0) await dbHelper.update(data);
    if (data.amount == 1 && status == 'plus') await dbHelper.insert(data);
    if (data.amount > 1 && status == 'plus') await dbHelper.update(data);
    _getDatabase();
    _countProduct();
  }

  _delAll() {
    _cart.forEach((element) {
      dbHelper.delete(element);
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
        title: Text('Keranjang Pesanan',
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
        child: _cart.length > 0
            ? Container(
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
                    Expanded(
                      child: Stack(children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: GroupedListView<dynamic, String>(
                            elements: _cart,
                            groupBy: (element) => element.date,
                            groupSeparatorBuilder: (String groupByValue) =>
                                Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                _getDate(groupByValue),
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                            itemBuilder: (context, dynamic element) => ItemCard(
                              product: element,
                              press: () => {},
                              notifyParent: _upProduct,
                            ),
                            floatingHeader: true, // optional
                            order: GroupedListOrder.ASC, // optional
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
              )
            : Container(
                child: EmptyCart(),
              ),
      ),
    );
  }
}

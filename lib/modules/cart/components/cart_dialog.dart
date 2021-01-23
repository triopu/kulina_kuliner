import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kulinakuliner/modules/cart/views/cart_view.dart';
import 'package:flutter/cupertino.dart';

class CartDialog extends StatefulWidget {
  final int price;
  final int total;
  const CartDialog({
    Key key,
    this.price,
    this.total,
  }) : super(key: key);
  @override
  _CartDialogState createState() => _CartDialogState();
}

class _CartDialogState extends State<CartDialog> {
  String _formatNumber(int number) {
    final format = NumberFormat.decimalPattern('id');
    return format.format(number);
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        right: 0,
        left: 0,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.total.toString() +
                            " Item | " +
                            "Rp. ${_formatNumber(widget.price)}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("Termasuk ongkos kirim")
                    ],
                  ),
                  FlatButton(
                    color: Colors.transparent,
                    onPressed: () {},
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Text('CHECKOUT'),
                        new Icon(CupertinoIcons.chevron_right),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

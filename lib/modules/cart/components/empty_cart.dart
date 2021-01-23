import 'package:flutter/material.dart';

class EmptyCart extends StatefulWidget {
  @override
  _EmptyCartState createState() => _EmptyCartState();
}

class _EmptyCartState extends State<EmptyCart> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/cart-empty.jpg',
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Keranjangmu masih kosong, nih.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  color: Colors.lightBlueAccent,
                  child: Text(
                    'Pesan Sekarang',
                    style: TextStyle(color: Colors.white),
                  ),
                )))
      ],
    ));
  }
}

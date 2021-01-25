import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:kulinakuliner/modules/home/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:kulinakuliner/modules/cart/components/count_button.dart';

class ItemCard extends StatefulWidget {
  final ProductData product;
  final Function press;
  final Function notifyParent;

  const ItemCard({
    Key key,
    this.product,
    this.press,
    this.notifyParent,
  }) : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  String _formatNumber(int number) {
    final format = NumberFormat.decimalPattern('id');
    return format.format(number);
  }

  String _status = 'minus';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        elevation: 5,
        child: Container(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      height: 110,
                      padding: EdgeInsets.all(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.product.imageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress),
                        ),
                        errorWidget: (context, url, error) =>
                            Center(child: Icon(Icons.error)),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.product.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(CupertinoIcons.trash),
                            onPressed: () {
                              widget.notifyParent(widget.product, 'delete');
                            },
                            iconSize: 15,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            widget.product.packageName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Rp. ${_formatNumber(widget.product.price)}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            child: NumericStepButton(
                              input: widget.product.amount,
                              maxValue: 20,
                              onChanged: (value) {
                                widget.product.amount = value;
                                widget.notifyParent(widget.product, _status);
                                setState(() {});
                              },
                              onStatus: (value) {
                                setState(() {
                                  _status = value;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

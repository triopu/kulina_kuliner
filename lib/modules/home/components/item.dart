import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kulinakuliner/modules/home/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'count_button.dart';

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
    return GestureDetector(
      onTap: widget.press,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.product.imageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(5)),
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
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.product.rating.toString().substring(0, 3),
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        SmoothStarRating(
                          starCount: 5,
                          rating: widget.product.rating,
                          size: 15,
                          isReadOnly: true,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    Text(
                      widget.product.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'by ' +
                          widget.product.brandName +
                          ' - ' +
                          widget.product.packageName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      widget.product.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        Text(
                          "Rp. ${_formatNumber(widget.product.price)}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " termasuk ongkir",
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                    widget.product.amount > 0
                        ? Container(
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
                        : ConstrainedBox(
                            constraints:
                                const BoxConstraints(minWidth: double.infinity),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: OutlineButton(
                                textColor: Colors.blue,
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(7)),
                                padding: EdgeInsets.all(5.0),
                                color: Colors.blue,
                                splashColor: Colors.blueAccent,
                                onPressed: () {
                                  widget.product.amount = 1;
                                  widget.notifyParent(widget.product, 'plus');
                                  setState(() {});
                                },
                                borderSide: BorderSide(color: Colors.blue),
                                child: Text(
                                  "Tambah Keranjang",
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

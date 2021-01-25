import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NumericStepButton extends StatefulWidget {
  final int minValue;
  final int maxValue;
  int input;

  final ValueChanged<int> onChanged;
  final ValueChanged<String> onStatus;

  NumericStepButton(
      {Key key,
      this.minValue = 0,
      this.maxValue = 10,
      this.input,
      this.onStatus,
      this.onChanged})
      : super(key: key);

  @override
  State<NumericStepButton> createState() {
    return _NumericStepButtonState();
  }
}

class _NumericStepButtonState extends State<NumericStepButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              CupertinoIcons.minus_square_fill,
              color: Theme.of(context).accentColor,
              size: 30,
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                if (widget.input > widget.minValue) {
                  widget.input--;
                }
                widget.onStatus('minus');
                widget.onChanged(widget.input);
              });
            },
          ),
          Text(
            widget.input.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.plus_square_fill,
              color: Theme.of(context).accentColor,
              size: 30,
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                if (widget.input < widget.maxValue) {
                  widget.input++;
                }
                widget.onStatus('plus');
                widget.onChanged(widget.input);
              });
            },
          ),
        ],
      ),
    );
  }
}

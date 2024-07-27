import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReplyCardWidget extends StatefulWidget {
  ReplyCardWidget({super.key, required this.message, required this.time});
  String message;
  String time;

  @override
  State<ReplyCardWidget> createState() => _ReplyCardWidgetState();
}

class _ReplyCardWidgetState extends State<ReplyCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Card(
          color: Color(
            0xFFFFFFFF,
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: 30,
                  top: 10,
                  right: 51,
                  left: 10,
                ),
                child: Text(
                  widget.message,
                  style: TextStyle(),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text(
                    widget.time,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

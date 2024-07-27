// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class OwnMessageCard extends StatefulWidget {
  OwnMessageCard({super.key, required this.message, required this.time});
  String message;
  String time;
  @override
  State<OwnMessageCard> createState() => _OwnMessageCardState();
}

class _OwnMessageCardState extends State<OwnMessageCard> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Card(
          color: const Color(
            0xFFdcf8c6,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 30,
                  top: 10,
                  right: 51,
                  left: 10,
                ),
                child: Text(
                  widget.message,
                  style: const TextStyle(),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Row(
                    children: [
                      Text(
                        widget.time,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(Icons.done_all_outlined)
                    ],
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

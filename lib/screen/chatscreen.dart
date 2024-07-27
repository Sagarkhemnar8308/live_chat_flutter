import 'package:chat_app_live/preferences/local_preferences.dart';
import 'package:chat_app_live/screen/ownmessage.dart';
import 'package:chat_app_live/screen/replycard.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../model/messageModel.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    super.key,
    required this.id,
    required this.targetId,
  });
  int id;
  int targetId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  bool showEmojii = false;
  final FocusNode _focusnode = FocusNode();
  io.Socket? socket;
  List<MessageModel> msg = [];

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    connect();
    _focusnode.addListener(() {
      if (_focusnode.hasFocus) {
        setState(() {
          showEmojii = false;
        });
      }
    });
    super.initState();
  }

  void sendmessage(String message, int id, int targetid) {
    setMessage("source", message);
    socket?.emit("message", {
      "message": message,
      "sourceId": id,
      "targetId": targetid,
    });
  }

  void setMessage(String type, String message) {
    MessageModel data = MessageModel(
      type: type,
      message: message,
      time: DateTime.now().toString().substring(10, 16),
    );
    setState(() {
      msg.add(data);
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void connect() {
    //192.168.31.194
    String? ip = LocalStorageUtils.getIP();
    print("object me ip is $ip");

    if (ip != null) {
      try {
        socket = io.io("http://192.168.31.194:5000", <String, dynamic>{
          "transports": ["websocket"],
          "autoConnect": true,
        });
        socket?.connect();
        socket?.on('connect', (_) {
          print('Connected: ${socket?.id}');

          socket?.on(
            "message",
            (data) {
              print("message is $data");
              setMessage("destination", data['message']);
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                curve: Curves.easeOut,
                duration: const Duration(
                  milliseconds: 300,
                ),
              );
            },
          );
        });
        socket?.on('connect_error', (error) {
          print('Connection Error: $error');
        });
        socket?.on('disconnect', (_) {
          print('Disconnected');
        });
        socket?.emit(
          'signin',
          widget.id,
        );
      } catch (e) {
        print('Error connecting to socket: $e');
      }
    } else {
      print("No IP address found in local storage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (showEmojii) {
          setState(() {
            showEmojii = false;
          });
        } else {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: const Column(
            children: [
              Text("data"),
              Text("data"),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                controller: scrollController,
                itemCount: msg.length + 1,
                itemBuilder: (context, index) {
                  if (index == msg.length) {
                    return Container(
                      height: 40,
                    );
                  }
                  if (msg[index].type == "source") {
                    return OwnMessageCard(
                      message: msg[index].message,
                      time: msg[index].time,
                    );
                  } else {
                    return ReplyCardWidget(
                      message: msg[index].message,
                      time: msg[index].time,
                    );
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(
                  10.0,
                ),
                child: Container(
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.92,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  25,
                                ),
                              ),
                              child: TextFormField(
                                focusNode: _focusnode,
                                onTap: () {
                                  scrollController.animateTo(
                                    scrollController.position.maxScrollExtent,
                                    curve: Curves.easeOut,
                                    duration: const Duration(
                                      milliseconds: 300,
                                    ),
                                  );
                                },
                                controller: messageController,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                minLines: 1,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type a message",
                                  prefixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showEmojii = true;
                                        _focusnode.unfocus();
                                        _focusnode.canRequestFocus = false;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.emoji_emotions_outlined,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      scrollController.animateTo(
                                        scrollController
                                            .position.maxScrollExtent,
                                        curve: Curves.easeOut,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                      );
                                      sendmessage(
                                          messageController.text.toLowerCase(),
                                          widget.id,
                                          widget.targetId);
                                      messageController.clear();
                                    },
                                    icon: const Icon(
                                      Icons.send,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      showEmojii ? emojiselect() : const SizedBox(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget emojiselect() {
    return EmojiPicker(
      onEmojiSelected: (Category? category, Emoji emoji) {
        setState(() {
          messageController.text =
              messageController.text + emoji.emoji.toString();
        });
      },
      onBackspacePressed: () {},
      textEditingController: messageController,
      config: Config(
        height: 256,
        checkPlatformCompatibility: true,
        emojiViewConfig: EmojiViewConfig(
          emojiSizeMax: 28 *
              (foundation.defaultTargetPlatform == TargetPlatform.iOS
                  ? 1.20
                  : 1.0),
        ),
        swapCategoryAndBottomBar: false,
        skinToneConfig: const SkinToneConfig(),
        categoryViewConfig: const CategoryViewConfig(),
        bottomActionBarConfig: const BottomActionBarConfig(),
        searchViewConfig: const SearchViewConfig(),
      ),
    );
  }
}

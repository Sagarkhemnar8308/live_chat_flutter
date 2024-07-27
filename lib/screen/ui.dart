import 'package:chat_app_live/preferences/local_preferences.dart';
import 'package:chat_app_live/screen/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.id});
  int? id;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    final info = NetworkInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? wifiIP = await info.getWifiIP();
       LocalStorageUtils.saveIP(wifiIP ?? "");
      print("object me $wifiIP");
    });
    _controller = TabController(
      length: 4,
      vsync: this,
    );
    super.initState();
  }

  List data = [
    {
      "name": "emulator",
      "id": 1,
    },
    {
      "name": "SM",
      "id": 2,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Whatsapp clone'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
              ),
            ),
          ],
          bottom: TabBar(
            controller: _controller,
            tabs: const [
              Tab(
                icon: Icon(
                  Icons.camera_alt_outlined,
                ),
              ),
              Tab(
                text: 'Chat',
              ),
              Tab(
                text: 'Status',
              ),
              Tab(
                text: 'Calls',
              ),
            ],
          ),
        ),
        body: TabBarView(controller: _controller, children: [
          Text("data"),
          ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          id: widget.id!,
                          targetId: data[index]['id'],
                        ),
                      ));
                },
                title: Text(data[index]['name']),
              );
            },
          ),
          Text("data"),
          Text("data"),
        ]));
  }
}

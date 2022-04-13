// ignore: file_names
// ignore_for_file: file_names

import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crazy_led_songs/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({required this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  static final clientID = 0;
  BluetoothConnection? connection;

  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;
  bool lowVolume = false;
  double percent = 0.0;

  @override
  void initState() {
    String finalString="";
    finalString = finalString + ((songFeatures["length"]=="null"||songFeatures["length"]==null)?(0.55).toString():songFeatures["length"].toString()) + "," + songFeatures["danceability"].toString() + "," + songFeatures["acousticness"].toString() + "," + songFeatures["energy"].toString() + "," + songFeatures["instrumentalness"].toString() + "," + songFeatures["liveness"].toString() + "," + songFeatures["valence"].toString() + "," + songFeatures["loudness"].toString() + "," + songFeatures["speechiness"].toString() + "," + songFeatures["tempo"].toString() + ",";;
    print(finalString);
    super.initState();
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        percent = 0.0;
        lowVolume = false;
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.text.trim()),
                style: TextStyle(color: Colors.white)),
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color:
                    _message.whom == clientID ? Color(0xff00C897) :  Color(0xff4286f4),
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    final serverName = widget.server.name ?? "Unknown";
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: redShade,
      //     title: (isConnecting
      //         ? Text('Connecting chat to ' + serverName + '...')
      //         : isConnected
      //         ? Text('Live chat with ' + serverName)
      //         : Text('Chat log with ' + serverName))),
      body: SafeArea(
        child:

            Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: greyShade,
                        size: 25,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        isConnecting
                            ? 'Connecting chat to ' + '\n' + serverName + '...'
                            : isConnected
                                ? 'Live chat with ' + '\n' + serverName
                                : 'Chat log with ' + '\n' + serverName,
                        style: TextStyle(
                          fontSize: 25,
                          color: greyShade,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 5.0, left: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  //border: Border.all(width: 3.0),
                  color: Color(0xffEEEEEE),
                  borderRadius: BorderRadius.all(Radius.circular(
                          20.0) //                 <--- border radius here
                      ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 30.0, left: 30.0, top: 20, bottom: 20.0),
                  child: Text(
                    "Crazy LED Controls",
                    style: TextStyle(
                      fontSize: 18,
                      color: greyShade,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            //Text("Remote Control Car Controls"),
            SizedBox(height: 20),
//            Row(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Container(
//                  margin: const EdgeInsets.all(8.0),
//                  child: IconButton(
//                      icon: const Icon(
//                        Icons.arrow_circle_up,
//                        size: 35.0,
//                      ),
//                      onPressed: isConnected ? () => _sendMessage('F') : null),
//                ),
//              ],
//            ),
//            Row(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: [
//                Container(
//                  margin: const EdgeInsets.all(8.0),
//                  child: IconButton(
//                      icon: const Icon(
//                        Icons.arrow_back,
//                        size: 35.0,
//                      ),
//                      onPressed: isConnected ? () => _sendMessage('L') : null),
//                ),
//                Container(
//                  margin: const EdgeInsets.all(8.0),
//                  child: IconButton(
//                      icon: const Icon(
//                        Icons.arrow_forward,
//                        size: 35.0,
//                      ),
//                      onPressed: isConnected ? () => _sendMessage('R') : null),
//                ),
//              ],
//            ),
//            Row(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Container(
//                  margin: const EdgeInsets.all(8.0),
//                  child: IconButton(
//                      icon: const Icon(
//                        Icons.arrow_circle_down,
//                        size: 35.0,
//                      ),
//                      onPressed: isConnected ? () => _sendMessage('B') : null),
//                ),
//              ],
//            ),
//             SizedBox(height: 20),
//
//
//
//            Padding(
//              padding:
//                  const EdgeInsets.only( left: 15.0, right: 15.0, bottom: 15.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: [
//                  ElevatedButton(
//                    style: ElevatedButton.styleFrom(
//                      primary: Colors.white,
//                      onPrimary: greyShade,
//                      side: BorderSide(
//                        width: 3,
//                        color: greyShade,
//                      ),
//                      shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(10),
//                      ),
//                    ),
//                    onPressed: isConnected
//                        ? () {
//                            _sendMessage('V');
//                            if (lowVolume) {
//                              _showMaterialDialog();
//                            }
//                          }
//                        : null,
//                    child: Padding(
//                      padding: const EdgeInsets.only(bottom:8.0),
//                      child: Text(
//                        'Get Volume',
//                        style: TextStyle(
//                          color: greyShade,
//                          fontSize: 16.0,
//                        ),
//                        textAlign: TextAlign.center,
//                      ),
//                    ),
//                  )
//                ],
//              ),
//            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: IconButton(
                      icon: const Icon(
                        Icons.lightbulb,
                        size: 35.0,
                      ),
                      onPressed: isConnected ? () {
                        if(songFeatures["length"] == "null" || songFeatures["length"]==null){
                          songFeatures["length"] = 0.55;
                        }
//                        String jsonString = json.encode(songFeatures);
                        //USE THESE AGAR JSON WALA NA CHALE and comment upar wali lines 312-315. Also 320 me _sendMessage ka paramter change karna hoga, iska output is 0.55,0.2,0.5 aise karke..
                        String finalString="";
                          finalString = finalString + ((songFeatures["length"]=="null"||songFeatures["length"]==null)?(0.55).toString():songFeatures["length"].toString()) + "," + songFeatures["danceability"].toString() + "," + songFeatures["acousticness"].toString() + "," + songFeatures["energy"].toString() + "," + songFeatures["instrumentalness"].toString() + "," + songFeatures["liveness"].toString() + "," + songFeatures["valence"].toString() + "," + songFeatures["loudness"].toString() + "," + songFeatures["speechiness"].toString() + "," + songFeatures["tempo"].toString() + ",";
                          print(finalString);
                        _sendMessage(finalString);
                      }:null),
                ),
              ],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: redShade
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Bluetooth Communication" + '\n' + "Messages",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),


            Flexible(
              child: ListView(
                  padding: const EdgeInsets.all(12.0),
                  controller: listScrollController,
                  children: list),
              //commit test
            ),
          ],
        ),
      ),
    );
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert!!'),
            content: Text('The bottle has ' +
                (percent * 100).toStringAsFixed(1) +
                '% drink left and requires refilling!'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    _dismissDialog();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: greyShade,
                    ),
                  )),
            ],
          );
        });
  }

  _dismissDialog() {
    Navigator.pop(context);
  }

  void _onDataReceived(Uint8List data) {
    print(data);
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);

    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    print(dataString);
    int mini = 350;
    int maxi = 600;
    int dataInt = int.parse(dataString) > maxi
        ? min(maxi, int.parse(dataString))
        : max(mini, int.parse(dataString));
    print(dataInt);
    percent = ((dataInt - mini) / max(1, (maxi - mini)));
    print(percent * 100);
//    TODO enter alert if percent <25% in UI
    setState(() {
      if (percent < 0.25) {
        lowVolume = true;
      } else {
        lowVolume = false;
      }
      messages.add(
        _Message(
          1,
          "The Volume left is " + (percent * 100).toStringAsFixed(1) + "%",
        ),
      );
    });
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();
    print(text);
    if (text.length > 0) {
      try {
        print(utf8.encode(text));
        connection!.output.add(Uint8List.fromList(utf8.encode(text)));

        await connection!.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  final Color backgroundColor;
  final String _title;

  Delegate(this.backgroundColor, this._title);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          Text(
            _title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

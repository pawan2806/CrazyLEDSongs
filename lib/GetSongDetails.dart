// ignore: file_names
// ignore_for_file: file_names

import 'package:crazy_led_songs/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crazy_led_songs/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'helpers/constants.dart';
import './BackgroundCollectedPage.dart';
import './BackgroundCollectingTask.dart';
import './ChatPage.dart';
import './DiscoveryPage.dart';
import './SelectBondedDevicePage.dart';
import 'package:spotify/spotify.dart';
class GetSongDetails extends StatefulWidget {
  @override
  _GetSongDetailsState createState() => _GetSongDetailsState();
}

class _GetSongDetailsState extends State<GetSongDetails> {

  String currentSongName="";
  String currentSongId="";
  static const token = "BQBIxzDznZ60IMQtY7Z4rbN6JtmiaB0D-3YAG4FEZni0bUqWeTtT32oNsJhWumNNcGjrmE4wBmlM_iFlJzNin_djJ1kxYnbrQWAJjA89nzV-NctdwbKjIRah9Nbp2S5LVjh-1sVHv2Otxc2L_APBU4PiSLecUF5FP4L1y57nqY7b";
//  String accessToken="";
  bool currentSongFetched = false;
  bool featuresFetched = false;
  @override
  void initState() {
    // TODO: implement initState
//    getAccessToken();
    super.initState();
  }

//  void getAccessToken() async {
//      var credentials = SpotifyApiCredentials("38caca3b2f7649799800f6fab1005d55", "9f065fb6b6064cf6b9f25fecdc0640e7");
////      var spotify = SpotifyApi(credentials);
//      final grant = SpotifyApi.authorizationCodeGrant(credentials);
//      final redirectUri = 'https://example.com/auth';
//      final scopes = ['user-read-currently-playing'];
//      final authUri = grant.getAuthorizationUrl(
//        Uri.parse(redirectUri),
//        scopes: scopes, // scopes are optional
//      );
//      String responseUri="";
//    WebView(
//      javascriptMode: JavascriptMode.unrestricted,
//      initialUrl: authUri.toString(),
//      navigationDelegate: (navReq) {
//        if (navReq.url.startsWith(redirectUri)) {
//          responseUri = navReq.url;
//          return NavigationDecision.prevent;
//        }
//
//        return NavigationDecision.navigate;
//      },
//    );
//      final spotify = SpotifyApi.fromAuthCodeGrant(grant, responseUri);
//      final finalCredentials = await spotify.getCredentials();
//      print(finalCredentials.accessToken);
////      credentials = await spotify.getCredentials();
////      print('\nCredentials:');
////      print('Client Id: ${credentials.clientId}');
////      print('Access Token: ${credentials.accessToken}');
////      accessToken = credentials.accessToken!;
////      print(accessToken);
////      print('Credentials Expired: ${credentials.isExpired}');
//    }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Flutter Bluetooth Serial'),
        //   backgroundColor: Colors.red,
        // ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
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
                            "Crazy LED Console",
                            style: TextStyle(
                              fontSize: 22,
                              color: greyShade,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(

                      height: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(0xff373B44),
                              Color(0xff4286f4),
                            ],
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  var url = Uri.parse('https://api.spotify.com/v1/me/player/currently-playing');
                                  var response = await http.get(url, headers: {"Authorization":"Bearer " + token},);
                                  print('Response status: ${response.statusCode}');
                                  print('Response body: ${response.body}');
                                  if(response.statusCode==200){
                                    setState(() {
                                      currentSongName =json.decode(response.body)["item"]["name"];
                                      currentSongId = json.decode(response.body)["item"]["id"];
                                      currentSongFetched = true;
                                    });
                                  }else{
                                    setState(() {
                                      currentSongName="";
                                      currentSongId="";
                                      currentSongFetched = false;
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    'Get the current' +
                                        '\n' +
                                        'playing song',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Center(child: Text("Current Song is: " + currentSongName==""?"Not Fetched yet":currentSongName)),
              Center(child: Text("Current Song ID is: " + currentSongId==""?"Not Fetched yet":currentSongId)),


              Visibility(
                visible: currentSongFetched,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(

                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color(0xff373B44),
                                Color(0xff4286f4),
                              ],
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    var url = Uri.parse('https://api.spotify.com/v1/audio-features/' + currentSongId);
                                    var response = await http.get(url, headers: {"Authorization":"Bearer " + token},);
                                    print('Response status: ${response.statusCode}');
                                    print('Response body: ${response.body}');
                                    if(response.statusCode==200){
                                      setState(() {
                                          songFeatures = json.decode(response.body);
                                          print(songFeatures);
                                          featuresFetched = true;

                                      });
                                    }else{
                                      setState(() {
                                        songFeatures={};
                                        print(songFeatures);
                                          featuresFetched = false;
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      'Get Features of' +
                                          '\n' +
                                          'current song',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Visibility(
                visible: featuresFetched,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(

                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color(0xff373B44),
                                Color(0xff4286f4),
                              ],
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainPage()),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      'Connect Bluetooth' + '\n' + 'and Set Ambience',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Expanded(
              //   child: Container(
              //     alignment: Alignment.center,
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.only(
              //               top: 10.0, left: 15.0, right: 15.0),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             children: [
              //               ElevatedButton(
              //                 style: ElevatedButton.styleFrom(
              //                   primary: Colors.white,
              //                   onPrimary:   Color(0xFFFC4F4F),
              //                   side: BorderSide(
              //                     width: 3,
              //                      color: Color(0xFFFC4F4F),
              //                   ),
              //                   shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(10),
              //                   ),
              //                 ),
              //                 onPressed: () async {
              //                   final BluetoothDevice? selectedDevice =
              //                       await Navigator.of(context).push(
              //                     MaterialPageRoute(
              //                       builder: (context) {
              //                         return DiscoveryPage();
              //                       },
              //                     ),
              //                   );

              //                   if (selectedDevice != null) {
              //                     print('Discovery -> selected ' +
              //                         selectedDevice.address);
              //                   } else {
              //                     print('Discovery -> no device selected');
              //                   }
              //                 },
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: Text(
              //                     'Search for devices to pair',
              //                     style: TextStyle( color: Color(0xFFFC4F4F),
              //                     fontSize: 16.0,),
              //                     textAlign: TextAlign.center,
              //                   ),
              //                 ),
              //               )
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.only(
              //               top: 10.0, left: 15.0, right: 15.0),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             children: [
              //               ElevatedButton(
              //                 style: ElevatedButton.styleFrom(
              //                   primary: Colors.white,
              //                   onPrimary: Color(0xFFFC4F4F),
              //                   side: BorderSide(
              //                     width: 3,
              //                     color: Color(0xFFFC4F4F),
              //                   ),
              //                   shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(10),
              //                   ),
              //                 ),
              //                 onPressed: () async {
              //                   final BluetoothDevice? selectedDevice =
              //                       await Navigator.of(context).push(
              //                     MaterialPageRoute(
              //                       builder: (context) {
              //                         return SelectBondedDevicePage(
              //                             checkAvailability: false);
              //                       },
              //                     ),
              //                   );

              //                   if (selectedDevice != null) {
              //                     print('Connect -> selected ' +
              //                         selectedDevice.address);
              //                     _startChat(context, selectedDevice);
              //                   } else {
              //                     print('Connect -> no device selected');
              //                   }
              //                 },
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: Text(
              //                     'Select Paired Device to send data',
              //                     style: TextStyle(
              //                       fontSize: 16.0,
              //                        color: Color(0xFFFC4F4F),
              //                     ),
              //                     textAlign: TextAlign.center,
              //                   ),
              //                 ),
              //               )
              //             ],
              //           ),
              //         ),
              //         //     ListTile(
              //         //   title: FlatButton(
              //         //       color: Colors.red,
              //         //       child: const Text(
              //         //         'Search for devices to pair',
              //         //         style: TextStyle(color: Colors.white),
              //         //       ),
              //         //       onPressed: () async {
              //         //         final BluetoothDevice? selectedDevice =
              //         //             await Navigator.of(context).push(
              //         //           MaterialPageRoute(
              //         //             builder: (context) {
              //         //               return DiscoveryPage();
              //         //             },
              //         //           ),
              //         //         );

              //         //         if (selectedDevice != null) {
              //         //           print(
              //         //               'Discovery -> selected ' + selectedDevice.address);
              //         //         } else {
              //         //           print('Discovery -> no device selected');
              //         //         }
              //         //       }),
              //         // ),
              //         // ListTile(
              //         //   title: FlatButton(
              //         //     color: Colors.red,
              //         //     child: const Text(
              //         //       'Select Paired Device to send data',
              //         //       style: TextStyle(color: Colors.white),
              //         //     ),
              //         //     onPressed: () async {
              //         //       final BluetoothDevice? selectedDevice =
              //         //           await Navigator.of(context).push(
              //         //         MaterialPageRoute(
              //         //           builder: (context) {
              //         //             return SelectBondedDevicePage(
              //         //                 checkAvailability: false);
              //         //           },
              //         //         ),
              //         //       );

              //         //       if (selectedDevice != null) {
              //         //         print('Connect -> selected ' + selectedDevice.address);
              //         //         _startChat(context, selectedDevice);
              //         //       } else {
              //         //         print('Connect -> no device selected');
              //         //       }
              //         //     },
              //         //   ),
              //         // ),
              //       ],
              //     ),
              //   ),
              // ),

              Divider(),
              //            ListTile(title: const Text('Multiple connections example')),
              //            ListTile(
              //              title: ElevatedButton(
              //                child: ((_collectingTask?.inProgress ?? false)
              //                    ? const Text('Disconnect and stop background collecting')
              //                    : const Text('Connect to start background collecting')),
              //                onPressed: () async {
              //                  if (_collectingTask?.inProgress ?? false) {
              //                    await _collectingTask!.cancel();
              //                    setState(() {
              //                      /* Update for `_collectingTask.inProgress` */
              //                    });
              //                  } else {
              //                    final BluetoothDevice? selectedDevice =
              //                    await Navigator.of(context).push(
              //                      MaterialPageRoute(
              //                        builder: (context) {
              //                          return SelectBondedDevicePage(
              //                              checkAvailability: false);
              //                        },
              //                      ),
              //                    );
              //
              //                    if (selectedDevice != null) {
              //                      await _startBackgroundTask(context, selectedDevice);
              //                      setState(() {
              //                        /* Update for `_collectingTask.inProgress` */
              //                      });
              //                    }
              //                  }
              //                },
              //              ),
              //            ),
              //            ListTile(
              //              title: ElevatedButton(
              //                child: const Text('View background collected data'),
              //                onPressed: (_collectingTask != null)
              //                    ? () {
              //                  Navigator.of(context).push(
              //                    MaterialPageRoute(
              //                      builder: (context) {
              //                        return ScopedModel<BackgroundCollectingTask>(
              //                          model: _collectingTask!,
              //                          child: BackgroundCollectedPage(),
              //                        );
              //                      },
              //                    ),
              //                  );
              //                }
              //                    : null,
              //              ),
              //            ),
            ],
          ),
        ),
      ),
    );
  }
}

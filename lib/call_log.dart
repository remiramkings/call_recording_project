import 'dart:ui';
import 'package:call_log/call_log.dart';
import 'package:call_recording_project/IconTextButton.dart';
import 'package:call_recording_project/call_log_drilldown.dart';
import 'package:call_recording_project/empty_list_img.dart';
import 'package:call_recording_project/loading_indicator.dart';
import 'package:call_recording_project/services/audio_query_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class CallLogPhone extends StatefulWidget {
  @override
  _CallLogPhone createState() => _CallLogPhone();
}

class _CallLogPhone extends State<CallLogPhone> {
  TextEditingController searchController = TextEditingController();
  bool onSearch = false;
  late Future<List<CallLogEntry>> futureData;
  var months = new Map();
  num _drillDown = -1;
  var androidVersionNames = [
    'New Client',
    'Clients',
    'New Enquiry',
    'Enquiries',
    'New Order',
    'Orders',
    'New ToDo',
    'ToDo',
    'New Service',
    'Services',
    'Attendance',
    'Travel Log',
    'Leaves',
    'PMS List'
  ];

  @override
  void initState() {
    super.initState();
    futureData = fetchQuote(context);
    months['01'] = 'JAN';
    months['02'] = 'FEB';
    months['03'] = 'MAR';
    months['04'] = 'APR';
    months['05'] = 'MAY';
    months['06'] = 'JUN';
    months['07'] = 'JUL';
    months['08'] = 'AUG';
    months['09'] = 'SEP';
    months['10'] = 'OCT';
    months['11'] = 'NOV';
    months['12'] = 'DEC';
    months['00'] = 'NIL';

    AudioQueryService
      .getInstance()
      .queryAudioFilesFromRoot(force: true);
  }

  @override
  Widget build(BuildContext context) {
    // fetchQuote(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: onSearch ? SearchOnAppBAr() : NormalAppbar(),

      body: Center(
          child: FutureBuilder<List<CallLogEntry>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<CallLogEntry>? data = snapshot.data;
                if(data!.isEmpty){
                  return Center(
                      child: Container(
                        decoration: BoxDecoration(
                            image:
                            DecorationImage(image: AssetImage("images/noresult.png"))),
                      ));
                }
                return new GestureDetector(
                    onTap: ()=> print("hello"),
                    child: _myListView(context, data)
                );
              } else if (snapshot.hasError) {
                return EmptyListImg();
              }
              return ToDoLoadingIndicator();
            },
          )),
    );
  }

  AppBar NormalAppbar() {
    return AppBar(
      title: Text(
        'Call Log',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      backgroundColor: Colors.blue,
      actions: <Widget>[

        Visibility(
          visible:false,// !widget.from_Report,
          child: IconButton(
            icon: Icon(Icons.search),
            tooltip: "menu",
            onPressed: () {
              setState(() {
                onSearch = true;
              });
            },
            color: Colors.white,
          ),
        ),
      ],
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        tooltip: "menu",
        onPressed: () {
          Navigator.pop(context);
        },
        color: Colors.white,
      ),
    );
  }

  resetSearch(){
    setState(() {
      searchController.text = '';
      onSearch = false;
      futureData = fetchQuote(context);
    });
  }

  AppBar SearchOnAppBAr() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Expanded(
              child: Container(
                  child: TextField(
                    autofocus: true,
                    controller: searchController,
                    onSubmitted: (_) {
                      setState(() {
                        futureData = fetchQuote(context);
                      });
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                futureData = fetchQuote(context);
                              });
                            },
                            icon: Icon(Icons.search))),
                  )
              )
          ),

        ],
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        tooltip: "menu",
        onPressed: () {
          if(onSearch) {
            resetSearch();
            return;
          }

          Navigator.pop(context);
        },
        color: Colors.white,
      ),
    );
  }

  Future<bool> getCallLogPermission() async {
    if (await Permission.phone.request().isGranted) {
      return true;
    }
    var permission = await Permission.phone.request();

    if (permission == PermissionStatus.denied || permission == PermissionStatus.permanentlyDenied) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("CallLog Permission Is Denied")));
      return false;
    }

    return true;
  }

  Future<List<CallLogEntry>> fetchQuote(context) async {

    if(!await getCallLogPermission()){
      return [];
    }

    var now = DateTime.now();
    int from = now.subtract(Duration(days: 20)).millisecondsSinceEpoch;
    int to = now.subtract(Duration(days: 0)).millisecondsSinceEpoch;
    Iterable<CallLogEntry> entries = await CallLog.query(
      dateFrom: from,
      dateTo: to,
      durationFrom: 0,
      durationTo: 260,
      name: searchController.text,
      number: '',
      // type: CallType.incoming,
    );
    for( var item in entries){
      print(item.name);
      print(item.number);
      print(item.duration);
      print(item.callType);
      print(new DateTime.fromMillisecondsSinceEpoch(item.timestamp!).toString());
    }
    return entries.toList();
  }

  Widget _myListView(BuildContext context,List<CallLogEntry> logEntries) {
    return ListView.separated(
        itemCount: logEntries!.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: Color(0xff8b8888)),
        itemBuilder: (BuildContext context, int index) {
          var selectedData = logEntries[index];
          String dt = DateTime.fromMillisecondsSinceEpoch(
              selectedData.timestamp!).toString();
          var year = dt.substring(0, 4);
          var mm = "00";
          if(selectedData.timestamp != null) {
            mm = dt.substring(5, 7);
          }
          var mon = months[mm];
          var dd = dt.substring(8, 10);
          var gt = "0";
          if(selectedData.duration != null) gt = selectedData.duration.toString();
          var bl = "0";
          if(selectedData.callType != null) bl = selectedData.callType.toString();
          var nm = "";
          if(selectedData.name != null) nm = selectedData.name ?? '';
          return Container(
            margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8,),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _drillDown = _drillDown == index ? -1 : index;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        //margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
                        //height: 95,
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Text(year,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    height: 1.0,
                                    color: Color(0xffffbd4d),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(dd,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    height: 1.0,
                                    color: Color(0xff3970b0),
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                mon,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    height: 1.0,
                                    color: Color(0xffb7332f),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                      Expanded(
                        child: Container(
                          //height: 75,
                            padding: EdgeInsets.fromLTRB(10, 1, 10, 2),
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  //width: 150,
                                  child: Text(
                                    selectedData.name ?? '',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Color(0xff0c0c0c),
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  //width: 150,
                                  child: Text(
                                    selectedData.number ?? '',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 1,),
                          Visibility(
                            visible: true,
                            child: Icon(
                              _drillDown == index
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down_outlined,
                              color: Colors.blue,
                              size: 25,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: _drillDown == index,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 10,
                              children: [
                                IconTextButton(
                                    title: "Add To Enq",
                                    icon: Icons.add_task,
                                    onTap: () {
                                      
                                    },
                                    visibility: true),
                              ],
                            ),
                            CallLogDrillDown(
                              callData: logEntries[index],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}

class Data {
  final String balance;
  final String grand_total;
  final String client_name;
  final String created_date;
  final String client_mobile_number;

  // {"data":[{"client_id":"129187","company_id":"6",
  // "client_name":"Kannan","client_code":"0",
  // "created_date":"2022-02-22 00:00:00",
  // "location_lat":"0","location_lng":"0",
  // "client_location":"8MVX+PJ4, Thottapuzhacherry, Kerala 689549, India",
  // "client_mobile_number":"8138841737","client_email":"",
  // "whatsapp_linked":"0","full_name":"Jack","total_enq":"2",
  // "closed_enq":"0","grand_total":null,"advance":"0",
  // "balance":null,"comments":"jjjj","created_user_id":"151",
  // "lastupdate_date":"2022-02-22 12:33:04","AddContact":"0",
  // "last_updated_date_left":"-3","lastfollow_up_date":"2022-02-22 12:32:00",
  // "lastfollow_up_date_left":"-3","client_region_id":"38",
  // "gst_number":"NULL","region_name":"Kerala","assigned_user_id":"618",
  // "Assigned_user_name":"Edwin Thomas","opening_balance":"null",
  // "status_id":"1","client_branch":"0","branch_name":null,"drop_down_1":"0",
  // "drop_down_2":"0","drop_down_3":"0","drop_down_4":"0","text_box_1":"null",
  // "text_box_2":"null","text_box_3":"","text_box_4":"","client_type_id":"1",
  // "type_name":"End User","user_logo":""

  Data(
      {required this.balance,
        required this.grand_total,
        required this.client_name,
        required this.created_date,
        required this.client_mobile_number});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      balance: json['balance'],
      grand_total: json['grand_total'],
      client_name: json['client_name'],
      created_date: json['created_date'],
      client_mobile_number: json['client_mobile_number'],
    );
  }
}

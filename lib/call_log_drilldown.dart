import 'package:call_log/call_log.dart';
import 'package:call_recording_project/custom_audio_player.dart';
import 'package:call_recording_project/services/audio_query_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io' as io;

class CallLogDrillDown extends StatefulWidget {
  CallLogEntry callData;
  CallLogDrillDown({
    super.key,
    required this.callData
  });

  @override
  State<CallLogDrillDown> createState() => _CallLogDrillDownState();
}

class _CallLogDrillDownState extends State<CallLogDrillDown> {

  bool canPlayAudio = false;
  String? audioUrl;
  DateFormat dateFormat = DateFormat("yyyyMMddHHmm"); 

  @override
  initState(){
    super.initState();
    getFileUrlFromPhoneNumberAndTime(widget.callData.number ?? "-", DateTime.fromMillisecondsSinceEpoch(
              widget.callData.timestamp!));
  }

  


  getFileUrlFromPhoneNumberAndTime(String phoneNumber, DateTime dateTime) async {
    List<String?> songUris = await AudioQueryService
      .getInstance()
      .queryAudioFilesFromRoot();

    String timestamp = dateFormat.format(dateTime);
    phoneNumber = phoneNumber.substring(phoneNumber.length-10);

    String? songUrl = songUris
      .           where((entry){
        return entry != null && entry.isNotEmpty
          && entry.contains(phoneNumber) && entry.contains(timestamp);
      })
      .firstOrNull;

      if(songUrl == null){
        return;
      }

      setState(() {
        audioUrl = songUrl;
      });

  }

  @override
  Widget build(BuildContext context) {
    // const audioUrl =  "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3";// widget.callData.recordingUrl;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(12.0),
      child: audioUrl == null ? const Text("No recordings found")
      : CustomAudioPlayer(filePath: audioUrl ?? "",)
    );
  }
}
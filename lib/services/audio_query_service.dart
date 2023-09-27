import 'dart:io' as io;

import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioQueryService {
  static AudioQueryService _instance = AudioQueryService();
  final OnAudioQuery _audioQuery = OnAudioQuery();

  static AudioQueryService getInstance() {
    return _instance;
  }

  static List<String?> songPaths = [];

  Future<List<String?>> queryAudioFiles({bool force = false}) async {
    if(songPaths.isNotEmpty && !force){
      return songPaths;
    }
    List<SongModel> songs = await _audioQuery.querySongs();   
    songPaths = songs
      .map((e) => e.data)
      .where((e) => e != null)
      .toList();
    
    return songPaths;
  }

  Future<List<String?>> queryAudioFilesFromRoot({bool force = false}) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
      //await Permission.manageExternalStorage.request();
    }
    if(songPaths.isNotEmpty && !force){
      return songPaths;
    }
    io.Directory? rootDir = await getExternalStorageDirectory();
    String? rootPath = rootDir!.path.split("/Android").firstOrNull;
    if(rootPath == null){
      return [];
    }
    List<io.FileSystemEntity> entities = io.Directory(rootPath).listSync(recursive: true);
    if(entities.isEmpty){
      return [];
    }

    songPaths =  entities
      .where((e) {
          RegExp regexp = RegExp(r'.*(\.(m4a|mp3|wav))$');
          return regexp.hasMatch(e.path);
      })
      .map((e) => e.path)
      .toList();
    
    return songPaths;
  }


}
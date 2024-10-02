import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/repositories/running_repository.dart';
import 'package:frontend/services/file_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class RunningService extends GetxService {
  late final RunningRepository _runningRepository;
  late final FileService _fileService;

  RunningService() {
    _runningRepository = RunningRepository();
    _fileService = FileService();
  }

  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
  }

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    );
  }

  double calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  String calculatePace(double speedMps) {
    if (speedMps <= 0) return "0'00''";
    double speedKmh = speedMps * 3.6;
    double pace = 60 / speedKmh;
    int minutes = pace.floor();
    int seconds = ((pace - minutes) * 60).round();
    return "$minutes'${seconds.toString().padLeft(2, '0')}''";
  }

  // Polyline createRealTimePolyline(List<LatLng> points) {
  //   return Polyline(
  //     polylineId: const PolylineId('realTimePath'),
  //     color: Colors.blue,
  //     width: 5,
  //     points: points,
  //   );
  // }

  Duration calculateElapsedTime(DateTime startTime) {
    return DateTime.now().difference(startTime);
  }

  // 이전 polyline 생성
  Future<Polyline?> loadPresetPath() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/preset_path.json';
      final file = File(filePath);

      // 파일이 존재할 경우 데이터 읽기
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(jsonString);

        // JSON 데이터를 LatLng 리스트로 변환
        List<LatLng> presetPath = jsonList
            .map((point) => LatLng(point['latitude'], point['longitude']))
            .toList();

        // Polyline 생성하여 반환
        return Polyline(
          polylineId: PolylineId('presetPath'),
          color: Colors.green, // 기존 경로의 색상 지정
          width: 5,
          points: presetPath,
        );
      } else {
        print('Preset path file does not exist.');
        return null;
      }
    } catch (e) {
      print('Error loading preset path: $e');
      return null;
    }
  }

  Future<String> endRunningSession() async {
    try {
      // Submit the running record and get recordId
      final recordId = await _runningRepository.submitRunningRecord();
      // Rename file with the obtained recordId
      await _fileService.renameFile(recordId);
      return recordId;
    } catch (e) {
      rethrow; // Propagate error back to the controller for handling
    }
  }

  Future<Polyline> createSavedPathPolyline(String fileName) async {
    List<LatLng> savedPath = await _fileService.readSavedPath(fileName);
    return Polyline(
      polylineId: PolylineId('savedPath'),
      color: Colors.red, // 저장된 경로는 빨간색으로 표시
      width: 5,
      points: savedPath,
    );
  }

  // 실시간 경로를 위한 polyline 생성 메서드 (기존 메서드 수정)
  Polyline createRealTimePolyline(List<LatLng> points) {
    return Polyline(
      polylineId: PolylineId('realTimePath'),
      color: Colors.blue, // 실시간 경로는 파란색으로 표시
      width: 5,
      points: points,
    );
  }
}
import 'package:flutter/material.dart';
import '../../widgets/map/result_map.dart';
import '../../widgets/review_record_item.dart';
import '../../widgets/review_info_item.dart';

class RecordDetailView extends StatelessWidget {
  RecordDetailView({super.key});

  // 제목, 주소, 시간, 내용 등을 하나의 Map으로 관리
  final Map<String, dynamic> details = {
    'title': "유성천 옆 산책로",
    'address': "대전광역시 문화원로 80",
    'time': DateTime(2024, 9, 6, 9, 24, 27), // DateTime 객체
    'image': '',
    'content':
        "오늘 날씨 너무 선선해!\n선선한 날씨에 뛰니까 10km도 뛸 수 있었당\n다음주에는 10km 1시간 내로 도전 !!!",
  };

  final List<num> records = const [10, 4016, 67, 480];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          '기록 상세',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 56,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LocationInfo 위젯 사용하여 데이터 표시
                        LocationInfo(
                          title: details['title'],
                          address: details['address'],
                          time: details['time'],
                        ),
                        SizedBox(height: 20),
                        // 러닝 사진
                        Image.asset(
                          'assets/images/review_default_image.png',
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 28),
                        // 러닝 리뷰
                        Text(
                          '러닝 리뷰',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          details['content'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xffA0A0A0),
                          ),
                        ),
                        SizedBox(height: 50),
                        // 기록 상세
                        Text(
                          '기록 상세',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ReviewRecordItem(value: records[0], label: '운동 거리'),
                            ReviewRecordItem(value: records[1], label: '운동 시간'),
                            ReviewRecordItem(
                                value: records[2], label: '러닝 경사도'),
                            ReviewRecordItem(
                                value: records[3], label: '소모 칼로리'),
                          ],
                        ),
                        SizedBox(height: 44),
                      ],
                    ),
                  ),
                  // 지도 터치 막아둠
                  AbsorbPointer(
                    absorbing: true,
                    child: SizedBox(
                      height: 300,
                      child: const ResultMap(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
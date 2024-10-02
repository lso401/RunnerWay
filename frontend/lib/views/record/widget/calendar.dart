import 'package:flutter/material.dart';
import 'package:frontend/controllers/record_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  // 처음에 selectedDate는 오늘 날짜로 설정
  Calendar({
    super.key,
  });

  // 디바운스를 적용하기 위한 변수
  final RxBool _canChangeMonth = true.obs;
  final int debounceDuration = 500;

  @override
  Widget build(BuildContext context) {
    final RecordController recordController = Get.find<RecordController>();

    // 월 변경 함수 (디바운스 적용)
    void changeMonth(int offset) {
      if (_canChangeMonth.value) {
        DateTime currentMonth =
            recordController.focusedDate.value ?? DateTime.now();
        DateTime newMonth =
            DateTime(currentMonth.year, currentMonth.month + offset);

        recordController.setFocusedDate(newMonth);

        // 월이 유효한지 확인 (예: 2024년 1월 1일 이후로만 허용)
        if (newMonth.isAfter(DateTime(2024, 1, 1)) &&
            newMonth.isBefore(DateTime(2025, 1, 31))) {
          recordController.setFocusedDate(newMonth);

          // 디바운스 적용: 일정 시간 동안 버튼 비활성화
          _canChangeMonth.value = false;
          Future.delayed(Duration(milliseconds: debounceDuration), () {
            _canChangeMonth.value = true;
          });
        }
      }
    }

    // selectedDate는 오늘 날짜로 초기화하고, focusedMonth는 선택된 날짜의 달로 초기화
    // DateTime selectedDate =
    //     recordController.selectedDate.value ?? DateTime.now();
    DateTime focusedMonth =
        recordController.focusedDate.value ?? DateTime.now();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 월 이동 버튼과 현재 보여주는 월 표시
        Obx(() {
          DateTime focusedMonth =
              recordController.focusedDate.value ?? DateTime.now();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.chevron_left_rounded),
                  onPressed: () => changeMonth(-1),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  DateFormat('yyyy.MM').format(focusedMonth),
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.chevron_right_rounded),
                  onPressed: () => changeMonth(1),
                ),
              ),
            ],
          );
        }),

        // 달력 표시
        Obx(() {
          // 매번 선택된 날짜와 포커스된 달에 따라 달력을 다시 그리도록 함
          return TableCalendar(
            onDaySelected: (selectedDay, focusedDay) {
              // 날짜 선택 시 selectedDate 업데이트
              recordController.setSelectedDate(selectedDay);
              recordController.setFocusedDate(focusedDay); // 해당 월로 업데이트
            },
            selectedDayPredicate: (date) =>
                isSameDay(recordController.selectedDate.value, date),
            focusedDay: recordController.focusedDate.value ?? DateTime.now(),
            firstDay: DateTime(1999, 1, 1),
            lastDay: DateTime(2100, 1, 31),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              todayTextStyle: TextStyle(
                color: null,
              ),
              todayDecoration: BoxDecoration(
                color: null,
              ),
              selectedTextStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Color(0xFF1EA6FC),
              ),
              selectedDecoration: BoxDecoration(color: null),
            ),
            headerStyle: HeaderStyle(
              titleTextFormatter: (date, locale) => "",
              formatButtonVisible: false,
              leftChevronVisible: false,
              rightChevronVisible: false,
              headerMargin: EdgeInsets.only(bottom: 1),
              titleTextStyle: TextStyle(fontSize: 0),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: Color(0xFF6C7072).withOpacity(0.5),
                fontSize: 13,
              ),
              weekendStyle: TextStyle(
                color: Color(0xFF6C7072).withOpacity(0.5),
                fontSize: 13,
              ),
              dowTextFormatter: (date, locale) =>
                  DateFormat.E(locale).format(date)[0],
            ),
            daysOfWeekHeight: 44,
          );
        }),
      ],
    );
  }
}
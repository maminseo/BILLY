import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat_room_page.dart';

class ItemDetailPage extends StatelessWidget {
  final String title;
  final String category;
  final String price;
  final String location;
  final String? imagePath;

  const ItemDetailPage({
    super.key,
    required this.title,
    required this.category,
    required this.price,
    required this.location,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('물품 상세'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ✅ 상단 이미지 영역 - (이전 구문 오류 수정)
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: theme.colorScheme.primaryContainer,
            ),
            clipBehavior: Clip.antiAlias,
            child: imagePath != null
                ? Image.asset(
                    imagePath!,
                    fit: BoxFit.cover,
                  )
                : const Center(
                    child: Icon(
                      Icons.image_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
          ), 
          const SizedBox(height: 16),
          
          Text(
            category,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.place_rounded, size: 16),
              const SizedBox(width: 4),
              Text(
                location,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            price,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '물품 설명',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            '초보자도 쉽게 사용할 수 있는 가볍고 성능 좋은 DSLR 세트입니다. 여행, 스냅 촬영, 수업 과제 등에 완벽합니다',
          ),
          const SizedBox(height: 24),
          // 대여 문의 / 예약 버튼
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _openRentalSheet(context),
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              label: const Text('대여 문의 / 예약하기'),
            ),
          ),
        ],
      ),
    );
  }

  // === 대여기간 시트 열기 ===
  void _openRentalSheet(BuildContext context) async {
    final result = await showModalBottomSheet<_RentalPeriodResult>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _RentalBottomSheet(
        title: title,
        price: price,
      ),
    );

    if (result == null) return;

    final systemText =
        '대여 문의가 들어왔어요.\n\n'
        '• 물품: $title\n'
        '• 기간: ${_formatDateTime(result.start)} ~ ${_formatDateTime(result.end)}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatRoomPage(
          roomTitle: title,
          initialSystemText: systemText,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final mm = dt.month.toString().padLeft(2, '0');
    final dd = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$mm월 $dd일 $hh:$min';
  }
}

// === 시트에서 넘겨줄 결과 타입 ===
class _RentalPeriodResult {
  final DateTime start;
  final DateTime end;

  _RentalPeriodResult(this.start, this.end);
}

// === 대여기간 설정 바텀 시트 ===
class _RentalBottomSheet extends StatefulWidget {
  final String title;
  final String price;

  const _RentalBottomSheet({
    required this.title,
    required this.price,
  });

  @override
  State<_RentalBottomSheet> createState() => _RentalBottomSheetState();
}

class _RentalBottomSheetState extends State<_RentalBottomSheet> {
  late DateTime _start;
  late DateTime _end;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // 시작은 지금 기준 1시간 뒤, 끝은 2시간 뒤로 기본값
    _start = now.add(const Duration(hours: 1));
    _end = now.add(const Duration(hours: 2));
    // 분을 5분 단위로 정리
    _start = _roundTo5min(_start);
    _end = _roundTo5min(_end);
  }

  DateTime _roundTo5min(DateTime dt) {
    final m = (dt.minute / 5).round() * 5;
    return DateTime(dt.year, dt.month, dt.day, dt.hour, m);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        bottom: bottom,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 드래그 핸들러
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '대여 기간 설정',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 16),

              // 시작 시간
              _buildSection(
                context,
                label: '대여 시작',
                dateTime: _start,
                onDateTap: () async {
                  final picked = await _pickDate(context, _start);
                  if (picked != null) {
                    setState(() {
                      _start = DateTime(
                        picked.year,
                        picked.month,
                        picked.day,
                        _start.hour,
                        _start.minute,
                      );
                      if (_end.isBefore(_start)) {
                        _end = _start.add(const Duration(hours: 1));
                      }
                    });
                  }
                },
                onTimeTap: () async {
                  final picked = await _pickTime(context, _start);
                  if (picked != null) {
                    setState(() {
                      _start = DateTime(
                        _start.year,
                        _start.month,
                        _start.day,
                        picked.hour,
                        picked.minute,
                      );
                      if (_end.isBefore(_start)) {
                        _end = _start.add(const Duration(hours: 1));
                      }
                    });
                  }
                },
              ),

              const SizedBox(height: 12),

              // 끝 시간
              _buildSection(
                context,
                label: '반납 시작',
                dateTime: _end,
                onDateTap: () async {
                  final picked = await _pickDate(context, _end);
                  if (picked != null) {
                    setState(() {
                      _end = DateTime(
                        picked.year,
                        picked.month,
                        picked.day,
                        _end.hour,
                        _end.minute,
                      );
                      if (_end.isBefore(_start)) {
                        _end = _start.add(const Duration(hours: 1));
                      }
                    });
                  }
                },
                onTimeTap: () async {
                  final picked = await _pickTime(context, _end);
                  if (picked != null) {
                    setState(() {
                      _end = DateTime(
                        _end.year,
                        _end.month,
                        _end.day,
                        picked.hour,
                        picked.minute,
                      );
                      if (_end.isBefore(_start)) {
                        _end = _start.add(const Duration(hours: 1));
                      }
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    // 196줄 근처의 코드가 이 부분일 가능성이 높습니다.
                    // Navigator.pop에 _RentalPeriodResult를 반환합니다.
                    Navigator.pop(
                      context,
                      _RentalPeriodResult(_start, _end),
                    );
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: const Text('이 기간으로 대여 문의하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 날짜/시간 한 줄
  Widget _buildSection(
    BuildContext context, {
    required String label,
    required DateTime dateTime,
    required VoidCallback onDateTap,
    required VoidCallback onTimeTap,
  }) {
    final theme = Theme.of(context);

    String dateText =
        '${dateTime.month}월 ${dateTime.day}일 (${_weekdayKor(dateTime.weekday)})';
    String timeText =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: theme.textTheme.labelMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onDateTap,
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(dateText),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: onTimeTap,
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(timeText),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _weekdayKor(int weekday) {
    const names = ['월', '화', '수', '목', '금', '토', '일'];
    return names[weekday - 1];
  }

  // 날짜는 기존 Material date picker 사용
  Future<DateTime?> _pickDate(BuildContext context, DateTime base) {
    return showDatePicker(
      context: context,
      initialDate: base,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
  }

  // === << 여기서 시간이 '휠 + 5분 단위' >> ===
  Future<_TimeOfDay?> _pickTime(BuildContext context, DateTime base) async {
    final initial = _TimeOfDay(base.hour, base.minute);
    final result = await _showCupertinoTimePicker(context, initial);
    return result;
  }
}

/// 단순 TimeOfDay 대체용(Flutter 기본 TimeOfDay 안 써도 됨)
class _TimeOfDay {
  final int hour;
  final int minute;

  _TimeOfDay(this.hour, this.minute);
}

/// iOS 스타일 휠 타임피커 (5분 단위)
Future<_TimeOfDay?> _showCupertinoTimePicker(
    BuildContext context, _TimeOfDay initial) {
  _TimeOfDay temp = _TimeOfDay(initial.hour, initial.minute);

  final initialDateTime =
      DateTime(0, 1, 1, initial.hour, (initial.minute ~/ 5) * 5);
  
  final theme = Theme.of(context);

  return showCupertinoModalPopup<_TimeOfDay>(
    context: context,
    builder: (ctx) {
      return Container(
        height: 280,
        color: Colors.white,
        child: Column(
          children: [
            // 상단 버튼 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(null),
                    child: Text('취소', style: TextStyle(color: theme.colorScheme.primary)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(temp),
                    child: Text('완료', style: TextStyle(color: theme.colorScheme.primary)),
                  ),
                ],
              ),
            ),
            const Divider(height: 0),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                minuteInterval: 5, // ★ 5분 단위
                initialDateTime: initialDateTime,
                onDateTimeChanged: (dt) {
                  temp = _TimeOfDay(dt.hour, dt.minute);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
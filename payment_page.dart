import 'package:flutter/material.dart';

// 🔹 ChatList로 가야 하니까 이거 꼭 추가!
import 'chat_list_page.dart';

class PaymentPage extends StatefulWidget {
  final String itemTitle;
  final String price;      // 예: "15,000원 /일"
  final String periodText; // 예: "오늘 12:30 ~ 오늘 18:30 (총 6시간 이용)"

  const PaymentPage({
    super.key,
    required this.itemTitle,
    required this.price,
    required this.periodText,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int _selectedInsurance = 1; // 0: 기본, 1: 표준, 2: 완전
  String _selectedMethod = '국민 5160 / 개인';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('예약 및 결제하기'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 상품 정보
          Text(
            widget.itemTitle,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            widget.price,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          // 보험 / 보장
          Text(
            '보험 및 보장상품',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _insuranceCard(),

          const SizedBox(height: 24),

          // 이용 시간
          Text(
            '이용 시간',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _timeCard(),

          const SizedBox(height: 24),

          // 결제 수단
          Text(
            '결제 수단',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _paymentMethodCard(),
        ],
      ),

      // 하단 큰 결제 버튼
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _onPayPressed,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                '결제하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _insuranceCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          RadioListTile<int>(
            value: 0,
            groupValue: _selectedInsurance,
            onChanged: (v) => setState(() => _selectedInsurance = v ?? 0),
            title: const Text('기본보장'),
            subtitle: const Text('파손 시 최대 30만원 부담'),
            secondary: const Text('+ 0원'),
          ),
          const Divider(height: 1),
          RadioListTile<int>(
            value: 1,
            groupValue: _selectedInsurance,
            onChanged: (v) => setState(() => _selectedInsurance = v ?? 1),
            title: const Text('표준보장'),
            subtitle: const Text('파손 시 최대 10만원 부담'),
            secondary: const Text('+ 3,000원'),
          ),
          const Divider(height: 1),
          RadioListTile<int>(
            value: 2,
            groupValue: _selectedInsurance,
            onChanged: (v) => setState(() => _selectedInsurance = v ?? 2),
            title: const Text('완전보장'),
            subtitle: const Text('파손 시 0원 부담'),
            secondary: const Text('+ 5,000원'),
          ),
        ],
      ),
    );
  }

  Widget _timeCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '총 6시간 이용', // 데모라 고정 값
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.periodText,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentMethodCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedMethod,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              items: const [
                DropdownMenuItem(
                  value: '국민 5160 / 개인',
                  child: Text('국민 5160 / 개인'),
                ),
                DropdownMenuItem(
                  value: '카카오페이',
                  child: Text('카카오페이'),
                ),
                DropdownMenuItem(
                  value: '토스페이',
                  child: Text('토스페이'),
                ),
              ],
              onChanged: (v) {
                if (v == null) return;
                setState(() => _selectedMethod = v);
              },
            ),
            const SizedBox(height: 4),
            const Text(
              '실제 결제는 이루어지지 않는 데모 화면입니다.',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _onPayPressed() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 48,
            ),
            SizedBox(height: 12),
            Text(
              '결제가 완료되었습니다.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 6),
            Text(
              '채팅방에서 대여 진행을 계속해주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              // 1) 팝업 닫기
              Navigator.pop(context);
              // 2) 결제 페이지 닫기
              Navigator.pop(context);
              // 3) 채팅 목록 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChatListPage(),
                ),
              );
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}

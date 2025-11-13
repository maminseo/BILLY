import 'package:flutter/material.dart';
import 'chat_room_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅'),
      ),
      body: ListView(
        children: [
          _ChatListTile(
            title: 'DSLR 카메라 세트',
            subtitle: '결제를 진행해주세요!',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChatRoomPage(
                    roomTitle: 'DSLR 카메라 세트',
                    // 아래 3개가 “거래 계속하기” 카드 내용
                    itemTitle: 'DSLR 카메라 세트',
                    itemPrice: '15,000원 /일',
                    rentPeriodText: '오늘 12:30 ~ 오늘 18:30 (총 6시간 이용)',
                    // 선택 사항: 채팅 상단 안내 문구
                    initialSystemText: '대여 조건이 확정되었어요. '
                        '아래 카드에서 거래를 계속해 주세요.',
                  ),
                ),
              );
            },
          ),
          _ChatListTile(
            title: '라즈베리 파이',
            subtitle: '네고 가능할까요?',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChatRoomPage(
                    roomTitle: '라즈베리 파이',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ChatListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ChatListTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Icon(
          Icons.person,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

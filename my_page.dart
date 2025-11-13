import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_page.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 프로필 영역
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.person,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.email ?? 'asd@gmail.com',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '신뢰도 점수 4.7 / 5.0',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 빌려준/빌린 횟수
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: '빌려준 횟수',
                  value: '3회',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: '빌린 횟수',
                  value: '5회',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 이번 달 수익
          _StatCard(
            title: '이번 달 수익',
            value: '12,000원',
            alignLeft: true,
          ),
          const SizedBox(height: 16),

          // 🔹 AI 가이드 카드 (여기가 새로 추가된 부분)
          Text(
            'AI 가이드',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _AiGuideCard(),
          const SizedBox(height: 24),

          const Divider(height: 32),

          // 내 활동
          Text(
            '내 활동',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('대여 / 차용 내역'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.reviews),
            title: const Text('리뷰 및 신뢰도'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart_rounded),
            title: const Text('수익 / 지출 통계'),
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // 로그아웃
          Center(
            child: TextButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const LoginPage(),
                    ),
                    (route) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('로그아웃'),
            ),
          ),
        ],
      ),
    );
  }
}

// 공용 통계 카드 위젯
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final bool alignLeft;

  const _StatCard({
    required this.title,
    required this.value,
    this.alignLeft = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// 🔹 AI 가이드 카드 UI
class _AiGuideCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 썸네일
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: primary.withOpacity(0.12),
            ),
            child: Icon(
              Icons.play_circle_fill_rounded,
              color: primary,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          // 텍스트 영역
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DSLR 카메라 사용법',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '최근 대여한 카메라의 기본 사용법,\n'
                  '촬영 모드·조리개·셔터/ISO를 5분 안에 정리한\n'
                  '유튜브/블로그 가이드를 AI가 찾아줍니다.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.smart_toy_rounded,
                        size: 14, color: primary),
                    const SizedBox(width: 4),
                    Text(
                      '자동 크롤링',
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // 버튼
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('AI 가이드 화면은 추후 연결될 예정입니다.'),
                ),
              );
            },
            child: const Text('가이드 보기'),
          ),
        ],
      ),
    );
  }
}

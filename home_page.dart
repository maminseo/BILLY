import 'package:flutter/material.dart';

import 'item_create_page.dart';
import 'search_page.dart';
import 'chat_list_page.dart';
import 'my_page.dart';
import 'item_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _HomeTab(),
      const SearchPage(),
      const ChatListPage(),
      const MyPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      // ✅ 홈 탭에서만 플로팅 버튼 표시
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ItemCreatePage(),
                  ),
                );
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('물품 등록'),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: '홈',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search_rounded),
            label: '검색',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: '채팅',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: '마이',
          ),
        ],
      ),
    );
  }
}

/// 홈 탭: 인기 대여 물품 + 카테고리
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 데모용 더미 데이터 (나중에 Firestore로 교체 예정)
    final items = [
  {
    'title': 'DSLR 카메라 세트',
    'category': '촬영 장비',
    'price': '15,000원 /일',
    'location': '동아대 승학캠퍼스',
    'image': 'assets/images/dslr.png',
  },
  {
    'title': '전자저울',
    'category': '실험 장비',
    'price': '2,000원 /일',
    'location': '동아대 부민캠퍼스',
    'image': 'assets/images/scale.png',
  },
  {
    'title': '라즈베리 파이',
    'category': '개발/IT',
    'price': '3,000원 /일',
    'location': '부산대 부산캠퍼스',
    'image': 'assets/images/raspberry_pi.png',
  },
];


    final categories = [
      '촬영 장비',
      '실험 장비',
      '디지털 기기',
      '개발/IT',
      '교재·전공서',
    ];

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: true,
          elevation: 0,
          backgroundColor: theme.colorScheme.surface,
          title: const Text(
            'BILLY',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),

        // 상단 인사 + 검색창
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '오늘 빌려 쓰고 싶은 전공 물품은?',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  readOnly: true,
                  onTap: () {
                    // TODO: 나중에 검색 탭으로 이동 로직 연결
                  },
                  decoration: InputDecoration(
                    hintText: '물품, 전공, 키워드로 검색',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor:
                        theme.colorScheme.surfaceVariant.withOpacity(0.6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 카테고리 chips
        SliverToBoxAdapter(
          child: SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final c = categories[index];
                return FilterChip(
                  label: Text(c),
                  onSelected: (_) {
                    // 나중에 카테고리 필터 연결
                  },
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: categories.length,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // 인기 물품 리스트
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          sliver: SliverList.separated(
            itemBuilder: (context, index) {
              final item = items[index];
              return _ItemCard(
                title: item['title']!,
                category: item['category']!,
                price: item['price']!,
                location: item['location']!,
                imagePath: item['image'],
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: items.length,
          ),
        ),
      ],
    );
  }
}

/// 물품 카드 위젯
class _ItemCard extends StatelessWidget {
  final String title;
  final String category;
  final String price;
  final String location;
  final String? imagePath; // ✅ 추가

  const _ItemCard({
    required this.title,
    required this.category,
    required this.price,
    required this.location,
    this.imagePath, // ✅ 추가
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ItemDetailPage(
              title: title,
              category: category,
              price: price,
              location: location,
              imagePath: imagePath,
            ),
          ),
        );
      },
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // 썸네일 자리 (임시)
            Container(
  width: 80,
  height: 80,
  margin: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    color: theme.colorScheme.primaryContainer.withOpacity(0.7),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: imagePath != null
        ? Image.asset(
            imagePath!,
            fit: BoxFit.cover,
          )
        : const Icon(
            Icons.image_rounded,
            color: Colors.white,
          ),
  ),
),

            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 16, top: 12, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.place_rounded,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          location,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      price,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<String> _filters = ['전체', '촬영 장비', '실험 장비', '디지털 기기', '개발/IT', '기타'];
  int _selectedFilterIndex = 0;

  // 가격 필터 (데모용)
  RangeValues _priceRange = const RangeValues(0, 30000);
  final double _minPossiblePrice = 0;
  final double _maxPossiblePrice = 50000;

  // 기간 필터 (데모용)
  final List<String> _periodOptions = [
    '당일',
    '1~3일',
    '4~7일',
    '1주일+',
  ];
  int _selectedPeriodIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String _formatPrice(double value) {
      // 1000 단위로 반올림해서 "3,000원" 같이 표시 (데모용)
      final int v = (value / 1000).round() * 1000;
      return '${v.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},')}원';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('검색 및 필터'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // 검색창
            TextField(
              decoration: InputDecoration(
                hintText: '검색어를 입력하세요',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 카테고리
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '카테고리',
                style: theme.textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_filters.length, (index) {
                final selected = _selectedFilterIndex == index;
                return ChoiceChip(
                  label: Text(_filters[index]),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      _selectedFilterIndex = index;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 24),

            // 가격 / 기간 필터 카드
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '가격 / 기간 필터',
                style: theme.textTheme.labelLarge,
            ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                color: theme.colorScheme.surface,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 가격 슬라이더
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '가격대',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${_formatPrice(_priceRange.start)} ~ ${_formatPrice(_priceRange.end)}',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: _minPossiblePrice,
                    max: _maxPossiblePrice,
                    divisions: 10, // 5,000원 단위 정도 (데모용)
                    labels: RangeLabels(
                      _formatPrice(_priceRange.start),
                      _formatPrice(_priceRange.end),
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),

                  // 기간 선택
                  Text(
                    '대여 기간',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: List.generate(_periodOptions.length, (index) {
                      final selected = _selectedPeriodIndex == index;
                      return ChoiceChip(
                        label: Text(_periodOptions[index]),
                        selected: selected,
                        onSelected: (_) {
                          setState(() {
                            _selectedPeriodIndex = index;
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 적용 버튼 (실제 검색은 안 하고, UI만)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  // 여기서는 실제 검색은 안 하고 SnackBar만 띄워서 데모 느낌만!
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('데모용: 선택한 필터로 검색하는 척만 합니다 😊'),
                    ),
                  );
                },
                child: const Text('필터 적용하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

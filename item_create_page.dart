import 'package:flutter/material.dart';

class ItemCreatePage extends StatefulWidget {
  const ItemCreatePage({super.key});

  @override
  State<ItemCreatePage> createState() => _ItemCreatePageState();
}

class _ItemCreatePageState extends State<ItemCreatePage> {
  final _titleController = TextEditingController();
  final _campusController = TextEditingController(text: '동아대 승학캠퍼스');
  final _priceController = TextEditingController();
  final _depositController = TextEditingController();
  final _descController = TextEditingController();

  // 🐞 [오류 수정]: '카메라' 대신 items 리스트에 존재하는 값으로 초기화
  String _selectedCategory = '촬영 장비';

  // 🛠️ 카테고리 목록 정의
  final List<String> _categories = [
    '촬영 장비',
    '실험 장비',
    '디지털 기기',
    '개발/IT',
    '스포츠/레저',
    '생활용품',
    '도서/문구'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _campusController.dispose();
    _priceController.dispose();
    _depositController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // TODO: 실제 해커톤 때 여기서 Firestore에 저장하면 됨
    if (_titleController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 대여료는 필수입니다.')),
      );
      return;
    }

    // 임시로 성공 메시지만
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('상품이 등록되었습니다. (데모)')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 🎨 테마 색상을 사용하도록 수정
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('물품 등록'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지 업로드 자리
              GestureDetector(
                onTap: () {
                  // TODO: 실제 구현 시 이미지 선택
                },
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    // 🎨 테마 색상(primaryContainer)을 사용하도록 수정
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add_photo_alternate_outlined, 
                      size: 40,
                      // 🎨 아이콘 색상도 테마 색상을 따르도록 수정
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '물품 이름',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // 카테고리 드롭다운
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                // items 리스트를 _categories를 이용해 동적으로 생성
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category, 
                    child: Text(category),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: '카테고리',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _selectedCategory = v);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _campusController,
                decoration: const InputDecoration(
                  labelText: '거래 위치',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: '대여료 (원 / 일)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _depositController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: '보증금 (선택)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: '물품 설명',
                  hintText: '주의사항, 사용 팁, 대여 가능한 시간대 등을 적어주세요.',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  // 🎨 테마 색상을 사용하도록 수정
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _submit,
                  child: const Text('등록하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
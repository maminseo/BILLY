import 'package:flutter/material.dart';

import 'payment_page.dart';

class ChatMessage {
  final String text;
  final bool isMine;
  final bool isSystem;

  ChatMessage({
    required this.text,
    required this.isMine,
    this.isSystem = false,
  });
}

class ChatRoomPage extends StatefulWidget {
  final String roomTitle;

  /// 거래 카드에 쓸 정보 (옵션)
  final String? itemTitle;
  final String? itemPrice;
  final String? rentPeriodText;

  /// 기존 시스템 안내 문구 (옵션)
  final String? initialSystemText;

  const ChatRoomPage({
    super.key,
    required this.roomTitle,
    this.itemTitle,
    this.itemPrice,
    this.rentPeriodText,
    this.initialSystemText,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialSystemText != null) {
      _messages.add(
        ChatMessage(
          text: widget.initialSystemText!,
          isMine: false,
          isSystem: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isMine: true));
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF6957FF);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomTitle),
      ),
      body: Column(
        children: [
          // 🔹 상대방이 보낸 것처럼 보이는 “거래 계속하기” 카드
          if (widget.itemTitle != null) _buildOfferCard(themeColor, context),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                if (msg.isSystem) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg.text,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                }

                final align =
                    msg.isMine ? Alignment.centerRight : Alignment.centerLeft;
                final color = msg.isMine ? themeColor : Colors.grey.shade200;
                final textColor = msg.isMine ? Colors.white : Colors.black87;

                return Align(
                  alignment: align,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(color: textColor),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: '메시지를 입력하세요',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _send,
                    icon: Icon(Icons.send, color: themeColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 거래 계속하기 카드 (상대방 말풍선 쪽 정렬)
  Widget _buildOfferCard(Color themeColor, BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 80, 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.itemTitle!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            if (widget.itemPrice != null)
              Text(
                widget.itemPrice!,
                style: const TextStyle(fontSize: 13),
              ),
            if (widget.rentPeriodText != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.rentPeriodText!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentPage(
                        itemTitle: widget.itemTitle!,
                        price: widget.itemPrice ?? '',
                        periodText:
                            widget.rentPeriodText ?? '오늘 12:30 ~ 오늘 18:30',
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: themeColor,
                ),
                child: const Text('거래 계속하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

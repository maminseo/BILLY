import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'login_page.dart';
import 'home_page.dart';

// --- 로고에서 추출한 색상 정의 ---
// 1. primaryColor (로고 배경색: 밝은 하늘색/청록색 계열)
const Color _primaryColor = Color(0xFFA6E3F4); 
// 2. secondaryColor (로고 캐릭터색: 민트색 계열) - 포인트 색상으로 사용
const Color _secondaryColor = Color(0xFF8BE6C8); 
// ------------------------------

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BillyApp());
}

class BillyApp extends StatelessWidget {
  const BillyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BILLY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // 이 부분을 로고의 색상으로 수정했습니다.
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor, // 로고 배경색을 주 색상 Seed로 사용
          // primary: _primaryColor, // (선택 사항) 명시적으로 Primary 색상 설정
          // secondary: _secondaryColor, // (선택 사항) 명시적으로 Secondary 색상 설정
        ),
        useMaterial3: true,
        fontFamily: 'Apple SD Gothic Neo',
      ),
      home: const RootPage(),
    );
  }
}

/// 로그인 여부에 따라 LoginPage 또는 HomePage를 보여주는 루트 위젯
class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 로딩 상태
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 로그인 되어 있으면 홈, 아니면 로그인 페이지
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
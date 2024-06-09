import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seproject/dataController.dart';
import 'package:seproject/policy.dart';
import 'package:seproject/scoreControl.dart';
import 'package:seproject/gradelistpage.dart';
import 'package:seproject/reviewPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF1D43A9)), // CAU BLUE
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
          titleLarge: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        useMaterial3: true,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedRole = '김교수';
  String? _hoveredRole;
  final myController = Get.put(DataController());

  Widget roleButton(String title, IconData icon, Function onTap) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _hoveredRole = title;
        });
      },
      onExit: (event) {
        setState(() {
          _hoveredRole = null;
        });
      },
      child: ElevatedButton(
        onPressed: () => onTap(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: _hoveredRole == title ? Color(0xFF1D43A9) : Colors.white), // 아이콘 색상 반전
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: _hoveredRole == title ? Color(0xFF1D43A9) : Colors.white, // 글씨 색상 반전
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _hoveredRole == title ? Colors.white : Color(0xFF1D43A9), // 버튼 색상 반전
          elevation: 5, // 그림자 깊이
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20), // 내부 여백
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // 버튼 모서리를 둥글게 만듦
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // 배너 높이 조정
        child: AppBar(
          backgroundColor: Color(0xFF1D43A9), // CAU BLUE
          title: Center(
            child: Text(
              '중앙대학교 성적 시스템',
              style: TextStyle(
                fontSize: 28, // 텍스트 크기 조정
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),
          elevation: 10,
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF1D43A9), // CAU BLUE
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '메뉴',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  roleButton("성적 관리", Icons.grade, () {
                    if (myController.users[myController.selectedUser.value].role == '학생') {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(content: Text("학생은 성적 조회만 가능합니다."));
                      });
                    } else {
                      Get.to(CourseListPage());
                    }
                  }),
                  roleButton("정책 설정", Icons.policy, () {
                    if (myController.users[myController.selectedUser.value].role != '교수') {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(content: Text("정책 설정은 교수만 가능합니다."));
                      });
                    } else {
                      Get.to(() => PolicyPage());
                    }
                  }),
                  roleButton("성적 조회", Icons.visibility, () {
                    Get.to(() => GradeListPage());
                  }),
                  roleButton("이의 신청", Icons.error, () {
                    if (myController.users[myController.selectedUser.value].role == '학생') {
                      // 학생인 경우 이의 신청 페이지로 이동
                      Get.to(() => StudentObjectionPage());
                    } else if (myController.users[myController.selectedUser.value].role == '교수'){
                      Get.to(() => ProfessorObjectionReviewPage());
                    } else {
                      // 그 외의 경우 (조교 등), 이의 신청 접근 불가 메시지를 표시
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(content: Text("이의 신청 접근 권한이 없습니다."));
                      });
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Color(0xFFF2F2F2), // 단색 배경색
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '사용자를 선택하세요:',
                  style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFF1D43A9), width: 2),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRole,
                      dropdownColor: Colors.white, // 드롭다운 배경색
                      style: TextStyle(color: Color(0xFF1D43A9)), // 드롭다운 텍스트 색상 CAU BLUE
                      items: ['김교수', '박조교', '이학생'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: MouseRegion(
                            onEnter: (event) => setState(() {
                              _hoveredRole = value; // Hover 시 선택된 사용자 업데이트
                            }),
                            onExit: (event) => setState(() {
                              _hoveredRole = null;
                            }),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: _hoveredRole == value ? Color(0xFF1D43A9) : Colors.white,
                              ),
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: _hoveredRole == value ? Colors.white : Color(0xFF1D43A9),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRole = newValue!;
                          myController.changeRole(['김교수', '박조교', '이학생'].indexOf(newValue));
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '선택된 사용자: $_selectedRole',
                  style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CourseListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Course List"),
      ),
      body: Center(
        child: Text("Course List Page"),
      ),
    );
  }
}
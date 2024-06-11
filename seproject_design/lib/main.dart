import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dataController.dart';
import 'gradelistpage.dart';
import 'policy.dart';
import 'reviewPage.dart';
import 'scoreControl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedRole = '김교수';
  final myController = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1D43A9),
        iconTheme: IconThemeData(color: Colors.white),
        title: Center(
          child: Text(
            '중앙대학교 성적 시스템',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF1D43A9),
              ),
              child: Text(
                '메뉴',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.manage_accounts),
              title: Text('성적 관리'),
              onTap: () {
                if (myController.users[myController.selectedUser.value].role == '학생') {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("학생은 성적 조회만 가능합니다."),
                      );
                    },
                  );
                } else {
                  Get.to(CourseListPage());
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.policy),
              title: Text('정책 설정'),
              onTap: () {
                if (myController.users[myController.selectedUser.value].role == '교수') {
                  Get.to(PolicyPage());
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("정책 설정은 교수만 가능합니다."),
                      );
                    },
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.grade),
              title: Text('성적 조회'),
              onTap: () {
                Get.to(GradeListPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_late),
              title: Text('이의 신청'),
              onTap: () {
                if (myController.users[myController.selectedUser.value].role == '교수') {
                  Get.to(ProfessorObjectionReviewPage());
                } else if (myController.users[myController.selectedUser.value].role == '학생') {
                  Get.to(StudentObjectionPage());
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("이의 신청 접근 권한이 없습니다."),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '사용자를 선택하세요:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedRole,
                items: <String>['김교수', '박조교', '이학생'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                    if (newValue == '김교수') {
                      myController.changeRole(0);
                    } else if (newValue == '박조교') {
                      myController.changeRole(1);
                    } else if (newValue == '이학생') {
                      myController.changeRole(2);
                    }
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                '선택된 사용자: $_selectedRole',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

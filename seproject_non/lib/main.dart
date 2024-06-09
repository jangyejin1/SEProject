import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seproject/dataController.dart';
import 'package:seproject/gradelistpage.dart';
import 'package:seproject/policy.dart';
import 'package:seproject/reviewPage.dart';
import 'package:seproject/scoreControl.dart';

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
        title: Center(child: Text('중앙대학교 성적 시스템',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.white),)),
      ),
      body: Center(
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
                  if(newValue == '김교수'){
                    myController.changeRole(0);
                  }
                  else if(newValue == '박조교'){
                    myController.changeRole(1);
                  }
                  else if(newValue == '이학생'){
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
            SizedBox(height: 20),
            ElevatedButton(onPressed: (){
              if(myController.users[myController.selectedUser.value].role == '학생'){
                //Show push message on screen
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    content: Text("학생은 성적 조회만 가능합니다."),
                  );
                });
              }
              else{
                  Get.to(CourseListPage());
              }
            }, child: Text("성적 관리",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1D43A9), // 버튼 색상
                elevation: 5, // 그림자 깊이
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20), // 내부 여백
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // 버튼 모서리를 둥글게 만듦
                ),

              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: (){
              if(myController.users[myController.selectedUser.value].role == '교수'){
                Get.to(PolicyPage());

              }
              else{
                //Show push message on screen
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    content: Text("정책 설정은 교수만 가능합니다."),
                  );
                });
              }

            }, child: Text("정책 설정",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1D43A9), // 버튼 색상
                  elevation: 5, // 그림자 깊이
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20), // 내부 여백
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 버튼 모서리를 둥글게 만듦
                  ),

                )),
            SizedBox(height: 20),
            ElevatedButton(onPressed: (){
              Get.to(GradeListPage());

            }, child: Text("성적 조회",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1D43A9), // 버튼 색상
                  elevation: 5, // 그림자 깊이
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20), // 내부 여백
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 버튼 모서리를 둥글게 만듦
                  ),

                )),
            SizedBox(height: 20),
            ElevatedButton(onPressed: (){
              if(myController.users[myController.selectedUser.value].role == '교수'){
                Get.to(ProfessorObjectionReviewPage());
              }
              else if(myController.users[myController.selectedUser.value].role == '학생'){
                Get.to(StudentObjectionPage());
              }else{
                showDialog(context: context, builder: (context) {
                        return AlertDialog(content: Text("이의 신청 접근 권한이 없습니다."));
                      });
              }

            }, child: Text("이의 신청",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                style: ElevatedButton.styleFrom(
                  backgroundColor:Color(0xFF1D43A9), // 버튼 색상
                  elevation: 5, // 그림자 깊이
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20), // 내부 여백
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 버튼 모서리를 둥글게 만듦
                  ),

                )),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seproject/dataController.dart';



class CourseListPage extends StatelessWidget {
  final myController = Get.put(DataController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF1D43A9),
        title: Center(child: Text('과목 리스트',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
      ),
      body: ListView.builder(
        itemCount: myController.users[myController.selectedUser.value].courses.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentListPage(course: myController.users[myController.selectedUser.value].courses[index]),
                  ),
                );
              },
              title: Center(
                child: Text(
                  myController.users[myController.selectedUser.value].courses[index],
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        },
      )

    );
  }
}

class StudentListPage extends StatelessWidget {
  final String course;
  final myController = Get.put(DataController());

  StudentListPage({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF1D43A9),
        title: Center(child: Text('$course의 수강생 목록',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
      ),
      body: Obx(() {
        var students = myController.getStudentsByCourse(course);
        return ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                title: Center(
                  child: Text(
                    students[index].name,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                onTap: () {
                  Get.to(() => GradeEditPage(student: students[index], courseName: course));
                },
              ),
            );
          },
        );

      }),
    );
  }
}

class GradeEditPage extends StatefulWidget {
  final Student student;
  final String courseName;

  GradeEditPage({required this.student, required this.courseName});

  @override
  _GradeEditPageState createState() => _GradeEditPageState();
}

class _GradeEditPageState extends State<GradeEditPage> {
  late TextEditingController _controller;
  final myController = Get.find<DataController>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.student.grades[widget.courseName]?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1D43A9),
        automaticallyImplyLeading: false,
        title: Text('${widget.student.name}의 성적을 수정',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 16), // 텍스트 스타일 설정
              decoration: InputDecoration(
                labelText: '성적',
                border: OutlineInputBorder(), // 텍스트 필드 테두리 설정
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // 내부 여백 설정
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  var newGrade = double.tryParse(_controller.text) ?? 0.0;
                  myController.updateGrade(widget.student.id, widget.courseName, newGrade);
                });
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1D43A9),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // 내부 여백 설정
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // 버튼 모양 설정
                ),
              ),
              child: Text('저장', style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold)), // 버튼 텍스트 스타일 설정
            ),
          ],
        ),
      ),
    );
  }
}
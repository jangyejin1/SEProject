import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seproject/dataController.dart';

class CourseListPage extends StatelessWidget {
  final myController = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous page
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF1D43A9),
        iconTheme: IconThemeData(color: Colors.white),
        title: Center(
          child: Text(
            '과목 리스트',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: myController.users[myController.selectedUser.value].courses.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous page
          },
        ),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF1D43A9),
        title: Center(
          child: Text(
            '$course의 수강생 목록',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Obx(() {
        var students = myController.getStudentsByCourse(course);
        return ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                title: Center(
                  child: Text(
                    students[index].name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
  final myController = Get.find<DataController>();
  late List<List<TextEditingController>> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = widget.student.assignments
        .where((assignment) => assignment.course == widget.courseName)
        .map((assignment) =>
            assignment.questions.map((question) => TextEditingController(text: question.score.toString())).toList())
        .toList();
  }

  @override
  void dispose() {
    for (var controllers in _controllers) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _saveGrades() {
    setState(() {
      var assignments = widget.student.assignments.where((assignment) => assignment.course == widget.courseName).toList();
      for (int i = 0; i < assignments.length; i++) {
        var assignment = assignments[i];
        double totalScore = 0.0;
        for (int j = 0; j < assignment.questions.length; j++) {
          var newScore = double.tryParse(_controllers[i][j].text) ?? 0.0;
          assignment.questions[j].score = newScore;
          totalScore += newScore;
        }
        assignment.score = totalScore;
      }
      // 성적 업데이트 후 전체 점수 다시 계산
      var totalCourseScore = assignments.fold(0.0, (sum, assignment) => sum + assignment.score);
      myController.updateGrade(widget.student.id, widget.courseName, totalCourseScore);
    });
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    var assignments = widget.student.assignments.where((assignment) => assignment.course == widget.courseName).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous page
          },
        ),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF1D43A9),
        title: Text(
          '${widget.student.name}의 성적을 수정',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: assignments.length,
                itemBuilder: (context, index) {
                  var assignment = assignments[index];
                  return ExpansionTile(
                    title: Text(assignment.name),
                    children: assignment.questions.map((question) {
                      int questionIndex = assignment.questions.indexOf(question);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: _controllers[index][questionIndex],
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            labelText: '${question.title} 점수',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _saveGrades,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1D43A9),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                '저장',
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

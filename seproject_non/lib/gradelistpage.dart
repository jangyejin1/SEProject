import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seproject/dataController.dart';

class GradeListPage extends StatelessWidget {
  final DataController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("성적 조회")),
      body: Obx(() {
        var students = controller.currentStudents;
        var currentUser = controller.users[controller.selectedUser.value];
        bool isProfessorOrAssistant = currentUser.role == '교수' || currentUser.role == '조교';

        return ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            Student student = students[index];
            return ExpansionTile(
              title: Text(student.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: student.courses.map((course) {
                  var policy = controller.policies.firstWhere((element) => element.title == course);
                  if (!policy.show && !isProfessorOrAssistant) {
                    return Text(
                      "$course: 성적 비공개",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    );
                  }
                  int rank = controller.getRankInCourse(student, course);
                  int totalStudents = controller.getTotalStudentsInCourse(course);
                  return Text(
                    "$course: 총점: ${student.grades[course]} (순위: $rank/$totalStudents)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                }).toList(),
              ),
              children: student.courses.map((course) {
                var policy = controller.policies.firstWhere((element) => element.title == course);
                if (!policy.show && !isProfessorOrAssistant) {
                  return ListTile(
                    title: Text(course),
                    subtitle: Text("성적 비공개"),
                  );
                }
                var courseAssignments = student.assignments.where((assignment) => assignment.course == course).toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ...courseAssignments.map((assignment) => ListTile(
                      title: Text(assignment.name),
                      subtitle: Text("마감: ${assignment.deadline}, 상태: ${assignment.status}"),
                      trailing: Text("점수: ${assignment.score}"),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("과제 세부 점수: ${assignment.name}"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("평균 점수: ${assignment.average.toStringAsFixed(2)}"),
                              Text("최소 점수: ${assignment.minScore.toStringAsFixed(2)}"),
                              Text("최대 점수: ${assignment.maxScore.toStringAsFixed(2)}"),
                              Divider(),
                              Text("문항별 점수:", style: TextStyle(fontWeight: FontWeight.bold)),
                              ...assignment.questions.map((question) => Text("${question.title}: ${question.score.toStringAsFixed(2)}")).toList(),
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: Text('닫기'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      ),
                    )).toList(),
                  ],
                );
              }).toList(),
            );
          },
        );
      }),
    );
  }
}

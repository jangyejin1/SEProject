import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dataController.dart';  // DataController를 import 해야 합니다.

// 학생용 이의 신청 페이지
class StudentObjectionPage extends StatelessWidget {
  final DataController controller = Get.find<DataController>();
  final TextEditingController objectionText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("이의 신청")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: objectionText,
              decoration: InputDecoration(
                labelText: "이의 신청 내용을 입력하세요",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 여기에서 이의 신청을 DataController에 추가
                String studentName = controller.users[controller.selectedUser.value].name;
                controller.addObjection(studentName, objectionText.text);

                // 필드 초기화
                objectionText.clear();

                // 대화상자를 띄워 사용자에게 제출 완료를 알립니다
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('제출 완료'),
                      content: Text('이의신청이 성공적으로 등록되었습니다.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('확인'),
                          onPressed: () {
                            Navigator.of(context).pop();  // 대화상자 닫기
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("제출")
            )
          ],
        ),
      ),
    );
  }
}

// 교수용 이의 신청 관리 페이지
class ProfessorObjectionReviewPage extends StatelessWidget {
  final DataController controller = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("이의 신청 관리"),
        backgroundColor: Colors.blue,
      ),
      body: Obx(() => ListView.builder(
        itemCount: controller.objections.length,
        itemBuilder: (context, index) {
          final objection = controller.objections[index];
          return ListTile(
            title: Text(objection.studentName),
            subtitle: Text(objection.content),
            trailing: IconButton(
              icon: Icon(Icons.visibility),
              onPressed: () {
                // 세부 이의 신청 페이지로 이동
                Get.to(() => ObjectionDetailsPage(objection: objection));
              },
            ),
          );
        },
      )),
    );
  }
}

class ObjectionDetailsPage extends StatelessWidget {
  final Objection objection;
  ObjectionDetailsPage({required this.objection});

  @override
  Widget build(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();
    final DataController controller = Get.find<DataController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("이의 신청 세부 사항"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("학생 이름: ${objection.studentName}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("이의 신청 내용: ${objection.content}", style: TextStyle(fontSize: 16)),
            TextField(
              controller: feedbackController,
              decoration: InputDecoration(
                labelText: "피드백 입력",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.acceptObjection(objection, feedbackController.text);
                    showCompletionDialog(context, '이의 신청이 인정되었습니다.', () {
                      Navigator.of(context).pop(); // 대화상자 닫고 이전 페이지로 돌아감
                    });
                  },
                  child: Text("인정"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.rejectObjection(objection, feedbackController.text);
                    showCompletionDialog(context, '이의 신청이 반려되었습니다.', () {
                      Navigator.of(context).pop(); // 대화상자 닫고 이전 페이지로 돌아감
                    });
                  },
                  child: Text("반려"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void showCompletionDialog(BuildContext context, String message, Function onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('제출 완료'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop(); // 대화상자 닫기
              },
            ),
          ],
        );
      },
    );
  }
}
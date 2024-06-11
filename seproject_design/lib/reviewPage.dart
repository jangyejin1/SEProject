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
      appBar: AppBar(
        title: Text("이의 신청", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF1D43A9),
      ),
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
              child: Text("제출", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1D43A9),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
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
        title: Text("이의 신청 관리", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF1D43A9),
      ),
      body: Obx(() => ListView.builder(
        itemCount: controller.objections.length,
        itemBuilder: (context, index) {
          final objection = controller.objections[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: ListTile(
              title: Text(
                objection.studentName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(objection.content),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
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
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("이의 신청 세부 사항", 
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF1D43A9)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "학생 이름: ${objection.studentName}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "이의 신청 내용: ${objection.content}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
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
                  child: Text("인정", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.rejectObjection(objection, feedbackController.text);
                    showCompletionDialog(context, '이의 신청이 반려되었습니다.', () {
                      Navigator.of(context).pop(); // 대화상자 닫고 이전 페이지로 돌아감
                    });
                  },
                  child: Text("반려", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seproject/dataController.dart';

class PolicyPage extends StatefulWidget {
  @override
  _PolicyState createState() => _PolicyState();
}

class _PolicyState extends State<PolicyPage> {
  final myController = Get.put(DataController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF1D43A9),
        title: Center(child: Text('과목 정책 설정',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
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
                    builder: (context) => PolicyList(course: myController.users[myController.selectedUser.value].courses[index]),
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

class PolicyList extends StatefulWidget {
  final String course;

  PolicyList({required this.course});

  @override
  _PolicyListState createState() => _PolicyListState();
}

class _PolicyListState extends State<PolicyList> {
  final myController = Get.put(DataController());
  late TextEditingController _aPlusController;
  late TextEditingController _aController;
  late TextEditingController _bPlusController;
  late TextEditingController _bController;
  late TextEditingController _cPlusController;
  late TextEditingController _cController;
  bool _checkboxValue = false;
  int _total = 0;
  Policy subject = Policy(title: '', grades: {}, show: false);
  @override
  void initState() {
    super.initState();
    subject = myController.policies.firstWhere((element) => element.title == widget.course);
    _checkboxValue = subject.show;

    _aPlusController = TextEditingController(
      text: subject.grades['A+']?.toString() ?? '0.0',
    );
    _aController = TextEditingController(
      text: subject.grades['A']?.toString() ?? '0.0',
    );
    _bPlusController = TextEditingController(
      text: subject.grades['B+']?.toString() ?? '0.0',
    );
    _bController = TextEditingController(
      text: subject.grades['B']?.toString() ?? '0.0',
    );
    _cPlusController = TextEditingController(
      text: subject.grades['C+']?.toString() ?? '0.0',
    );
    _cController = TextEditingController(
      text: subject.grades['C']?.toString() ?? '0.0',
    );
    _total = _calculateTotal();
    _aPlusController.addListener(_updateTotal);
    _aController.addListener(_updateTotal);
    _bPlusController.addListener(_updateTotal);
    _cPlusController.addListener(_updateTotal);
    _cController.addListener(_updateTotal);
  }
  @override
  void dispose() {
    _aPlusController.dispose();
    _aController.dispose();
    _bPlusController.dispose();
    _cPlusController.dispose();
    _cController.dispose();
    super.dispose();
  }

  void _updateTotal() {
    setState(() {
      _total = _calculateTotal();
    });
  }


  int _calculateTotal() {
    int aPlus = int.tryParse(_aPlusController.text) ?? 0;
    int a = int.tryParse(_aController.text) ?? 0;
    int bPlus = int.tryParse(_bPlusController.text) ?? 0;
    int b = int.tryParse(_bController.text) ?? 0;
    int cPlus = int.tryParse(_cPlusController.text) ?? 0;
    int c = int.tryParse(_cController.text) ?? 0;

    return aPlus + a + bPlus + b + cPlus + c;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF1D43A9),
        title: Center(child: Text('${widget.course} 정책',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            buildGradeField('A+', _aPlusController),
            buildGradeField('A', _aController),
            buildGradeField('B+', _bPlusController),
            buildGradeField('C+', _cPlusController),
            buildGradeField('C', _cController),
            SizedBox(height: 20),
            Text(
              '비율 총합: $_total%',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('성적 공개 여부',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                Checkbox(
                  value: _checkboxValue,
                  onChanged: (bool? value) {
                    setState(() {
                      _checkboxValue = value ?? false;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if(_total != 100) {
                  Get.snackbar('경고', '비율의 총합이 100이 되어야 합니다.');
                  return;
                }
                else if(_total == 100){
                  setState(() {
                    // Update the grades
                    subject.grades['A+'] = int.parse(_aPlusController.text);
                    subject.grades['A'] = int.parse(_aController.text);
                    subject.grades['B+'] = int.parse(_bPlusController.text);
                    subject.grades['B'] = int.parse(_bController.text);
                    subject.grades['C+'] = int.parse(_cPlusController.text);
                    subject.grades['C'] = int.parse(_cController.text);
                    subject.show = _checkboxValue;
                  });
                  Get.back();
                  Get.snackbar('변경 완료', '성적 정책이 반영되었습니다.');
                }

              },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1D43A9),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // 내부 여백 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 버튼 모양 설정
                  ),
                ),
                child: Text('저장', style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold)) // 버튼 텍스트 스타일 설정
            ),

          ]
        ),
      )
    );
  }

  Widget buildGradeField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(), // 텍스트 필드 테두리 설정
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // 내부 여백 설정
        ),
        style: TextStyle(fontSize: 16), // 텍스트 스타일 설정
      ),
    );
  }
}

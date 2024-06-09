import 'package:get/get.dart';

class DataController extends GetxController {
  var selectedUser = 0.obs;
  var users = <User>[].obs;
  var policies = <Policy>[].obs;
  var objections = <Objection>[].obs;  // 이의 신청 목록을 RxList로 추가

  get students => null;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    fetchPolicy();
    fetchObjections();  // 이의 신청 목록 초기화
  }

  //예진-성적관리
  RxList<Student> get currentStudents {
    if (users[selectedUser.value].role == '학생') {
      return RxList<Student>.from([users[selectedUser.value] as Student]);
    } else {
      return RxList<Student>.from(users.whereType<Student>());
    }
  }

//예진-성적관리
  //총점
  double calculateTotalScore(Student student) {
    return student.assignments.fold(0.0, (total, current) => total + current.score);
  }
  
  //예진-이의신청
  //학생관련 함수
  void fetchObjections() {
    // 예제 데이터
    objections.assignAll([
      Objection(studentName: '학생 A', content: '점수가 잘못 입력되었습니다.'),
      Objection(studentName: '학생 B', content: '출석 오류가 있습니다.')
    ]);
  }
  void addObjection(String studentName, String content) {
    Objection newObjection = Objection(studentName: studentName, content: content);
    objections.add(newObjection);
    update();  // GetX 컨트롤러에서 UI 갱신을 위해 호출
  }
  
  //교수관련 함수
  void acceptObjection(Objection objection, String feedback) {
  // 이의 신청을 인정하는 로직 구현
  objection.accepted = true;
  objection.feedback = feedback;
  update();  // UI 갱신
  }
  void rejectObjection(Objection objection, String feedback) {
  // 이의 신청을 반려하는 로직 구현
  objection.accepted = false;
  objection.feedback = feedback;
  update();  // UI 갱신
  }

  void fetchUsers() {
    // 예시 데이터를 추가합니다.
    users.assignAll([
      User(name: '김교수', role: '교수', id: 1, permission: true, courses: ['소프트웨어공학', '컴퓨터구조']),
      User(name: '박조교', role: '조교', id: 2, permission: true, courses: ['소프트웨어공학']),
      Student(name: '이학생', role: '학생', id: 3, permission: false, courses: ['소프트웨어공학','컴퓨터구조'], grades: {'소프트웨어공학':90, '컴퓨터구조':80},
      //예진
      assignments: [
        Assignment(
          name: "과제1", 
          deadline: "2023-09-30", 
          status: "제출 완료", 
          score: 85,
          average: 58,
          minScore: 0,
          maxScore: 90,
          questions: [
            Question(title: "문제1", score: 40),
            Question(title: "문제2", score: 45)
          ]
        ),
        Assignment(
          name: "과제2", 
          deadline: "2023-10-15", 
          status: "미제출", 
          score: 0,
          average: 67,
          minScore: 3,
          maxScore: 98,
          questions: [
            Question(title: "문제1", score: 50)
          ]
        ),
      ]
    ),
    Student(name: '유학생', role: '학생', id: 4, permission: false, courses: ['소프트웨어공학','컴퓨터구조'], grades: {'소프트웨어공학':78, '컴퓨터구조':67},
      //예진
      assignments: [
        Assignment(
          name: "과제1", 
          deadline: "2023-09-30", 
          status: "제출 완료", 
          score: 80,
          average: 58,
          minScore: 0,
          maxScore: 90,
          questions: [
            Question(title: "문제1", score: 40),
            Question(title: "문제2", score: 40)
          ]
        ),
        Assignment(
          name: "과제2", 
          deadline: "2023-10-15", 
          status: "제출 완료", 
          score: 98,
          average: 67,
          minScore: 3,
          maxScore: 98,
          questions: [
            Question(title: "문제1", score: 98)
          ]
        ),
      ]
    )
  ]);//-예진
  }

  void fetchPolicy(){
    policies.assignAll([
      Policy(title: '소프트웨어공학', grades: {'A+': 10, 'A': 25, 'B+': 20, 'B': 20, 'C+': 15, 'C': 10}, show: false),
      Policy(title: '컴퓨터구조', grades: {'A+': 12, 'A': 23, 'B+': 25, 'B': 15, 'C+': 15, 'C': 10}, show: false),
    ]);
  }

  int calculateRate(Policy subject){
    int total = 0;
    subject.grades.forEach((key, value) {
      total += value;
    });
    return total;
  }

  void changeRole(int role) {
    selectedUser.value = role;
  }

  void checkGrades(Student student) {
    if (student.grades.containsKey('소프트웨어공학')) {
      double? softwareEngineeringGrade = student.grades['소프트웨어공학'];
      print('소프트웨어공학 성적: $softwareEngineeringGrade');
    } else {
      print('소프트웨어공학 과목이 존재하지 않습니다.');
    }
  }

  void updateGrade(int studentId, String course, double grade) {
    var student = users.firstWhere((user) => user.id == studentId && user is Student) as Student;
    student.grades[course] = grade;
    users.refresh();
  }

  List<Student> getStudentsByCourse(String course) {
    return users.where((user) => user is Student && user.courses.contains(course)).map((user) => user as Student).toList();
  }
}

class User {
  String name;
  String role;
  int id;
  bool permission;
  List<String> courses;

  User({required this.name, required this.role, required this.id, required this.permission, required this.courses});
}


//예진
class Question {
  String title;
  double score;  // 이 문제에서 얻을 수 있는 최대 점수

  Question({required this.title, required this.score});
}

//예진
class Assignment {
  String name;
  String deadline;
  String status;
  double score;
  double average;
  double minScore;
  double maxScore;
  List<Question> questions;  // 이 과제에 포함된 문제들의 목록
  
  Assignment({
    required this.name, 
    required this.deadline, 
    required this.status, 
    required this.score,     
    required this.average,
    required this.minScore,
    required this.maxScore, 
    required this.questions});
}
//예진-이의신청
class Objection {
  String studentName;
  String content;
  bool accepted = false;
  String feedback = '';

  Objection({required this.studentName, required this.content});
}


class Student extends User {
  Map<String, double> grades;
  //예진
  List<Assignment> assignments;  // 과제 목록을 추가
  
  Student({
    required String name,
    required String role,
    required int id,
    required bool permission,
    required List<String> courses,
    required this.grades,
    //예진
    this.assignments = const [],  // 초기값으로 빈 리스트를 제공
  }) : super(name: name, role: role, id: id, permission: permission, courses: courses);
}

class Policy{
  String title;
  Map<String, int> grades;
  bool show;

  String returnPolicy(){
    String result = '';
    grades.forEach((key, value) {
      result += '$key: $value ';
    });
    return result;
  }

  String returnShow(){
    if(show == true){
      return '성적 공개';
    }
    else{
      return '성적 비공개';
    }
  }
  
  Policy({required this.title, required this.grades, required this.show});
}


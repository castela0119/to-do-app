import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _toDoList = [];
  final TextEditingController _dialogTextController = TextEditingController();

  void _showAddToDoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('할 일 추가'),
          content: TextField(
            controller: _dialogTextController,
            decoration: const InputDecoration(
              hintText: '할 일을 입력하세요',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                if (_dialogTextController.text.isNotEmpty) {
                  setState(() {
                    _toDoList.add({
                      'task': _dialogTextController.text,
                      'isCompleted': false,
                    });
                    _dialogTextController.clear();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }

  void _toggleCompletion(int index) {
    setState(() {
      // Toggle the completion status of the task
      _toDoList[index]['isCompleted'] = !_toDoList[index]['isCompleted'];
    });
  }


  void _deleteToDoItem(int index) {
    setState(() {
      _toDoList.removeAt(index);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
          children: const [
            Icon(Icons.description), // 문서 아이콘
            SizedBox(width: 8), // 아이콘과 텍스트 간격
            Text('TO-DO-LIST'), // 텍스트
          ],
        ),
        centerTitle: true, // 제목을 중앙 정렬
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_toDoList.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    '할 일이 없습니다. 추가 버튼을 눌러보세요!',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _toDoList.length,
                  itemBuilder: (context, index) {
                    final toDoItem = _toDoList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: Checkbox(
                          value: toDoItem['isCompleted'],
                          activeColor: Colors.green, // 체크 시 초록색으로 표시
                          onChanged: (value) {
                            _toggleCompletion(index);
                          },
                        ),
                        title: Text(
                          toDoItem['task'],
                          style: TextStyle(
                            decoration: toDoItem['isCompleted']
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteToDoItem(index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddToDoDialog,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

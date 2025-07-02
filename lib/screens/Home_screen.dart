import 'package:flutter/material.dart';
import 'package:task_buddy/Constants/app_colors.dart';
import 'package:task_buddy/Constants/app_texts.dart';
import 'package:task_buddy/Constants/app_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_buddy/screens/Add%20new%20task.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? userData;

  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'UI/UX Design Task',
      'date': '1 Feb, 2025',
      'category': 'Work',
      'color': Colors.blue,
      'status': 'To-do',
    },
    {
      'title': 'Submit project report',
      'date': '1 Feb, 2025',
      'category': 'Education',
      'color': Colors.purple,
      'status': 'To-do',
    },
    {
      'title': 'Read 10 pages of a book',
      'date': '1 Feb, 2025',
      'category': 'Personal',
      'color': Colors.orange,
      'status': 'To-do',
    },
    {
      'title': 'Buy groceries for the week',
      'date': '1 Feb, 2025',
      'category': 'Home',
      'color': Colors.green,
      'status': 'To-do',
    },
    {
      'title': 'Presentation in progress',
      'date': '1 Feb, 2025',
      'category': 'Work',
      'color': Colors.blue,
      'status': 'In-Progress',
    },
    {
      'title': 'Task Completed Sample',
      'date': '1 Feb, 2025',
      'category': 'Work',
      'color': Colors.red,
      'status': 'Completed',
    },
    {
      'title': 'Submit Taxes',
      'date': '1 Feb, 2025',
      'category': 'Home',
      'color': Colors.green,
      'status': 'Completed',
    },
    {
      'title': 'Go to Gym',
      'date': '1 Feb, 2025',
      'category': 'Personal',
      'color': Colors.orange,
      'status': 'Completed',
    },
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    fetchUserData();
    super.initState();
  }

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        setState(() {
          userData = doc.data();
        });
      }
    }
  }

  List<Map<String, dynamic>> getTasks(String status) {
    return tasks.where((task) => task['status'] == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final name = userData?['name'] ?? 'Guest';
    final photoUrl = userData?['photoUrl'];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: photoUrl != null
                  ? NetworkImage(photoUrl)
                  :null
              //    : const AssetImage('assets/images/default_user.png') as ImageProvider,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome, $name", style: AppTextStyles.headerSmall),
                Text(
                  "Prioritize. Plan. Achieve.",
                  style: AppTextStyles.bodySmall!.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.person, color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: Colors.black54,
          indicatorColor: AppColors.primaryColor,
          tabs: [
            Tab(text: "To-do (${getTasks("To-do").length})"),
            Tab(text: "In-Progress (${getTasks("In-Progress").length})"),
            Tab(text: "Completed (${getTasks("Completed").length})"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildTaskList(getTasks("To-do")),
          buildTaskList(getTasks("In-Progress")),
          buildTaskList(getTasks("Completed")),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddTaskPage(),
                          ),
                        );
        },
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildTaskList(List<Map<String, dynamic>> taskList) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        final task = taskList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 1,
          child: ListTile(
            leading: Checkbox(value: false, onChanged: (_) {}),
            title: Text(task['title'], style: AppTextStyles.taskTitle),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task['date'], style: AppTextStyles.taskDate),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: task['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task['category'],
                        style: TextStyle(
                          color: task['color'],
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            trailing: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: task['color'],
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
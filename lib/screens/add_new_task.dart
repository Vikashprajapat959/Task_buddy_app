import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  String taskTitle = '';
  String taskDescription = '';
  String selectedCategory = 'Work';
  DateTime? deadline;
  String selectedPriority = 'Low';

  List<String> categories = [
    'Work',
    'Education',
    'Shopping',
    'Personal',
    'Home',
    'Custom'
  ];

  List<String> priorities = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6EDF9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Text(
          'Add new task',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildLabel('Title'),
              buildTextField(
                hintText: 'Enter task title',
                onSaved: (val) => taskTitle = val!,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Please enter a title' : null,
              ),
              SizedBox(height: 16),
              buildLabel('Description'),
              buildTextField(
                hintText: 'Enter Description here...',
                maxLines: 3,
                onSaved: (val) => taskDescription = val!,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Please enter a description' : null,
              ),
              SizedBox(height: 20),
              buildLabel('Select Category'),
              Wrap(
                spacing: 10,
                children: categories.map((category) {
                  final isSelected = category == selectedCategory;
                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    selectedColor: Colors.deepPurple,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    backgroundColor: Colors.grey[200],
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              buildLabel('Deadline'),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: deadline ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2050),
                  );
                  if (picked != null) {
                    setState(() {
                      deadline = picked;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: deadline == null
                          ? 'Select Date'
                          : DateFormat('dd/MM/yyyy').format(deadline!),
                      prefixIcon: Icon(Icons.calendar_today),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              buildLabel('Set Priority'),
              Row(
                children: priorities.map((level) {
                  return Expanded(
                    child: RadioListTile<String>(
                      title: Text(level),
                      value: level,
                      activeColor: Colors.deepPurple,
                      groupValue: selectedPriority,
                      onChanged: (value) {
                        setState(() {
                          selectedPriority = value!;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Handle save
                    print('Task Saved: $taskTitle - $taskDescription');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Save Task!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }

  Widget buildTextField({
    String? hintText,
    int maxLines = 1,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      maxLines: maxLines,
      onSaved: onSaved,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
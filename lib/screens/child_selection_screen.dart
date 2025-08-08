import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../services/db_service.dart';
import 'subtest_screen.dart';

class ChildSelectionScreen extends StatefulWidget {
  const ChildSelectionScreen({super.key});

  @override
  State<ChildSelectionScreen> createState() => _ChildSelectionScreenState();
}

class _ChildSelectionScreenState extends State<ChildSelectionScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> children = [];
  List<Map<String, dynamic>> adults = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final db = Provider.of<DbService>(context, listen: false);
    final childrenList = await db.getChildren();
    final adultsList = await db.getAdults();
    setState(() {
      children = childrenList;
      adults = adultsList;
    });
  }

  final _first = TextEditingController();
  final _last = TextEditingController();
  DateTime? _picked;

  @override
  void dispose() {
    _tabController.dispose();
    _first.dispose();
    _last.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختيار المستخدم'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'الأطفال'),
            Tab(text: 'البالغين'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChildrenTab(),
          _buildAdultsTab(),
        ],
      ),
    );
  }

  Widget _buildChildrenTab() {
    return Column(
      children: [
        if (children.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                const Icon(Icons.people, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'الأطفال الحاليين (${children.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
        ],
        Expanded(
          child: children.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.child_care, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'لا يوجد أطفال مسجلين',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        'يمكنك إضافة طفل جديد من الأسفل',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: children.length,
                  itemBuilder: (c, i) {
                    final ch = children[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            '${ch['firstName'][0]}${ch['lastName'][0]}',
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                        title: Text('${ch['firstName']} ${ch['lastName']}'),
                        subtitle: Text(
                            'تاريخ الميلاد: ${ch['dob']?.substring(0, 10) ?? ''}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SubtestScreen(childMap: ch)));
                        },
                      ),
                    );
                  },
                ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: _buildAddForm(isChild: true),
        ),
      ],
    );
  }

  Widget _buildAdultsTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: adults.length,
            itemBuilder: (c, i) {
              final adult = adults[i];
              return ListTile(
                title: Text('${adult['firstName']} ${adult['lastName']}'),
                subtitle: Text(adult['dob'] ?? ''),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SubtestScreen(childMap: adult)));
                },
              );
            },
          ),
        ),
        _buildAddForm(isChild: false),
      ],
    );
  }

  Widget _buildAddForm({required bool isChild}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
              controller: _first,
              decoration: const InputDecoration(labelText: 'الاسم')),
          TextField(
              controller: _last,
              decoration: const InputDecoration(labelText: 'الكنية')),
          Row(
            children: [
              Expanded(
                  child: Text(_picked == null
                      ? 'تاريخ الميلاد'
                      : _picked!.toIso8601String().split('T').first)),
              ElevatedButton(
                  onPressed: () async {
                    final d = await showDatePicker(
                        context: context,
                        initialDate: isChild ? DateTime(2016) : DateTime(1990),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now());
                    if (d != null) setState(() => _picked = d);
                  },
                  child: const Text('اختار تاريخ'))
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                if (_first.text.isEmpty ||
                    _last.text.isEmpty ||
                    _picked == null) return;
                final db = Provider.of<DbService>(context, listen: false);

                if (isChild) {
                  await db.insertChild({
                    'firstName': _first.text,
                    'lastName': _last.text,
                    'dob': _picked!.toIso8601String()
                  });
                } else {
                  await db.insertAdult({
                    'firstName': _first.text,
                    'lastName': _last.text,
                    'dob': _picked!.toIso8601String()
                  });
                }

                _first.clear();
                _last.clear();
                _picked = null;
                await _loadData();
              },
              child: Text(isChild ? 'أضف طفل' : 'أضف بالغ'))
        ],
      ),
    );
  }
}

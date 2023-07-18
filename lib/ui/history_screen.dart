import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.history});

  final List<String> history;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History Screen"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  widget.history.clear();

                });
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: Column(
        children: [
          ...List.generate(
              widget.history.length,
              (index) => ListTile(
                    title: Text(widget.history[index]),
                  )),
        ],
      ),
    );
  }
}

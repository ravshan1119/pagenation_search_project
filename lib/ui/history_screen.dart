import 'package:flutter/material.dart';
import 'package:pagenation_search_brawser/data/local/shared_pref.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.history});

  final List<String> history;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<String> historys = [];

  @override
  void initState() {
    for (int i = 0; i < widget.history.length; i++) {
      historys.add(StorageRepository.getString(widget.history[i]));
    }
    super.initState();
  }

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
                  historys.clear();
                });
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: Column(
        children: [
          ...List.generate(
              historys.length,
              (index) => GestureDetector(
                    onLongPress: () {
                      StorageRepository.deleteString(historys[index]);
                      historys.remove(historys[index]);
                      final snackBar = SnackBar(
                        content: const Text('delete this history'),
                        action: SnackBarAction(
                          label: 'ok',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );

                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      setState(() {});
                    },
                    child: ListTile(
                      title: Text(widget.history[index]),
                      leading: GestureDetector(
                          onTap: () {
                          },
                          child: Icon(
                            Icons.highlight_remove_sharp,
                            color: Colors.red.shade500,
                          )),
                    ),
                  )),
        ],
      ),
    );
  }
}

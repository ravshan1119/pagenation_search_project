import 'package:flutter/material.dart';
import 'package:pagenation_search_brawser/data/local/shared_pref.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.history, required this.voidCallback});

  final List<String> history;
  final VoidCallback voidCallback;

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
                  widget.history.clear();
                  widget.voidCallback.call();
                });
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(
                historys.length,
                (index) => GestureDetector(
                      child: ListTile(
                        title: Text(widget.history[index]),
                        leading: GestureDetector(
                            onTap: () {},
                            child: IconButton(onPressed: (){
                              StorageRepository.deleteString(historys[index]);
                              historys.remove(historys[index]);
                              widget.history.remove(historys[index]);
                              const snackBar = SnackBar(
                                content: Text('delete this history'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              setState(() {
                                widget.voidCallback.call();

                              });
                            }, icon: Icon(Icons.highlight_remove,color: Colors.red.shade400,))),
                      ),
                    )),
          ],
        ),
      ),
    );
  }
}

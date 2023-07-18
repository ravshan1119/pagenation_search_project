import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pagenation_search_brawser/data/local/shared_pref.dart';
import 'package:pagenation_search_brawser/data/model/google_search_model.dart';
import 'package:pagenation_search_brawser/data/model/organic_model.dart';
import 'package:pagenation_search_brawser/data/model/universal_data.dart';
import 'package:pagenation_search_brawser/data/network/api_provider.dart';
import 'package:pagenation_search_brawser/ui/history_screen.dart';
import 'package:pagenation_search_brawser/ui/widgets/search_screen_shimmer.dart';
import 'package:pagenation_search_brawser/utils/app_images.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController queryController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  int currentPage = 1;
  int countOfPage = 5;
  String queryText = "";
  bool isLoading = false;
  List<String> history = [];

  List<OrganicModel> organicModels = [];

  _fetchResult() async {
    setState(() {
      isLoading = true;
    });
    UniversalData universalData = await ApiProvider.searchGoogle(
      query: queryText,
      page: currentPage,
      count: countOfPage,
    );

    setState(() {
      isLoading = false;
    });

    if (universalData.error.isEmpty) {
      GoogleSearchModel googleSearchModel =
          universalData.data as GoogleSearchModel;
      organicModels.addAll(googleSearchModel.organicModels);
      setState(() {});
    }
    currentPage++;
  }

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _fetchResult();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HistoryScreen(
                              history: history,
                              voidCallback: () {
                                setState(() {});
                              },
                            )));
              },
              icon: const Icon(
                Icons.history,
                color: Colors.grey,
              ))
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.logo,
                height: 32,
                width: 92,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) {
                queryText = v;
              },
              onSubmitted: (v) {
                setState(() {
                  StorageRepository.putString(queryText, queryText);
                  history.add(queryText);
                  organicModels = [];
                  currentPage = 1;
                });
                _fetchResult();
              },
              controller: queryController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      queryController.clear();
                    },
                    icon: const Icon(
                      CupertinoIcons.multiply,
                      color: Colors.grey,
                    ),
                  ),
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 2,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ))),
              textInputAction: TextInputAction.search,
            ),
          ),
          SizedBox(
            height: 40,
            width: double.infinity,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                ...List.generate(
                    history.length,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                StorageRepository.putString(
                                    queryText, queryText);
                                history.add(queryText);
                                organicModels = [];
                                currentPage = 1;
                                queryController.text = queryText;
                              });
                              _fetchResult();
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(history[index]),
                              )),
                            ),
                          ),
                        ))
              ],
            ),
          ),
          Expanded(
              child: ListView(
            controller: scrollController,
            children: [
              ...List.generate(organicModels.length, (index) {
                OrganicModel organicModel = organicModels[index];
                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(16)),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        organicModel.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      Text(organicModel.snippet),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          organicModel.link,
                          maxLines: 1,
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                      Text(organicModel.date),
                    ],
                  ),
                );
              }),
              Visibility(
                visible: isLoading,
                child: const Center(
                  child: SearchScreenShimmer(),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

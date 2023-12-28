import 'package:flutter/material.dart';
import 'dart:math';

import 'package:pagination_project/pagination_widget.dart';

String generateRandomString(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  Random random = Random();
  String randomString = '';

  for (int i = 0; i < length; i++) {
    randomString += chars[random.nextInt(chars.length)];
  }

  return randomString;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<BookItem>> bookData = [];
  int currentPage = 1;
  bool isLoading = false;

  final totalPage = 100;
  final pageSize = 10;

  @override
  void initState() {
    super.initState();
    initRandomData();
  }

  void initRandomData() {
    for (int i = 0; i < totalPage; i++) {
      List<BookItem> pageList = [];

      for (int j = 0; j < pageSize; j++) {
        String title = generateRandomString(10);
        String description = "";
        for (int k = 0; k < 10; k++) {
          description += " ${generateRandomString(10)}";
        }
        String imageUrl = "https://picsum.photos/300/300";
        pageList.add(BookItem(
          title: title,
          description: description,
          imageUrl: imageUrl,
        ));
      }

      bookData.add(pageList);
    }

    loadData();
  }

  void loadData() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: bookData.isEmpty
                ? Container(
                    width: double.infinity,
                  )
                : isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ListView(
                          children: bookData[currentPage - 1].map((item) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Material(
                                clipBehavior: Clip.antiAlias,
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blueAccent,
                                elevation: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        item.imageUrl,
                                        width: 100,
                                        height: 100,
                                      ),
                                      const SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            item.description,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
          ),
          PaginationWidget(
            currentPage: currentPage,
            totalPage: totalPage,
            onPageClick: (page) {
              setState(() {
                currentPage = page;
              });
            },
            onNextClick: () {
              setState(() {
                currentPage = currentPage + 1;
              });
            },
            onPreviousClick: () {
              setState(() {
                currentPage = currentPage - 1;
              });
            },
            onLastPageClick: () {
              setState(() {
                currentPage = totalPage;
              });
            },
            onFirstPageClick: () {
              setState(() {
                currentPage = 1;
              });
            },
          ),
        ],
      ),
    );
  }
}

class BookItem {
  final String title;
  final String description;
  final String imageUrl;

  BookItem({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

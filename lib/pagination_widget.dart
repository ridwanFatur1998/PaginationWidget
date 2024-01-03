import 'package:flutter/material.dart';

enum Area { lowerArea, middleArea, higherArea }

class PaginationWidget extends StatelessWidget {
  final int totalPage;
  final int currentPage;
  final Function(int) onPageClick;
  final VoidCallback onNextClick;
  final VoidCallback onPreviousClick;
  final VoidCallback onLastPageClick;
  final VoidCallback onFirstPageClick;

  /// must be odd number and higher than 3
  final int boxCount;

  const PaginationWidget({
    super.key,
    required this.totalPage,
    required this.currentPage,
    required this.onPageClick,
    required this.onNextClick,
    required this.onPreviousClick,
    required this.onLastPageClick,
    required this.onFirstPageClick,
    this.boxCount = 9,
  });

  List<Widget> boxWidgetsList() {
    if (totalPage <= boxCount) {
      return List.generate(totalPage, (index) {
        return boxWidget(
          clickable: true,
          numberPage: index + 1,
          selectedPage: index + 1 == currentPage,
        );
      });
    }

    return List.generate(boxCount, (index) {
      final area = () {
        final divider1 = boxCount / 2;
        final divider2 = totalPage - boxCount / 2;
        if (currentPage < divider1) {
          return Area.lowerArea;
        } else if (currentPage > divider2) {
          return Area.higherArea;
        } else {
          return Area.middleArea;
        }
      }();

      int numberPage = () {
        if (index == 0) return 1;
        if (index == boxCount - 1) return totalPage;

        if (index == 1) {
          switch (area) {
            case Area.lowerArea:
              return 2;
            case Area.middleArea:
              return -1;
            case Area.higherArea:
              return -1;
          }
        }

        if (index == boxCount - 2) {
          switch (area) {
            case Area.lowerArea:
              return -1;
            case Area.middleArea:
              return -1;
            case Area.higherArea:
              return totalPage - 1;
          }
        }

        // index below is between (2, totalPage - 2) , inclusive
        final middleIndex = (boxCount / 2).floor();

        switch (area) {
          case Area.lowerArea:
            return 1 + index;
          case Area.middleArea:
            return currentPage + (index - middleIndex);
          case Area.higherArea:
            return (totalPage - (boxCount - 1)) + index;
        }
      }();

      bool selectedPage = numberPage == currentPage;
      bool clickable = numberPage != -1;

      return boxWidget(
        clickable: clickable,
        numberPage: numberPage,
        selectedPage: selectedPage,
      );
    });
  }

  Widget boxWidget({
    required bool clickable,
    required int numberPage,
    required bool selectedPage,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: clickable
            ? () {
                if (numberPage == 1) {
                  onFirstPageClick();
                } else if (numberPage == totalPage) {
                  onLastPageClick();
                } else {
                  onPageClick(numberPage);
                }
              }
            : null,
        splashFactory: InkRipple.splashFactory,
        child: Material(
          clipBehavior: Clip.antiAlias,
          color: selectedPage ? Colors.blue : Colors.white,
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Text(
              numberPage == -1 ? "..." : "$numberPage",
              style: TextStyle(
                color: selectedPage ? Colors.white : Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: currentPage == 1
                  ? null
                  : () {
                      onPreviousClick();
                    },
              child: const Text("Prev"),
            ),
            ...boxWidgetsList(),
            ElevatedButton(
              onPressed: currentPage == totalPage
                  ? null
                  : () {
                      onNextClick();
                    },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}

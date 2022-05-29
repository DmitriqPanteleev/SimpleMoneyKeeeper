import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_keeper/color_palette.dart';
import 'package:money_keeper/controllers/db.dart';
import 'package:money_keeper/ui/screens/add_trans_screen.dart';
import 'package:money_keeper/ui/widgets/text_widgets.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  DBHelper dbHelper = DBHelper();
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;
  DateTime today = DateTime.now();
  List<FlSpot> plotPoints = [];

  List<FlSpot> getPlotPoints(Map entireData) {
    plotPoints = [];
    entireData.forEach((key, value) {
      if (value['type'] == "Expense" &&
          (value['date'] as DateTime).month == today.month) {
        plotPoints.add(
          FlSpot(
            (value['date'] as DateTime).day.toDouble(),
            (value['amount'] as int).toDouble(),
          ),
        );
      }
    });
    return plotPoints;
  }

  void getTotalBalance(Map entireData) {
    totalBalance = 0;
    totalIncome = 0;
    totalExpense = 0;
    entireData.forEach((key, value) {
      if (value['type'] == "Income") {
        totalBalance += (value['amount'] as int);
        totalIncome += (value['amount'] as int);
      } else {
        totalBalance -= (value['amount'] as int);
        totalExpense += (value['amount'] as int);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: ((context) => const AddTransactionScreen())))
              .whenComplete(() {
            setState(() {});
          });
        },
        backgroundColor: CustomColors.brown,
        splashColor: Colors.white70,
        child: const Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      body: FutureBuilder<Map>(
          future: dbHelper.fetch(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: HeadLineText(title: "Ошибка!"));
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                    child: HeadLineText(title: "Значений нет!"));
              }
              getPlotPoints(snapshot.data!);
              getTotalBalance(snapshot.data!);
              return ListView(
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: const EdgeInsets.all(12),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.topCenter,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [CustomColors.beige, CustomColors.brown]),
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                      child: Column(
                        children: <Widget>[
                          const DescText(
                            title: "Баланс",
                            color: Colors.white,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          DescText(
                            title: "$totalBalance ₽",
                            color: Colors.white,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _cardIncome(context, totalIncome.toString()),
                              _cardExpense(context, totalExpense.toString())
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: HeadLineText(title: "График трат"),
                  ),
                  plotPoints.length < 2
                      ? Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(30),
                          margin: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: CustomColors.red, width: 1),
                              borderRadius: BorderRadius.circular(15)),
                          child: const DescText(
                              title:
                                  "Недостаточно точек для построения графика. Убедитесь, что точек больше, чем две"))
                      : Container(
                          padding: const EdgeInsets.all(30),
                          margin: const EdgeInsets.all(24),
                          height: 400,
                          child: LineChart(
                            LineChartData(
                              titlesData: FlTitlesData(
                                bottomTitles:
                                    AxisTitles(drawBehindEverything: false),
                                topTitles:
                                    AxisTitles(drawBehindEverything: false),
                                leftTitles:
                                    AxisTitles(drawBehindEverything: true),
                                rightTitles:
                                    AxisTitles(drawBehindEverything: false),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  show: snapshot.data!.isEmpty ? false : true,
                                  barWidth: 1,
                                  isCurved: true,
                                  curveSmoothness: 0.3,
                                  color: CustomColors.orange,
                                  spots: getPlotPoints(snapshot.data!),
                                ),
                              ],
                            ),
                          ),
                        ),
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: HeadLineText(title: "Последние транзакции"),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          snapshot.data!.length > 5 ? 5 : snapshot.data!.length,
                      itemBuilder: (context, index) {
                        int lengthOfMap = snapshot.data!.length;
                        Map dataAtIndex =
                            snapshot.data![lengthOfMap - index - 1];
                        if (dataAtIndex['type'] == "Income") {
                          return _incomeTile(context, dataAtIndex['amount'],
                              dataAtIndex['note']);
                        }
                        return _expenseTile(context, dataAtIndex['amount'],
                            dataAtIndex['note']);
                      }),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ],
              );
            } else {
              return const Center(child: HeadLineText(title: "Ошибка!"));
            }
          }),
    );
  }
}

//
// Widgets for a current screen
Widget _cardIncome(BuildContext context, String value) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            color: Colors.white),
        child: const Icon(Icons.arrow_upward, color: CustomColors.green),
      ),
      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
      DescText(
        title: "$value ₽",
        color: Colors.white,
      )
    ],
  );
}

Widget _cardExpense(BuildContext context, String value) {
  return Row(
    children: [
      DescText(
        title: "$value ₽",
        color: Colors.white,
      ),
      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
      Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            color: Colors.white),
        child: const Icon(Icons.arrow_downward, color: CustomColors.red),
      ),
    ],
  );
}

Widget _expenseTile(BuildContext context, int value, String note) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Colors.white, CustomColors.brown],
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  color: Colors.transparent),
              child: const Icon(
                Icons.arrow_downward,
                color: CustomColors.red,
                size: 20,
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            DescText(
              title: note,
              color: Colors.black54,
            )
          ],
        ),
        ButtonText(
          title: "- $value",
          color: Colors.white,
        )
      ],
    ),
  );
}

Widget _incomeTile(BuildContext context, int value, String note) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Colors.white, CustomColors.brown],
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  color: Colors.transparent),
              child: const Icon(
                Icons.arrow_upward,
                color: CustomColors.green,
                size: 20,
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            DescText(
              title: note,
              color: Colors.black54,
            )
          ],
        ),
        ButtonText(
          title: "$value",
          color: Colors.white,
        )
      ],
    ),
  );
}

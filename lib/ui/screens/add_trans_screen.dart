import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_keeper/color_palette.dart';
import 'package:money_keeper/controllers/db.dart';
import 'package:money_keeper/ui/widgets/text_widgets.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  //
  int? amount;
  String note = "Some Expense";
  String type = "Income";
  DateTime date = DateTime.now();
  //

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2020, 12),
        lastDate: DateTime.now());

    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  child: const HeadLineText(title: "Добавить транзакцию"),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                const DescText(title: "Введите сумму"),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                // Input of sum
                Row(
                  children: <Widget>[
                    const Icon(Icons.attach_money),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: CustomColors.black,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 155, 155, 155),
                            ),
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          hintText: "0 RUB",
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          try {
                            amount = int.parse(value);
                          } catch (e) {}
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                const DescText(title: "Введите описание"),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  children: <Widget>[
                    const Icon(Icons.description),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: CustomColors.black,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 155, 155, 155),
                            ),
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          hintText: "Я потратил/заработал на...",
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          note = value;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                const DescText(title: "Тип транзакции"),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  children: <Widget>[
                    const Icon(Icons.moving_sharp),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    ChoiceChip(
                      label:
                          const ButtonText(title: "Доход", color: Colors.white),
                      selected: type == "Income" ? true : false,
                      selectedColor: CustomColors.green,
                      disabledColor: CustomColors.black,
                      onSelected: (value) {
                        setState(() {
                          type = "Income";
                        });
                      },
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                    ChoiceChip(
                      label: const ButtonText(
                          title: "Расход", color: Colors.white),
                      selected: type == "Expense" ? true : false,
                      selectedColor: CustomColors.red,
                      disabledColor: CustomColors.black,
                      onSelected: (value) {
                        setState(() {
                          type = "Expense";
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                const DescText(title: "Время транзакции"),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  children: <Widget>[
                    const Icon(Icons.date_range),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Expanded(
                        child: Text(
                      "${date.day}.${date.month}.${date.year}",
                      style: const TextStyle(
                          color: CustomColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                    )),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: const Text("Выбрать дату",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.white70),
                        backgroundColor:
                            MaterialStateProperty.all(CustomColors.brown),
                        fixedSize: MaterialStateProperty.all(
                          Size(
                            MediaQuery.of(context).size.width * 0.4,
                            MediaQuery.of(context).size.width * 0.1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                ElevatedButton(
                  onPressed: () async {
                    if (amount != null && note.isNotEmpty) {
                      DBHelper dbHelper = DBHelper();
                      await dbHelper.addData(amount!, date, note, type);
                      Navigator.of(context).pop();
                    } else {
                      showCupertinoDialog(
                          context: context,
                          builder: ((context) => AlertDialog(
                                title: const DescText(
                                    title: "Необходимо заполнить все поля"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const ButtonText(title: "Назад"))
                                ],
                              )));
                    }
                  },
                  child:
                      const ButtonText(title: "Добавить", color: Colors.white),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.white70),
                    backgroundColor:
                        MaterialStateProperty.all(CustomColors.brown),
                    fixedSize: MaterialStateProperty.all(
                      Size(
                        MediaQuery.of(context).size.width * 0.6,
                        MediaQuery.of(context).size.width * 0.15,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/chart.dart';
import 'package:flutter_complete_guide/widgets/new_transaction.dart';
import 'package:flutter_complete_guide/widgets/transaction_list.dart';

import './models/transaction.dart';

void main() {
  //call this before setting orientation
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        // errorColor: Colors.red,
        fontFamily: 'Quicksand',
        //theme for the rest of the app
        textTheme: ThemeData.light().textTheme.merge(
              TextTheme(
                  headline6: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                  button: TextStyle(color: Colors.white)),
            ),
        //app bar theme
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.merge(
                TextTheme(
                  headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String titleInput;
  bool _showChart = false;

  String amountInput;
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoe',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // )
  ];

  List<Transaction> get _recentTransaction {
    return _userTransactions.where((transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTex = Transaction(
        title: title,
        amount: amount,
        date: chosenDate,
        id: DateTime.now().toString());
    setState(() {
      _userTransactions.add(newTex);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bCtx) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(addTx: _addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    //get te orientation of the device
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;


    final appBar = AppBar(
      title: Text(
        "Personal Expenses",
        style: TextStyle(fontFamily: 'OpenSans'),
      ),
      actions: [
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context))
      ],
    );
    final txListWidget= Container(
        height: (MediaQuery.of(context).size.height -
            appBar.preferredSize.height -
            MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionList(
            transactions: _userTransactions,
            deleteTx: _deleteTransaction));
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //if it is landscape the Row renders, else nothing
            if(isLandScape) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Show chart'),
                Switch(
                  value: _showChart,
                  onChanged: (val) {
                    setState(() {
                      _showChart = val;
                    });
                  },
                ),
              ],
            ),
            if(!isLandScape)
              Container(
                height: (MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top) *
                    0.3,
                width: double.infinity,
                child: Chart(
                  recentTransactions: _recentTransaction,
                ),
              ),
            if(!isLandScape) txListWidget,
            //if show chart is true
           if(isLandScape) _showChart
                ? Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.7,
                    width: double.infinity,
                    child: Chart(
                      recentTransactions: _recentTransaction,
                    ),
                  )
                //else show this
                : txListWidget
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTransaction(context),
        elevation: 4.0,
        child: IconButton(
          icon: Icon(Icons.add),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
final Function addTx;
NewTransaction({this.addTx});
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {


    return  Card(
      elevation: 5.0,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
              onChanged: (value) {
               // titleInput = value;
              },
            ),
            TextField(
                decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
                ),
            FlatButton(
                onPressed: (){
                  addTx(titleController.text, double.tryParse(amountController.text));
                },
                child: Text(
                  'Add Transaction',
                  style: TextStyle(color: Colors.purple),
                ))
          ],
        ),
      ),
    );
  }
}

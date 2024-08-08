import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function delTx;

  TransactionList(this.transactions,this.delTx);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: transactions.isEmpty
          ? Column(
              children: [
                Text(
                  'No transactions added yet!',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                    height: 300,
                    child: Image.asset(
                      'assets/images/waiting2.png',
                      fit: BoxFit.cover,
                    )),
              ],
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                            child: Text(
                              '₹${transactions[index].amt.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        transactions[index].title,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                        ),
                      ),
                      subtitle: Text(
                        DateFormat.yMMMd().format(transactions[index].date),
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: ()=>delTx(transactions[index].id),
                      )),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}

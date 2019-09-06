import 'package:flutter/material.dart';
import '../widgets/PieGraph.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/transaction_model.dart';

/*
* GraphPage:
*   Summary:
*     Page used to hold the Pie Chart Widget.
*     Takes the chart data as a parameter as
 *     well as the total amount spent for that
 *     month and passes it to the Pie Graph Widget.
 *
 *  Params:
 *    List: chart_data
 *              Simple linear Transaction Data
 *    double: ammount
 *              max amount spent fo the month
* */
class GraphPage extends StatelessWidget{
  //Initialize a List of Series data with TransactionData and names(String)
  final List<charts.Series<TransactionData, String>>  chart_data;
  //Double passed into constructor to keep track of total spending
  final double ammount;
  GraphPage(this.chart_data, this.ammount);

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Transaction Data'),
        ),
        body: Container(
          //padding and margin in order to center the Widgets on the Page
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.all(20.0),

          //A stack was used in order to display total in the center of the graph
          child:new Stack(
            children: <Widget>[
              //Initialize PieGraph Widget
              PieGraph(chart_data),
              //Alignment for text in center of pie graph
              new Align(
                alignment: Alignment.center,
                //ammount variable used with toStringAsFixed to limit to 2 decimal places
                child: Text('\$${ammount.toStringAsFixed(2)}'),
              ),
            ],
          ),
          ),
    );
  }
}

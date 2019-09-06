import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' show get;
import '../widgets/graph_page.dart';
import 'dart:convert';

/*
* Transaction Data:
*   Summary:
*     A class used to store linear data for
*     the pie chart. Data is fetched from
*     REST Api server.
*
*   Params:
*       String:
*         yype:
*           The Category of the transaction
*           based on the JSON from the API.
*
*       Double:
*         ammount:
*           The amount spent on the transaction.
* */

class TransactionData{
  //The category of the transaction
  String type;
  //the amount spent on the transaction
  double ammount;

  TransactionData(this.type, this.ammount);
}

void fetch_data(BuildContext context){
  //the max amount to be incremented after every transaction
  double ammount = 0;
  //get today's date
  DateTime now = new DateTime.now();
  //extract the month from the date and parse to a string
  var month = '0' + now.month.toString();
  //create list of linear data
  List<charts.Series<TransactionData, String>> chart_data;
  //fetch data from API using the current month in the url
  get('http://MY-VM-IP/month/${month}/MY-API-KEY')
  //use the (then) function to only execute code after data is fetched
      .then((result){
        //initialize four doubles to increment amounts of money for each category
    double type_0 = 0;
    double type_1 = 0;
    double type_2 = 0;
    double type_3 = 0;

    //parse result data to json(future implementation will store json locally)
    var json_data = json.decode(result.body);

    //loop through the length of all transactions in json
    for(int i = 0; i < json_data['Transaction Data'].length; i++){
      //extract the transaction type from json and store it
      var type = json_data['Transaction Data'][i]['Type'];
      //extract body of current json object
      var data_body = json_data['Transaction Data'][i];
      //increment the max amount variable
      ammount += data_body['Ammount'];

      /*
      * Conditionals for each type of transaction, and respective
      * increments to corresponding variables.
      *
      * Type 0: Bills
      * Type 1: Online Purchase
      * Type 2: Car
      * Type 3: Food
      * */
      if(type == 0){
        type_0 += data_body['Ammount'];
      }
      else if(type == 1){
        type_1 += data_body['Ammount'];
      }
      else if(type == 2){
        type_2 += data_body['Ammount'];
      }
      else if(type == 3){
        type_3 += data_body['Ammount'];
      }
    }

    //create list of linear data set with names and corresponding values
    final data = [
      new TransactionData('Bills', type_0),
      new TransactionData('Online Purchase', type_1),
      new TransactionData('Car', type_2),
      new TransactionData('Food', type_3),
    ];
    //initialize the list as a new list of Linear data
    chart_data = [new charts.Series<TransactionData, String>(
      id: 'Transactions',
      data: data,
      //Function to store domain name values(the X axiz of the graph)
      domainFn: (TransactionData tr, _)=> tr.type,
      //function to store measures of domains(the Y axis of the graph)
      measureFn: (TransactionData tr, _)=> tr.ammount,
      //function to give colors to different
      colorFn: (TransactionData tr, _){

        /*
        * Conditionals to give colors to corresponding
        * portions of the pie graph.
        *
        * Type Bills: green
        * Type Online Purchase: blue
        * Type Car: purple
        * Type Food: red
        * */
        if(tr.type == 'Bills'){
          return charts.MaterialPalette.green.shadeDefault;
        }
        else if(tr.type == 'Online Purchase'){
          return charts.MaterialPalette.blue.shadeDefault;
        }
        else if(tr.type == 'Car'){
          return charts.MaterialPalette.purple.shadeDefault;
        }
        else{
          return charts.MaterialPalette.red.shadeDefault;
        }
      },
    )];

    //after fetching data and logic push a new page
    //In this case push replacment is used because users should not be able
    //to navigate back to the loading page, but instead back to the home page
    Navigator.pushReplacement(context,
        new MaterialPageRoute(
            builder: (context) => new GraphPage(chart_data, ammount)));
  });

}
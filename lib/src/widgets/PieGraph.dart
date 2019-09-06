import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class PieGraph extends StatelessWidget{

  final List<charts.Series<TransactionData, String>> chart_data;

  PieGraph(this.chart_data);

  Widget build(BuildContext context) {
    return new charts.PieChart(chart_data,
        animate: true,
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60),
        defaultInteractions: true,
        behaviors:[
        new charts.DatumLegend(
          // By default, if the position of the chart is on the left or right of
          // the chart, [horizontalFirst] is set to false. This means that the
          // legend entries will grow as new rows first instead of a new column.
          horizontalFirst: false,
          // This defines the padding around each legend entry.
          cellPadding: new EdgeInsets.only(right: 4.0),
          // Set [showMeasures] to true to display measures in series legend.
          showMeasures: true,
          // Configure the measure value to be shown by default in the legend.
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          measureFormatter: (num value) {
            return value == null ? '-' : '\t\t \$${value.toStringAsFixed(2)}';
          },
        ),
      ],
    );
  }



}

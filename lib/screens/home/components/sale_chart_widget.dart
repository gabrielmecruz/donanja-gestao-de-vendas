import 'package:app_tcc/models/order.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

enum Month { none, Jan, Fev, Mar, Abr, Mai, Jun, Jul, Ago, Set, Out, Nov, Dez }

class SaleBarChart extends StatefulWidget {
  SaleBarChart(this.order, this.validOrders);

  final List<Order> validOrders;
  final Order? order;
  @override
  _SaleBarChartState createState() => _SaleBarChartState();
}

class _SaleBarChartState extends State<SaleBarChart> {
  String getMonthText(Month month) {
    switch (month) {
      case Month.Jan:
        return 'Jan';
      case Month.Fev:
        return 'Fev';
      case Month.Mar:
        return 'Mar';
      case Month.Abr:
        return 'Abr';
      case Month.Mai:
        return 'Mai';
      case Month.Jun:
        return 'Jun';
      case Month.Jul:
        return 'Jul';
      case Month.Ago:
        return 'Ago';
      case Month.Set:
        return 'Set';
      case Month.Out:
        return 'Out';
      case Month.Nov:
        return 'Nov';
      case Month.Dez:
        return 'Dez';
      case Month.none:
      default:
        return '';
    }
  }

  final month = Month.Ago;

  List<charts.Series<dynamic, String>>? seriesList;

  /// Create series list with multiple series
  List<charts.Series<OrdinalSales, String>> _createData() {
    final salesData = <OrdinalSales>[];

    for (int i = widget.order!.currentMonth - 4;
        i < widget.order!.currentMonth + 1;
        i++) {
      salesData.add(OrdinalSales(
        month: getMonthText(Month.values[i]),
        sales: widget.order!.itemsByMonth(widget.validOrders, i),
      ));
    }

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Vendas',
        domainFn: (OrdinalSales sales, _) => sales.month,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: salesData,
        seriesColor: charts.ColorUtil.fromDartColor(Color.fromARGB(200, 60, 150, 161)),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    seriesList = _createData();
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList!,
      animate: false,
      barGroupingType: charts.BarGroupingType.grouped,
      behaviors: [
        new charts.SeriesLegend(
          position: charts.BehaviorPosition.top,
          showMeasures: true,
        ),
      ],
    );
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String month;
  final int sales;

  OrdinalSales({required this.month, required this.sales});

  @override
  String toString() {
    return 'OrdinalSales{month: $month, sales: $sales}';
  }
}

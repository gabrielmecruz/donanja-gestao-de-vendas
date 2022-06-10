import 'package:app_tcc/models/finances.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatefulWidget {
  TransactionTile(this.transaction);

  Transactions transaction;
  @override
  _TransactionTileState createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  final PageController pageController = PageController();
  bool colorController = true;

  String get dateFormat {
    initializeDateFormatting('pt_BR', null);
    DateTime dt = widget.transaction.date!.toDate();
    return DateFormat(DateFormat.YEAR_NUM_MONTH_DAY, 'pt_Br').format(dt);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget.transaction.type == true
                    ? Icon(
                        Icons.arrow_circle_down,
                        color: Theme.of(context).primaryColor.withGreen(150),
                        size: 30,
                      )
                    : Icon(
                        Icons.arrow_circle_up,
                        color: Color.fromARGB(255, 200, 0, 0),
                        size: 30,
                      ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.transaction.desc.toString(),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'R\$ ${widget.transaction.value!.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: Text(
                            dateFormat,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

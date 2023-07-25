import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectDateBottomSheet extends StatelessWidget {
  const SelectDateBottomSheet({
    Key? key,
    required this.screenHeight,
  }) : super(key: key);

  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DatePickerDialog(
              restorationId: 'date_picker_dialog',
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              initialDate: DateTime.now().add(Duration(days: 1)),
              firstDate: DateTime(DateTime.now().year),
              lastDate: DateTime(2024),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color(0xff19433C),
                    minimumSize: const Size.fromHeight(50),
                    textStyle: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(fontSize: 20.0, color: Colors.white)),
                onPressed: () {},
                child: Text('Save'))
          ],
        ),
      ),
    );
  }
}

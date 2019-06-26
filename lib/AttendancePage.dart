import 'package:flutter/material.dart';
import 'package:advanced_share/advanced_share.dart';
import 'package:date_format/date_format.dart';

class AttendancePage extends StatefulWidget {
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<String> itemColor;
  List<int> absentRollNumber = [];
  DateTime getTodayDate;
  String todayDate;
  String stringAbsenties;

  @override
  initState() {
    super.initState();
    itemColor = List<String>.generate(40, (index) => "empty");
    getTodayDate = DateTime.now();
  }

  getDate() {
    return (formatDate(getTodayDate, [dd, '-', mm, '-', yyyy]));
  }

  getAbsenties() {
    todayDate = getDate();

    for (var i = 0; i < itemColor.length; i++) {
      if (itemColor[i] == "red") {
        absentRollNumber.add(i + 1);
      }
    }

    stringAbsenties = absentRollNumber.join(",");
  }

  retakeAttendance(){
    setState(() {
      itemColor = List<String>.filled(40, "empty");
    });
  }

  send() async {
    var watsappMessage="";
    getAbsenties();
    watsappMessage="Date : $todayDate (CSE - A) absenties are : $stringAbsenties";
    AdvancedShare.generic(
      msg: watsappMessage,
      title: "Today's Attendance",
    ).then((response) {
      print(response);
    });
  }

  present(int i) {
    setState(() {
      itemColor[i] = "green";
    });
  }

  absent(int i) {
    setState(() {
      itemColor[i] = "red";
    });
  }

  getColor(int i) {
    switch (itemColor[i]) {
      case "empty":
        return Colors.black38;
        break;
      case "green":
        return Colors.green;
        break;
      case "red":
        return Colors.red;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Attendance"),
        ),
        //backgroundColor: Colors.green,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: GridView.builder(
            padding: EdgeInsets.all(20.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1.0,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: 40,
            itemBuilder: (context, i) => CircleAvatar(
                radius: 10.0,
                backgroundColor: getColor(i),
                child: GestureDetector(
                  onTap: () {
                    present(i);
                  },
                  onDoubleTap: () {
                    absent(i);
                  },
                  child: Text(
                    "${i + 1}",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )),
          )),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(60.0, 10.0, 20.0, 20.0),
                child: RaisedButton(
                  onPressed: () {
                    retakeAttendance();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.red,
                  child: Text("RETAKE",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(95.0, 10.0, 20.0, 20.0),
                child: RaisedButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.green,
                  child: Text("SUBMIT",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          send();
        },
        child: Icon(Icons.share),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

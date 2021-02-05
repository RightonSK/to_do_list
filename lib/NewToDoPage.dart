
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'ToDoCollection.dart';

class NewToDoPage extends StatefulWidget {
  NewToDoPage() : super();

  final String title = "New ToDo Form";

  @override
  _NewToDoPageState createState() => _NewToDoPageState();
}

class _NewToDoPageState extends State<NewToDoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: NewToDoForm(),
    );
  }
}

class NewToDoForm extends StatefulWidget {
  @override
  NewToDoFormState createState() {
    return NewToDoFormState();
  }
}

class NewToDoFormState extends State<NewToDoForm> {
  var _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final placeController = TextEditingController();

  bool _needReminder = false;
  DateTime _dateTimeObj;
  String _dateTime;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    var initSettingsiOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // do nothing for now
      }
    );
    var initializationSettings = InitializationSettings(android: initSettingsAndroid, iOS: initSettingsiOS);
  }

  Future<void> scheduleNotification(DateTime notificationTime, String title, String place) async {
    print('Notification is scheduled for: '+ notificationTime.toString()+
        ' which is after' +
        notificationTime.difference(DateTime.now()).inSeconds.toString() +
        ' seconds'
    );
    var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: notificationTime.difference(DateTime.now()).inSeconds));
    var androidChannelSpecifics = AndroidNotificationDetails(
        "channelId",
        "channelName",
        "channelDescription",
      icon: "@mipmap/ic_launcher",
      enableLights: true,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iOSChannelSpecifies = IOSNotificationDetails(
      sound: "find_sound.aiff",
    );
    var platfromChannelSpecifics = NotificationDetails(
      android: androidChannelSpecifics, iOS: iOSChannelSpecifies
    );
    await flutterLocalNotificationsPlugin.schedule(
        0,
        title,
        place,
        scheduleNotificationDateTime,
        platfromChannelSpecifics,
        payload: 'Test Payload',
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    placeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Text(
              'Title',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            )),
          ),
          TextFormField(
            controller: titleController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Text(
              'Place',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            )),
          ),
          TextFormField(
            controller: placeController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
                child: Text(
              'DateTime',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 5.0,
              onPressed: () {
                DatePicker.showDateTimePicker(
                  context,
                  theme: DatePickerTheme(
                    containerHeight: 200.0,
                  ),
                  showTitleActions: true,
                  onConfirm: (datetime) {
                    print('Selected DateTime is $datetime');
                    _dateTimeObj = datetime;
                    _dateTime =
                        '${datetime.year}-${datetime.month}-${datetime.day} ${datetime.hour}:${datetime.minute}:${datetime.second}';
                    setState(() {});
                  },
                  currentTime: DateTime.now(),
                  locale: LocaleType.en,
                );
                setState(() {});
              },
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.alarm_add_outlined,
                                size: 18.0,
                                color: Colors.teal,
                              ),
                              Text(
                                "$_dateTime",
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Text(
                      "Change",
                      style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Center(
                    child: Text(
                  'Reminder?',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                )),
              ),
              Center(
                child: Checkbox(
                    value: _needReminder,
                    onChanged: (value) {
                      setState(() {
                        _needReminder = value;
                      });
                    }),
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    print('Title: '+titleController.text+' Place: '+placeController.text+
                    ' DateTime: '+_dateTime+' Reminder? '+_needReminder.toString());
                    ToDoCollection.add(titleController.text, placeController.text, _dateTimeObj.toString(),_needReminder);
                    if(_formKey.currentState.validate()) {
                      if(_needReminder == true) {
                        scheduleNotification(_dateTimeObj, titleController.text, placeController.text);
                      }
                      Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                    }
                  },
                  child: Text("Add ToDo")
              ),
            ),
          ),
        ],
      ),
    );
  }
}

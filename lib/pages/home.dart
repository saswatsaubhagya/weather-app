import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../utils/appstate.dart';
import '../controllers/weather.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget appBottomSheet({WeatherController weatherController}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        //textfield
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: TextField(
            controller: weatherController.cityController,
            decoration: InputDecoration(
              hintText: "Enter the city",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        //submit button
        RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onPressed: () async {
            Navigator.pop(context);
            await weatherController.getWeather(
                city: weatherController.cityController.text);
          },
          child: Text("Submit"),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<WeatherController>(context, listen: false).getWeather();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(147, 49, 143, 1),
              Color.fromRGBO(102, 46, 147, 1),
            ],
          ),
        ),
        child: Consumer<WeatherController>(
          builder: (context, weatherController, child) {
            return weatherController.state == AppState.Busy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //day
                        Padding(
                          padding: EdgeInsets.only(top: 50, left: 40),
                          child: Text(
                            "${weatherController.getDay(DateTime.now().weekday)}",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //time
                        Padding(
                          padding: EdgeInsets.only(left: 40),
                          child: Text(
                            DateFormat().add_jm().format(
                                  DateTime.parse(
                                    weatherController.weather.location == null
                                        ? DateTime.now().toString()
                                        : weatherController
                                            .weather.location.localtime,
                                  ),
                                ),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        //icon
                        Center(
                          child: Image.asset(
                            "assets/images/thunder.png",
                            height: 200,
                            width: 200,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        //temprature with city
                        Padding(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "${weatherController.weather.location == null ? "" : weatherController.weather.current.temperature.toString()} c",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                ),
                              ),
                              Container(
                                height: 40,
                                child: VerticalDivider(color: Colors.white),
                              ),
                              Column(children: <Widget>[
                                Text(
                                  weatherController.weather.location == null
                                      ? ""
                                      : weatherController.weather.current
                                          .weatherDescriptions[0],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 50,
                                  ),
                                ),
                                Text(
                                    weatherController.weather.location == null
                                        ? ""
                                        : weatherController
                                            .weather.location.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                    )),
                              ])
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return appBottomSheet(
                                        weatherController: weatherController);
                                  });
                            },
                            child: Text("Search another"),
                          ),
                        )
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:world_weather_app/repo.dart';

class CitySelection extends StatefulWidget {
  const CitySelection({super.key});

  @override
  State<CitySelection> createState() => _CitySelectionState();
}

class _CitySelectionState extends State<CitySelection> {

    bool isLoading = false;
   
    List <WeatherData> citys = [
      WeatherData(city: "Cairo",flag: 'egypt.png'),
      WeatherData(city: "Jerusalem",flag: 'palestine.png'),
      WeatherData(city: "Nairobi",flag: 'kenya.png'),
      WeatherData(city: "Athens",flag: 'greece.png'),
      WeatherData(city: "Milan",flag: 'italy.png'),
      WeatherData(city: "Paris",flag: 'france.png'),
      WeatherData(city: "London",flag: 'uk.png'),
      WeatherData(city: "Berlin",flag: 'germany.png'),
      WeatherData(city: "Moscow",flag: 'russia.png'),
      WeatherData(city: "New York",flag: 'usa.png'),
      WeatherData(city: "Tehran",flag: 'iran.png'),
      WeatherData(city: "Tokyo",flag: 'japan.png'),
      WeatherData(city: "Dubai",flag: 'uae.png'),
      WeatherData(city: "Seoul",flag: 'south_korea.png'),
      WeatherData(city: "Jakarta",flag: 'indonesia.png')

    ];

    Future <void> updateCity (index) async {
      
      setState(() {
        isLoading = true;
      });
      WeatherData weatherData = citys[index];
      try {
        await weatherData.fetchWeatherData();

        Map map = {
          'city': weatherData.city,
          'weatherCondition': weatherData.weatherCondition,
          'temperature':weatherData.temperature,
          'humidity':weatherData.humidity,
          'windSpeed':weatherData.windSpeed
        };

        SchedulerBinding.instance.addPostFrameCallback(
          (_)=> Navigator.pop(context,map)
        );
      } catch(e){
        if (mounted){ showDialog(context: context, 
                    builder: (_)=> AlertDialog(
                      title: Text("Error"),
                      content: Text("Could not fetch weather for ${weatherData.city}.\nPlease check your internet connection."),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: Text(" OK !"))
                      ],
                    ));}
      } finally {
        setState(() {
          isLoading = false;
        });
      }

    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[900],
          title: Text(" Choose a City "),
          centerTitle: true,
        ),
        body: isLoading 
                ? Center(child: CircularProgressIndicator())  
                : ListView.separated(itemBuilder: (context,index){
                                          return Card(
                                            child: ListTile(
                                              tileColor: Colors.grey[300],
                                              onTap: () async {
                                                await updateCity(index);
                                              },
                                              title: Text(citys[index].city),
                                              leading: CircleAvatar(
                                                backgroundImage: AssetImage('assets/${citys[index].flag!}'),
                                              ),
                                            ),

                                          );

                                        },
                                        separatorBuilder: (context,index)=>SizedBox(height: 8),
                                        itemCount: citys.length),
              );
    }
}
class Weather {
  final int id;
  final String main;
  final String description;

  Weather({
    required this.id,
    required this.main,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'main': main,
      'description': description,
    };
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['id'] as int,
      main: json['main'] as String,
      description: json['description'] as String,
    );
  }
}

class WeatherData {
  int id;
  final List<Weather> weather;
  String base;
  Main main;
  int visibility;
  Wind wind;
  String name;
  int cod;

  WeatherData({
    required this.id,
    required this.weather,
    required this.base,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.name,
    required this.cod,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'weather': this.weather,
      'base': this.base,
      'main': this.main,
      'visibility': this.visibility,
      'wind': this.wind,
      'name': this.name,
      'cod': this.cod,
    };
  }

  factory WeatherData.fromMap(Map<String, dynamic> map) {
    return WeatherData(
      id: map['id'] as int,
      weather: map['weather'] as List<Weather>,
      base: map['base'] as String,
      main: map['main'] as Main,
      visibility: map['visibility'] as int,
      wind: map['wind'] as Wind,
      name: map['name'] as String,
      cod: map['cod'] as int,
    );
  }

}
class Wind {
  num speed;
  num deg;

  Wind({
    required this.speed,
    required this.deg,
  });

  Map<String, dynamic> toMap() {
    return {
      'speed': this.speed,
      'deg': this.deg,
    };
  }

  factory Wind.fromMap(Map<String, dynamic> map) {
    return Wind(
      speed: map['speed'] as num,
      deg: map['deg'] as num,
    );
  }

}

class Main {
  num temp;
  num feels_like;
  num temp_min;
  num temp_max;
  num humidity;

  Main({
    required this.temp,
    required this.feels_like,
    required this.temp_min,
    required this.temp_max,
    required this.humidity,
  });

  Map<String, dynamic> toMap() {
    return {
      'temp': this.temp,
      'feels_like': this.feels_like,
      'temp_min': this.temp_min,
      'temp_max': this.temp_max,
      'humidity': this.humidity,
    };
  }

  factory Main.fromMap(Map<String, dynamic> map) {
    return Main(
      temp: map['temp'] as num,
      feels_like: map['feels_like'] as num,
      temp_min: map['temp_min'] as num,
      temp_max: map['temp_max'] as num,
      humidity: map['humidity'] as num,
    );
  }
}
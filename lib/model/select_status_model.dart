class ModelAllLocation {
  ModelAllLocation({
    required this.id,
    required this.country,
    required this.region,
  });

  int id;
  String country;
  List<Region> region;

  factory ModelAllLocation.fromJson(Map<String, dynamic> json) =>
      ModelAllLocation(
        id: json["id"],
        country: json["country"],
        region:
            List<Region>.from(json["region"].map((x) => Region.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country,
        "region": List<dynamic>.from(region.map((x) => x.toJson())),
      };
}

class Region {
  Region({
    required this.id,
    required this.region,
    required this.countryId,
    required this.city,
  });

  int id;
  String region;
  int countryId;
  List<City2> city;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        id: json["id"],
        region: json["region"],
        countryId: json["country_id"],
        city: List<City2>.from(json["city"].map((x) => City2.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "region": region,
        "country_id": countryId,
        "city": List<dynamic>.from(city.map((x) => x.toJson())),
      };
}

class City2 {
  City2({
    required this.city,
    required this.regionId,
  });

  String city;
  int regionId;

  factory City2.fromJson(Map<String, dynamic> json) => City2(
        city: json["city"],
        regionId: json["region_id"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "region_id": regionId,
      };
}

class StatusModel {
  int? id;
  String? name;
  String? emoji;
  String? emojiU;
  List<State>? state;

  StatusModel({this.id, this.name, this.emoji, this.emojiU, this.state});

  StatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    emoji = json['emoji'];
    emojiU = json['emojiU'];
    if (json['state'] != null) {
      state = <State>[];
      json['state'].forEach((v) {
        state!.add(new State.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['emoji'] = this.emoji;
    data['emojiU'] = this.emojiU;
    if (this.state != null) {
      data['state'] = this.state!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class State {
  int? id;
  String? name;
  int? countryId;
  List<City>? city;

  State({this.id, this.name, this.countryId, this.city});

  State.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'];
    if (json['city'] != null) {
      city = <City>[];
      json['city'].forEach((v) {
        city!.add(new City.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['country_id'] = this.countryId;
    if (this.city != null) {
      data['city'] = this.city!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class City {
  int? id;
  String? name;
  int? stateId;

  City({this.id, this.name, this.stateId});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stateId = json['state_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['state_id'] = this.stateId;
    return data;
  }
}

class RestFrame {
  RestFrame({this.category, this.error, this.result});

  List<String> category;
  bool error;
  dynamic result;

  factory RestFrame.fromJson(Map<String, dynamic> json) {
    return RestFrame(
      category: new List<String>.from(json['category']),
      error: json['error'],
      result: json['result'],
    );
  }
}

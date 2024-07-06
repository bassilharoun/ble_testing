class PositionResponse {
  final dynamic x;
  final dynamic y;
  final String buildingId;
  final String levelId;
  final String errorMessage;

  PositionResponse({
    required this.x,
    required this.y,
    required this.buildingId,
    required this.levelId,
    required this.errorMessage,
  });

  // Factory method to create an instance from JSON
  factory PositionResponse.fromJson(Map<String, dynamic> json) {
    return PositionResponse(
      x: json['x'],
      y: json['y'],
      buildingId: json['buildingId'],
      levelId: json['levelId'],
      errorMessage: json['errorMessage'],
    );
  }
}

class Salami {
  String id;
  double amount;
  int timestamp;
  String name;

//<editor-fold desc="Data Methods">

  Salami({
    required this.id,
    required this.amount,
    required this.timestamp,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Salami &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          amount == other.amount &&
          timestamp == other.timestamp &&
          name == other.name);

  @override
  int get hashCode => id.hashCode ^ amount.hashCode ^ timestamp.hashCode ^ name.hashCode;

  @override
  String toString() {
    return 'Salami{' + ' id: $id,' + ' amount: $amount,' + ' timestamp: $timestamp,' + ' name: $name,' + '}';
  }

  Salami copyWith({
    String? id,
    double? amount,
    int? timestamp,
    String? name,
  }) {
    return Salami(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'amount': this.amount,
      'timestamp': this.timestamp,
      'name': this.name,
    };
  }

  factory Salami.fromMap(Map<String, dynamic> map) {
    return Salami(
      id: map['id'] as String,
      amount: map['amount'] as double,
      timestamp: map['timestamp'] as int,
      name: map['name'] as String,
    );
  }

//</editor-fold>
}
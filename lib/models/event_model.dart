import 'dart:convert';

import 'package:flutter/material.dart';

class EventModel {
  final String idSub;
  final String idUser;
  final String name;
  final String dateSub;
  final String sub;
  final String xdesc;
  final String status;
  EventModel({
    required this.idSub,
    required this.idUser,
    required this.name,
    required this.dateSub,
    required this.sub,
    required this.xdesc,
    required this.status,
  });

  EventModel copyWith({
    String? idSub,
    String? idUser,
    String? name,
    String? dateSub,
    String? sub,
    String? xdesc,
    String? status,
  }) {
    return EventModel(
      idSub: idSub ?? this.idSub,
      idUser: idUser ?? this.idUser,
      name: name ?? this.name,
      dateSub: dateSub ?? this.dateSub,
      sub: sub ?? this.sub,
      xdesc: xdesc ?? this.xdesc,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idSub': idSub,
      'idUser': idUser,
      'name': name,
      'dateSub': dateSub,
      'sub': sub,
      'xdesc': xdesc,
      'status': status,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      idSub: map['idSub'] ?? '',
      idUser: map['idUser'] ?? '',
      name: map['name'] ?? '',
      dateSub: map['dateSub'] ?? '',
      sub: map['sub'] ?? '',
      xdesc: map['xdesc'] ?? '',
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) => EventModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EventModel(idSub: $idSub, idUser: $idUser, name: $name, dateSub: $dateSub, sub: $sub, xdesc: $xdesc, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is EventModel &&
      other.idSub == idSub &&
      other.idUser == idUser &&
      other.name == name &&
      other.dateSub == dateSub &&
      other.sub == sub &&
      other.xdesc == xdesc &&
      other.status == status;
  }

  @override
  int get hashCode {
    return idSub.hashCode ^
      idUser.hashCode ^
      name.hashCode ^
      dateSub.hashCode ^
      sub.hashCode ^
      xdesc.hashCode ^
      status.hashCode;
  }
}

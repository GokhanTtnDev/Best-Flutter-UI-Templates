import 'package:flutter/material.dart';

class CreditCardModel {
  final String id;
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final double balance;
  final List<Color> gradient;
  final String type;

  CreditCardModel({
    required this.id,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.balance,
    required this.gradient,
    required this.type,
  });
}
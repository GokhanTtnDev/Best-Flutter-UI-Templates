import 'package:flutter/material.dart';

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final DateTime date;
  final bool isIncome;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.date,
    this.isIncome = false,
  });
}
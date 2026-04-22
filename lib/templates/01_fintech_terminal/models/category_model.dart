import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final double amount;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final double percentage;

  CategoryModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.percentage,
  });
}
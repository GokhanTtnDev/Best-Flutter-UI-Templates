import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../models/credit_card_model.dart';
import '../models/category_model.dart';
import '../../../core/constants/app_colors.dart';

class MockData {
  static List<TransactionModel> getTransactions() {
    return [
      TransactionModel(
        id: '1',
        title: 'Spending',
        amount: 500.00,
        icon: Icons.credit_card_rounded,
        color: AppColors.negativeRed,
        backgroundColor: const Color(0xFFFFF1F2),
        date: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      TransactionModel(
        id: '2',
        title: 'Income',
        amount: 3000.00,
        icon: Icons.account_balance_wallet_rounded,
        color: AppColors.positiveGreen,
        backgroundColor: const Color(0xFFECFDF5),
        date: DateTime.now().subtract(const Duration(days: 1)),
        isIncome: true,
      ),
      TransactionModel(
        id: '3',
        title: 'Bills',
        amount: 800.00,
        icon: Icons.description_rounded,
        color: AppColors.negativeRed,
        backgroundColor: const Color(0xFFFFFBEB),
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      TransactionModel(
        id: '4',
        title: 'Savings',
        amount: 1000.00,
        icon: Icons.savings_rounded,
        color: AppColors.accentOrange,
        backgroundColor: const Color(0xFFFFF7ED),
        date: DateTime.now().subtract(const Duration(days: 3)),
        isIncome: true,
      ),
    ];
  }

  static List<CreditCardModel> getCards() {
    return [
      CreditCardModel(
        id: '1',
        cardNumber: '**** **** **** 1244',
        cardHolder: 'ALEXANDER PIERCE',
        expiryDate: '12/28',
        balance: 12500.00,
        gradient: [AppColors.primaryIndigo, AppColors.primaryBlueDark],
        type: 'VISA',
      ),
      CreditCardModel(
        id: '2',
        cardNumber: '**** **** **** 9821',
        cardHolder: 'ALEXANDER PIERCE',
        expiryDate: '09/26',
        balance: 3400.50,
        gradient: [AppColors.positiveEmerald, const Color(0xFF047857)],
        type: 'MASTERCARD',
      ),
      CreditCardModel(
        id: '3',
        cardNumber: '**** **** **** 5534',
        cardHolder: 'ALEXANDER PIERCE',
        expiryDate: '11/25',
        balance: 850.00,
        gradient: [AppColors.accentOrange, const Color(0xFFB45309)],
        type: 'VISA',
      ),
    ];
  }

  static List<CategoryModel> getCategories() {
    return [
      CategoryModel(
        id: '1',
        name: 'Food & Dining',
        amount: 450.50,
        icon: Icons.restaurant_rounded,
        color: AppColors.primaryIndigo,
        backgroundColor: const Color(0xFFEEF2FF),
        percentage: 0.45,
      ),
      CategoryModel(
        id: '2',
        name: 'Transportation',
        amount: 250.00,
        icon: Icons.directions_car_rounded,
        color: AppColors.accentOrange,
        backgroundColor: const Color(0xFFFFF7ED),
        percentage: 0.25,
      ),
      CategoryModel(
        id: '3',
        name: 'Subscriptions',
        amount: 150.00,
        icon: Icons.play_circle_filled_rounded,
        color: AppColors.positiveEmerald,
        backgroundColor: const Color(0xFFECFDF5),
        percentage: 0.15,
      ),
      CategoryModel(
        id: '4',
        name: 'Shopping',
        amount: 150.00,
        icon: Icons.shopping_bag_rounded,
        color: AppColors.negativeRose,
        backgroundColor: const Color(0xFFFFF1F2),
        percentage: 0.15,
      ),
    ];
  }
}
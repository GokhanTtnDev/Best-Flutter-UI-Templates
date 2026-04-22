import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/transaction_model.dart';

class TransactionList extends StatelessWidget {
  final Map<String, dynamic> activeCurrency;
  final List<TransactionModel> transactions;

  const TransactionList({
    super.key,
    required this.activeCurrency,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 4, bottom: 100),
      physics: const BouncingScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return _buildTransactionItem(transactions[index], context);
      },
    );
  }

  Widget _buildTransactionItem(TransactionModel tx, BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: activeCurrency['symbol'],
      decimalDigits: 2,
    );
    final convertedAmount = tx.amount * activeCurrency['rate'];

    return GestureDetector(
      onTap: () => _showTransactionDetails(context, tx, currencyFormat, convertedAmount),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: tx.backgroundColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(tx.icon, color: tx.color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('MMM dd, HH:mm').format(tx.date),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "${tx.isIncome ? '+' : '-'}${currencyFormat.format(convertedAmount)}",
              style: TextStyle(
                color: tx.isIncome ? AppColors.positiveEmerald : AppColors.negativeRose,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, TransactionModel tx, NumberFormat format, double amount) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: tx.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(tx.icon, color: tx.color, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                tx.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                "${tx.isIncome ? '+' : '-'}${format.format(amount)}",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: tx.isIncome ? AppColors.positiveEmerald : AppColors.textPrimary,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow("Date", DateFormat('MMMM dd, yyyy - HH:mm').format(tx.date)),
              _buildDetailRow("Status", "Completed"),
              _buildDetailRow("Transaction ID", tx.id.padLeft(8, '0')),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
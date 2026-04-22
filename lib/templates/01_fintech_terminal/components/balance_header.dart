import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';

class BalanceHeader extends StatelessWidget {
  final Map<String, dynamic> activeCurrency;
  final List<Map<String, dynamic>> currencies;
  final Function(Map<String, dynamic>) onCurrencyChanged;
  final double balance;
  final VoidCallback onTopUp;
  final VoidCallback onSend;
  final VoidCallback onMenuTap;
  final VoidCallback onNotifTap;

  const BalanceHeader({
    super.key,
    required this.activeCurrency,
    required this.currencies,
    required this.onCurrencyChanged,
    required this.balance,
    required this.onTopUp,
    required this.onSend,
    required this.onMenuTap,
    required this.onNotifTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: activeCurrency['symbol'],
      decimalDigits: 2,
    );
    final double convertedBalance = balance * activeCurrency['rate'];

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1B4B), AppColors.background],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleIcon(Icons.grid_view_rounded, onMenuTap),
                  _buildCurrencyDropdown(),
                  _buildCircleIcon(Icons.notifications_none_rounded, onNotifTap),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "TOTAL BALANCE",
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currencyFormat.format(convertedBalance),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionChip(Icons.add_rounded, "Top Up", onTopUp),
                const SizedBox(width: 12),
                _buildActionChip(Icons.swap_horiz_rounded, "Send", onSend),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown() {
    return PopupMenuButton<Map<String, dynamic>>(
      onSelected: onCurrencyChanged,
      color: AppColors.secondarySlate,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      offset: const Offset(0, 45),
      itemBuilder: (context) {
        return currencies.map((c) {
          return PopupMenuItem<Map<String, dynamic>>(
            value: c,
            child: Row(
              children: [
                Text(c['flag'], style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 12),
                Text(
                  c['code'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(activeCurrency['flag'], style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              activeCurrency['code'],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildActionChip(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryIndigo,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryIndigo.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
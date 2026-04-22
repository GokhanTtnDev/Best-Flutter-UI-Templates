import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onWalletTap;
  final VoidCallback onStatsTap;
  final VoidCallback onSafetyTap;
  final VoidCallback onMoreTap;

  const QuickActions({
    super.key,
    required this.onWalletTap,
    required this.onStatsTap,
    required this.onSafetyTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.04), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionItem(Icons.account_balance_wallet_rounded, "Wallet", AppColors.primaryIndigo, onWalletTap),
          _buildActionItem(Icons.analytics_rounded, "Stats", AppColors.positiveEmerald, onStatsTap),
          _buildActionItem(Icons.shield_rounded, "Safety", AppColors.accentAmber, onSafetyTap),
          _buildActionItem(Icons.more_horiz_rounded, "More", AppColors.textSecondary, onMoreTap),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: color.withOpacity(0.1),
        highlightColor: color.withOpacity(0.05),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
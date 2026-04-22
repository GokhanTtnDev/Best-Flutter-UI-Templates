import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import 'components/balance_header.dart';
import 'components/navigation_bar.dart';
import 'components/quick_actions.dart';
import 'components/transaction_list.dart';
import 'utils/mock_data.dart';
import 'models/transaction_model.dart';
import 'models/credit_card_model.dart';
import 'models/category_model.dart';

class FintechDashboard extends StatefulWidget {
  const FintechDashboard({super.key});

  @override
  State<FintechDashboard> createState() => _FintechDashboardState();
}

class _FintechDashboardState extends State<FintechDashboard> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> currencies = [
    {'code': 'USD', 'flag': '🇺🇸', 'symbol': '\$', 'rate': 1.0},
    {'code': 'TRY', 'flag': '🇹🇷', 'symbol': '₺', 'rate': 32.4},
    {'code': 'EUR', 'flag': '🇪🇺', 'symbol': '€', 'rate': 0.92},
    {'code': 'GBP', 'flag': '🇬🇧', 'symbol': '£', 'rate': 0.79},
  ];

  late Map<String, dynamic> activeCurrency;
  late List<TransactionModel> transactions;
  late List<CreditCardModel> cards;
  late List<CategoryModel> categories;

  double currentBalance = 24560.00;
  int navIndex = 0;
  int _currentCardIndex = 0;
  int _activeTimeFilter = 2;

  final Set<String> _frozenCards = {};
  final Map<String, double> _cardLimits = {};
  final Map<String, Map<String, bool>> _cardSettings = {};

  bool _isFaceIdEnabled = true;
  bool _isPushEnabled = true;
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    activeCurrency = currencies[0];
    transactions = MockData.getTransactions();
    cards = MockData.getCards();
    categories = MockData.getCategories();

    for (var card in cards) {
      _cardLimits[card.id] = 5000.0;
      _cardSettings[card.id] = {
        'online': true,
        'atm': true,
        'international': false,
        'contactless': true,
      };
    }
  }

  void _updateCurrency(Map<String, dynamic> newCurrency) {
    setState(() {
      activeCurrency = newCurrency;
    });
  }

  void _addTransaction(double amount, bool isIncome, String title) {
    setState(() {
      if (isIncome) {
        currentBalance += amount;
      } else {
        currentBalance -= amount;
      }

      transactions.insert(
        0,
        TransactionModel(
          id: Random().nextInt(99999).toString(),
          title: title,
          amount: amount,
          icon: isIncome ? Icons.account_balance_wallet_rounded : Icons.send_rounded,
          color: isIncome ? AppColors.positiveGreen : AppColors.primaryIndigo,
          backgroundColor: isIncome ? const Color(0xFFECFDF5) : const Color(0xFFEEF2FF),
          date: DateTime.now(),
          isIncome: isIncome,
        ),
      );
    });
  }

  void _showTransactionSheet(bool isTopUp) {
    final TextEditingController amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  isTopUp ? "Top Up Balance" : "Send Money",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    prefixText: "${activeCurrency['symbol']} ",
                    prefixStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
                    labelText: "Amount",
                    labelStyle: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.backgroundLight,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryIndigo, width: 2)),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      final amount = double.tryParse(amountController.text);
                      if (amount != null && amount > 0) {
                        final usdAmount = amount / activeCurrency['rate'];
                        _addTransaction(usdAmount, isTopUp, isTopUp ? "Deposit" : "Transfer");
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryIndigo,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text(
                      isTopUp ? "Confirm Top Up" : "Send Now",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAllTransactions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("All Transactions", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.backgroundLight, shape: BoxShape.circle),
                        child: const Icon(Icons.close_rounded, color: AppColors.textPrimary, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search transactions...",
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.backgroundLight,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TransactionList(
                  activeCurrency: activeCurrency,
                  transactions: transactions,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMenuPanel() {
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
                decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primaryIndigo.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_rounded, color: AppColors.primaryIndigo, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Alexander Pierce", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      Text("Premium Account", style: TextStyle(fontSize: 14, color: AppColors.primaryIndigo, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildMenuRow(Icons.settings_rounded, "Account Settings", () => setState(() => navIndex = 4)),
              _buildMenuRow(Icons.help_outline_rounded, "Help & Support", () {}),
              _buildMenuRow(Icons.security_rounded, "Security", () {}),
              const SizedBox(height: 16),
              _buildMenuRow(Icons.logout_rounded, "Log Out", () {}, color: AppColors.negativeRose),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showNotificationsPanel() {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 24),
              const Text("Notifications", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 20),
              _buildNotificationItem(Icons.check_circle_rounded, "Payment Successful", "Your transfer of \$450.00 to John was successful.", AppColors.positiveEmerald),
              _buildNotificationItem(Icons.warning_rounded, "Security Alert", "New login detected from an unrecognized device.", AppColors.accentAmber),
              _buildNotificationItem(Icons.local_offer_rounded, "New Offer", "Get 5% cashback on all supermarket purchases.", AppColors.primaryIndigo),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showSafetyPanel() {
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
                decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 24),
              const Icon(Icons.shield_rounded, color: AppColors.accentAmber, size: 60),
              const SizedBox(height: 16),
              const Text("Safety & Security", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              const Text("Your account is fully protected.", style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 30),
              _buildMenuRow(Icons.password_rounded, "Change Password", () {}),
              _buildMenuRow(Icons.fingerprint_rounded, "Biometric Authentication", () {}),
              _buildMenuRow(Icons.devices_rounded, "Active Devices", () {}),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showMorePanel() {
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
                decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 24),
              const Text("More Options", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 20),
              _buildMenuRow(Icons.receipt_long_rounded, "Statements & Reports", () {}),
              _buildMenuRow(Icons.support_agent_rounded, "Customer Support", () {}),
              _buildMenuRow(Icons.info_outline_rounded, "About Crystal Finance", () {}),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showPinSheet() {
    String enteredPin = "";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
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
                    decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(height: 24),
                  const Text("Enter New PIN", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: index < enteredPin.length ? AppColors.primaryIndigo : AppColors.backgroundLight,
                          shape: BoxShape.circle,
                          border: index < enteredPin.length ? null : Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),
                  Wrap(
                    spacing: 30,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: List.generate(12, (index) {
                      if (index == 9) return const SizedBox(width: 70, height: 70);
                      if (index == 11) {
                        return GestureDetector(
                          onTap: () {
                            if (enteredPin.isNotEmpty) {
                              setSheetState(() => enteredPin = enteredPin.substring(0, enteredPin.length - 1));
                            }
                          },
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(color: AppColors.backgroundLight, shape: BoxShape.circle),
                            child: const Icon(Icons.backspace_rounded, color: AppColors.textPrimary),
                          ),
                        );
                      }
                      final number = index == 10 ? 0 : index + 1;
                      return GestureDetector(
                        onTap: () {
                          if (enteredPin.length < 4) {
                            setSheetState(() => enteredPin += number.toString());
                            if (enteredPin.length == 4) {
                              Future.delayed(const Duration(milliseconds: 300), () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: const Text("PIN updated successfully"), backgroundColor: AppColors.positiveEmerald, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), behavior: SnackBarBehavior.floating),
                                );
                              });
                            }
                          }
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(color: AppColors.backgroundLight, shape: BoxShape.circle),
                          child: Center(
                            child: Text(number.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showLimitsSheet(String cardId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final currencyFormat = NumberFormat.currency(symbol: activeCurrency['symbol'], decimalDigits: 0);
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text("Daily Spending Limit", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  const Text("Adjust your daily transaction limit for this card.", style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      currencyFormat.format(_cardLimits[cardId]! * activeCurrency['rate']),
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.primaryIndigo),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primaryIndigo,
                      inactiveTrackColor: AppColors.backgroundLight,
                      thumbColor: AppColors.primaryIndigo,
                      overlayColor: AppColors.primaryIndigo.withOpacity(0.2),
                      trackHeight: 8,
                    ),
                    child: Slider(
                      value: _cardLimits[cardId]!,
                      min: 0,
                      max: 20000,
                      divisions: 40,
                      onChanged: (val) {
                        setSheetState(() => _cardLimits[cardId] = val);
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryIndigo,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text("Save Changes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSettingsSheet(String cardId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text("Card Settings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 20),
                  _buildSettingSwitch(
                    "Online Payments",
                    "Allow transactions on the internet",
                    Icons.language_rounded,
                    _cardSettings[cardId]!['online']!,
                        (val) {
                      setSheetState(() => _cardSettings[cardId]!['online'] = val);
                      setState(() {});
                    },
                  ),
                  _buildSettingSwitch(
                    "ATM Withdrawals",
                    "Allow cash withdrawals at ATMs",
                    Icons.local_atm_rounded,
                    _cardSettings[cardId]!['atm']!,
                        (val) {
                      setSheetState(() => _cardSettings[cardId]!['atm'] = val);
                      setState(() {});
                    },
                  ),
                  _buildSettingSwitch(
                    "International",
                    "Allow payments in other countries",
                    Icons.flight_takeoff_rounded,
                    _cardSettings[cardId]!['international']!,
                        (val) {
                      setSheetState(() => _cardSettings[cardId]!['international'] = val);
                      setState(() {});
                    },
                  ),
                  _buildSettingSwitch(
                    "Contactless",
                    "Allow tap-to-pay via NFC",
                    Icons.contactless_rounded,
                    _cardSettings[cardId]!['contactless']!,
                        (val) {
                      setSheetState(() => _cardSettings[cardId]!['contactless'] = val);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCardDetails(CreditCardModel card) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(color: AppColors.backgroundLight, shape: BoxShape.circle),
                        child: const Icon(Icons.fingerprint_rounded, size: 40, color: AppColors.primaryIndigo),
                      ),
                      const SizedBox(height: 24),
                      const Text("Card Verified", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 30),
                      _buildDetailRow("Card Number", "4532 1244 9821 5534"),
                      const SizedBox(height: 16),
                      _buildDetailRow("CVV", "824"),
                      const SizedBox(height: 16),
                      _buildDetailRow("Expiry", card.expiryDate),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.backgroundLight,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text("Close", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showPersonalInfoSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 24),
                const Text("Personal Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 24),
                _buildTextField("Full Name", "Alexander Pierce"),
                const SizedBox(height: 16),
                _buildTextField("Email Address", "alexander@example.com", TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildTextField("Phone Number", "+1 234 567 8900", TextInputType.phone),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: const Text("Profile updated successfully"), backgroundColor: AppColors.positiveEmerald, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), behavior: SnackBarBehavior.floating),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryIndigo,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text("Save Changes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBankAccountsSheet() {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Connected Banks", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.add_circle_rounded, color: AppColors.primaryIndigo, size: 28),
                  )
                ],
              ),
              const SizedBox(height: 20),
              _buildConnectedBank("Chase Bank", "**** 4412", Icons.account_balance_rounded),
              _buildConnectedBank("Bank of America", "**** 8901", Icons.account_balance_rounded),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConnectedBank(String name, String account, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.primaryIndigo, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text("Account $account", style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, [TextInputType keyboardType = TextInputType.text]) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      keyboardType: keyboardType,
      style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.backgroundLight,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryIndigo, width: 2)),
      ),
    );
  }

  Widget _buildSettingSwitch(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.primaryIndigo, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeColor: AppColors.primaryIndigo,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildMenuRow(IconData icon, String title, VoidCallback onTap, {Color color = AppColors.textPrimary}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color))),
            Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(IconData icon, String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopIcon(IconData icon, VoidCallback onTap) {
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

  Widget _buildWalletAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: color.withOpacity(0.08), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 350,
          child: BalanceHeader(
            activeCurrency: activeCurrency,
            currencies: currencies,
            onCurrencyChanged: _updateCurrency,
            balance: currentBalance,
            onTopUp: () => _showTransactionSheet(true),
            onSend: () => _showTransactionSheet(false),
            onMenuTap: _showMenuPanel,
            onNotifTap: _showNotificationsPanel,
          ),
        ),
        Positioned(
          top: 300,
          left: 0,
          right: 0,
          bottom: 90,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Transactions",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: 0.2),
                      ),
                      GestureDetector(
                        onTap: _showAllTransactions,
                        child: const Text("See All", style: TextStyle(color: AppColors.primaryIndigo, fontWeight: FontWeight.w700, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: TransactionList(
                    activeCurrency: activeCurrency,
                    transactions: transactions,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 260,
          left: 24,
          right: 24,
          child: QuickActions(
            onWalletTap: () => setState(() => navIndex = 1),
            onStatsTap: () => setState(() => navIndex = 3),
            onSafetyTap: _showSafetyPanel,
            onMoreTap: _showMorePanel,
          ),
        ),
      ],
    );
  }

  Widget _buildWalletTab() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 380,
          child: Container(
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
                        _buildTopIcon(Icons.arrow_back_ios_new_rounded, () => setState(() => navIndex = 0)),
                        const Text("MY WALLET", style: TextStyle(color: Colors.white, letterSpacing: 2.5, fontWeight: FontWeight.w900, fontSize: 11)),
                        _buildTopIcon(Icons.add_rounded, () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Add new card..."), behavior: SnackBarBehavior.floating, backgroundColor: AppColors.secondarySlate),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 210,
                    child: PageView.builder(
                      controller: PageController(viewportFraction: 0.85),
                      itemCount: cards.length,
                      onPageChanged: (index) => setState(() => _currentCardIndex = index),
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        final isActive = _currentCardIndex == index;
                        final isFrozen = _frozenCards.contains(card.id);

                        return GestureDetector(
                          onTap: () => _showCardDetails(card),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.only(left: 8, right: 8, top: isActive ? 0 : 15, bottom: isActive ? 0 : 15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: card.gradient),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: isActive && !isFrozen ? [BoxShadow(color: card.gradient[0].withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))] : [],
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(Icons.contactless_outlined, color: Colors.white, size: 28),
                                          Text(card.type, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
                                        ],
                                      ),
                                      const Spacer(),
                                      Text(card.cardNumber, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2)),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("CARD HOLDER", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.w600)),
                                              const SizedBox(height: 4),
                                              Text(card.cardHolder, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("EXPIRES", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.w600)),
                                              const SizedBox(height: 4),
                                              Text(card.expiryDate, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (isFrozen)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                      child: Container(
                                        color: Colors.white.withOpacity(0.2),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.ac_unit_rounded, color: Colors.white, size: 40),
                                              const SizedBox(height: 8),
                                              Text("CARD FROZEN", style: TextStyle(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w900, letterSpacing: 2)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(cards.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentCardIndex == index ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentCardIndex == index ? AppColors.primaryIndigo : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 350,
          left: 0,
          right: 0,
          bottom: 90,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildWalletAction(
                      _frozenCards.contains(cards[_currentCardIndex].id) ? Icons.play_arrow_rounded : Icons.ac_unit_rounded,
                      _frozenCards.contains(cards[_currentCardIndex].id) ? "Unfreeze" : "Freeze",
                      _frozenCards.contains(cards[_currentCardIndex].id) ? AppColors.positiveEmerald : AppColors.primaryIndigo,
                          () {
                        setState(() {
                          final id = cards[_currentCardIndex].id;
                          if (_frozenCards.contains(id)) {
                            _frozenCards.remove(id);
                          } else {
                            _frozenCards.add(id);
                          }
                        });
                      },
                    ),
                    _buildWalletAction(Icons.password_rounded, "PIN", AppColors.positiveEmerald, _showPinSheet),
                    _buildWalletAction(Icons.speed_rounded, "Limits", AppColors.accentAmber, () => _showLimitsSheet(cards[_currentCardIndex].id)),
                    _buildWalletAction(Icons.settings_rounded, "Settings", AppColors.textSecondary, () => _showSettingsSheet(cards[_currentCardIndex].id)),
                  ],
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Card Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: 0.2)),
                      Text("See All", style: TextStyle(color: AppColors.primaryIndigo, fontWeight: FontWeight.w700, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: TransactionList(
                    activeCurrency: activeCurrency,
                    transactions: _currentCardIndex % 2 == 0 ? transactions : transactions.reversed.toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsTab() {
    final currencyFormat = NumberFormat.currency(symbol: activeCurrency['symbol'], decimalDigits: 2);

    final baseMultipliers = [0.03, 0.22, 1.0, 11.5];
    final randomJitters = [
      [1.2, 0.8, 1.1, 0.9],
      [0.9, 1.1, 0.95, 1.05],
      [1.0, 1.0, 1.0, 1.0],
      [1.05, 0.95, 1.1, 0.9],
    ];

    List<CategoryModel> dynamicCategories = [];
    double calculatedTotal = 0;

    for (int i = 0; i < categories.length; i++) {
      final cat = categories[i];
      final multiplier = baseMultipliers[_activeTimeFilter] * randomJitters[_activeTimeFilter][i % 4];
      final newAmount = cat.amount * multiplier;
      calculatedTotal += newAmount;
      dynamicCategories.add(CategoryModel(
        id: cat.id,
        name: cat.name,
        amount: newAmount,
        icon: cat.icon,
        color: cat.color,
        backgroundColor: cat.backgroundColor,
        percentage: 0,
      ));
    }

    List<CategoryModel> activeCategories = dynamicCategories.map((c) => CategoryModel(
      id: c.id,
      name: c.name,
      amount: c.amount,
      icon: c.icon,
      color: c.color,
      backgroundColor: c.backgroundColor,
      percentage: calculatedTotal == 0 ? 0 : c.amount / calculatedTotal,
    )).toList();

    double totalSpentConverted = calculatedTotal * activeCurrency['rate'];

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 380,
          child: Container(
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
                        _buildTopIcon(Icons.arrow_back_ios_new_rounded, () => setState(() => navIndex = 0)),
                        const Text("STATISTICS", style: TextStyle(color: Colors.white, letterSpacing: 2.5, fontWeight: FontWeight.w900, fontSize: 11)),
                        _buildTopIcon(Icons.calendar_month_rounded, () {}),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 180,
                    width: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        TweenAnimationBuilder<double>(
                          key: ValueKey(_activeTimeFilter),
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return CustomPaint(
                              size: const Size(180, 180),
                              painter: DonutChartPainter(activeCategories, value),
                            );
                          },
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Total Spent", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            TweenAnimationBuilder<double>(
                              key: ValueKey(_activeTimeFilter),
                              tween: Tween<double>(begin: 0, end: totalSpentConverted),
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Text(
                                  currencyFormat.format(value),
                                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 320,
          left: 0,
          right: 0,
          bottom: 90,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTimeFilter("Day", 0),
                      _buildTimeFilter("Week", 1),
                      _buildTimeFilter("Month", 2),
                      _buildTimeFilter("Year", 3),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Top Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: 0.2)),
                      Icon(Icons.sort_rounded, color: AppColors.textSecondary, size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    physics: const BouncingScrollPhysics(),
                    itemCount: activeCategories.length,
                    itemBuilder: (context, index) {
                      final cat = activeCategories[index];
                      final convertedAmount = cat.amount * activeCurrency['rate'];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: cat.backgroundColor, borderRadius: BorderRadius.circular(14)),
                                  child: Icon(cat.icon, color: cat.color, size: 22),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                                      const SizedBox(height: 4),
                                      Text("${(cat.percentage * 100).toInt()}%", style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                TweenAnimationBuilder<double>(
                                  key: ValueKey(_activeTimeFilter),
                                  tween: Tween<double>(begin: 0, end: convertedAmount),
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, value, child) {
                                    return Text(
                                      currencyFormat.format(value),
                                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w900, fontSize: 15),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Stack(
                              children: [
                                Container(height: 6, decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(3))),
                                TweenAnimationBuilder<double>(
                                  key: ValueKey(_activeTimeFilter),
                                  tween: Tween<double>(begin: 0, end: cat.percentage),
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, value, child) {
                                    return FractionallySizedBox(
                                      widthFactor: value,
                                      child: Container(height: 6, decoration: BoxDecoration(color: cat.color, borderRadius: BorderRadius.circular(3))),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeFilter(String label, int index) {
    final isActive = _activeTimeFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTimeFilter = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryIndigo : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 380,
          child: Container(
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
                        _buildTopIcon(Icons.arrow_back_ios_new_rounded, () => setState(() => navIndex = 0)),
                        const Text("PROFILE", style: TextStyle(color: Colors.white, letterSpacing: 2.5, fontWeight: FontWeight.w900, fontSize: 11)),
                        _buildTopIcon(Icons.settings_rounded, _showMenuPanel),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primaryIndigo.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                    ),
                    child: const Center(
                      child: Icon(Icons.person_rounded, size: 50, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Alexander Pierce", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("Premium Member", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 320,
          left: 0,
          right: 0,
          bottom: 90,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: ListView(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 24),
              physics: const BouncingScrollPhysics(),
              children: [
                const Text("Account", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 1)),
                const SizedBox(height: 16),
                _buildProfileRow(Icons.person_outline_rounded, "Personal Information", "Edit your profile details", _showPersonalInfoSheet),
                _buildProfileRow(Icons.account_balance_rounded, "Connected Banks", "Manage your bank accounts", _showBankAccountsSheet),

                const SizedBox(height: 32),
                const Text("Security", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 1)),
                const SizedBox(height: 16),
                _buildProfileRow(Icons.lock_outline_rounded, "Change PIN", "Update your 4-digit PIN", _showPinSheet),
                _buildProfileSwitch(Icons.face_rounded, "Face ID / Touch ID", _isFaceIdEnabled, (val) => setState(() => _isFaceIdEnabled = val)),

                const SizedBox(height: 32),
                const Text("Preferences", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 1)),
                const SizedBox(height: 16),
                _buildProfileSwitch(Icons.notifications_active_outlined, "Push Notifications", _isPushEnabled, (val) => setState(() => _isPushEnabled = val)),
                _buildProfileSwitch(Icons.dark_mode_outlined, "Dark Mode", _isDarkMode, (val) => setState(() => _isDarkMode = val)),
                _buildProfileRow(Icons.language_rounded, "Language", "English (US)", () {}),

                const SizedBox(height: 32),
                const Text("Support", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 1)),
                const SizedBox(height: 16),
                _buildProfileRow(Icons.help_outline_rounded, "Help Center", "FAQ and Support", () {}),
                _buildProfileRow(Icons.logout_rounded, "Log Out", "Sign out of your account", () {}, AppColors.negativeRose),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileRow(IconData icon, String title, String subtitle, VoidCallback onTap, [Color iconColor = AppColors.primaryIndigo]) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: iconColor == AppColors.negativeRose ? iconColor : AppColors.textPrimary)),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ]
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSwitch(IconData icon, String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: AppColors.primaryIndigo, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ),
          CupertinoSwitch(
            value: value,
            activeColor: AppColors.primaryIndigo,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          IndexedStack(
            index: navIndex,
            children: [
              _buildHomeTab(),
              _buildWalletTab(),
              const SizedBox(),
              _buildStatisticsTab(),
              _buildProfileTab(),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomNavigationBar(
              currentIndex: navIndex,
              onTap: (index) {
                if (index == 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Opening Camera scanner..."),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.secondarySlate,
                    ),
                  );
                  return;
                }
                setState(() {
                  navIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final List<CategoryModel> categories;
  final double animationValue;

  DonutChartPainter(this.categories, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 12;
    double startAngle = -pi / 2;

    for (var category in categories) {
      final sweepAngle = (category.percentage * 2 * pi) * animationValue;

      final paint = Paint()
        ..color = category.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round;

      if (sweepAngle > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle - 0.15,
          false,
          paint,
        );
      }
      startAngle += (category.percentage * 2 * pi);
    }
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || oldDelegate.categories != categories;
  }
}
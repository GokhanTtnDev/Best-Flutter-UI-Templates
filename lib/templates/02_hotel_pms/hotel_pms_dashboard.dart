import 'package:flutter/material.dart';
import 'views/overview_view.dart';
import 'views/bookings_view.dart';
import 'views/housekeeping_view.dart';
import 'views/guests_view.dart';
import 'views/reports_view.dart';
import 'views/settings_view.dart';

class HotelPmsDashboard extends StatefulWidget {
  const HotelPmsDashboard({super.key});

  @override
  State<HotelPmsDashboard> createState() => _HotelPmsDashboardState();
}

class _HotelPmsDashboardState extends State<HotelPmsDashboard> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;
  bool _pushNotifications = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.grid_view_rounded, 'title': 'Overview'},
    {'icon': Icons.calendar_month_rounded, 'title': 'Bookings'},
    {'icon': Icons.cleaning_services_rounded, 'title': 'Housekeeping'},
    {'icon': Icons.people_alt_rounded, 'title': 'Guests'},
    {'icon': Icons.analytics_rounded, 'title': 'Reports'},
    {'icon': Icons.settings_rounded, 'title': 'Settings'},
  ];

  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'New VIP Booking',
      'message': 'Marcus Aurelius booked Presidential Suite.',
      'time': '2m ago',
      'isRead': false,
      'icon': Icons.star_rounded,
      'color': const Color(0xFFF59E0B),
    },
    {
      'title': 'Housekeeping Update',
      'message': 'Room 205 has been cleaned and inspected.',
      'time': '1h ago',
      'isRead': true,
      'icon': Icons.cleaning_services_rounded,
      'color': const Color(0xFF10B981),
    },
  ];

  List<Map<String, dynamic>> _bookings = [
    {'name': 'Marcus Aurelius', 'room': '101', 'type': 'Deluxe', 'status': 'Confirmed', 'dates': 'Oct 12 - Oct 15'},
    {'name': 'Seneca', 'room': '205', 'type': 'Suite', 'status': 'Checked In', 'dates': 'Oct 10 - Oct 14'},
    {'name': 'Epictetus', 'room': '302', 'type': 'Standard', 'status': 'Pending', 'dates': 'Oct 13 - Oct 16'},
    {'name': 'Zeno', 'room': '104', 'type': 'Deluxe', 'status': 'Checked Out', 'dates': 'Oct 05 - Oct 10'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _checkInController.dispose();
    _checkOutController.dispose();
    super.dispose();
  }

  void _showNotificationsPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: _isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                      color: _isDarkMode ? const Color(0xFF0F172A) : Colors.white,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      border: Border(bottom: BorderSide(color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Notifications',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white : const Color(0xFF0F172A)),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              for (var n in _notifications) {
                                n['isRead'] = true;
                              }
                            });
                            setState(() {});
                          },
                          child: const Text('Mark all as read', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final n = _notifications[index];
                        final isRead = n['isRead'] as bool;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              n['isRead'] = true;
                            });
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isRead
                                  ? (_isDarkMode ? const Color(0xFF0F172A) : Colors.white)
                                  : (_isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF)),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: isRead
                                      ? (_isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0))
                                      : const Color(0xFF3B82F6).withOpacity(0.5)
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: (n['color'] as Color).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(n['icon'], color: n['color'], size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(n['title'], style: TextStyle(fontWeight: isRead ? FontWeight.w600 : FontWeight.w700, color: _isDarkMode ? Colors.white : const Color(0xFF0F172A))),
                                          Text(n['time'], style: TextStyle(fontSize: 12, color: isRead ? const Color(0xFF94A3B8) : const Color(0xFF3B82F6))),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(n['message'], style: TextStyle(fontSize: 14, color: isRead ? const Color(0xFF64748B) : const Color(0xFF334155))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showNewBookingModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _isDarkMode ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('New Booking', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white : const Color(0xFF0F172A))),
                const SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Guest Name',
                    labelStyle: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black54),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _isDarkMode ? const Color(0xFF334155) : Colors.grey.shade400),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _checkInController,
                        style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Check-in Date',
                          labelStyle: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black54),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: _isDarkMode ? const Color(0xFF334155) : Colors.grey.shade400),
                          ),
                          suffixIcon: Icon(Icons.calendar_today, color: _isDarkMode ? Colors.white70 : Colors.black54),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _checkOutController,
                        style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Check-out Date',
                          labelStyle: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black54),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: _isDarkMode ? const Color(0xFF334155) : Colors.grey.shade400),
                          ),
                          suffixIcon: Icon(Icons.calendar_today, color: _isDarkMode ? Colors.white70 : Colors.black54),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.trim().isNotEmpty) {
                        setState(() {
                          _bookings.insert(0, {
                            'name': _nameController.text.trim(),
                            'room': 'TBD',
                            'type': 'Standard',
                            'status': 'Confirmed',
                            'dates': '${_checkInController.text.isEmpty ? 'Today' : _checkInController.text} - ${_checkOutController.text.isEmpty ? 'Tomorrow' : _checkOutController.text}',
                          });
                          _selectedIndex = 1;
                        });

                        _nameController.clear();
                        _checkInController.clear();
                        _checkOutController.clear();

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Booking successfully created!'),
                            backgroundColor: const Color(0xFF10B981),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Confirm Booking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const OverviewView(),
          BookingsView(bookings: _bookings),
          const HousekeepingView(),
          const GuestsView(),
          const ReportsView(),
          SettingsView(
            isDarkMode: _isDarkMode,
            pushNotifications: _pushNotifications,
            onThemeChanged: (val) => setState(() => _isDarkMode = val),
            onPushChanged: (val) => setState(() => _pushNotifications = val),
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1 || _selectedIndex == 0
          ? FloatingActionButton.extended(
        onPressed: _showNewBookingModal,
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add, size: 20),
        label: const Text('New Booking', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        elevation: 4,
      )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final unreadCount = _notifications.where((n) => !(n['isRead'] as bool)).length;
    return AppBar(
      backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: _isDarkMode ? Colors.white : const Color(0xFF0F172A)),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0), height: 1.0),
      ),
      title: Text(
        _menuItems[_selectedIndex]['title'],
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _isDarkMode ? Colors.white : const Color(0xFF0F172A)),
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: _showNotificationsPanel,
              icon: Icon(Icons.notifications_outlined, color: _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
            ),
            if (unreadCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, height: 1),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 8),
        const CircleAvatar(
          radius: 16,
          backgroundColor: Color(0xFFE2E8F0),
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.apartment_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('GokhanTtnDev Hotel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white : const Color(0xFF0F172A))),
                      Text('Premium PMS', style: TextStyle(fontSize: 12, color: _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _menuItems.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (_isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9))
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(_menuItems[index]['icon'], color: isSelected ? (_isDarkMode ? Colors.white : const Color(0xFF0F172A)) : const Color(0xFF64748B), size: 22),
                            const SizedBox(width: 12),
                            Text(_menuItems[index]['title'], style: TextStyle(fontSize: 15, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, color: isSelected ? (_isDarkMode ? Colors.white : const Color(0xFF0F172A)) : const Color(0xFF64748B))),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(height: 1, color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  const CircleAvatar(radius: 18, backgroundColor: Color(0xFFE2E8F0), backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11')),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Front Desk', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _isDarkMode ? Colors.white : const Color(0xFF0F172A))),
                        Text('Shift: 08:00 - 16:00', style: TextStyle(fontSize: 11, color: _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B)), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
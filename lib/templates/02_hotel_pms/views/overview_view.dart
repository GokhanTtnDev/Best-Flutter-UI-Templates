import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OverviewView extends StatefulWidget {
  const OverviewView({super.key});

  @override
  State<OverviewView> createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Prepare VIP welcome package for Room 301', 'isDone': false, 'time': '14:00'},
    {'title': 'Review night audit discrepancy', 'isDone': true, 'time': '09:00'},
    {'title': 'Order fresh linens from supplier', 'isDone': false, 'time': '16:30'},
    {'title': 'Call maintenance for AC in Room 205', 'isDone': true, 'time': '11:15'},
  ];

  final List<Map<String, dynamic>> _activities = [
    {'title': 'Marcus Aurelius checked in', 'room': '301', 'time': '10 mins ago', 'icon': Icons.login_rounded, 'color': const Color(0xFF10B981)},
    {'title': 'Room 104 cleaned by Maria', 'room': '104', 'time': '45 mins ago', 'icon': Icons.cleaning_services_rounded, 'color': const Color(0xFF3B82F6)},
    {'title': 'Zeno checked out', 'room': '205', 'time': '2 hours ago', 'icon': Icons.logout_rounded, 'color': const Color(0xFFF59E0B)},
    {'title': 'New booking from Expedia', 'room': 'Pending', 'time': '3 hours ago', 'icon': Icons.book_online_rounded, 'color': const Color(0xFF8B5CF6)},
  ];

  final List<double> _weeklyRevenue = [0.4, 0.6, 0.5, 0.8, 1.0, 0.7, 0.9];

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(currentDate),
          const SizedBox(height: 24),

          _buildSectionTitle('Key Performance Indicators'),
          const SizedBox(height: 16),
          _buildMetricsGrid(),
          const SizedBox(height: 32),

          _buildSectionTitle('Revenue Trend (Last 7 Days)'),
          const SizedBox(height: 16),
          _buildRevenueChart(),
          const SizedBox(height: 32),

          _buildSectionTitle('Live Room Status'),
          const SizedBox(height: 16),
          _buildRoomStatusSummary(),
          const SizedBox(height: 32),

          _buildSectionTitle('Front Desk Tasks'),
          const SizedBox(height: 16),
          _buildTasksList(),
          const SizedBox(height: 32),

          _buildSectionTitle('Recent Activity Feed'),
          const SizedBox(height: 16),
          _buildActivityFeed(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xFF0F172A),
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildHeader(String date) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good Morning, Team',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                date,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const Column(
              children: [
                Icon(Icons.wb_sunny_rounded, color: Color(0xFFFBBF24), size: 28),
                SizedBox(height: 4),
                Text('24°C', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    final List<Map<String, dynamic>> metrics = [
      {'title': 'Arrivals', 'value': '24', 'trend': '+4', 'isPositive': true, 'icon': Icons.login_rounded, 'color': const Color(0xFF3B82F6)},
      {'title': 'Departures', 'value': '18', 'trend': '-2', 'isPositive': false, 'icon': Icons.logout_rounded, 'color': const Color(0xFFF59E0B)},
      {'title': 'Occupancy', 'value': '86%', 'trend': '+5%', 'isPositive': true, 'icon': Icons.pie_chart_rounded, 'color': const Color(0xFF10B981)},
      {'title': 'RevPAR', 'value': '\$142', 'trend': '+\$12', 'isPositive': true, 'icon': Icons.trending_up_rounded, 'color': const Color(0xFF8B5CF6)},
      {'title': 'ADR', 'value': '\$185', 'trend': '+\$5', 'isPositive': true, 'icon': Icons.attach_money_rounded, 'color': const Color(0xFF06B6D4)},
      {'title': 'Available', 'value': '14', 'trend': 'Low', 'isPositive': false, 'icon': Icons.meeting_room_rounded, 'color': const Color(0xFFEF4444)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final m = metrics[index];
        final color = m['color'] as Color;
        final icon = m['icon'] as IconData;
        final isPositive = m['isPositive'] as bool;
        final trend = m['trend'] as String;
        final value = m['value'] as String;
        final title = m['title'] as String;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPositive ? const Color(0xFF10B981).withOpacity(0.1) : const Color(0xFFEF4444).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      trend,
                      style: TextStyle(
                        color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                  Text(title, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRevenueChart() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      height: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('\$42,500.00', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                child: const Text('This Week', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_weeklyRevenue.length, (index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: _weeklyRevenue[index],
                          child: Container(
                            width: 32,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      days[index],
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomStatusSummary() {
    final statuses = [
      {'label': 'Clean', 'count': '42', 'color': const Color(0xFF10B981)},
      {'label': 'Dirty', 'count': '18', 'color': const Color(0xFFEF4444)},
      {'label': 'Cleaning', 'count': '6', 'color': const Color(0xFFF59E0B)},
      {'label': 'Maint.', 'count': '3', 'color': const Color(0xFF64748B)},
    ];

    return Row(
      children: statuses.map((status) {
        final color = status['color'] as Color;
        final count = status['count'] as String;
        final label = status['label'] as String;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color.withOpacity(0.8)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTasksList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _tasks.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE2E8F0)),
        itemBuilder: (context, index) {
          final task = _tasks[index];
          final isDone = task['isDone'] as bool;
          final title = task['title'] as String;
          final time = task['time'] as String;

          return CheckboxListTile(
            value: isDone,
            onChanged: (bool? value) {
              setState(() {
                _tasks[index]['isDone'] = value ?? false;
              });
            },
            activeColor: const Color(0xFF10B981),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDone ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                decoration: isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              'Scheduled for $time',
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            controlAffinity: ListTileControlAffinity.leading,
          );
        },
      ),
    );
  }

  Widget _buildActivityFeed() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _activities.length,
        itemBuilder: (context, index) {
          final activity = _activities[index];
          final color = activity['color'] as Color;
          final icon = activity['icon'] as IconData;
          final title = activity['title'] as String;
          final time = activity['time'] as String;
          final room = activity['room'] as String;
          final isLast = index == _activities.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 18),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: const Color(0xFFE2E8F0),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              time,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(color: Color(0xFFCBD5E1), shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Room $room',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF3B82F6)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
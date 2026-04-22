import 'package:flutter/material.dart';

class HousekeepingView extends StatefulWidget {
  const HousekeepingView({super.key});

  @override
  State<HousekeepingView> createState() => _HousekeepingViewState();
}

class _HousekeepingViewState extends State<HousekeepingView> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Dirty', 'Cleaning', 'Clean', 'Maintenance', 'DND'];

  final List<Map<String, dynamic>> _rooms = [
    {
      'id': 'R101',
      'number': '101',
      'type': 'Standard',
      'status': 'Clean',
      'assignedTo': 'Maria Garcia',
      'notes': '',
      'isPriority': false,
    },
    {
      'id': 'R102',
      'number': '102',
      'type': 'Deluxe',
      'status': 'Dirty',
      'assignedTo': 'Unassigned',
      'notes': 'Guest requested extra towels.',
      'isPriority': true,
    },
    {
      'id': 'R103',
      'number': '103',
      'type': 'Suite',
      'status': 'Cleaning',
      'assignedTo': 'Elena Rodriguez',
      'notes': 'Deep clean required.',
      'isPriority': false,
    },
    {
      'id': 'R201',
      'number': '201',
      'type': 'Standard',
      'status': 'DND',
      'assignedTo': 'Unassigned',
      'notes': 'Do not disturb until 14:00.',
      'isPriority': false,
    },
    {
      'id': 'R202',
      'number': '202',
      'type': 'Standard',
      'status': 'Maintenance',
      'assignedTo': 'Tech Team',
      'notes': 'AC unit leaking.',
      'isPriority': true,
    },
    {
      'id': 'R203',
      'number': '203',
      'type': 'Deluxe',
      'status': 'Dirty',
      'assignedTo': 'Maria Garcia',
      'notes': '',
      'isPriority': false,
    },
    {
      'id': 'R301',
      'number': '301',
      'type': 'Suite',
      'status': 'Clean',
      'assignedTo': 'Elena Rodriguez',
      'notes': 'VIP inspection passed.',
      'isPriority': false,
    },
    {
      'id': 'R302',
      'number': '302',
      'type': 'Standard',
      'status': 'Dirty',
      'assignedTo': 'Unassigned',
      'notes': '',
      'isPriority': false,
    },
  ];

  final List<String> _staffMembers = [
    'Unassigned',
    'Maria Garcia',
    'Elena Rodriguez',
    'Rosa Gomez',
    'Tech Team'
  ];

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'clean':
        return const Color(0xFF10B981);
      case 'dirty':
        return const Color(0xFFEF4444);
      case 'cleaning':
        return const Color(0xFFF59E0B);
      case 'maintenance':
        return const Color(0xFF64748B);
      case 'dnd':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF64748B);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'clean':
        return Icons.check_circle_rounded;
      case 'dirty':
        return Icons.cleaning_services_rounded;
      case 'cleaning':
        return Icons.autorenew_rounded;
      case 'maintenance':
        return Icons.build_rounded;
      case 'dnd':
        return Icons.do_not_disturb_on_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  void _showActionMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showAddRoomModal() {
    final TextEditingController numberController = TextEditingController();
    String selectedType = 'Standard';
    String selectedStatus = 'Clean';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add New Room',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: numberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Room Number',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: 'Room Type',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                      items: ['Standard', 'Deluxe', 'Suite', 'Penthouse'].map((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value));
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) setModalState(() => selectedType = newValue);
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: InputDecoration(
                        labelText: 'Initial Status',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                      items: ['Clean', 'Dirty', 'Maintenance'].map((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value));
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) setModalState(() => selectedStatus = newValue);
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (numberController.text.trim().isEmpty) {
                            _showActionMessage('Room number is required', isError: true);
                            return;
                          }
                          setState(() {
                            _rooms.add({
                              'id': 'R${numberController.text.trim()}',
                              'number': numberController.text.trim(),
                              'type': selectedType,
                              'status': selectedStatus,
                              'assignedTo': 'Unassigned',
                              'notes': '',
                              'isPriority': false,
                            });
                          });
                          Navigator.pop(context);
                          _showActionMessage('Room ${numberController.text} added successfully');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Save Room', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showRoomDetailsModal(BuildContext context, int index) {
    final room = _rooms[index];
    String currentStatus = room['status'];
    String currentAssigned = room['assignedTo'];
    bool isPriority = room['isPriority'];
    final TextEditingController notesController = TextEditingController(text: room['notes']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.85,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 24),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Room ${room['number']}',
                                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                  ),
                                  if (isPriority) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF2F2),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: const Color(0xFFFECACA)),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFEF4444)),
                                          SizedBox(width: 4),
                                          Text('Priority', style: TextStyle(color: Color(0xFFEF4444), fontSize: 12, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                room['type'],
                                style: const TextStyle(fontSize: 16, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete Room'),
                                  content: Text('Are you sure you want to remove Room ${room['number']} from the system?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _rooms.removeAt(index);
                                        });
                                        Navigator.pop(ctx);
                                        _showActionMessage('Room ${room['number']} deleted', isError: true);
                                      },
                                      child: const Text('Delete', style: TextStyle(color: Color(0xFFEF4444))),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                            style: IconButton.styleFrom(backgroundColor: const Color(0xFFFEF2F2)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Update Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: ['Clean', 'Dirty', 'Cleaning', 'Maintenance', 'DND'].map((status) {
                                final isSelected = currentStatus == status;
                                final color = _getStatusColor(status);
                                return ChoiceChip(
                                  label: Text(status),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) setModalState(() => currentStatus = status);
                                  },
                                  labelStyle: TextStyle(
                                    color: isSelected ? Colors.white : color,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  ),
                                  backgroundColor: color.withOpacity(0.1),
                                  selectedColor: color,
                                  side: BorderSide(color: isSelected ? color : color.withOpacity(0.3)),
                                  showCheckmark: false,
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                            const Text('Assign Housekeeper', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: currentAssigned,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              items: _staffMembers.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    children: [
                                      Icon(
                                        value == 'Unassigned' ? Icons.person_off_rounded : Icons.person_rounded,
                                        color: value == 'Unassigned' ? const Color(0xFF94A3B8) : const Color(0xFF3B82F6),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(value),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                if (newValue != null) setModalState(() => currentAssigned = newValue);
                              },
                            ),
                            const SizedBox(height: 24),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Mark as Priority', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                              subtitle: const Text('Requires immediate attention', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                              value: isPriority,
                              onChanged: (val) => setModalState(() => isPriority = val),
                              activeColor: const Color(0xFFEF4444),
                            ),
                            const SizedBox(height: 24),
                            const Text('Housekeeping Notes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                            const SizedBox(height: 12),
                            TextField(
                              controller: notesController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: 'Add special instructions, lost & found items, or maintenance requests...',
                                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: const BorderSide(color: Color(0xFFE2E8F0), width: 2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Cancel', style: TextStyle(color: Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _rooms[index]['status'] = currentStatus;
                                  _rooms[index]['assignedTo'] = currentAssigned;
                                  _rooms[index]['isPriority'] = isPriority;
                                  _rooms[index]['notes'] = notesController.text.trim();
                                });
                                Navigator.pop(context);
                                _showActionMessage('Room ${room['number']} updated successfully');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F172A),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalDirty = _rooms.where((r) => r['status'] == 'Dirty').length;
    int totalClean = _rooms.where((r) => r['status'] == 'Clean').length;
    int totalPriority = _rooms.where((r) => r['isPriority'] == true).length;

    final filteredRooms = _selectedFilter == 'All'
        ? _rooms
        : _rooms.where((r) => r['status'].toString().toLowerCase() == _selectedFilter.toLowerCase()).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: 'Dirty',
                  count: totalDirty.toString(),
                  color: const Color(0xFFEF4444),
                  icon: Icons.cleaning_services_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  title: 'Clean',
                  count: totalClean.toString(),
                  color: const Color(0xFF10B981),
                  icon: Icons.check_circle_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  title: 'Priority',
                  count: totalPriority.toString(),
                  color: const Color(0xFFF59E0B),
                  icon: Icons.warning_rounded,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _showAddRoomModal,
                child: Container(
                  height: 80,
                  width: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: _filters.map((filter) {
              final isSelected = _selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF64748B),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedFilter = filter);
                  },
                  backgroundColor: Colors.white,
                  selectedColor: const Color(0xFF0F172A),
                  side: BorderSide(color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: filteredRooms.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.meeting_room_rounded, size: 48, color: Color(0xFFCBD5E1)),
                const SizedBox(height: 16),
                Text('No $_selectedFilter rooms found', style: const TextStyle(color: Color(0xFF64748B), fontSize: 16)),
              ],
            ),
          )
              : GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: filteredRooms.length,
            itemBuilder: (context, index) {
              final room = filteredRooms[index];
              final originalIndex = _rooms.indexWhere((r) => r['id'] == room['id']);
              final statusColor = _getStatusColor(room['status']);
              final statusIcon = _getStatusIcon(room['status']);
              final bool isPriority = room['isPriority'];

              return GestureDetector(
                onTap: () => _showRoomDetailsModal(context, originalIndex),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isPriority ? const Color(0xFFEF4444) : const Color(0xFFE2E8F0), width: isPriority ? 2 : 1),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.05),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                          border: Border(bottom: BorderSide(color: statusColor.withOpacity(0.1))),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(statusIcon, color: statusColor, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  room['status'],
                                  style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            if (isPriority) const Icon(Icons.warning_rounded, color: Color(0xFFEF4444), size: 16),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(room['number'], style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                              const SizedBox(height: 4),
                              Text(room['type'], style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: room['assignedTo'] == 'Unassigned' ? const Color(0xFFF1F5F9) : const Color(0xFFEFF6FF),
                              child: Icon(
                                room['assignedTo'] == 'Unassigned' ? Icons.person_off_rounded : Icons.person_rounded,
                                size: 14,
                                color: room['assignedTo'] == 'Unassigned' ? const Color(0xFF94A3B8) : const Color(0xFF3B82F6),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                room['assignedTo'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: room['assignedTo'] == 'Unassigned' ? const Color(0xFF94A3B8) : const Color(0xFF334155),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
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
    );
  }

  Widget _buildSummaryCard({required String title, required String count, required Color color, required IconData icon}) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Text(count, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            ],
          ),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}
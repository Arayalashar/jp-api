import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/supir_provider.dart';
import '../../../shared/widgets/custom_snackbar.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/theme/light_theme.dart';


class TugasSupirScreen extends StatefulWidget {
  final String idSupir;
  const TugasSupirScreen({super.key, required this.idSupir});

  @override
  State<TugasSupirScreen> createState() => _TugasSupirScreenState();
}

class _TugasSupirScreenState extends State<TugasSupirScreen> {
  String _selectedFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Siap Dikirim', 'Dalam Perjalanan', 'Sampai Tujuan', 'Gagal Kirim'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupirProvider>().fetchTugas(widget.idSupir);
    });
  }

  List<dynamic> _getFilteredList(List<dynamic> allTugas) {
    if (_selectedFilter == 'Semua') return allTugas;
    return allTugas.where((t) => t['status_pengiriman'] == _selectedFilter).toList();
  }

  void _showUpdateDialog(Map<String, dynamic> tugas) {
    String selectedStatus = "Dalam Perjalanan";
    TextEditingController ketController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              backgroundColor: LightTheme.surface,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  decoration: BoxDecoration(
                    color: LightTheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: LightTheme.border),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: LightTheme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.local_shipping_outlined, color: LightTheme.primary, size: 24),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Text("Update Pengiriman", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: LightTheme.textPrimary)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Dokumen info
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: LightTheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: LightTheme.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tugas['nomor_dokumen'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: LightTheme.textPrimary)),
                            const SizedBox(height: 4),
                            Text("Tujuan: ${tugas['tujuan_pengiriman']}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: LightTheme.textTertiary)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text("Status Terbaru", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: LightTheme.textPrimary)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedStatus,
                        dropdownColor: LightTheme.surface,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: LightTheme.textSecondary),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: LightTheme.textPrimary),
                        items: ['Dalam Perjalanan', 'Sampai Tujuan', 'Gagal Kirim']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: LightTheme.textPrimary))))
                            .toList(),
                        onChanged: (val) => setStateDialog(() => selectedStatus = val!),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: LightTheme.surfaceVariant,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: LightTheme.border)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: LightTheme.border)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: LightTheme.primary)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text("Keterangan Tambahan", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: LightTheme.textPrimary)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: ketController,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 14, color: LightTheme.textPrimary),
                        decoration: InputDecoration(
                          hintText: "Nama Penerima / Alasan Gagal...",
                          hintStyle: const TextStyle(color: LightTheme.textTertiary),
                          filled: true,
                          fillColor: LightTheme.surfaceVariant,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: LightTheme.border)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: LightTheme.border)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: LightTheme.primary)),
                        ),
                      ),
                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(dialogContext);
                            final provider = context.read<SupirProvider>();
                            final result = await provider.updateStatus(
                              idDokumen: tugas['id_dokumen'].toString(),
                              status: selectedStatus,
                              keterangan: ketController.text,
                              idSupir: widget.idSupir,
                            );
                            if (mounted) {
                              if (result['status'] == 'success') {
                                CustomSnackbar.show(context, "Status berhasil diperbarui!");
                              } else {
                                CustomSnackbar.show(context, result['message'] ?? 'Gagal', isError: true);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: LightTheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text("Simpan Status", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: LightTheme.textSecondary,
                            side: const BorderSide(color: LightTheme.border, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text("Batal", style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
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
    return Scaffold(
      backgroundColor: LightTheme.background,
      appBar: AppBar(
        title: const Text('Daftar Pengiriman', style: TextStyle(color: LightTheme.textPrimary, fontWeight: FontWeight.w700)),
        backgroundColor: LightTheme.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: LightTheme.textPrimary),
      ),
      body: SafeArea(
        bottom: false,
        child: Consumer<SupirProvider>(
          builder: (context, provider, child) {
            return RefreshIndicator(
              onRefresh: () => provider.fetchTugas(widget.idSupir),
              color: LightTheme.primary,
              backgroundColor: LightTheme.surface,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                  
                  if (provider.isLoading && provider.tugasList.isEmpty)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator(color: LightTheme.primary)),
                    )
                  else if (provider.errorMessage != null && provider.tugasList.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline_rounded, size: 48, color: LightTheme.warning),
                            const SizedBox(height: 16),
                            Text(provider.errorMessage!, style: const TextStyle(color: LightTheme.warning)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => provider.fetchTugas(widget.idSupir), 
                              style: ElevatedButton.styleFrom(backgroundColor: LightTheme.primary, foregroundColor: Colors.white),
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    // Filter chips
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 8),
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _filters.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final f = _filters[index];
                            final isSelected = _selectedFilter == f;
                            return ChoiceChip(
                              label: Text(f),
                              selected: isSelected,
                              onSelected: (_) => setState(() => _selectedFilter = f),
                              selectedColor: LightTheme.primary,
                              backgroundColor: LightTheme.primary.withValues(alpha: 0.05),
                              labelStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? LightTheme.surface : LightTheme.primary.withValues(alpha: 0.8),
                              ),
                              side: BorderSide(
                                color: isSelected ? LightTheme.primary : LightTheme.primary.withValues(alpha: 0.2),
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                              showCheckmark: false,
                            );
                          },
                        ),
                      ),
                    ),

                    // List
                    Builder(builder: (context) {
                      final filtered = _getFilteredList(provider.tugasList);
                      if (filtered.isEmpty) {
                        return const SliverFillRemaining(
                          child: EmptyStateWidget(
                            icon: Icons.local_shipping_outlined,
                            title: 'Tidak ada pengiriman',
                            subtitle: 'Tarik ke bawah untuk memuat ulang',
                          ),
                        );
                      }
                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _buildTugasCard(filtered[index])
                                .animate()
                                .fadeIn(duration: 400.ms, delay: Duration(milliseconds: index * 80))
                                .slideY(begin: 0.05, end: 0, duration: 400.ms),
                            childCount: filtered.length,
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  
  Widget _buildTugasCard(Map<String, dynamic> tugas) {
    final status = tugas['status_pengiriman'] ?? 'Pending';
    bool isSelesai = status == 'Sampai Tujuan' || status == 'Gagal Kirim';

    // Timeline steps
    final steps = ['Siap Dikirim', 'Dalam Perjalanan', 'Sampai Tujuan'];
    int currentStepIndex = steps.indexOf(status);
    if (currentStepIndex < 0) currentStepIndex = -1;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: LightTheme.surface, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))], border: Border.all(color: LightTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  tugas['nomor_dokumen'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: LightTheme.textPrimary),
                ),
              ),
              StatusBadge(status: status),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: LightTheme.border),
          ),
          _buildInfoRow(Icons.description_outlined, "Tipe:", tugas['jenis_dokumen']),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.location_on_outlined, "Tujuan:", tugas['tujuan_pengiriman'], isHighlight: true),

          // Timeline
          const SizedBox(height: 16),
          Row(
            children: List.generate(steps.length, (i) {
              bool done = i <= currentStepIndex;
              bool isCurrent = i == currentStepIndex;
              return Expanded(
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: done ? LightTheme.primary : LightTheme.surfaceVariant,
                            shape: BoxShape.circle,
                            border: isCurrent
                                ? Border.all(color: LightTheme.primary.withValues(alpha: 0.5), width: 2)
                                : null,
                            boxShadow: isCurrent
                                ? [BoxShadow(color: LightTheme.primary.withValues(alpha: 0.3), blurRadius: 8)]
                                : null,
                          ),
                          child: done
                              ? const Icon(Icons.check, size: 14, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          steps[i].replaceAll(' ', '\n'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: done ? FontWeight.w700 : FontWeight.w500,
                            color: done ? LightTheme.primary : LightTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    if (i < steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: i < currentStepIndex ? LightTheme.primary : LightTheme.border,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),

          if (!isSelesai) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showUpdateDialog(tugas),
                icon: const Icon(Icons.edit_location_alt_rounded, size: 18),
                label: const Text("Update Status", style: TextStyle(fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: LightTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isHighlight = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(top: 2), child: Icon(icon, size: 16, color: LightTheme.textTertiary)),
        const SizedBox(width: 8),
        Text("$label ", style: const TextStyle(fontSize: 13, color: LightTheme.textTertiary, fontWeight: FontWeight.w500)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: isHighlight ? LightTheme.primary : LightTheme.textPrimary,
              fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w600,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

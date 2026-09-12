import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/supir_provider.dart';
import '../../../shared/theme/light_theme.dart';
import '../../../shared/widgets/empty_state_widget.dart';

class RiwayatSupirScreen extends StatefulWidget {
  final String idSupir;
  const RiwayatSupirScreen({super.key, required this.idSupir});

  @override
  State<RiwayatSupirScreen> createState() => _RiwayatSupirScreenState();
}

class _RiwayatSupirScreenState extends State<RiwayatSupirScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupirProvider>().fetchRiwayat(widget.idSupir);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightTheme.background,
      appBar: AppBar(
        title: const Text('Riwayat Pengiriman', style: TextStyle(color: LightTheme.textPrimary, fontWeight: FontWeight.w700)),
        backgroundColor: LightTheme.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: LightTheme.textPrimary),
      ),
      body: Consumer<SupirProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.riwayatList.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: LightTheme.primary));
          }

          if (provider.errorMessage != null && provider.riwayatList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 48, color: LightTheme.warning),
                  const SizedBox(height: 16),
                  Text(provider.errorMessage!, style: const TextStyle(color: LightTheme.warning)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchRiwayat(widget.idSupir), 
                    style: ElevatedButton.styleFrom(backgroundColor: LightTheme.primary),
                    child: const Text('Coba Lagi', style: TextStyle(color: LightTheme.surface)),
                  ),
                ],
              ),
            );
          }

          final listRiwayat = provider.riwayatList;

          return RefreshIndicator(
            onRefresh: () => provider.fetchRiwayat(widget.idSupir),
            color: LightTheme.primary,
            backgroundColor: LightTheme.surface,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              slivers: [
                if (listRiwayat.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      decoration: const BoxDecoration(
                        color: LightTheme.surface,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                        border: Border(bottom: BorderSide(color: LightTheme.border)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Statistik Pengiriman', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: LightTheme.textPrimary)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(color: LightTheme.primary, borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('${listRiwayat.length}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: LightTheme.surface)),
                                      const Text('Total Pengiriman', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: LightTheme.surface)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                if (listRiwayat.isEmpty)
                  const SliverFillRemaining(
                    child: EmptyStateWidget(
                      icon: Icons.history_rounded,
                      title: 'Belum ada riwayat pengiriman',
                      subtitle: 'Tarik ke bawah untuk memuat ulang',
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = listRiwayat[index];
                          return _buildRiwayatCard(item)
                              .animate()
                              .fadeIn(duration: 400.ms, delay: Duration(milliseconds: index * 50))
                              .slideY(begin: 0.05, end: 0, duration: 400.ms);
                        },
                        childCount: listRiwayat.length,
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

  Widget _buildRiwayatCard(dynamic item) {
    final status = (item['status_pengiriman'] ?? 'Selesai').toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: LightTheme.cardDecoration(radius: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item['nomor_dokumen'] ?? '',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: LightTheme.textPrimary, height: 1.3),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: LightTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: LightTheme.primary.withValues(alpha: 0.2)),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: LightTheme.primary, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: LightTheme.border),
          ),
          _buildInfoRow(Icons.description_outlined, "Jenis:", item['jenis_dokumen'] ?? '-'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.location_on_outlined, "Tujuan:", item['tujuan_pengiriman'] ?? '-'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isBold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 16, color: LightTheme.textTertiary),
        ),
        const SizedBox(width: 8),
        Text("$label ", style: const TextStyle(fontSize: 13, color: LightTheme.textTertiary, fontWeight: FontWeight.w500)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: LightTheme.textPrimary,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../models/gudang_model.dart';
import '../repositories/gudang_repository.dart';

class GudangProvider extends ChangeNotifier {
  final GudangRepository _repository = GudangRepository();
  
  List<GudangModel> _tugasList = [];
  List<GudangModel> _riwayatList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<GudangModel> get tugasList => _tugasList;
  List<GudangModel> get riwayatList => _riwayatList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTugas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tugasList = await _repository.fetchTugas();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRiwayat(String idGudang) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _riwayatList = await _repository.fetchRiwayat(idGudang);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> selesaikanPacking(String idDokumen, String idKaryawan) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _repository.selesaikanPacking(idDokumen, idKaryawan);

      if (result['status'] == 'success') {
        await fetchTugas(); // Refresh data tugas
        await fetchRiwayat(idKaryawan); // Refresh data riwayat agar item baru muncul
      } else {
        _isLoading = false;
        notifyListeners();
      }
      
      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'status': 'error', 'message': 'Terjadi kesalahan sistem.'};
    }
  }
}

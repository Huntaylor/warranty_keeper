// ignore_for_file: library_private_types_in_public_api

part of 'warranty_cubit.dart';

abstract class WarrantyState extends Equatable {
  const WarrantyState();

  bool get isError => this is _Error;
  bool get isLoading => this is _Loading;
  bool get isReady => this is _Ready;

  _Ready get asReady => this as _Ready;
  _Error get asError => this as _Error;
  _Loading get asLoading => this as _Loading;

  @override
  List<Object?> get props => [];
}

class _Loading extends WarrantyState {
  const _Loading();
}

class _Error extends WarrantyState {
  const _Error();
}

@autoequal
@CopyWith()
class _Ready extends WarrantyState {
  const _Ready({
    required this.warrantyInfo,
    this.selectedReminderDateChip,
    this.selectedWarrantyDateChip,
    this.hasError,
  });
  final WarrantyInfo warrantyInfo;
  final int? selectedWarrantyDateChip;
  final int? selectedReminderDateChip;
  final bool? hasError;

  List<Map<String, String>> get warrantyDurationChips {
    const list = [
      {
        'duration': '30 Days',
      },
      {
        'duration': '1 Year',
      },
      {
        'duration': '5 Years',
      },
      {
        'duration': 'Lifetime',
      },
    ];
    return list;
  }

  List<Map<String, String>> get reminderChips {
    const list = [
      {
        'duration': '1 Day',
      },
      {
        'duration': '1 Week',
      },
      {
        'duration': '2 Weeks',
      },
      {
        'duration': '30 Days',
      },
    ];
    return list;
  }

  @override
  List<Object?> get props => _$props;
}

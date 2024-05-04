// ignore_for_file: library_private_types_in_public_api

part of 'warranties_cubit.dart';

abstract class WarrantiesState extends Equatable {
  const WarrantiesState();

  bool get isLoading => this is _Loading;
  bool get isReady => this is _Ready;
  bool get isError => this is _Error;

  _Loading get asLoading => this as _Loading;
  _Ready get asReady => this as _Ready;
  _Error get asError => this as _Error;

  @override
  List<Object?> get props => [];
}

class _Loading extends WarrantiesState {
  const _Loading();
}

enum WarrantiesViewOption { expired, expiring, current }

@autoequal
@CopyWith()
class _Ready extends WarrantiesState {
  const _Ready({
    required this.warranties,
    this.warrantiesViewOption = WarrantiesViewOption.current,
    this.isProductImage = true,
  });

  final WarrantiesViewOption warrantiesViewOption;

  final List<WarrantyInfo> warranties;
  final bool isProductImage;

  List<WarrantyInfo> get lifetimeWarranties {
    return List.from(warranties)..removeWhere((element) => !element.lifetime);
  }

  List<WarrantyInfo> get sortedWarranties {
    List<WarrantyInfo> sortedWarranties;
    List<WarrantyInfo> lifetimeWarrantiesList;
    lifetimeWarrantiesList = List.from(lifetimeWarranties);

    sortedWarranties = List.from(warranties)
      ..removeWhere(
        (element) =>
            element.lifetime ||
            element.endOfWarranty != null &&
                DateTime.now().isAfter(element.endOfWarranty!),
      )
      ..sort(
        (a, b) => a.endOfWarranty!.compareTo(b.endOfWarranty!),
      );
    return sortedWarranties..addAll(lifetimeWarrantiesList);
  }

  List<WarrantyInfo> get currentWarranties {
    List<WarrantyInfo> currentWarranties;
    currentWarranties = List.from(warranties);

    if (currentWarranties.any(
      (e) =>
          e.endOfWarranty != null &&
          e.endOfWarranty!.difference(DateTime.now()).inDays <= 0,
    )) {
      currentWarranties
        ..removeWhere(
          (ee) => ee.endOfWarranty!.difference(DateTime.now()).inDays <= 0,
        )
        ..sort(
          (a, b) => a.endOfWarranty!.compareTo(b.endOfWarranty!),
        );
    }
    return currentWarranties;
  }

  List<WarrantyInfo> get expiring {
    List<WarrantyInfo> expiringList;
    expiringList = List.from(warranties);
    if (expiringList.any((e) => e.lifetime)) {
      expiringList.removeWhere((ee) => ee.lifetime);
    }
    if (expiringList
        .any((e) => e.endOfWarranty!.difference(DateTime.now()).inDays <= 0)) {
      expiringList.removeWhere(
        (ee) => ee.endOfWarranty!.difference(DateTime.now()).inDays <= 0,
      );
    }

    if (expiringList.any((e) {
      final days = timeRemaining(e.endOfWarranty!).$2.$3;
      final months = timeRemaining(e.endOfWarranty!).$2.$2;
      final years = timeRemaining(e.endOfWarranty!).$2.$1;

      return days < 30 || months < 1 || years < 1;
    })) {
      expiringList
        ..removeWhere(
          (ee) {
            final days = timeRemaining(ee.endOfWarranty!).$2.$3;
            final years = timeRemaining(ee.endOfWarranty!).$2.$1;
            final months = timeRemaining(ee.endOfWarranty!).$2.$2;
            return years > 0 || months > 0 || days > 30 || ee.lifetime;
          },
        )
        ..sort(
          (a, b) => a.endOfWarranty!.compareTo(b.endOfWarranty!),
        );
    }
    return expiringList;
  }

  List<WarrantyInfo> get expired {
    final now = DateTime.now();
    List<WarrantyInfo> expiredList;
    expiredList = List.from(warranties);
    if (expiredList.any((e) => e.lifetime)) {
      expiredList.removeWhere((ee) => ee.lifetime);
    }

    if (expiredList.any(
      (warranty) => warranty.endOfWarranty!.isAfter(now),
    )) {
      expiredList
        ..removeWhere(
          (ee) {
            return now.isBefore(ee.endOfWarranty!);
          },
        )
        ..sort(
          (a, b) => a.endOfWarranty!.compareTo(b.endOfWarranty!),
        );
    }

    return expiredList;
  }

  @override
  List<Object?> get props => _$props;
}

class _Error extends WarrantiesState {
  const _Error();
}

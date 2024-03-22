import 'package:autoequal/autoequal.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:warranty_watch/app/app_library.dart';

part 'warranty_info.g.dart';

@JsonSerializable()
@CopyWith()
@autoequal
class WarrantyInfo extends Equatable {
  WarrantyInfo({
    required this.id,
    this.name,
    this.purchaseDate,
    this.warrantyWebsite,
    this.endOfWarranty,
    this.reminderDate,
    this.details,
    this.image,
    this.imageUrl,
    this.receiptImage,
    this.receiptImageUrl,
    this.lifetime = false,
    this.wantsReminders = false,
  }) : createdOn = DateTime.now();

  factory WarrantyInfo.fromJson(Map<dynamic, dynamic> source) =>
      _$WarrantyInfoFromJson(source);
  final String id;
  final String? name;
  final DateTime? purchaseDate;
  final DateTime? createdOn;
  final String? warrantyWebsite;
  final DateTime? endOfWarranty;
  final DateTime? reminderDate;
  final String? details;
  final String? image;
  final String? imageUrl;
  final String? receiptImage;
  final String? receiptImageUrl;
  final bool lifetime;
  final bool wantsReminders;

  @override
  List<Object?> get props => _$props;

  bool canSave() {
    if (name == null) return false;
    if (name!.isEmpty) return false;
    if (endOfWarranty == null && lifetime != true) return false;
    return true;
  }

  Map<String, dynamic> toJson() => _$WarrantyInfoToJson(this);
}

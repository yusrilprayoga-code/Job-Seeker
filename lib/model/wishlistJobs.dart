import 'package:hive/hive.dart';

part 'wishlistJobs.g.dart';

@HiveType(typeId: 0)
class WishlistJobs extends HiveObject {
  @HiveField(0)
  String? created;

  @HiveField(1)
  String? expires;

  @HiveField(2)
  String? sourced;

  @HiveField(3)
  int? unique;

  @HiveField(4)
  String? companyName;

  @HiveField(5)
  String? companyUrl;

  @HiveField(6)
  String? title;

  @HiveField(7)
  String? description;

  @HiveField(8)
  String? link;

  @HiveField(9)
  List<String>? category;

  @HiveField(10)
  String? location;

  @HiveField(11)
  String? country;

  @HiveField(12)
  double? salary;

  WishlistJobs({
    this.created,
    this.expires,
    this.sourced,
    this.unique,
    this.companyName,
    this.companyUrl,
    this.title,
    this.description,
    this.link,
    this.category,
    this.location,
    this.country,
    this.salary,
  });
}

import 'dart:math';

class JobsData {
  final List<Jobs>? jobs;

  JobsData({
    this.jobs,
  });

  JobsData.fromJson(Map<String, dynamic> json)
      : jobs = (json['jobs'] as List?)
            ?.map((dynamic e) => Jobs.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'jobs': jobs?.map((e) => e.toJson()).toList()};
}

class Jobs {
  final String? created;
  final String? expires;
  final String? sourced;
  final int? unique;
  final String? companyName;
  final String? companyUrl;
  final String? title;
  final String? description;
  final String? link;
  final List<String>? category;
  final String? location;
  final String? country;
  final double salary;

  Jobs({
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
    required this.salary, // Add required keyword for the non-nullable field
  }) : assert(salary >= 0); // Ensure salary is not negative

  Jobs.fromJson(Map<String, dynamic> json)
      : created = json['created'] as String?,
        expires = json['expires'] as String?,
        sourced = json['sourced'] as String?,
        unique = json['unique'] as int?,
        companyName = json['companyName'] as String?,
        companyUrl = json['companyUrl'] as String?,
        title = json['title'] as String?,
        description = json['description'] as String?,
        link = json['link'] as String?,
        category = (json['category'] as List?)
            ?.map((dynamic e) => e as String)
            .toList(),
        location = json['location'] as String?,
        country = json['country'] as String?,
        salary =
            (json['salary'] as double?) ?? Random().nextInt(100000).toDouble();

  Map<String, dynamic> toJson() => {
        'created': created,
        'expires': expires,
        'sourced': sourced,
        'unique': unique,
        'companyName': companyName,
        'companyUrl': companyUrl,
        'title': title,
        'description': description,
        'link': link,
        'category': category,
        'location': location,
        'country': country,
        'salary': salary,
      };
}

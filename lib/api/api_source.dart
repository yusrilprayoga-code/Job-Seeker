import 'dart:convert';

import 'package:Jobs_Seeker/constants/Jobs_Impl.dart';
import 'package:http/http.dart' as http;

class ApiSource {
  static const _JobsApi = 'https://zobjobs.com/api/jobs';

  Future<List<Jobs>> getJobs() async {
    final response = await http.get(Uri.parse(_JobsApi));

    if (response.statusCode == 200) {
      return JobsData(
        jobs: (json.decode(response.body)['jobs'] as List)
            .map((dynamic e) => Jobs.fromJson(e as Map<String, dynamic>))
            .toList(),
      ).jobs!;
    } else {
      throw Exception('Gagal memuat data jobs');
    }
  }
}

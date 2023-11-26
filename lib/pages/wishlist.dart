import 'dart:async';
import 'dart:convert';

import 'package:Jobs_Seeker/main.dart';
import 'package:Jobs_Seeker/model/wishlistJobs.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';

enum Currency { USD, THB, AED, EUR }

enum TimeZone { WIB, WITA, WIT, LondonMusimPanas, LondonMusimDingin }

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late Box<WishlistJobs> wishlistJobsBox;
  Currency selectedCurrency = Currency.USD;
  late Timer timer;
  TimeZone selectedTimeZone = TimeZone.WIB;
  String? formattedTime;

  @override
  void initState() {
    super.initState();
    wishlistJobsBox = Hive.box<WishlistJobs>(hiveBoxName);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      getTime();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: wishlistJobsBox.isEmpty
            ? Center(
                child: Text('No data'),
              )
            : ListView.builder(
                itemCount: wishlistJobsBox.length,
                itemBuilder: (context, index) {
                  final job = wishlistJobsBox.getAt(index);
                  return Dismissible(
                    key: Key(job!.title!),
                    onDismissed: (direction) {
                      wishlistJobsBox.deleteAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Job deleted'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTimezoneDropdown(),
                              SizedBox(height: 10),
                              _buildFormattedTime(),
                              SizedBox(height: 10),
                              _buildJobFeatured(job),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildJobFeatured(WishlistJobs job) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            job.title!,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            job.companyName!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            job.country!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ListTile(
          title: Row(
            children: [
              Text(
                '${formatPrice(
                  job.salary!,
                )}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '(${selectedCurrency.toString().split('.').last})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 2,
              ),
              buildCurrencyDropdown(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCurrencyDropdown() {
    return DropdownButton<Currency>(
      value: selectedCurrency,
      onChanged: (Currency? newValue) {
        if (newValue != null) {
          setState(() {
            selectedCurrency = newValue;
          });
        }
      },
      items: Currency.values.map((Currency currency) {
        return DropdownMenuItem<Currency>(
          value: currency,
          child: Text(getCurrencySymbol(currency)),
        );
      }).toList(),
    );
  }

  String formatPrice(double price) {
    switch (selectedCurrency) {
      case Currency.USD:
        return '\$ ${price.toStringAsFixed(2)}';
      case Currency.THB:
        return '฿ ${(price * 32).toStringAsFixed(2)}';
      case Currency.AED:
        return 'AED ${(price * 4).toStringAsFixed(0)}';
      case Currency.EUR:
        return '€ ${(price * 0.85).toStringAsFixed(2)}';
    }
  }

  String getCurrencySymbol(Currency currency) {
    switch (currency) {
      case Currency.USD:
        return '\$';
      case Currency.THB:
        return '฿';
      case Currency.AED:
        return 'AED';
      case Currency.EUR:
        return '€';
    }
  }

  Widget _buildFormattedTime() {
    return Text(
      formattedTime ?? '',
      style: const TextStyle(
        fontSize: 12,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTimezoneDropdown() {
    return DropdownButton<TimeZone>(
      value: selectedTimeZone,
      onChanged: (TimeZone? newValue) {
        setState(() {
          selectedTimeZone = newValue!;
          getTime(); // Update time when timezone changes
        });
      },
      items: TimeZone.values.map((TimeZone timezone) {
        return DropdownMenuItem<TimeZone>(
          value: timezone,
          child: Text(
            "Convert To ${timezone.toString().split('.').last}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }

  void getTime() async {
    try {
      Response response = await get(
          Uri.parse("https://worldtimeapi.org/api/timezone/Asia/Jakarta"));
      Map data = jsonDecode(response.body);

      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);

      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));

      formattedTime = _getFormattedTime(now, selectedTimeZone);
      setState(() {});
    } catch (e) {
      print('Error fetching time: $e');
    }
  }

  String _getFormattedTime(DateTime time, TimeZone timeZone) {
    switch (timeZone) {
      case TimeZone.WIB:
        return '${time.hour}:${time.minute}:${time.second} WIB';
      case TimeZone.WITA:
        return '${time.hour + 1}:${time.minute}:${time.second} WITA';
      case TimeZone.WIT:
        return '${time.hour + 2}:${time.minute}:${time.second} WIT';
      case TimeZone.LondonMusimPanas:
        return '${time.hour + 6}:${time.minute}:${time.second} London (Musim Panas)';
      case TimeZone.LondonMusimDingin:
        return '${time.hour + 7}:${time.minute}:${time.second} London (Musim Dingin)';
      default:
        return '';
    }
  }
}

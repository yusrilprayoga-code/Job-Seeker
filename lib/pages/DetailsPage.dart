import 'package:Jobs_Seeker/constants/Jobs_Impl.dart';
import 'package:Jobs_Seeker/main.dart';
import 'package:Jobs_Seeker/model/wishlistJobs.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.job}) : super(key: key);

  final Jobs job;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Box<WishlistJobs> wishlistJobsBox;

  @override
  void initState() {
    super.initState();
    wishlistJobsBox = Hive.box<WishlistJobs>(hiveBoxName);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Lottie.network(
                'https://lottie.host/da6ca49f-39f1-44e2-87b1-5ee393058948/VXItF3VKB3.json',
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Divider(),
            SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.job.companyName!,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.job.title!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      buildDetailRow('Location', widget.job.location!),
                      buildDetailRow('Created', widget.job.created!),
                      buildDetailRow('Expires', widget.job.expires!),
                      buildDetailRow('Description', widget.job.description!),
                      buildDetailRow('Salary', widget.job.salary.toString()),
                      buildDetailRow('How to Apply', widget.job.link!),
                      buildButtonWishlist(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget buildButtonWishlist() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          wishlistJobsBox = Hive.box<WishlistJobs>(hiveBoxName);
          wishlistJobsBox.add(
            WishlistJobs(
              created: widget.job.created,
              expires: widget.job.expires,
              sourced: widget.job.sourced,
              unique: widget.job.unique,
              companyName: widget.job.companyName,
              companyUrl: widget.job.companyUrl,
              title: widget.job.title,
              description: widget.job.description,
              link: widget.job.link,
              category: widget.job.category,
              location: widget.job.location,
              country: widget.job.country,
              salary: '${widget.job.salary} ' == 'null'
                  ? 0.0
                  : widget.job.salary.toDouble(),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Job added to Wishlist'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: Text('Add to Wishlist',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}

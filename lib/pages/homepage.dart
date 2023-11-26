import 'package:Jobs_Seeker/api/api_source.dart';
import 'package:Jobs_Seeker/constants/Jobs_Impl.dart';
import 'package:Jobs_Seeker/pages/DetailsPage.dart';
import 'package:Jobs_Seeker/pages/profile.dart';
import 'package:Jobs_Seeker/pages/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Jobs>> jobsData;
  late PageController _pageController;
  int _selectedIndex = 0;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    jobsData = ApiSource().getJobs();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Jobs Seeker',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            buildJobsList(),
            WishlistPage(),
            MyProfile(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget buildJobsList() {
    return SafeArea(
      child: FutureBuilder<List<Jobs>>(
        future: jobsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Jobs> jobsList = snapshot.data!;

            // Filter jobs based on the search query
            List<Jobs> filteredJobs = jobsList.where((job) {
              return job.title!
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()) ||
                  job.companyName!
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()) ||
                  job.country!
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase());
            }).toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Hello, Maria Theoktista',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      //image
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/profil.jpg',
                            ),
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[200],
                          ),
                          child: TextFormField(
                            controller: _searchController,
                            onChanged: (value) {
                              _searchController.text = value;
                              setState(() {
                                filteredJobs = jobsList.where((job) {
                                  return job.title!.toLowerCase().contains(
                                          _searchController.text
                                              .toLowerCase()) ||
                                      job.companyName!.toLowerCase().contains(
                                          _searchController.text
                                              .toLowerCase()) ||
                                      job.country!.toLowerCase().contains(
                                          _searchController.text.toLowerCase());
                                }).toList();
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search jobs...',
                              icon: Icon(Icons.search),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                  SizedBox(height: 25),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.75,
                      ),
                      shrinkWrap: true,
                      itemCount: filteredJobs.length,
                      itemBuilder: (context, index) {
                        Jobs job = filteredJobs[index];

                        return GestureDetector(
                          onTap: () {
                            //detail page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(job: job),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  child: Lottie.network(
                                    'https://lottie.host/da6ca49f-39f1-44e2-87b1-5ee393058948/VXItF3VKB3.json',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    color: Colors.grey[200],
                                    elevation: 5.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              job.title!,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Expanded(
                                            child: Text(
                                              job.companyName!,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Expanded(
                                            child: Text(
                                              job.country!,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

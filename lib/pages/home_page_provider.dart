import 'package:flutter/material.dart';
import 'package:help_app/objects/service_call.dart';
import 'package:help_app/pages/provider_profile.dart';
import 'package:help_app/widgets/call_card.dart';

class HomePageProvider extends StatefulWidget {
  const HomePageProvider({Key? key}) : super(key: key);

  @override
  State<HomePageProvider> createState() => HomePageProviderState();
}

class HomePageProviderState extends State<HomePageProvider> {
  String selectedLocation = "All";
  String selectedCategory = "All";
  int originalVisiblePostCount = 10;
  int visiblePostCount = 10;
  bool _isLoading = true;

  List<ServiceCall?> allCalls = [];

  @override
  void initState() {
    super.initState();
    fetchCalls();
  }

  Future<void> fetchCalls() async {
    try {
      List<ServiceCall?> calls = await ServiceCall.getAllPosts();
      setState(() {
        allCalls = calls;
        _isLoading = false;
      });
      print("fetched all service calls data successfully");
      print(allCalls[1]?.area);
    } catch (e) {
      print("error occured while fetching all service calls $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Location: "),
                      DropdownButton<String>(
                        value: selectedLocation,
                        items: getUniqueLocations().map((location) {
                          return DropdownMenuItem<String>(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedLocation = value!;
                            visiblePostCount = originalVisiblePostCount;
                          });
                        },
                      ),
                      SizedBox(width: 20),
                      Text("Category: "),
                      DropdownButton<String>(
                        value: selectedCategory,
                        items: getUniqueCategories().map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                            visiblePostCount = originalVisiblePostCount;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: allCalls.length,
                    itemBuilder: (context, index) {
                      if ((selectedLocation == "All" ||
                              allCalls[index]?.area == selectedLocation) &&
                          (selectedCategory == "All" ||
                              allCalls[index]?.category == selectedCategory)) {
                        return CallCard(call: allCalls[index]);
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProviderProfile(),
                ),
              );
              break;
            case 2:
              break;
          }
        },
      ),
    );
  }

  List<String> getUniqueLocations() {
    Set<String> uniqueLocations = Set<String>();
    uniqueLocations.add("All");
    for (var call in allCalls) {
      uniqueLocations.add(call?.area ?? '');
    }
    return uniqueLocations.toList();
  }

  List<String> getUniqueCategories() {
    Set<String> uniqueCategories = Set<String>();
    uniqueCategories.add("All");
    for (var call in allCalls) {
      uniqueCategories.add(call?.category ?? '');
    }
    return uniqueCategories.toList();
  }
}

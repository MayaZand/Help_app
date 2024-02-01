import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:help_app/objects/provider_user.dart';
import 'package:help_app/objects/user.dart';

class ProviderProfile extends StatefulWidget {
  const ProviderProfile({Key? key}) : super(key: key);

  @override
  State<ProviderProfile> createState() => _ProviderProfileState();
}

class _ProviderProfileState extends State<ProviderProfile> {
  String? _uid;
  ProviderUser? _user;

  @override
  void initState() {
    super.initState();
    checkCurrentUser();
  }

  Future<void> checkCurrentUser() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    ProviderUser? provider_user = await ProviderUser.getUserById(userId!);

    if (userId.isNotEmpty) {
      // User is logged in
      // ProviderUser? provider_user = await ProviderUser.getUserById(userId);
      if (provider_user != null) {
        setState(() {
          _uid = userId;
          _user = provider_user;
        });
      }
    } else {
      print("User not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Provider Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20), // Added space from top
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue, // Change to blue
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 80,
              ),
            ),
            SizedBox(height: 20),
            Text(
              _user?.name ?? 'NA',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildBoldTextWithStars('proffesion:', _user?.profession ?? 'NA'),
            SizedBox(height: 10),
            _buildBoldTextWithStars(
                'Area of Occupation:', _user?.location ?? 'NA'),
            SizedBox(height: 10),
            _buildBoldTextWithStars(
                'Rating:', _user?.rating.toString() ?? '1.1'), // Changed here
            SizedBox(height: 10),
            // _buildBoldTextWithStars('Recommendations:', first.recommendations),
            SizedBox(height: 20), // Added space from top
            _buildBottomButtons(context), // Added bottom buttons
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    double halfStar = rating - fullStars;

    List<Widget> stars = [];

    // Add full stars
    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.yellow));
    }

    // Add half star if necessary
    if (halfStar > 0) {
      stars.add(Icon(Icons.star_half, color: Colors.yellow));
      fullStars++; // Increment fullStars to account for the half star
    }

    // Add empty stars to complete 5 stars
    for (int i = fullStars; i < 5; i++) {
      stars
          .add(Icon(Icons.star_border, color: Colors.grey)); // Empty star color
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stars,
    );
  }

  Widget _buildBoldText(String label, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildBoldTextWithStars(String label, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(width: 5),
        if (label == 'Rating:')
          _buildStarRating(
              double.parse(text)), // Display stars if label is 'Rating:'
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            // Handle tapping the home button
            // You can navigate to the home screen here
          },
          child: Column(
            children: [
              Icon(Icons.home, size: 30),
              Text('Home'),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            // Handle tapping the search button
            // You can implement search functionality here
          },
          child: Column(
            children: [
              Icon(Icons.search, size: 30),
              Text('Search'),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            // Handle tapping the profile button
            // You can navigate to the user's profile screen here
          },
          child: Column(
            children: [
              Icon(Icons.person, size: 30),
              Text('Profile'),
            ],
          ),
        ),
      ],
    );
  }
}

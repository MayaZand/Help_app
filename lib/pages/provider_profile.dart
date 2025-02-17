import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:help_app/objects/provider_user.dart';
import 'package:help_app/objects/user.dart';
import 'package:help_app/pages/customer_welcome_page.dart';
import 'package:help_app/pages/home_page_provider.dart'; // Import HomePageProvider page

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
    ProviderUser? providerUser = await ProviderUser.getUserById(userId!);

    if (userId.isNotEmpty) {
      setState(() {
        _uid = userId;
        _user = providerUser;
        // print(_user?.rating);
      });
    } else {
      print("User not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        children: [
          Container(
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

                // email field
                Text(
                  "email: ${_user?.email ?? 'NA'}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // _buildBoldText('Area:', _user?.area ?? 'NA'),
                SizedBox(height: 10),
                _buildBoldTextWithStars(
                    'Rating:', _user?.rating ?? 1.1), // Changed here
                SizedBox(height: 10),
                // _buildBoldTextWithStars('Recommendations:', first.recommendations),
                SizedBox(height: 20), // Added space from top
              ],
            ),
          ),

          // divider
          const SizedBox(
            height: 80.0,
          ),

          // bottom navigator buttons bar
          Container(
            child: _buildBottomButtons(context),
          )
        ],
      ),
    );
  }

  Widget _buildStarRating(num rating) {
    int fullStars = rating.floor();
    num halfStar = rating - fullStars;

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

  Widget _buildBoldTextWithStars(String label, num rating) {
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
        if (label == 'Rating:')
          _buildStarRating(rating), // Display stars if label is 'Rating:'
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            // Navigate to HomePageProvider
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePageProvider()),
            );
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
            _signOut(context);
          },
          child: Column(
            children: [
              Icon(Icons.logout, size: 30),
              Text('Log out'),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the sign-in page after successful logout
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              CustomerWelcomePage(), // Replace SignInPage with your actual sign-in page widget
        ),
      );
    } catch (e) {
      print('Error signing out: $e');
      // Handle error signing out, if any
    }
  }
}

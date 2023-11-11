// ignore: file_names
import 'package:drive_app/Features/Auth/Screens/Controller/authController.dart';
import 'package:drive_app/Features/HomeScreen/Screen/Tab_Screen/folde_home_screen.dart';
import 'package:drive_app/Features/HomeScreen/Screen/Tab_Screen/noteAppScreen.dart';
import 'package:drive_app/Themes/pallete.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Fluttertoast.showToast(
          msg:
              "cannot open the link😓,Please search flutterboy_dev on istagram 😊",
          toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              flexibleSpace: Visibility(
                visible: isSearching,
                maintainAnimation: true,
                maintainState: true,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: TextField(
                        onTapOutside: (e) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                            hintText: "Search.......",
                            fillColor: Pallete.whiteColor,
                            border: OutlineInputBorder(
                                // borderRadius: BorderRadius.circular(10),
                                ),
                            filled: true,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isSearching = !isSearching;
                                });
                              },
                              icon: Icon(
                                Icons.cancel_rounded,
                                color: Pallete.blackColor,
                              ),
                            )),
                        controller: _searchController,
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Pallete.yellowColor,
              automaticallyImplyLeading: false,
              actions: [
                Visibility(
                  visible: !isSearching,
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                // applicationName: "Store Free",
                                // applicationVersion: "1.0",
                                children: [
                                  Center(
                                    child: Text(
                                      "Features to use",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("1) Create Folder."),
                                        SizedBox(height: 2),
                                        Text("2) Add Images , Video & PDF."),
                                        SizedBox(height: 2),
                                        Text("3) Add & Edit Notes."),
                                        SizedBox(height: 2),
                                        Text("4) Lock the Note."),
                                        SizedBox(height: 2),
                                        Text(
                                            "5) Create PDF from Notes and Download"),
                                        SizedBox(height: 10),
                                        RichText(
                                          text: TextSpan(
                                              text:
                                                  "Any query or additional features contact",
                                              style: TextStyle(
                                                  color: Pallete.blackColor),
                                              children: [
                                                TextSpan(
                                                    text: " @flutterdev_boy",
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            _launchURL(
                                                                "https://www.instagram.com/flutter_boydev/?igshid=1rykg2jvndtss");
                                                          },
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                  text: " on instagram",

                                                  // style: TextStyle(
                                                  //     color: Colors.blue,
                                                  //     fontWeight:
                                                  //         FontWeight.bold),
                                                ),
                                              ]),
                                        ),
                                        // Text(
                                        //     "Any query or additional features contact @flutterdev_boy on Instagram"),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            });
                      },
                      icon: const Icon(
                        Icons.question_mark,
                        color: Pallete.blackColor,
                      )),
                ),
                Visibility(
                  visible: !isSearching,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          isSearching = !isSearching;
                        });
                      },
                      icon: Icon(
                        Icons.search,
                        color: Pallete.blackColor,
                      )),
                ),
                Visibility(
                  visible: !isSearching,
                  child: IconButton(
                      onPressed: () {
                        ref.read(authCpntrollerProvider.notifier).logOut();
                        // setState(() {
                        //   isSearching = !isSearching;
                        // });
                      },
                      icon: Icon(
                        Icons.logout,
                        color: Pallete.blackColor,
                      )),
                ),
              ],

              // expandedHeight: 80,
              // snap: true,
              pinned: true,
              floating: true,

              title: Visibility(
                visible: !isSearching,
                child: const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "Store Free",
                    style: TextStyle(
                        color: Pallete.blackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                ),
              ),

              bottom: TabBar(
                dividerColor: Pallete.whiteColor,
                // dividerHeight: 3,
                indicatorWeight: 5,
                isScrollable: false,

                labelStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.normal),
                indicatorColor: Pallete.blackColor,
                labelColor: Pallete.blackColor,
                unselectedLabelColor: const Color.fromARGB(255, 238, 229, 229),
                indicatorSize: TabBarIndicatorSize.tab,
                controller: _tabController,
                tabs: const [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text('Folder'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text('NotePad'),
                  ),
                ],
                automaticIndicatorColorAdjustment: true,
              ),
              //
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  FolderHomeScreen(),
                  NoteAppScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kalpas/api/api.dart';
import 'package:kalpas/pages/favs.dart';
import 'package:kalpas/pages/news.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isFirstButtonSelected = true;

  @override
  Widget build(BuildContext context) {
    Api controller = Api();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              topbar(),
              Expanded(
                  child: FutureBuilder(
                future: controller.fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final jsonData = snapshot.data;
                    if (jsonData == null) {
                      return const Text('No data available');
                    }

                    final List<dynamic> datafetch = jsonData['articles'];
                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      itemCount: datafetch.length,
                      itemBuilder: (context, index) {
                        final data = datafetch[index];
                        return Column(
                          children: [
                            Container(
                                child: cardnews(context, data, controller)),
                          ],
                        );
                      },
                    );
                  }
                },
              ))
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector cardnews(
      BuildContext context, Map<String, dynamic> data, Api controller) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => News(data: data)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Slidable(
          // key: ValueKey(index),
          endActionPane: ActionPane(
              extentRatio: 1 / 3,
              motion: const BehindMotion(),
              children: [
                SlidableAction(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  onPressed: (context) => {controller.storeFavs(data)},
                  icon: Icons.favorite,
                  foregroundColor: Colors.red,
                  backgroundColor: const Color.fromARGB(255, 255, 196, 196),
                  label: "  Add to\nFavourite",
                )
              ]),
          child: Container(
            height: 140,
            // margin:
            //     const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )
                ],
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(18),
                    image: DecorationImage(
                      image: NetworkImage(data['urlToImage'] ??
                          "https://as1.ftcdn.net/v2/jpg/02/99/61/74/1000_F_299617487_fPJ8v9Onthhzwnp4ftILrtSGKs1JCrbh.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'] ?? '',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        data['description'] ?? '',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_month_outlined),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(data["publishedAt"])
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding topbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                setState(() {
                  isFirstButtonSelected = true;
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: isFirstButtonSelected
                    ? const Color.fromARGB(255, 232, 243, 255)
                    : Colors.transparent,
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu,
                      color: Colors.black,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "News",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextButton(
              onPressed: () {
                setState(() {
                  isFirstButtonSelected = false;
                });
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Favs()));
              },
              style: TextButton.styleFrom(
                  backgroundColor: isFirstButtonSelected
                      ? Colors.transparent
                      : const Color.fromARGB(255, 232, 243, 255)),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Favs",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

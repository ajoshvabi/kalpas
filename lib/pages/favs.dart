import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kalpas/api/api.dart';
import 'package:kalpas/pages/index.dart';
import 'package:kalpas/pages/news.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favs extends StatefulWidget {
  const Favs({super.key});
  @override
  State<Favs> createState() => _FavsState();
}

class _FavsState extends State<Favs> {
  List<dynamic> favorites = [];
  bool isFirstButtonSelected = false;
  Api controller = Api();

  @override
  void initState() {
    super.initState();
    _showfav();
  }

  Future<void> _removeFavorite(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorites') ?? [];
    favoritesJson.removeAt(index);
    await prefs.setStringList('favorites', favoritesJson);
    _showfav();
  }

  Future<void> _showfav() async {
    final favs = await controller.getStoredFavs();
    setState(() {
      favorites = favs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            topbar(),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        if (favorites.isEmpty)
                          const Expanded(
                            child: Center(
                              child: Text(
                                "Add some data to favorites",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics()),
                              itemCount: favorites.length,
                              itemBuilder: (context, index) {
                                final listofarticle = favorites[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                News(data: listofarticle)));
                                  },
                                  child: cards(index, context, listofarticle),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding cards(int index, BuildContext context, listofarticle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Slidable(
        endActionPane: ActionPane(
            extentRatio: 1 / 3,
            motion: const BehindMotion(),
            children: [
              SlidableAction(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                onPressed: (context) => {_removeFavorite(index)},
                icon: Icons.delete_outlined,
                foregroundColor: Colors.red,
                backgroundColor: const Color.fromARGB(255, 255, 196, 196),
                label: "Remove from \n   Favourite",
              )
            ]),
        child: Container(
          height: 140,
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
                    image: NetworkImage(listofarticle['urlToImage'] ??
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
                      listofarticle['title'].toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      listofarticle['description'].toString(),
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
                        Text(' ${listofarticle['publishedAt']} GMT')
                      ],
                    )
                  ],
                ),
              ),
            ],
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Home()));
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

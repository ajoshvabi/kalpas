import 'package:flutter/material.dart';

class News extends StatelessWidget {
  Map<String, dynamic> data;
  final bool fav;
  News({Key? key, required this.data, required this.fav}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        top: 60, left: 20, right: 20, bottom: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(18),
                      image: DecorationImage(
                        image: NetworkImage(data["urlToImage"] ??
                            "https://as1.ftcdn.net/v2/jpg/02/99/61/74/1000_F_299617487_fPJ8v9Onthhzwnp4ftILrtSGKs1JCrbh.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, right: 15),
                      child: fav == true
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 40,
                            )
                          : const SizedBox(),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          data["title"] ?? "",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(data["publishedAt"] ?? "")
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          data["description"] ?? "",
                          style: const TextStyle(
                              height: 1.5,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  color: Colors.white,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.arrow_back_ios_new),
                      ),
                      Text(
                        "Back",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      )
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
}

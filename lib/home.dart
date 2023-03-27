import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();

  getRecipe(String query) async {
    String url = "https://edamam-recipe-search.p.rapidapi.com/search";
    final uri = Uri.parse(url);
    final finalUri = uri.replace(queryParameters: {'q': 'chicken'});
    var response = await http.get(
      finalUri,
      headers: {
        'X-RapidAPI-Key': 'a5085bc27fmsh0ae08cea84ac260p1e22ecjsnfc0dfe85906e',
        'X-RapidAPI-Host': 'edamam-recipe-search.p.rapidapi.com'
      },
    );
    print("api response : ${response.body}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe("");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List items = ["Spicy Food","Sweets","Chinese","Indian Food","Healthy Diet"];
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff213A50), Color(0xff071938)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight)),
          height: size.height,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(Icons.search),
                          )),
                      const Expanded(
                          child: TextField(
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                            hintText: "Search Recipie",
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none),
                      ))
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 8),
                  child: Text(
                    "WHAT DO YOU WANT TO COOK TODAY ?",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  "  Let's cook something !",
                  style: TextStyle(fontSize: 30.0, color: Colors.white60),
                ),
                Container(
                  height: 70,
                  margin: EdgeInsets.only(top: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              width: 120,
                              height: 20,child: TextButton(child:Text(items[index],style: TextStyle(color: Colors.black,fontSize: 20),),onPressed: (){}, ),
                            )),
                      );
                    },
                  ),
                ),
                ListView.builder(
                  itemCount: 10,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            ClipRRect(
                              child: Image.asset(
                                "assets/money-2724241__480.jpg",
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            Positioned(
                                bottom: 10.0,
                                left: 20.0,
                                child: Container(
                                    width: size.width * 0.75,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          40.0,
                                        ),
                                        color: Colors.black26),
                                    child: Text(
                                      "about",
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.white),
                                    )))
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

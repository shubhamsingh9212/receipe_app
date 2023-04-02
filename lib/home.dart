import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'global_widgets/cached_image.dart';
import 'global_widgets/web_view.dart';
import 'model/recipe_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  RecipeResponse? recipeResponse;
  bool loading = true;

  void getRecipe({String query = "potato"}) async {
    setState(() {
      recipeResponse = null;
      loading = true;
    });
    const apiKey = "bd4eb61ae8b31978a4e658b1a1bc678a";
    const apiId = "809dd040";
    String url =
        "https://api.edamam.com/search?q=$query&app_id=$apiId&app_key=$apiKey";
    var response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        setState(() {
          recipeResponse = RecipeResponse.fromJson(json);
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List items = [
      "Spicy Food",
      "Sweets",
      "Chinese",
      "Indian Food",
      "Healthy Diet"
    ];
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
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
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
                    Expanded(
                        child: TextField(
                      onSubmitted: (value) {
                        getRecipe(query: value.trim());
                      },
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      decoration: const InputDecoration(
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
                height: 70.h,
                margin: const EdgeInsets.only(top: 20),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: TextButton(
                            child: Text(
                              items[index],
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                            onPressed: () {
                              searchController.text = "";
                              getRecipe(query: items[index]);
                            },
                          ),
                        ));
                  },
                ),
              ),
              loading
                  ? const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : recipeResponse?.hits?.isEmpty ?? true
                      ? Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Center(
                              child: Text(
                            "No data",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20.sp),
                          )),
                        )
                      : ListView.builder(
                          itemCount: recipeResponse?.hits?.length ?? 0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return WebView(
                                      url: recipeResponse
                                              ?.hits?[index].recipe?.url ??
                                          "");
                                }));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 15.h),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: CachedImage(
                                        imageUrl: recipeResponse
                                                ?.hits?[index].recipe?.image ??
                                            "",
                                        height: 230.h,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 10.0,
                                        left: 20.0,
                                        child: Container(
                                            padding: EdgeInsets.all(8.sp),
                                            width: size.width * 0.75,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  15.0,
                                                ),
                                                color: Colors.black26),
                                            child: Text(
                                              recipeResponse?.hits?[index]
                                                      .recipe?.label ??
                                                  "",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white),
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
      ]),
    );
  }
}

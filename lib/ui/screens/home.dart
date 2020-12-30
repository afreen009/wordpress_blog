import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wordpress_flutter/global.dart';
import 'package:wordpress_flutter/models/single_post.dart';
import 'package:http/http.dart' as http;
import 'package:wordpress_flutter/ui/screens/post.dart';
import 'package:wordpress_flutter/ui/widgets/overlayed_container.dart';
import 'package:wordpress_flutter/ui/widgets/post_container.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

List<SinglePost> parsePosts(response) {
  final parsed = jsonDecode(response)['posts'].cast<Map<String, dynamic>>();
  return parsed.map<SinglePost>((json) => SinglePost.fromJson(json)).toList();
}

Future<List<SinglePost>> _getPosts() async {
  final response = await http.get(baseUrl);
  return compute(parsePosts, response.body);
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<SinglePost>> _postsFuture;
  @override
  void initState() {
    super.initState();
    _postsFuture = _getPosts();
    getMyPosts();
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: FutureBuilder(
//           future: getMyPosts(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError)
//               return Scaffold(
//                 body: Center(
//                   child: Text(snapshot.error),
//                 ),
//               );
//             else if (snapshot.hasData)
//               return ListView.builder(
//                 itemCount: snapshot.data.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   Map wpPost = snapshot.data[index];
//                   return Text(wpPost['title']['rendered']);
//                 },
//               );
//             return Container(child: Center(child: CircularProgressIndicator()));
//           },
//         ),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List>(
        future: getMyPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Scaffold(
              body: Center(
                child: Text("Error"),
              ),
            );
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text(
                  "Cybdom Blog",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.black),
                ),
                // actions: <Widget>[
                //   Padding(
                //     padding: const EdgeInsets.all(9.0),
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(9),
                //       child: Image.network(
                //         "${snapshot.data[0].avatarURL}",
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //   )
                // ],
              ),
              body: ListView(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .35,
                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                    child: PageView.builder(
                      controller: PageController(viewportFraction: .76),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        Map wpPost = snapshot.data[i];
                        print(snapshot.data.length);
                        return OverlayedContainer(
                          author: wpPost['title']['rendered'],
                          title: wpPost['title']['rendered'],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostScreen(postData: snapshot.data[i]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "All Posts",
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, i) {
                              Map wpPost = snapshot.data[i];
                              var media =
                                  wpPost['_embedded']["wp:featuredmedia"];
                              var imageUrl = wpPost['_embedded']
                                  ["wp:featuredmedia"][0]['source_url'];
                              // print('its here $media');
                              return PostContainer(
                                author: wpPost['title']['rendered'],
                                image: imageUrl != null ? imageUrl : 'no image',
                                title: wpPost['title']['rendered'],
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostScreen(
                                        postData: wpPost['content']
                                            ['rendered']),
                                  ),
                                ),
                              );
                            })
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

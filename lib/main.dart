
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'cwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'StackOverflow Mock',
        theme: ThemeData(
          primarySwatch: Colors.red,
       
        ),
        home: const HomePage());
  }
}

// Home Page
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:const Text("Stack Overflow Mock"),
        centerTitle: true,
      ),
      body: SafeArea(
        child:GetBuilder<Controller>(
          init: Controller(),
        builder: (getxController) =>  Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: search,
                          decoration: InputDecoration(
                            hintText: 'search',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10
                      ),
                      InkWell(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                           await getxController.getData(search.text);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF4256be),
                            borderRadius: BorderRadius. circular(35),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.5),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if(getxController.data != null)
            Expanded(
              child: ListView.builder(
                      itemCount: getxController.data["items"].length,
                      itemBuilder: (BuildContext context, int index) => InkWell(
                        onTap: (){
                          Get.to(()=> WebViewContainer(getxController.data["items"][index]["link"], getxController.data["items"][index]["title"]));
                        },
                        child: Container(width: double.infinity,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child:Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:NetworkImage(getxController.data["items"][index]["owner"]["profile_image"]),),
                                    title: Text(
                                        getxController.data["items"][index]["title"],
                                        style: TextStyle(fontSize: 18.0)
                                    ),
                                    subtitle: Text(
                                        getxController.data["items"][index]["owner"]["display_name"],
                                        style: TextStyle(fontSize: 14.0)
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    child: ListView.builder(itemCount: getxController.data["items"][index]["tags"].length,scrollDirection:Axis.horizontal, itemBuilder: (BuildContext context, int i) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: InkWell(
                                          onTap: (){
                                            search.text = getxController.data["items"][index]["tags"][i];
                                            getxController.getData(getxController.data["items"][index]["tags"][i]);
                                          },
                                          child: Chip(
                                            padding: EdgeInsets.all(8),backgroundColor: Colors.lightBlueAccent[100],
                                            label: Text(getxController.data["items"][index]["tags"][i]),),
                                        ),
                                      );
                                    },),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    ));
  }
}


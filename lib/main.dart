import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

//import 'dart:developer'; //log

class Steps {
  final String title;
  final String text;
  final int ordernumber;

  const Steps(this.title, this.text, this.ordernumber);
}

class Ingedients {
  final String name;
  final String amount;

  const Ingedients(this.name, this.amount);
}

class Infos {
  final String title;
  final int id;
  final String description;
  final List<Steps> steps;
  final List<Ingedients> ingedients;

  const Infos(this.title, this.id, this.description, this.steps, this.ingedients);
}

List<Infos> allinfos = [];

// searchbar
// scroll down refresh

void main() => runApp(MyApp());

class MyApp extends StatelessWidget { //erbt von StatelessWidget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meine Rezepte',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(title: 'Meine Rezepte'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future getData() async {
    var url = Uri.parse('http://512403920.swh.strato-hosting.eu/flutter/get2.php');
    http.Response response = await http.get(url);

    //create Array
    jsonDecode(response.body).forEach((key, value) {
      int localid = 0;
      String localtitle = "";
      String localdescription= "";
      List<Steps> allsteps = [];
      List<Ingedients> allingedients = [];
      value.forEach((key2, value2) {
        if(key2 == 'id'){
          localid = value2;
        }
        else if(key2 == 'title'){
          localtitle = value2;
        }
        else if(key2 == 'description'){
          localdescription = value2;
        }
        else{
          value2.forEach((key3, value3) {
            if(key2 == 'steps'){
              String localtitle2 = "";
              String localtext = "";
              int localordernumber = 0;
              value3.forEach((key4, value4) {
                if(key4 == 'title'){
                  localtitle2 = value4;
                }
                else if(key4 == 'text'){
                  localtext = value4;
                }
                else if(key4 == 'order_number'){
                  localordernumber = value4;
                }
              });
              allsteps.add(Steps(localtitle2, localtext, localordernumber));
            }
            else if(key2 == 'ingedients'){
              String localname = "";
              String localamount = "";
              value3.forEach((key4, value4) {
                if(key4 == 'name'){
                  localname = value4;
                }
                else if(key4 == 'amount'){
                  localamount = value4;
                }
              });
              allingedients.add(Ingedients(localname, localamount));
            }
          });
        }
      });
      allinfos.add(Infos(localtitle, localid, localdescription, allsteps, allingedients));
    });
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: const Text("Meine Rezepte"),
        centerTitle: true,
      ),
      body: Center(
        children: <Widget>[
          Align(
          alignment: Alignment(0.85, 0.95),
          child: ElevatedButton(
            onPressed: () {}, 
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(50, 50),
              shape: const CircleBorder(),
            ),
            child: const Text(
              'Rezept hinzufügen',
              style: TextStyle(fontSize: 24),
            )
          )
        ),
        ListView(
          children: [
            for(int i = 0; i < allinfos.length; i++)
              ListTile(
                title: Text(allinfos[i].title),
                subtitle: Text(allinfos[i].description),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReciptScreen(id: i)),
                  );
                },
              ),
          ],
        )
        ]
      )
    );
  }
}

/*

Expanded(
            child: Align(
              alignment: Alignment(0.85, 0.95),
              child: ElevatedButton(
                onPressed: () {}, 
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(50, 50),
                  shape: const CircleBorder(),
                ),
                child: const Text(
                  '+',
                  style: TextStyle(fontSize: 24),
                )
              )
            )
          )

*/

class ReciptScreen extends StatelessWidget {
  final int id;
  
  const ReciptScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(allinfos[id].title),
      ),
      body: Center(
        child: Column(children: [
          Text(allinfos[id].description, style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.normal,
            color: Colors.black)
          ),
          Text(" "),
          if(allinfos[id].ingedients.isNotEmpty)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
                Row(children:[
                  Text("Zutaten:")   
                ])
              ]
            ),
            for(int i = 0; i < allinfos[id].ingedients.length; i++)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  Row(children:[
                    if(allinfos[id].ingedients[i].name.isNotEmpty && allinfos[id].ingedients[i].amount.isNotEmpty)
                      Text(allinfos[id].ingedients[i].amount.toString()),
                      const Text(" "),
                      Text(allinfos[id].ingedients[i].name.toString()),
                  ]),
                ]
              ),
          
          Text(" "),
              
          if(allinfos[id].steps.isNotEmpty)
            for(int i = 0; i < allinfos[id].steps.length; i++)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  Row(children:[
                    if(allinfos[id].steps[i].title.isNotEmpty)
                      Text("Schritt $i: " + allinfos[id].steps[i].title.toString())                    
                  ]),
                  Row(children:[
                    if(allinfos[id].steps[i].text.isNotEmpty)
                      Text(allinfos[id].steps[i].text.toString())
                  ]),
                  Row(children:[
                    if(allinfos[id].steps[i].text.isNotEmpty)
                      const Text(" ")
                  ])
                ]
              ),      
          Expanded(
            child: Align(
              alignment: const Alignment(0.0, 0.95),
              child: ElevatedButton(
                onPressed: () {}, 
                child: const Text(
                  'Bearbeiten',
                  style: TextStyle(fontSize: 20),
                )
              )
            )
          )
        ]),
      ));
  }
}

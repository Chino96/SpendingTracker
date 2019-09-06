import 'package:flutter/material.dart';
import 'widgets/loading_page.dart';
import 'models/transaction_model.dart';

/*
Home Page:
* Summary:
*   A home page widget that the user will first see.
*   Displays card that is clickable tht will navigate
*   to the next window.(Future Implementation will allow
*   for more cards)
* */
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //Imgae widget Asset where Card is stored
  Image image = Image(
    image: AssetImage('assets/WellsFargo_Card.png'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //margin and padding to center image
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.all(20.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //gesture detector used to read click on card image
            GestureDetector(
              //when image is tapped
                onTap: (){
                  //navigator pushes the new page(only pushes is used in order to allow user to go back)
                  Navigator.push(context,
                      //create new route to a loading page, but use the fetch function to load next page
                      new MaterialPageRoute(
                          builder: (context) => new LoadingPage(fetch_data)));
                },
                //make image the Gesture Detectors child
                child: Image(
                  image: AssetImage('assets/WellsFargo_Card.png'),
                )
            ),
          ],
        ),
      ),
    );
  }
}


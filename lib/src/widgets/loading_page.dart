import 'package:flutter/material.dart';

/*
* Summary:
*   A basic loading page to serve as a buffer
*   between the home page and the graph page.
*   displaying a GIF image and a short message.
*
* Params:
*   Function: exe
*               A function to be executed while GIF
*               is playing.(Must take user to new page)
*
* */
class LoadingPage extends StatelessWidget{
  //Function to be instantiated in constructor
  Function exe;
  LoadingPage(this.exe);

  Widget build(BuildContext context){
    //Execute function and pass the current context
    exe(context);
    return Scaffold(
      body: Container(
        //Margins an padding to center image and message
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.only(left: 65.0, right: 40.0),

        child: Column(
          //place widgets in center of column
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage('assets/Loading.gif')
            ),
            Text('Fetching Data...'),
          ],
        ),
      ),
    );
  }

}
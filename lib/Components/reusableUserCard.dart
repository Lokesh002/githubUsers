import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/backEnd/sizeConfig.dart';
import 'package:flutter_app/Components/card.dart';

class ReusableUserCard extends StatelessWidget {
  final String userName;
  final Function onTap;
  final String image;
  final bool bookmarked;
  ReusableUserCard({this.userName, this.onTap, this.image, this.bookmarked});

  @override
  Widget build(BuildContext context) {
    SizeConfig screenSize = SizeConfig(context);
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              left: screenSize.screenWidth * 3,
              right: screenSize.screenWidth * 3),
          child: Column(
            children: <Widget>[
              CourseCard(
                color: Colors.white,
                height: screenSize.screenHeight * 10,
                width: screenSize.screenWidth * 94,
                // height: screenSize.screenHeight * 10,
                cardChild: Row(
                  children: <Widget>[
                    SizedBox(
                      width: screenSize.screenWidth * 5,
                    ),
                    SizedBox(
                      width: screenSize.screenWidth * 15,
                      height: screenSize.screenWidth * 15,
                      child: CircleAvatar(
                        backgroundColor: Colors.black26,
                        radius: screenSize.screenHeight * 2,
                        child: ClipOval(
                          child: SizedBox(
                            child: (image != null)
                                ? FadeInImage.assetNetwork(
                                    placeholder: 'images/media/logo.png',
                                    image: this.image)
                                : Image.asset('images/media/logo.png'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.screenWidth * 3,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: screenSize.screenHeight * 1,
                        ),
                        Container(
                          width: screenSize.screenWidth * 50,
                          child: Text(
                            '$userName',
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: screenSize.screenHeight * 2,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        SizedBox(
                          height: screenSize.screenHeight * 1,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        child: bookmarked
                            ? Icon(Icons.check_box)
                            : Icon(Icons.check_box_outline_blank),
                        width: screenSize.screenWidth * 5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenSize.screenHeight * 2,
              )
            ],
          ),
        ),
      ],
    );
  }
}

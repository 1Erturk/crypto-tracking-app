import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class News with ChangeNotifier {
  String title;
  String banner_image;
  String time_published;
  String source_domain;
  String summary;
  String url;
  DateTime? timestamp;

  News(
      this.title,
      this.banner_image,
      this.time_published,
      this.source_domain,
      this.summary,
      this.url,
      {this.timestamp});

  News.fromMap(Map<String, dynamic> map)
      : title = map["title"],
        banner_image = map["banner_image"] ?? "https://www.alticeusa.com/sites/default/files/2022-10/2022_Altice_Corp_Site_Homepage_Icons_Only_Solid_Black_News.png",
        time_published = map["time_published"],
        source_domain = map["source_domain"],
        summary = map["summary"],
        url = map["url"],
        timestamp = (map["timestamp"] as Timestamp?)?.toDate();

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "banner_image": banner_image,
      "time_published": time_published,
      "source_domain": source_domain,
      "summary": summary,
      "url": url,
    };
  }


}
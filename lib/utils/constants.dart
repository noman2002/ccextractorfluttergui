import 'package:flutter/material.dart';

const kBgLightColor = Color(0xFF303030);
const kBgDarkColor = Color(0xFF181818);
const kDefaultPadding = 20.0;

Map<String, dynamic> settings = {
  "output_file_name": null,
  "output_format": "srt",
  "append": false,
  "autoprogram": true,
};


/// Input formats
List<String> inputFormats = [
  "ts   -> For Transport Streams.",
  "ps   -> For Program Streams.",
  "es   -> For Elementary Streams.",
  "asf  -> ASF container (such as DVR-MS).",
  "wtv  -> Windows Television (WTV)",
  "bin  -> CCExtractor's own binary format.",
  "raw  -> For McPoodle's raw files.",
  "mp4  -> MP4/MOV/M4V and similar."
];
/// Output formats
List<String> outputFormats = [
  "srt",
  "ass/ssa",
  "webvtt",
  "sami",
  "bin",
  "raw",
  "dvdraw",
  "txt",
  "ttxt",
  "smptett",
  "spupng",
  "null",
];

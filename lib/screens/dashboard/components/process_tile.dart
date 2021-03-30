import 'package:ccxgui/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:ccxgui/bloc/process_bloc/process_bloc.dart';
import 'package:ccxgui/bloc/processing_queue_bloc/processing_queue_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProcessTile extends StatefulWidget {
  final bool isComepleted;
  final String fileName;
  final String filePath;
  final int fileIndex;
  const ProcessTile({
    Key? key,
    required this.isComepleted,
    required this.fileName,
    required this.filePath,
    required this.fileIndex,
  }) : super(key: key);
  @override
  _ProcessTileState createState() => _ProcessTileState();
}

class _ProcessTileState extends State<ProcessTile> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            isVisible = true;
          });
        },
        onExit: (event) {
          setState(() {
            isVisible = false;
          });
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.fileName,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          widget.filePath,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  // isVisible
                  //     ? Row(
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: IconButton(
                  //               onPressed: () {
                  //                 showDialog<void>(
                  //                     context: context,
                  //                     builder: (context) => SettingsDialog());
                  //               },
                  //               icon: Icon(
                  //                 Icons.settings,
                  //                 size: 25,
                  //                 color: Colors.blueAccent,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       )
                  //     : Container(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                    child: BlocBuilder<ProcessBloc, ProcessState>(
                      builder: (context, state) {
                        if (state.finishedAll) {
                          return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Icon(Icons.check),
                          );
                        }
                        if (int.parse(state.progress!) > 0 &&
                            widget.fileIndex == state.currentIndex &&
                            !state.comepletedIndices.contains(widget.fileIndex))
                          return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.green,
                                strokeWidth: 4,
                                value: int.parse(state.progress!) / 100,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          );
                        else if (state.comepletedIndices
                            .contains(widget.fileIndex)) {
                          return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Icon(Icons.check),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {
                              context
                                  .read<DashboardBloc>()
                                  .add(FileRemoved(widget.fileIndex));
                              try {
                                context.read<ProcessBloc>().add(
                                    FileRemovedFromProcessingQueue(
                                        widget.fileIndex));
                              } catch (e) {
                                print("processing for this file never started");
                              }
                            },
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          // decoration: BoxDecoration(
          //   color: kBgLightColor,
          //   borderRadius: BorderRadius.all(
          //     Radius.circular(
          //       10,
          //     ),
          //   ),
          // ),
          height: 90,
        ),
      ),
    );
  }
}

class SettingsDialog extends StatefulWidget {
  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  List<String> _inputFormats = [
    "ts   -> For Transport Streams.",
    "ps   -> For Program Streams.",
    "es   -> For Elementary Streams.",
    "asf  -> ASF container (such as DVR-MS).",
    "wtv  -> Windows Television (WTV)",
    "bin  -> CCExtractor's own binary format.",
    "raw  -> For McPoodle's raw files.",
    "mp4  -> MP4/MOV/M4V and similar."
  ]; // Option 2
  String? _selectedInputFormat; // Option 2
  List<String> _outputFormats = [
    "srt     -> SubRip (default, so not actually needed).",
    "ass/ssa -> SubStation Alpha.",
    "webvtt  -> WebVTT format",
    "sami    -> MS Synchronized Accesible Media Interface.",
    "bin     -> CC data in CCExtractor's own binary format.",
    "raw     -> CC data in McPoodle's Broadcast format.",
    "dvdraw  -> CC data in McPoodle's DVD format.",
    "txt     -> Transcript (no time codes, no roll-up captions, just the plain transcription.",
    "ttxt    -> Timed Transcript (transcription with time info)",
    "smptett -> SMPTE Timed Text (W3C TTML) format.",
    "spupng  -> Set of .xml and .png files for use with dvdauthor's spumux.",
    "null    -> Don't produce any file output",
    "report  -> Prints to stdout information about captions in specified input. Don't produce any file output"
  ]; // Option 2
  String? _selectedOutputFormat; // Option 2

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton(
            isExpanded: true,
            underline: Container(),
            hint: Text('Select input format'),
            value: _selectedInputFormat,
            onChanged: (newValue) {
              setState(() {
                _selectedInputFormat = newValue.toString();
              });
            },
            items: _inputFormats.map((location) {
              return DropdownMenuItem(
                child: new Text(location),
                value: location,
              );
            }).toList(),
          ),
          DropdownButton(
            isExpanded: true,
            underline: Container(),
            hint: Text('Select a output format'), // Not necessary for Option 1
            value: _selectedOutputFormat,
            onChanged: (newValue) {
              setState(() {
                _selectedOutputFormat = newValue.toString();
              });
            },
            items: _outputFormats.map((location) {
              return DropdownMenuItem(
                child: Text(location),
                value: location,
              );
            }).toList(),
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: "Enter output filename here",
              labelText: "Output filename",
              labelStyle: TextStyle(fontSize: 18),
              hintStyle: TextStyle(height: 2),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, right: 12),
          child: MaterialButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}

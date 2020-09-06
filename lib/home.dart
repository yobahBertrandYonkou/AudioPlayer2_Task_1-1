import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_visualizers/visualizer.dart';
import 'package:seekbar/seekbar.dart';
import 'package:flutter_visualizers/flutter_visualizers.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var audioplayer = AudioPlayer();
  var isPlaying = false;
  var musicName = "No Music";
  var totalDuration = "00:00";
  var currentTime = "00:00";
  var currentState = "No Music";
  var seekTime = "00.00";
  double pTime = 0.0;
  var isLoopOn = false;
  List<dynamic> filePath = [];
  List<dynamic> fileName = [];
  var numOfFiles;
  var currentFile = 0;

  @override
  Widget build(BuildContext context) {
    playMusic() async {
      audioplayer.stop();
      int status = await audioplayer.play(filePath[currentFile], isLocal: true);
      if (status == 1) {
        setState(() {
          isPlaying = true;
        });
      } else {
        print("Status: $status");
      }
    }

    audioplayer.onDurationChanged.listen((Duration d) {
      setState(
        () => totalDuration = d.toString().substring(2, 7),
      );
    });

    audioplayer.onPlayerStateChanged.listen((AudioPlayerState s) => {
          setState(
            () => currentState = s.toString(),
          ),
        });

    audioplayer.onPlayerCompletion.listen((event) {
      setState(() {
        currentFile = (currentFile + 1) % numOfFiles;
        musicName = fileName[currentFile];
        playMusic();
      });
    });

    audioplayer.onAudioPositionChanged.listen((Duration p) => {
          setState(
            () {
              currentTime = p.toString().substring(2, 7);
              seekTime =
                  currentTime.substring(0, 2) + currentTime.substring(3, 5);
              pTime = double.parse(seekTime) /
                  double.parse(totalDuration.substring(0, 2) +
                      totalDuration.substring(3, 5));
            },
          ),
        });
    FlutterStatusbarcolor.setStatusBarColor(Colors.black87);
    var body = Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            "https://raw.githubusercontent.com/yobahBertrandYonkou/flutter/master/logo211.jpg",
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Image.asset(
              isPlaying ? "images/icon1.png" : "images/icon11.png",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            musicName + " " + currentState.split(".").last,
            style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                currentTime,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Container(
                width: 400,
                child: SeekBar(
                  barColor: Colors.black,
                  progressColor: const Color(0xFF00c8ff),
                  value: pTime,
                ),
              ),
              Text(
                totalDuration,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF086375),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  splashColor: Colors.white,
                  icon: Icon(
                    Icons.loop,
                    color: isLoopOn ? const Color(0xFF00c8ff) : Colors.black,
                  ),
                  iconSize: 35,
                  onPressed: () {
                    if (isLoopOn) {
                      audioplayer.setReleaseMode(ReleaseMode.RELEASE);
                      setState(() {
                        isLoopOn = false;
                      });
                    } else {
                      audioplayer.setReleaseMode(ReleaseMode.LOOP);
                      setState(() {
                        isLoopOn = true;
                      });
                    }
                  },
                ),
                IconButton(
                  splashColor: Colors.white,
                  icon: Icon(Icons.skip_previous),
                  iconSize: 50,
                  onPressed: () {
                    if (isPlaying) {
                      setState(() {
                        if (currentFile == 0) {
                          currentFile = numOfFiles;
                          musicName = fileName[currentFile];
                          playMusic();
                        } else {
                          currentFile--;
                          musicName = fileName[currentFile];
                          playMusic();
                        }
                        print(currentFile);
                      });
                    }
                  },
                ),
                IconButton(
                  splashColor: Colors.white,
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                  iconSize: 50,
                  onPressed: () {
                    if (isPlaying) {
                      audioplayer.pause();
                      setState(
                        () {
                          isPlaying = false;
                        },
                      );
                    } else {
                      audioplayer.resume();
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                ),
                IconButton(
                  splashColor: Colors.white,
                  icon: Icon(Icons.skip_next),
                  iconSize: 50,
                  onPressed: () {
                    if (isPlaying) {
                      setState(() {
                        if (currentFile == numOfFiles - 1) {
                          currentFile = 0;
                          musicName = fileName[currentFile];
                          playMusic();
                        } else {
                          currentFile++;
                          musicName = fileName[currentFile];
                          playMusic();
                        }
                        print(currentFile);
                      });
                    }
                  },
                ),
                IconButton(
                  highlightColor: Colors.white,
                  splashColor: Colors.white,
                  icon: Icon(Icons.stop),
                  iconSize: 50,
                  onPressed: () {
                    if (isPlaying) {
                      audioplayer.stop();
                      setState(() {
                        isPlaying = false;
                        pTime = 0.0;
                        currentTime = "00:00";
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          splashColor: Colors.white,
          backgroundColor: const Color(0xFF086375),
          child: Icon(
            Icons.library_music,
            color: Colors.black,
          ),
          onPressed: () async {
            //returns map containing filenames and their path
            var files = await FilePicker.getMultiFilePath(
              type: FileType.custom,
              allowedExtensions: [
                "mp3",
                "wav",
                "mp4",
                "amr",
                "aiff",
                "aac",
                "wma",
                "flac",
                "alac"
              ],
            );
            //gets number of files selected from storage
            numOfFiles = files.length;
            //setting filename and path list to empty to avoid apend
            setState(() {
              fileName = [];
              filePath = [];
            });
            //getting file path and name from files

            files.forEach(
              (key, value) {
                fileName.add(key);
                filePath.add(value);
              },
            );
            print(files);
            print(fileName);

            setState(() {
              musicName = fileName[currentFile] ?? "No Music";
            });
            playMusic();
          },
        ),
        backgroundColor: const Color(0xFF3C1642),
        body: Center(
          child: body,
        ),
        appBar: AppBar(
          backgroundColor: const Color(0xFF086375),
          title: Text("Music Player"),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPath;

//Ask for permissions in android manifest files

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 600,
    );
    if (imageFile == null) return null;
    setState(() {
      _storedImage = File(imageFile.path);
    });

    //accessing file location
    final appDir = await sysPath.getApplicationDocumentsDirectory();
    final filename = path.basename(imageFile.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$filename');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 50,
        ),
        Expanded(
            child: FlatButton.icon(
          onPressed: _takePicture,
          icon: Icon(Icons.camera),
          label: Text('Take Pictures'),
          textColor: Theme.of(context).primaryColor,
        ))
      ],
    );
  }
}

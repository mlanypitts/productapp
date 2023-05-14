import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class AddProductWidget extends StatefulWidget {
  const AddProductWidget({Key? key}) : super(key: key);

  @override
  State<AddProductWidget> createState() => _AddProductWidgetState();
}

class _AddProductWidgetState extends State<AddProductWidget> {
  late double screenHeight;
  late double screenWidth;
  List<Uint8List> photos = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        color: Color(0xFFF6F1F1),
      ),
      height: screenHeight * 0.9,
      padding: const EdgeInsets.only(
        bottom: 15,
        left: 20,
        right: 20,
        top: 15,
      ),
      width: screenWidth,
      child: Column(
        children: [
          _topBar(),
          _photoSection(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.width;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _addPhotoButton() {
    return GestureDetector(
      onTap: () async {
        Uint8List? newPhoto = await _getPhoto(ImageSource.gallery);
        if (newPhoto != null && newPhoto.isNotEmpty) {
          photos.add(newPhoto);
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Color(0xFF19A7CE),
        ),
        height: 80,
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                color: Color(0xFFAFD3E2),
              ),
              height: 24,
              width: 24,
              child: const Icon(
                Icons.add,
                size: 20,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            const SizedBox(
              child: Text(
                'Add a photo',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List?> _getPhoto(ImageSource source) async {
    Uint8List? photoBytes;

    final picker = ImagePicker();
    XFile? pickedFile;

    try {
      pickedFile = (await picker.pickImage(source: source))!;
    } on Exception catch (e, stack) {
      print('Error in get image: $e, $stack');
    }

    if (pickedFile != null) {
      photoBytes = await pickedFile.readAsBytes();
    }

    return photoBytes;
  }

  Widget _photoSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Container(
        width: screenWidth,
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 8.0, // gap between adjacent chips
          runSpacing: 4.0, // gap between lines
          children: [
            ListView.builder(
                itemCount: photos.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container();
                }),
            _addPhotoButton(),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Color(0xFF19A7CE),
            ),
            padding: const EdgeInsets.all(7),
            height: 40,
            width: 40,
            child: const Icon(
              Icons.close,
              size: 20.0,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          alignment: Alignment.center,
          height: 40,
          child: const Text(
            'New Product',
            style: TextStyle(
              color: Color(0xFF146C94),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        )
      ],
    );
  }
}

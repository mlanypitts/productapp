import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/Product.dart';
import '../utils/constants.dart';

class AddProductWidget extends StatefulWidget {
  final double height;
  final double width;
  final Function(Product) onProductAdded;

  const AddProductWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.onProductAdded,
  }) : super(key: key);

  @override
  State<AddProductWidget> createState() => _AddProductWidgetState();
}

class _AddProductWidgetState extends State<AddProductWidget> {
  Uint8List photo = Uint8List.fromList([]);
  bool photoAdded = false;
  String title = '';
  String desc = '';
  double price = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        color: Constants.antiFlashWhite,
      ),
      height: widget.height,
      padding: const EdgeInsets.only(
        bottom: 15,
        left: 30,
        right: 30,
        top: 30,
      ),
      width: widget.width,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _topBar(),
                _photoSection(),
                _titleWidget(),
                _descWidget(),
                _priceWidget(),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            child: _saveButton(),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
          photo = newPhoto;
          setState(() {
            photoAdded = true;
          });
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Constants.pacificBlue,
        ),
        height: 120,
        width: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(14.0)),
                color: Constants.lightBlue,
              ),
              height: 28,
              width: 28,
              child: const Icon(
                Icons.add,
                color: Constants.seaBlue,
                size: 24,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            const SizedBox(
              child: Text(
                'Add a photo',
                style: TextStyle(
                  color: Constants.seaBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
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
      padding: const EdgeInsets.only(top: 36),
      child: !photoAdded ? _addPhotoButton() : _photoWidget(),
    );
  }

  Widget _titleWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelWidget('Title'),
          TextField(
            style: _textFieldStyle(),
            onChanged: (String value) {
              print(value);
              // Do some validation
            },
            onSubmitted: (String value) {
              title = value;
              print(title);
            },
          ),
        ],
      ),
    );
  }

  Widget _descWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelWidget('Description'),
          TextField(
            maxLength: 120,
            maxLines: 3,
            style: _textFieldStyle(),
            onChanged: (String value) {
              print(value);
              // Do some validation
            },
            onSubmitted: (String value) {
              desc = value;
              print(desc);
            },
          ),
        ],
      ),
    );
  }

  Widget _priceWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelWidget('Price'),
          TextField(
            style: _textFieldStyle(),
            onChanged: (String value) {
              print(value);
              // Do some validation
            },
            onSubmitted: (String value) {
              price = double.parse(value);
              print(price);
            },
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _labelWidget(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Constants.seaBlue,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  TextStyle _textFieldStyle() {
    return const TextStyle(
      color: Constants.pacificBlue,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    );
  }

  Widget _photoWidget() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      height: 120,
      width: 120,
      child: Image.memory(
        photo,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _saveButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              widget.onProductAdded(Product(
                title: title,
                description: desc,
                price: price,
                photo: photo,
              ));
              Navigator.of(context).pop();
            },
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: Constants.pacificBlue,
              ),
              padding: const EdgeInsets.all(7),
              height: 60,
              width: 80,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Constants.seaBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
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
              color: Constants.pacificBlue,
            ),
            padding: const EdgeInsets.all(7),
            height: 40,
            width: 40,
            child: const Icon(
              Icons.close,
              color: Constants.seaBlue,
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
              color: Constants.seaBlue,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        )
      ],
    );
  }
}

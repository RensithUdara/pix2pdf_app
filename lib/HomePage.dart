import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pix_2_pdf/Pdf_Converter_Screen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final picker = ImagePicker();
  final pdf = pw.Document();
  List<File> imageList = [];
  List<String> pdfFilePaths = [];

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        imageList.add(File(pickedFile.path));
      } else {
        print('No Image Selected');
      }
    });
  }

  Future<void> createPDF() async {
    for (var img in imageList) {
      final imageCreate = pw.MemoryImage(img.readAsBytesSync());

      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(imageCreate));
          }));
    }
  }

  Future<void> savePDF() async {
    _savePdfFile();
  }

  Future<void> _savePdfFile() async {
    try {
      final downloadDir = await getApplicationDocumentsDirectory();
      final filePath =
          '${downloadDir.path}/${DateTime.now().microsecondsSinceEpoch}.pdf';
      final file = File(filePath);

      await file.writeAsBytes(await pdf.save());
      pdfFilePaths.add(filePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "PDF saved successfully at $filePath",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      await OpenFile.open(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () async {
              await createPDF();
              await savePDF();
            },
            icon: const Icon(
              Icons.download,
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PdfConverter(
                              pdfFilePaths: pdfFilePaths,
                            )));
              },
              icon: const Icon(
                Icons.picture_as_pdf,
                color: Colors.white,
              ))
        ],
        title: const Text(
          "Pix to PDF",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.pinkAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 5.0,
      ),
      body: imageList.isNotEmpty
          ? ListView.builder(
              itemCount: imageList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(12),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      imageList[index],
                      height: 400,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(20),
                    dashPattern: const [10, 10],
                    color: Colors.black,
                    strokeWidth: 2,
                    child: Container(
                      height: 500,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            size: 60,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "No Images Selected",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    )),
              ),
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () => getImage(ImageSource.gallery),
            backgroundColor: Colors.pinkAccent,
            child: const Icon(
              Icons.photo_library_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          FloatingActionButton(
            onPressed: () => getImage(ImageSource.camera),
            backgroundColor: Colors.pinkAccent,
            child: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const Homepage()));
              },
              backgroundColor: Colors.pinkAccent,
              child: const Icon(
                Icons.refresh_outlined,
                color: Colors.white,
              )),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

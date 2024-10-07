import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class PdfConverter extends StatefulWidget {
  final List<String> pdfFilePaths;

  const PdfConverter({Key? key, required this.pdfFilePaths});

  @override
  State<PdfConverter> createState() =>
      _PdfConverterState(pdfFilePaths: pdfFilePaths);
}

class _PdfConverterState extends State<PdfConverter> {
  final List<String> pdfFilePaths;

  _PdfConverterState({required this.pdfFilePaths});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Generated PDFs",
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
      body: pdfFilePaths.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              itemCount: pdfFilePaths.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    leading: Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Colors.redAccent,
                      size: 35,
                    ),
                    title: Text(
                      "PDF ${index + 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                    trailing: Icon(
                      Icons.open_in_new_rounded,
                      color: Colors.grey[700],
                      size: 28,
                    ),
                    onTap: () async {
                      await OpenFile.open(pdfFilePaths[index]);
                    },
                  ),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.picture_as_pdf_outlined,
                    size: 90,
                    color: Colors.redAccent.withOpacity(0.6),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "No PDFs generated yet.",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Start by converting your images!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

import 'dart:io';

import 'package:drive_app/Themes/pallete.dart';
import 'package:drive_app/constants/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';

class GenearteApp {
  static Future<void> generatePdfAndSave(
      String textname, String descrpiton, BuildContext context) async {
    try {
      final pdf = pw.Document();
      final textfontB = await PdfGoogleFonts.nunitoExtraBold();
      final textfontP = await PdfGoogleFonts.nunitoExtraLight();
      final emoji = await PdfGoogleFonts.notoColorEmoji();
      const PdfColor dividerColor = PdfColors.black;
      const PdfColor footerText = PdfColors.purple;

      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(10),
        build: (pw.Context context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        textname,
                        style: pw.TextStyle(
                          font: textfontB,
                          fontSize: 30,
                          fontFallback: [emoji],
                        ),
                      ),
                    ],
                  ),
                  level: 3,
                  outlineColor: footerText,
                ),
                pw.Divider(
                  color: dividerColor,
                  thickness: 3,
                ),
                pw.Paragraph(
                    padding: const pw.EdgeInsets.only(
                      left: 3,
                    ),
                    text: descrpiton,
                    style: pw.TextStyle(
                      font: textfontP,
                      fontFallback: [emoji],
                    )),
                pw.Spacer(),
                pw.Divider(
                  color: dividerColor,
                  thickness: 1,
                ),
                pw.Footer(
                  title: pw.Text(
                    "Created From StoreFree-App",
                  ),
                ),
              ]);
        },
      ));

      final bytes = await pdf.save();

      final status = await Permission.storage.status;

      if (!status.isGranted) {
        final result = await Permission.storage.request();

        if (result.isGranted) {
          final directory = await getExternalStorageDirectory();
          if (directory != null) {
            final pdfFile = File('${directory.path}/$textname.pdf');
            if (kDebugMode) {
              print(pdfFile.path);
            }
            await pdfFile.writeAsBytes(bytes).then((value) {
              showsnackBars(context, "PDF Saved \t\t🥳", Pallete.greenColor);
            });
          } else {
            if (kDebugMode) {
              print('Error: Unable to access the download folder.');
            }
          }
        } else {
          if (kDebugMode) {
            print('Error: Storage permission denied.');
          }
        }
      } else {
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          final pdfFile = File('${directory.path}/$textname.pdf');
          if (kDebugMode) {
            print(pdfFile.path);
          }
          await pdfFile.writeAsBytes(bytes).then((value) {
            showsnackBars(context, "PDF Saved \t\t🥳", Pallete.greenColor);
          });
        } else {
          if (kDebugMode) {
            print('Error: Unable to access the download folder.');
          }
        }
      }
    } catch (e) {
      print("error $e");
    } finally {}
  }
}

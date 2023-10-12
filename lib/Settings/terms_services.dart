// ignore_for_file: camel_case_types


import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:vibeshr/untils/export_file.dart';


class teams_services extends StatefulWidget {
  const teams_services({super.key});

  @override
  State<teams_services> createState() => _teams_servicesState();
}

class _teams_servicesState extends State<teams_services> {
  final String COMING = 'assets/images/comingsoon.svg';
 bool _isLoading = true;
  late PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromAsset('assets/pdf/terms.pdf');

    setState(() => _isLoading = false);
  }
  
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: Kwhite,
        appBar: const VibhoAppBar(
          title: "Terms and Conditions",
          bColor: Kwhite,
          dontHaveBackAsLeading: false,
        ),
        body:  _isLoading==false?
       
     PDFViewer(
        showIndicator: false,
        showNavigation: false,
        showPicker: false,
          scrollDirection: Axis.vertical,
          document: document,
          
          zoomSteps: 2,
        
    ):const SpinKitWave(
                      color: KOrange,
                      size: 25,
                    )

    
    //      SfPdfViewer.asset(
    //   'assets/pdf/terms.pdf',
    // ),
     
          // SvgPicture.asset(
          //   COMING,
          //   height: double.infinity,
          //   width: double.infinity,
          //   fit: BoxFit.cover,
          // ),
         
        );
        
        
   
  }
}

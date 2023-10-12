import '../untils/export_file.dart';

class CustomFormField extends StatelessWidget {
  TextEditingController? controller;
  String hintText;
  dynamic validator;
  dynamic contentPadding;
  String labelText;
  bool readOnly;
  dynamic value;
  dynamic focusNode;
  int maxLines;
  dynamic onChanged;
  Widget? prefix;
  dynamic keyboardType;
  
  

  //keyboardType: TextInputType.datetime,

  Widget? suffix;
  CustomFormField(
      {Key? key,
      this.keyboardType,
      this.prefix,
      this.focusNode,
      required this.maxLines,
      this.suffix,
      this.value,
      this.onChanged,
      this.contentPadding,
      this.validator,
      required this.readOnly,
      required this.labelText,
      this.controller,
      required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    TextFormField(
      maxLines: maxLines,
      focusNode:focusNode ,
      keyboardType:keyboardType ,
      style: TextStyle(fontSize: 13.sp, fontWeight: kFW700,color: kblack),
      decoration: InputDecoration(
        focusColor: Colors.white,
        
    
        contentPadding:contentPadding,
           // const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
    
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Ktextcolor, width: 0.5),
          borderRadius: BorderRadius.circular(15.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Ktextcolor, width: 0.5),
          borderRadius: BorderRadius.circular(15.r),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Ktextcolor, width: 0.5),
          borderRadius: BorderRadius.circular(15.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Ktextcolor, width: 1),
          borderRadius: BorderRadius.circular(15.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Ktextcolor, width: 0.5),
          borderRadius: BorderRadius.circular(15.r),
        ),
        fillColor: Colors.grey,
    suffixIcon:suffix ,
    prefixIcon: prefix,
        hintText:hintText,
    alignLabelWithHint: true,
        //make hint text
        hintStyle: TextStyle(
          
          color: Klightgray.withOpacity(0.5),
          fontSize: kTenFont,
          fontWeight: FontWeight.w600,
        ),
    
        //create lable
        labelText:labelText,
        //lable style
        labelStyle: TextStyle(
          color: kblack,
          fontSize: kTenFont,
          fontWeight: FontWeight.w800,
        ),
      ),
      validator:validator,
      
      onChanged: onChanged
    );
  }
}

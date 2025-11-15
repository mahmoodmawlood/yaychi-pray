import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'location.dart';
import 'dart:math';
import 'restart.dart';


class LocationPage extends StatefulWidget {
  const LocationPage({super.key});
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final _labelController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _tzController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _yrController = TextEditingController();
  final TextEditingController _mnController = TextEditingController();
  final TextEditingController _dyController = TextEditingController();
  double lat = 0.0; double lng = 0.0; double tz = 0.0;
  Location? _selectedLocation; // ✅ holds currently selected location
  var box = Hive.box<Location>('locations');
  
  // Variables to store calculation results
  String _ToDay = '';
  String _Fajr = '';
  String _SunRise = '';
  String _Dhuhur = '';
  String _Asr = '';
  String _Maghrib = '';
  String _Isha = '';

String _yrinit =" ";
String _moninit=" ";
String _dayinit=" ";



  @override
  void initState() {
    super.initState();
    DateTime _now = DateTime.now();
    int y = _now.year;
    int m = _now.month;
    int d = _now.day;
    lat = 35.467;
    lng = 44.392;
    tz = 3.00;
    _yrController.text = y.toString();
    _mnController.text = m.toString();
    _dyController.text = d.toString();
    _yrinit = 'السنة'; _moninit='الشهر'; _dayinit = 'اليوم';

//    _yrinit = '$y'; _moninit='$m'; _dayinit = '$d';
    _prayer(y, m, d, lat, lng,  tz);
  } 



  void _restoreDefault() {
    setState (() {
    DateTime _now = DateTime.now();
    int y = _now.year;
    int m = _now.month;
    int d = _now.day;
    //lat = 35.467;
    //lng = 44.392;
    //tz = 3.00;
    _yrController.text = y.toString();
    _mnController.text = m.toString();
    _dyController.text = d.toString();
    _yrinit = 'السنة'; _moninit='الشهر'; _dayinit = 'اليوم'; 
    _prayer(y, m, d, lat, lng,  tz);
    });
  } 



  // get date year month and day and calculate
  void _getdata(){
    
    int y = int.tryParse(_yrController.text) ?? 0 ;
    int m = int.tryParse(_mnController.text) ?? 0;
    int d = int.tryParse(_dyController.text) ?? 0;
    if(_selectedLocation != null ){
      lat = _selectedLocation!.latitude ;
      lng = _selectedLocation!.longitude ;
      tz = _selectedLocation!.timezone ;
    }
    _yrinit = 'ادخل السنة'; _moninit='ادخل الشهر'; _dayinit = 'ادخل اليوم';
      _prayer(y, m, d, lat, lng, tz);
  }      // end of getdata

void _closeApp(){
  if(Platform.isAndroid){
    SystemNavigator.pop();    // android exit
  } else if(Platform.isIOS)  {
    exit(0);
  }
}





// ------------------------------------------------------------------
  
// BUIL UI 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.greenAccent, // background color for the title box
              borderRadius: BorderRadius.circular(8), // rounded corners
            ),
            child: const Text(
              'برنامج اوقات الصلاة - اعداد د. محمود خالد',
              style: TextStyle(
                color: Colors.black, // text color
                fontSize: 13, fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true, // optional
          backgroundColor: Colors.blue, // color of the AppBar itself
         actions: [
            IconButton(
             icon: const Icon(Icons.close),
             tooltip: ' Exit ',
             onPressed: _closeApp,
            ),
         ],
        ),      // end of AppBar


       body: LayoutBuilder(
        builder:(context, constraints){
         return SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                ),

        child: Padding(
         padding: const EdgeInsets.all(2.0),         
            child: Column(
             children: [
               Text(" ادخل التاريخ الميلادي هنا", 
               style: TextStyle(fontSize:13, fontWeight:FontWeight.bold )
               ),
               SizedBox(height:3),
                             Row(
                                children: [
                                  ElevatedButton(
                                  onPressed: _restoreDefault,
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade100),
                                    minimumSize: MaterialStateProperty.all<Size>(const Size(30,30)),
                                    ),
                                  child: Text(" تاريخ اليوم", style: 
                                              TextStyle(color: Colors.black ,fontSize:13,fontWeight: FontWeight.bold),
                                              ),
                                ),
                                    Expanded(child: _buildInputField(_yrinit, _yrController)),
                                    SizedBox(width: 1),
                                    Expanded(child: _buildInputField(_moninit, _mnController)),
                                    SizedBox(width: 1),
                                    Expanded(child: _buildInputField(_dayinit, _dyController)),
                                ],
                              ),  // end of date input rows
                              _buildResultBox('ToDay ', _ToDay, Colors.green),

             Row(        // Main Central row encompassing two columns
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Expanded(
                    child: Column(
                        children: [

                        
                           //   SizedBox(height: 3),
                           //     _buildResultBox('ToDay ', _ToDay, Colors.green),
                              SizedBox(height: 2),
                              ElevatedButton(
                                onPressed: _getdata,
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                                  minimumSize: MaterialStateProperty.all<Size>(const Size(100,30)),
                                  ),
                                child: Text("أحسب المواقيت ", 
                                      style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                                 ),
                                ), // end of button                                 
                    
                                SizedBox(height: 3),  
                                // out put fields for prayer times
                                SizedBox(height: 2),
                                _buildResultBox('Fajr ', _Fajr, Colors.blue.shade200),
                                SizedBox(height: 2),
                                _buildResultBox('SunRise', _SunRise, Colors.yellow.shade200),
                                SizedBox(height: 2),
                                _buildResultBox('Dhuhur', _Dhuhur, Colors.yellow), 
                                SizedBox(height: 2),
                                _buildResultBox('Asr  ', _Asr, Colors.yellow),   
                                SizedBox(height: 2),
                                _buildResultBox('Maghrib', _Maghrib, Colors.yellow.shade200),  
                                SizedBox(height: 2),
                                _buildResultBox('Ishaa', _Isha,Colors.grey.shade200),  

/*                                ElevatedButton(
                                  onPressed: _restoreDefault,
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade100),
                                    minimumSize: MaterialStateProperty.all<Size>(const Size(100,30)),
                                    ),
                                  child: Text("عودة الى تاريخ النظام", style: 
                                              TextStyle(color: Colors.black ,fontSize:12,fontWeight: FontWeight.bold),
                                              ),
                                ),  */
                   
                        ],               //children of left column
                    ),                   // end of left column
                ),                      // end of Expanded

                SizedBox(width:5),      // space between left and right sides
// ----------------------------------------------------------------------------------------------------------
                                        // start of the right column
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,   // align right
                        mainAxisAlignment: MainAxisAlignment.start,   // start from top
                        children: [
                                // 🔹 Dropdown to select a saved location
                                ValueListenableBuilder(
                                    valueListenable: box.listenable(),
                                    builder: (context, Box<Location> box, _) {
                                    var locations = box.values.toList();
                                    locations.sort((a,b) => a.label.compareTo(b.label));
                                    return DropdownButton<Location>(
                                        hint: Text("  كركوك",
                                              style: TextStyle(color: Colors.black,fontSize: 13, fontWeight: FontWeight.bold ),
                                        ),
                                        value: _selectedLocation,
                                        items: locations.map((loc) {
                                     
                                        
                                        return DropdownMenuItem<Location>(
                                            value: loc,
                                            child: Text(loc.label),
                                        );              // end return
                                        }).toList(),
                                        onChanged: (loc) {
                                        setState(() {
                                            _selectedLocation = loc;
                                        });             // end of setState
                                        },              // end of onChanged (loc)
                                    );                  // end of DropDown Button
                                    },                  // end of builder
                                ),                      //  end of Drop Down to select ..Value Listenable Builder
                                  
                                   
                                    // 🔹 Show details of selected location
                                    
                                   
                                   // SizedBox(height:20),
                                    if( _selectedLocation != null)
                                    Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
         " ${_selectedLocation!.label}, Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}, Zone: ${_selectedLocation!.timezone}",
                                      // long: ${_selectedLocation!.longitude},TimeZone:${_selectedLocation!.timezone}" ,
                                        //"Selected: ${_selectedLocation!.label}\n"
                                        //"Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}\n"
                                       // "Timezone: ${_selectedLocation!.timezone}",
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                        ),
                                    ),              // end of show selections
                                   
                                    SizedBox(height:5),
                                    //                         Add location button ********  ADD  LOCATION 
                                    ElevatedButton(
                                        onPressed: () {
                                            var box = Hive.box<Location>('locations');    // ***
                                            String label = _labelController.text.trim();  // ***
                                            bool exists = box.values.any(
                                              (loc) => loc.label.toLowerCase() == label.toLowerCase(),
                                            );
                                            if(exists){
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(" موجود '$label' الموقع")),
                                              );
                                            } else {
                                              if (_formKey.currentState!.validate()) {
                                                  var loc = Location(
                                                      _labelController.text,
                                                      double.tryParse(_latController.text) ?? 0.0,
                                                      double.tryParse(_lngController.text) ?? 0.0,
                                                      double.tryParse(_tzController.text) ?? 0.0,
                                                  ); 
                                                      box.add(loc);
                                                      _labelController.clear();
                                                      _latController.clear();
                                                      _lngController.clear();
                                                      _tzController.clear();
                                              }          // endif
                                             }       // end of Else            
                                            },              // end onPress
                                  
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                                         minimumSize: MaterialStateProperty.all<Size>(const Size(100,30)),
                                    ),

                                        child: Text('أضف موقع', style: TextStyle(color: Colors.black, fontSize: 13,
                                                    fontWeight: FontWeight.bold)),
                                    ),              //   end of Add Location elevated button


                                    SizedBox(height:5),  
                                    // 🔹 Form to add new location
                                    Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Form(
                                        key: _formKey,
                                          child: Column(
                                            children: [
                                                TextFormField(
                                                    style: const TextStyle(fontSize:13,fontWeight: FontWeight.bold),
                                                    controller: _labelController,
                                                    decoration: InputDecoration(labelText: "   الموقع الجديد " , filled: true, fillColor:
                                                      Colors.lightGreen[200],
                                                      labelStyle: TextStyle(color: Colors.black,fontSize:12,fontWeight: FontWeight.bold),
                                                      errorStyle:TextStyle(color: Colors.red,fontSize:12),
                                                      border: OutlineInputBorder(),
                                                      isDense: true,  // shrinks the height of the form
                                                      contentPadding:EdgeInsets.symmetric(vertical:5, horizontal: 20),
                                                    ),
                                                     validator: (value) {
                                                    if (value == null || value.isEmpty) return 'أدخل الموقع';
                                                    //final lat = double.tryParse(value);
                                                    //if (lat == null || lat < -90 || lat > 90) {
                                                    //    return 'Latitude must be between -90 and 90';
                                                    }
                                                    //return null;
                                                ),

                                                //SizedBox(height:10),
                                                TextFormField(
                                                    style: const TextStyle(fontSize:13,fontWeight: FontWeight.bold),   // to control the height
                                                    controller: _latController,
                                                    decoration: InputDecoration(labelText: '   خط العرض  ', filled: true, fillColor:
                                                      Colors.red[100], //lightGreen[50],
                                                      labelStyle: TextStyle(color: Colors.black,fontSize:12,fontWeight: FontWeight.bold),
                                                      errorStyle:TextStyle(color: Colors.red,fontSize:12),
                                                      border: OutlineInputBorder(),
                                                      isDense: true,  // shrinks the height of the form
                                                      contentPadding:EdgeInsets.symmetric(vertical:5, horizontal: 20),
                                                      ),
                                                 //   keyboardType: TextInputType.numberWithOptions(decimal:true),
                                                  //  inputFormatters: [
                                                  //    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),
                                                 //   ],
                                                    validator: (value) {
                                                    if (value == null || value.isEmpty) return ' أدخل خط العرض  ';
                                                    final lat = double.tryParse(value);
                                                    if (lat == null || lat < -90 || lat > 90) {
                                                        return 'أدخل رقم صحيح';
                                                    }
                                                    return null;
                                                    }, 
                                                ),          // end of latitude Input Form
                                                //SizedBox(height:10),

                                                TextFormField(
                                                    style: const TextStyle(fontSize:13,fontWeight: FontWeight.bold),
                                                    controller: _lngController,
                                                      decoration: InputDecoration(labelText: '   خط الطول  ', filled: true, fillColor:
                                                      Colors.lightGreen[200], 
                                                      labelStyle: TextStyle(color: Colors.black,fontSize:12,fontWeight: FontWeight.bold),
                                                      errorStyle:TextStyle(color: Colors.red,fontSize:12),
                                                      border: OutlineInputBorder(),
                                                      isDense: true,  // shrinks the height of the form
                                                      contentPadding:EdgeInsets.symmetric(vertical:5, horizontal: 20),
                                                      ),
                                                    keyboardType: TextInputType.numberWithOptions(decimal:true),
                                                  //  inputFormatters: [
                                                  //    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),
                                                  //  ],
                                                    validator: (value) {
                                                    if (value == null || value.isEmpty)   return  'أدخل خط الطول';
                                                   
                                                    final lng = double.tryParse(value);
                                                    if (lng == null || lng < -180 || lng > 180) {
                                                        return 'أدخل رقم صحيح';
                                                    }
                                                    return null;
                                                    }, 
                                                ),          // end of lonng Input Form

                                                //SizedBox(height:10),
                                                TextFormField(
                                                    style: const TextStyle(fontSize:13,fontWeight: FontWeight.bold),
                                                    controller: _tzController,
                                                    decoration: InputDecoration(labelText: '  فرق التوقيت ', filled: true, fillColor:
                                                      Colors.red[100], //lightGreen[50], 
                                                    labelStyle: TextStyle(color: Colors.black ,fontSize:12,fontWeight: FontWeight.bold),
                                                      errorStyle:TextStyle(color: Colors.red,fontSize:12),
                                                      border: OutlineInputBorder(),
                                                      isDense: true,  // shrinks the height of the form
                                                      contentPadding:EdgeInsets.symmetric(vertical:5, horizontal: 20),
                                                    ),
                                                    keyboardType: TextInputType.numberWithOptions(decimal:true),
                                                  /*  inputFormatters: [
                                                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),
                                                    ],  */
                                                    validator: (value) {
                                                    if (value == null || value.isEmpty) return  'أدخل فرق التوقيت';
                                                    final lng = double.tryParse(value);
                                                    if (lng == null || lng < -12 || lng > 14) {
                                                        return 'أدخل رقم صحيح';
                                                    }
                                                    return null;
                                                    },   
                                                ),          // end of time zone Input Form


                                            ],          // end of Children of Input Forms
                                          
                                        ),              // end of Column parent of input children
                                      
                                      ),                // end of Form
                                    ),                  // ond of secondary padding
                                  

/*                                    SizedBox(height:1),
                                    // 🔹 Delete all locations
                                    ElevatedButton(
                                        onPressed: () => box.clear(),

                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                                           minimumSize: MaterialStateProperty.all<Size>(const Size(100,30)),
                                         ),

                                        child: Text(" احذف كل المواقع", style: 
                                              TextStyle(color: Colors.black ,fontSize:13,fontWeight: FontWeight.bold),
                                              ),
                                    ),      */

                                    SizedBox(height:3),
                                    // delete selected location   ******************************DELETE SELECTED
                                    ElevatedButton(
                                      onPressed: (){
                                        if(_selectedLocation == null){
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content:Text(" لم يتم اختيار موقع")),
                                          );
                                          return;
                                        }
                                        var box = Hive.box<Location>('locations');
                                        String label = _selectedLocation!.label.trim(); 
                                        int index = box.values.toList().indexWhere(
                                          (loc) =>loc.label.toLowerCase() == label.toLowerCase(),
                                        );
                                        if(index != -1) {
                                          box.deleteAt(index);
                                          setState((){
                                            _selectedLocation = null; //reset selection
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("تم حذف الموقع المختار")),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("الموقع غير موجود")),
                                          );
                                        }
                                      },

                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                                            minimumSize: MaterialStateProperty.all<Size>(const Size(100,30)),
                                         ),

                                      child: Text("أحذف الموقع المختار", style:
                                          TextStyle(color: Colors.black ,fontSize:13,fontWeight: FontWeight.bold),
                                          ),
                                    ),   

                                  // ***************************************************             
/*            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("عودة الى موقع وتاريخ النظام"),
              onPressed: () {
                RestartWidget.restartApp(context);
              },
            ),  */
                                SizedBox(height: 1),

                                ElevatedButton(
                                  onPressed: () {
                                    RestartWidget.restartApp(context);
                                  },

                                  //onPressed: _restoreDefault,
                                
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade100),
                                    minimumSize: MaterialStateProperty.all<Size>(const Size(100,30)),
                                    ),
                                  child: Text("عودة للوضع الاساسي", style: 
                                              TextStyle(color: Colors.black ,fontSize:12,fontWeight: FontWeight.bold),
                                              ),
                                ),

                          
                               /*   TextFormField(
                                      style: const TextStyle(fontSize:12), //fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(labelText: ' ملاحظة \n الارتفاع ونسبة الاضاءة \n للهلال المولود مع الغروب', filled: true, fillColor:
                                      Colors.yellow, //lightGreen[50], 
                                      labelStyle: TextStyle(color: Colors.black ,fontSize:12,fontWeight: FontWeight.bold),
                                      border: OutlineInputBorder(),
                                      ),
                                   )  */

                        ],                               // end of children of Right column

                    ),                                   // end of Right side column

                ),                                       // end of second expanded
            ],                                           // end of main Children
         ),                                               // end of Main Row
          ],
          ),        // main main column
       ),        // end of Main Padding
            ), // constrined box

      );        // end of SingleChildScrollView   
        },    // builder
       ),   // body

    );      // end of Scaffold

  } // end of build Widget


  // Helper function to build Result Boxes
  Widget _buildResultBox(String title, String value, Color fill ) {
    return Container(
      //margin: EdgeInsets.only(left:100),
      //width: double.infinity,
      width: double.infinity,
      height:40,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: fill, //grey[100],
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /*Text(
            title,
            //style: TextStyle(fontSize:10),
            textDirection: TextDirection.ltr,
          ),*/
          SizedBox(height: 8),
          Text(value.isNotEmpty ? value : '    ',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

// Helper function to build input boxes for prayer times
  // Helper function to create input fields for
  Widget _buildInputField(String label, TextEditingController controller) {
    return 
      SizedBox(
       
      //  width: 70,
        height: 32,
        
          child: TextField(
          style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
          controller: controller,
          decoration: InputDecoration(filled: true, fillColor:
                                                      Colors.lightGreen[200],
          labelText: label,
          labelStyle: TextStyle(fontSize:13, fontWeight: FontWeight.bold),
          border: OutlineInputBorder(),
          //contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
      
      );
    
  }
// ----------------------------------Calculations Start Here

// Function to calculculate prayer times
  
  void _prayer(int y, int m, int d, double lat, double lng, double tz) {
  setState((){
    List<int> sgn = [1,1,0,-1,-1,-1];
    List<double> shift = [0.0, 0.0, 1.0, 0.6, 1.0, 0.0];
    List<double> altitude = [-18.0, -1.5333, -0.8333, -0.8333, -0.8333, -17.0];
    List<int> maxdays = [31,28,31,30,31,30,31,31,30,31,30,31];
    List<double> times = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    double twopi = 2.0*pi;
    double glong = lng; double glat = lat;
    double zone = tz; double rads = pi/180.0; double degs = 180.0/pi;
    double sinphi = sin(glat * rads);
    double cosphi = cos(glat * rads);
    glong = glong * rads;
    
  //setState(() {  
    //DateTime now = DateTime.now();
    //int y = now.year; int m = now.month; int d = now.day;
    // 
      if(y%4 == 0){maxdays[1]=29;}
      if( y > 500 && y < 2500 && m > 0 && m<= 12 && d > 0 && d <= maxdays[m-1]  ) {
      int k = 0; // int i = 1;
      for(int i = 1; i<=6; i++){
        double sinalt = sin(altitude[i-1]*rads);
        k += 1;
        double day = 367*y - 7*(y + (m + 9)~/12)~/4 + 275*m~/9 + d - 730531.5;
        double utold = pi; double utnew = 0.0;
        do { 
          utold = utnew;
          double days = day + utold/twopi;
          double t = days/36525.0;
          double L = (4.8949504201433 + 628.331969753199 * t); 
	  	    double b = L / twopi; 
		      double a = twopi * (b - b.abs() / b*(b.abs()).toInt()); 
  		    if (a < 0.0)  {a = twopi + a;} 
	  	    L = a; 
		      double g = (6.2400408 + 628.3019501 * t); 
		      b = g / twopi; 
		      a = twopi * (b - b.abs() / b*(b.abs()).toInt()); 

		      if (a < 0.0) { a = twopi + a;} 
  		    g = a; 	
	  	    double ec = .033423 * sin(g) + .00034907 * sin(2 * g); 
		      double lambda = L + ec; 
		      double e = -1 * ec + .0430398 * sin(2 * lambda) - .00092502 * sin(4 * lambda); 
  		    double obl = .409093 - .0002269 * t; 
	  	    double delta = asin(sin(obl) * sin(lambda)); 
		      double gha = utold - pi + e; 
		      double cosc = (sinalt - sinphi * sin(delta)) / (cosphi * cos(delta)); 
          // ASR COSC
	        if (k == 4){ 
		        double temp = 1.0 + tan(glat*rads - delta); 
		        temp = sin(atan(1.0 / temp)); 
		        cosc = (temp - sinphi * sin(delta)) / (cosphi * cos(delta)); 
	        }
          double correction = 0.0;
          if(cosc > 1.0) {correction = 0.0;}
          if(cosc < -1.0) {
            correction = pi;
          }else{
            correction = acos(cosc);
          }
          if(correction < 0.0) { correction += pi;}
          utnew = (utold - (gha + glong + sgn[k-1] * correction)) + zone*15.0*rads;
          b = utnew / twopi; 
          a = twopi * (b - b.abs() / b*(b.abs()).toInt()); 
          if (a < 0.0) {a = twopi + a;} 
          utnew = a; 
      
        }while((utold - utnew).abs() > 0.001);
      
        double tim = (utnew * degs / 15.0) + shift[k-1] * 5 / 60.0;
        if(tim>24.0) { tim -= 24.0;}
        if(tim<0.0) { tim +=24.0;}
        // store the time in List times[] for use in Isha time calculations
        times[k-1] = tim;
        if(k==6 && lat>= 16.37 && lat <= 32.23 && lng >= 34.5 && lng <= 55.68){
          tim = times[4] + 1.5;   // Isha in Saudi arabi = magrib timr + 90 min
        }
        int hr = tim.toInt();
        double min1 = (tim - hr)*60.0;
        int min = min1.round();
        int sec = ((min1 - min)*60.0).toInt();
        if(min == 60){
          min = 0;
          hr = hr + 1;
        }
        String f = min.toString().padLeft(2,'0');

        if(k==1){_Fajr    = "${hr}"+":"+ f+"  الفجر  ";}
        if(k==2){_SunRise = "${hr}"+":"+ f+"  الشروق  ";}
        if(k==3){_Dhuhur  = "${hr}"+":"+ f+"  الظهر  ";}
        if(k==4){_Asr     = "${hr}"+":"+ f+"  العصر  ";}
        if(k==5){_Maghrib = "${hr}"+":"+ f+"  المغرب  ";}
        if(k==6){_Isha    = "${hr}"+":"+ f+"  العشاء  ";} 
   //     _ToDay = _wday(y,m,d) +' $y / $m /$d  ';
    };  // end of for
    //
      List<String> out =    _hijree(y, m, d, lat, lng,  tz);
      String yearH = out[0];
      String monthH= out[1];
      String dayH = out[2];
      String wdayH = out[3];
      _ToDay = "هـ"+yearH+" "+monthH+" "+dayH;
      _ToDay = wdayH+" "+dayH+" "+monthH+" "+yearH+" هـ";
    }else{
      _ToDay =   ' خطأ اعد أدخال التاريخ  ';
      _Fajr =    '                             ';
      _SunRise = '                             ';
      _Dhuhur =  '                             ';
      _Asr =     '                             ';
      _Maghrib = '                             ';
      _Isha =    '                             ';
    }

   

     });  // end of setState
  }  // end of _prayer routine
// ----------------------------------------------------------------------------
    String _wday(int yr, int mn, int dy){
    List<String> days =['احد','اثنين','ثلاثاء','اربعاء','خميس','جمعة','سبت'];
    int yy = yr;
    int mm = mn;
    int dd = dy; 
    if(mm < 3){
      yy = yy - 1;  
      mm = mm + 12; 
    }
    int a = (yy/100.0).floor(); 
    int b = 2 - a + (a/4.0).floor(); 
    if(yy < 0){b = 0;}
    double  jd = (365.25*(yy+4716)).floor()+(30.6001*(mm+1)).floor()+ dd+ b-1524.5 + 1.5 ;
    int i = (jd - 7*(jd/7.0).toInt()).toInt();  
    
    return days[i];
    }
//  =======================END OF PRAYER ROUTINE ==================================
//
//  == ====== ==  HIJREE ROUTINE

List<String> _hijree(int y, int m, int d, double lat, double lng,  double tz){
  List<int> sgn = [1,1,0,-1,-1,-1];
  List<double> shift = [0.0, 0.0, 1.0, 0.6, 1.0, 0.0];
  List<double> altitude = [-18.0, -1.5333, -0.8333, -0.8333, -0.8333, -17.0];
  List<String> monthname = ['محرم','صفر','ربيع 1','ربيع 2','جمادى 1','جمادى 2',
      'رجب', 'شعبان','رمضان','شوال','ذوالقعدة','ذوالحجة'];
  List<String> weekday = ['احد','اثنين','ثلاثاء','اربعاء','خميس','جمعة','سبت'];
  List<int> maxdays =[31,28,31,30,31,30,31,31,30,31,30,31];
  //int itest = 0;
  double twopi = 2.0*pi;
  double glong = lng; double glat = lat;
  double zone = tz; double rads = pi/180.0; double degs = 180.0/pi;
  double sinphi = sin(glat * rads);
  double cosphi = cos(glat * rads);
  glong = glong * rads;
  // DateTime now = DateTime.now();
  int gyear1 = y; int gmonth1 = m; int gday1 = d;
  //int hour1 = now.hour; int minit = now.minute;
  //print('${gyear1}  ${gmonth1} ${gday1}');


// do{   // outer cycle, remove it later

  double y_shift = 0.0;
  int h_first = 0;  int h_day = 0; 

  do {                             // convergence inner cycle start
    y_shift += 0.1;
    List result = birth(gyear1,gmonth1,gday1, y_shift, zone);
    int gyear2 = result[0]; int gmonth2 = result[1]; int gday2 = result[2]; 
      double birth_time = result[3];

                                // get sunset time from function maghrib 
    double sunset = maghrib(gyear2, gmonth2, gday2, zone);
    int shh = sunset.floor();                                      //     ***** sunset hourr
    int smm = ((((sunset - shh)*60)*100).round()/100).floor();     //     ***** sunset minute

    //print('Birth ${birth_time}, SunSise ${sunset}');
    if(birth_time < sunset) { 
      h_first = gday2 + 1;
      List<double> moonloc = moon(gyear2, gmonth2 , gday2.toDouble(), shh, smm, lng, lat, tz); // **** moon loc at sunset  
      if(moonloc[1]<2.0 && moonloc[2]<0.2){
            h_first = gday2 + 2;
      }
    
      } else { h_first = gday2 + 2;
    }
    if(h_first > maxdays[gmonth2-1]){
      h_first -= maxdays[gmonth2-1];
      gmonth2 += 1; 
    }
    if(gmonth2>12){
      gmonth2 = 1;
      gyear2 += 1;
    }

    if(gyear1 == gyear2 && gmonth1 == gmonth2 && h_first <= gday1){
      h_day = 1 + gday1 - h_first;
    } 
    double jd1 = 0.0; double jd2 = 0.0;
    if(gyear1 == gyear2 && gmonth1>gmonth2) {
      jd1 = julian(gyear1, gmonth1, gday1);
      jd2 = julian(gyear2, gmonth2, h_first);
      int interval = (jd1 - jd2).toInt();
      h_day = 1 + interval;
    }

    if(gyear2 < gyear1){
      jd1 = julian(gyear1, gmonth1, gday1);
      jd2 = julian(gyear2, gmonth2, h_first);
      int interval = (jd1 - jd2).toInt();
      h_day = 1 + interval;
    }

  } while(h_day>30  || h_day == 0);                  // inner cycle end do

                                      //  get hijre year from function hijree()
  List<int> result1 = hijree(gyear1,gmonth1,gday1);
  int hijre = result1[0]; int i_m = result1[1]; int d_d = result1[2];
  if((h_day - d_d) >= 25) {i_m = i_m - 1;}
  if((d_d - h_day) >= 25) {i_m = i_m + 1;}

  if(i_m > 12) {
    i_m = 1;
    hijre += 1; 
  }
                                      // get week day index id from function w_day()
  double jd1 = julian(gyear1, gmonth1, gday1) + 1.5;
  int id = (jd1 % 7).toInt();
  
//                                     //Finalize
  String hyear = '$hijre';
  String wday = '${weekday[id]}';
  String hmonth = '${monthname[i_m-1]}';
  //print('----------------');
  //print('Hijree :$hijre');
  //print(hmonth+" "+ '$h_day');
  //print(wday);
  return[hyear,hmonth,'$h_day',wday];
  
}
                                    // END of main routine

// -----------------------MAGHRIB Routine--------------------------

double maghrib(int gyear2, int gmonth2, int gday2, double tz) {      // function to find sunset
  List<int> sgn = [1,1,0,-1,-1,-1];
  List<double> shift = [0.0, 0.0, 1.0, 0.6, 1.0, 0.0];
  List<double> altitude = [-18.0, -1.5333, -0.8333, -0.8333, -0.8333, -17.0];

  double twopi = 2.0*pi;
  double glong = 44.392; double glat = 35.4667;
  double zone = tz; double rads = pi/180.0; double degs = 180.0/pi;
  double sinphi = sin(glat * rads);
  double cosphi = cos(glat * rads);
  glong = glong * rads;
  
// 
// Maghrib index = i = 5, but 4 must be used because zero based (i-1)
  int i = 5;
  int k = 5;
  int y = gyear2; int m = gmonth2; int d = gday2;
  
  double sinalt = sin(altitude[i-1]*rads);

  double day = 367*y - 7*(y + (m + 9)~/12)~/4 + 275*m~/9 + d - 730531.5;
  double utold = pi; double utnew = 0.0;
    do {                              // iterate for convergence
      utold = utnew;
      double days = day + utold/twopi;
      double t = days/36525.0;
      double L = (4.8949504201433 + 628.331969753199 * t); 
	  	double b = L / twopi; 
		  double a = twopi * (b - b.abs() / b*(b.abs()).toInt()); 
		  if (a < 0.0)  {a = twopi + a;} 
		  L = a; 
		  double g = (6.2400408 + 628.3019501 * t); 
		  b = g / twopi; 
		  a = twopi * (b - b.abs() / b*(b.abs()).toInt()); 

		  if (a < 0.0) { a = twopi + a;} 
		  g = a; 	
		  double ec = .033423 * sin(g) + .00034907 * sin(2 * g); 
		  double lambda = L + ec; 
		  double e = -1 * ec + .0430398 * sin(2 * lambda) - .00092502 * sin(4 * lambda); 
		  double obl = .409093 - .0002269 * t; 
		  double delta = asin(sin(obl) * sin(lambda)); 
		  double gha = utold - pi + e; 
		  double cosc = (sinalt - sinphi * sin(delta)) / (cosphi * cos(delta)); 

      double correction = 0.0;
      if(cosc > 1.0) {correction = 0.0;}
      if(cosc < -1.0) {
        correction = pi;
      }else{
       correction = acos(cosc);
      }
      if(correction < 0.0) { correction += pi;}
      utnew = (utold - (gha + glong + sgn[k-1] * correction)) + zone*15.0*rads;
      b = utnew / twopi; 
      a = twopi * (b - b.abs() / b*(b.abs()).toInt()); 
      if (a < 0.0) {a = twopi + a;} 
      utnew = a; 
      
    }while((utold - utnew).abs() > 0.001);
    double tim = (utnew * degs / 15.0) + shift[k-1] * 5 / 60.0;
    if(tim>24.0) { tim -= 24.0;}
    if(tim<0.0) { tim +=24.0;}
   return tim;  // coincides to sunset in main
}                 // 
// ------------------ End of maghrib function

//                          Julian day routine
double julian(int year, int month, int day) {
  int iy = year; int m = month; int d = day;
  if(m < 3) {
    iy -= 1;
    m += 12;
  }
  int ia = (iy/100.0).floor();
  int ib = 2 - ia + (ia/4.0).floor();
  if(iy < 0) {ib = 0;}
  double jd = (365.25*(iy + 4716)).toInt() + (30.6001*(m + 1)).toInt() + d + ib - 1524.5;
  return jd;
}
// ----------------- End of Julian function

            // BIRTH ROUTINE  moon Birth day and time
List<dynamic> birth(int gyear1, int gmonth1,int gday1, double y_shift, double zone) {
  double year = gyear1.toDouble();
  double month = gmonth1.toDouble();
  double day = gday1.toDouble();
  double t = (year - 2000.0)/100.0;
  double dt = 0.0;
  if(year <948.0) { dt = 2177.0 + 497*t + 44.1*t*t;}
  if(year > 948.0){ dt = 102.0 + t*(102.0 + 25.3*t); } 
	if(year >= 2000.0 && year <= 2100.0) { dt = dt + 0.37*(year - 2100.0);}
  year = year + (month + 1.0 - y_shift)/12.0;
  
  int K = ((year - 2000.0)*12.3685).floor();
  double TT = K/1236.85;
  double E = 1.0 - 0.0025160*TT - 0.00000740*TT*TT;
	double MS = 2.55340 + 29.10535670*K - .00000140*TT*TT - .000000110*TT*TT*TT;
	double MP = 201.56430 + 385.816935280*K + .01075820*TT*TT + .000012380*TT*TT*TT 
		- .0000000580*TT*TT*TT*TT;
	double F = 160.71080 + 390.670502840*K - .00161180*TT*TT - .000002270*TT*TT*TT
		+ .0000000110*TT*TT*TT*TT;
	double OM = 124.77460 - 1.563755880*K + .00206720*TT*TT + .000002150*TT*TT*TT;
	double A1 = 299.770 + 0.1074080*K - .0091730*TT*TT; 
	double A2 = 251.880 + 0.0163210*K;
	double A3 = 251.830 + 26.6518860*K;
	double A4 = 349.420 + 36.4124780*K;
	double A5 = 84.6600 + 18.2062390*K;
	double A6 = 141.740 + 53.3037710*K;
	double A7 = 207.140 + 2.45373200*K;
	double A8 = 154.840 + 7.30686000*K;
	double A9 = 34.5200 + 27.2612390*K;
	double A10= 207.190 + 0.12182400*K;
	double A11= 291.340 + 1.84437900*K;
	double A12= 161.720 + 24.1981540*K;
	double A13= 239.560 + 25.5130990*K;
	double A14= 331.550 + 3.59251800*K;
	double JDE = 2451550.097660 + 29.5305888610*K + 0.000154370*TT*TT - 0.000000150*TT*TT*TT 
			+ 0.000000000730*TT*TT*TT*TT;
	double CORR1 = -0.40720*SIND(MP) + 0.172410*E*SIND(MS)+0.016080*SIND(2*MP) + 
			0.010390*SIND(2*F)+0.007390*E*SIND(MP-MS)-0.005140*E*SIND(MP+MS) + 
			0.002080*E*E*SIND(2*MS) - 0.001110*SIND(MP-2*F)-0.000570*SIND(MP+2*F) + 
			0.000560*E*SIND(2*MP+MS)-0.000420*SIND(3*MP)+0.000420*E*SIND(MS+2*F) + 
			0.000380*E*SIND(MS-2*F)-0.000240*E*SIND(2*MP-MS)-0.000170*SIND(OM) - 
			0.000070*SIND(MP+2*MS)+0.000040*SIND(2*MP-2*F)+0.000040*SIND(3*MS) + 
			0.000030*SIND(MP+MS-2*F)+0.000030*SIND(2*MP+2*F)-0.000030*SIND(MP+MS+2*F) + 
			0.000030*SIND(MP-MS+2*F)-0.000020*SIND(MP-MS-2*F)-0.000020*SIND(3*MP+MS)+ 
			0.000020*SIND(4*MP);
	double CORR2 = (325*SIND(A1)+ 165*SIND(A2)+164*SIND(A3)+126*SIND(A4)+110*SIND(A5)+62*SIND(A6) + 
			60*SIND(A7) + 56*SIND(A8) + 47*SIND(A9)+42*SIND(A10)+40*SIND(A11)+37*SIND(A12) + 
			35*SIND(A13)+23*SIND(A14))/1000000.0;
	JDE = JDE + CORR1 + CORR2 + 0.50 + zone/24; // zone/24 is added to make local time
	int ZZ = JDE.toInt();
	double FF = JDE - ZZ;
  int AA = 0;
  if(ZZ < 2299161){
    AA = ZZ;
  }else{
    int ALF = ((ZZ-1867216.250)/36524.250).toInt();
    AA = ZZ + 1 + ALF - (ALF/4.0).floor();
  }
  int BB = AA + 1524;
	int CC = ((BB-122.10)/365.250).floor();
	int DD = (365.25*CC).floor();
	int EE = ((BB-DD)/30.60010).floor();

	day = BB - DD + FF - (30.60010*EE).floor();  //  day is double
  int mon = 0; int yr = 0;
  if(EE < 14){mon = EE - 1; }
  if(EE >= 14){mon = EE - 13;}
  if(mon > 2){
    yr = CC - 4716;
  }else{
    yr = CC - 4715;
  }
  double time = day - day.floor();  // decimal part = fraction of a day
  time = 24*time*3600.0 - dt;
  double hr_part = time/3600.0;
  int hr = hr_part.floor();
  double min_part = (hr_part - hr)*60.0;
  int min = min_part.floor();
  double sec_part = (min_part - min)*60.0;
  int sec = sec_part.floor();
  return[yr, mon, day.floor(), hr_part];

//coincides in main to [gyear2, gmonth2, gday2, birth_time]

}
// ------------------------ End of birth date ----

// ------ sin(degrees)
double SIND(double x){
  return sin(x*pi/180.0);
}

//  ********************* HIJREE ROUTINE **********************
List<int> hijree(int gyear1, int gmonth1, int gday1){
  int y = gyear1;
  int m = gmonth1;
  int dd = gday1;
  int mm = m;
  int yy = y;
  int month = 0;
  int day = 0;
  int year = 0;
  if(m < 3){
    y = y - 1;
    m = m + 12;
  }
  int alfa = (y/100.0).floor();
  int beta = 2 - alfa + (alfa/4.0).floor();
  int b = (365.25*y).floor() + (30.6001*(m+1)).floor() + dd + 1722519 + beta;
  int c = ((b - 122.1)/365.25).floor();
  int d = (365.25*c).floor();
  int e = ((b - d)/30.6001).floor();
  day = b - d - (30.6001*e).floor();
  if(e < 14){month = e - 1;}
  if(e < 14){month = e - 1;} 
  if(e > 13){month = e - 13;}
  if(month > 2){year = c - 4716;} 
  if(month < 3){year = c - 4715;} 
  int w = 2; 
  if((year % 4) ==0){w = 1;} 
  int n = (275*month/9.0).floor() - w*((month+9)/12.0).floor() + day - 30; 
  int a = year - 623; 
  b = (a/4.0).floor(); 
  c = a % 4;
  double c1 = 365.2501*c; 
  int c2 = c1.floor(); 
  if( c1-c2 > 0.5){c2 = c2 + 1;} 
  int Dp = 1461*b + 170 + c2; 
//! print*,' Dp ', Dp
  int q = (Dp/10631.0).floor(); 
  int r = Dp % 10631; 
  int j = (r/354.0).floor(); 
  double k = (r % 354).toDouble(); 
  int o = ((11*j + 14)/30.0).floor(); 

  int h = 30*q + j + 1; 
  double jj = k - o + n - 1; 
//!if (h<0)h = 0.
//!print*,' jj 1 ',jj
//!if (jj<0)jj=354+jj
//!print*,' h ',h
//!print*,' jj ',jj
  int cl = 0;
  int dl = 0;
  if(jj > 354.0){  
    cl = (h % 30); 
    dl = 11*cl + 3; 
    dl = (dl % 30); 
    //!print*,' dl ',dl
      if(dl < 19){ 
		    jj = jj - 354; 
		    h = h + 1; 
      }
      if(dl > 18){
        jj = jj - 355; 
        h = h + 1; 
      }
   }
   if(jj == 0){
     jj = 355; 
     h = h - 1; 
  }
  int s =((jj-1)/29.5).floor(); 
  m = 1 + s; 
  d = (jj-29.5*s).floor(); 
  if(jj == 355){
    m = 12; 
    d = 30; 
  }

  return[h, m, d];
}
// ***************************************

//********************************moon routine*********************************************************
//   CALCULATE AZIMUTH ALTITUDE AND ILLUMINATION OF THE MOON AT THE GIVEN INSTANT  

List<double> moon(int IY, int M, double D, int hr, int MIN, double LONG, double FI, double zone){
  //List<int> maxdays =[31,28,31,30,31,30,31,31,30,31,30,31];
  List<int>values = [0,2,2,0,0,0,2,2,2,2,0,1,0,2,0,0,4,0,4,2,2,1,1,2,2,4,2,0,2,2,1,2, 
		0,0,2,2,2,4,0,3,2,4,0,2,2,2,4,0,4,1,2,0,1,3,4,2,0,1,2,2, 
		0,0,0,0,1,0,0,-1,0,-1,1,0,1,0,0,0,0,0,0,1,1,0,1,-1,0,0,0,1,0,-1,0,-2, 
		1,2,-2,0,0,-1,0,0,1,-1,2,2,1,-1,0,0,-1,0,1,0,1,0,0,-1,2,1,0,0, 
		1,-1,0,2,0,0,-2,-1,1,0,-1,0,1,0,1,1,-1,3,-2,-1,0,-1,0,1,2,0,-3,-2,-1,-2,1,0, 
		2,0,-1,1,0,-1,2,-1,1,-2,-1,-1,-2,0,1,4,0,-2,0,2,1,-2,-3,2,1,-1,3,-1, 
		0,0,0,0,0,2,0,0,0,0,0,0,0,-2,2,-2,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0, 
		0,0,0,-2,2,0,2,0,0,0,0,0,0,-2,0,0,0,0,-2,-2,0,0,0,0,0,0,0,-2];
  int rows = 60;
  int cols = 4;
  List<List<int>> IARG1 = List.generate(rows, (i) => List.filled(cols, 0));
  for (int i = 0; i < values.length; i++) {
    int row = i % rows;
    int col = i ~/ rows;
    IARG1[row][col] = values[i];
  }
  List<int> values1 = [0,0,0,2,2,2,2,0,2,0,2,2,2,2,2,2,2,0,4,0,0,0,1,0,0,0,1,0,4,4, 
		0,4,2,2,2,2,0,2,2,2,2,4,2,2,0,2,1,1,0,2,1,2,0,4,4,1,4,1,4,2, 
		0,0,0,0,0,0,0,0,0,0,-1,0,0,1,-1,-1,-1,1,0,1,0,1,0,1,1,1,0,0,0,0, 
		0,0,0,0,-1,0,0,0,0,1,1,0,-1,-2,0,1,1,1,1,1,0,-1,1,0,-1,0,0,0,-1,-2, 
		0,1,1,0,-1,-1,0,2,1,2,0,-2,1,0,-1,0,-1,-1,-1,0,0,-1,0,1,1,0,0,3,0,-1, 
		1,-2,0,2,1,-2,3,2,-3,-1,0,0,1,0,1,1,0,0,-2,-1,1,-2,2,-2,-1,1,1,-1,0,0, 
		1,1,-1,-1,1,-1,1,1,-1,-1,-1,-1,1,-1,1,1,-1,-1,-1,1,3,1,1,1,-1,-1,-1,1,-1,1, 
		-3,1,-3,-1,-1,1,-1,1,-1,1,1,1,1,-1,3,-1,-1,1,-1,-1,1,-1,1,-1,-1,-1,-1,-1,-1,1];
  List<List<int>> IARG2 = List.generate(rows, (i) => List.filled(cols, 0));
    for (int i = 0; i < values1.length; i++) {
    int row = i % rows;
    int col = i ~/ rows;
    IARG2[row][col] = values1[i];
  }    
  List<double> SIN1 = [6288774.00, 1274027.00,658314.00,213618.00,-185116.00,-114332.00,58793.00, 
		57066.00, 53322.00,45758.00,-40923.00,-34720.00,-30383.00,15327.00,-12528.00,10980.00, 
		10675.00,10034.00,8548.00,-7888.00,-6766.00,-5163.00,4987.00,4036.00,3994.00, 
		3861.00,3665.00,-2689.00,-2602.00,2390.00,-2348.00,2236.00,-2120.00,-2069.00, 
		2048.00,-1773.00,-1595.00,1215.00,-1110.00,-892.00,-810.00,759.00,-713.00,-700.00, 
		691.00, 596.00,549.00,537.00,520.00,-487.00,-399.00,-381.00,351.00,-340.00,330.00, 
		327.00,-323.00,299.00,294.00, 0.00];
  
  List<double> COS1 = [-20905355.00,-3699111.00,-2955968.00,-569925.00,48888.00,-3149.00,246158.00, 
		-152138.00,-170733.00,-204586.00,-129620.00,108743.00,104755.00,10321.00,0.00, 
		79661.00,-34782.00,-23210.00,-21636.00,24208.00,30824.00,-8379.00,-16675.00,-12831.00, 
		-10445.00,-11650.00,14403.00,-7003.00,0.00,10056.00,6322.00,-9884.00,5751.00,0.00, 
		-4950.00,4130.00,0.00,-3958.00,0.00,3258.00,2616.00,-1897.00,-2117.00,2354.00,0.00,0.00, 
		-1423.00,-1117.00,-1571.00,-1739.00,0.00,-4421.00,0.00,0.00,0.00,0.00,1165.00,0.00,0.00, 
		8752.00];
  
  List<double> SIN2 = [5128122.00, 280602.00,277693.00,173237.00,55413.00,46271.00,32573.00,17198.00,9266.00, 
		8822.00,8216.00,4324.00,4200.00,-3359.00,2463.00,2211.00,2065.00,-1870.00,1828.00,-1794.00, 
		-1749.00,-1565.00,-1491.00,-1475.00,-1410.00,-1344.00,-1335.00,1107.00,1021.00,833.00,777.00, 
		671.00,607.00,596.00,491.00,-451.00,439.00,422.00,421.00,-366.00,-351.00,331.00,315.00,302.00, 
		-283.00,-229.00,223.00,223.00,-220.00,-220.00,-185.00,181.00,-177.00,176.00,166.00,-164.00, 
		132.00,-119.00,115.00,107.00];
  
  List<int> values2 = [0,-2,0,0,0,0,-2,0,0,-2,-2,-2,0,2,0,2,0,0,-2,0,2,0,0,-2,0,-2,0,0,2,-2,0, 
		-2,0,0,2,2,0,-2,0,2,2,-2,-2,2,2,0,-2,-2,0,-2,-2,0,-1,-2,1,0,0,-1,0,0,2,0,2, 
		0,0,0,0,1,0,1,0,0,-1,17*0,2,0,2,1,0,-1,0,0,0,1,1,-1,6*0,-1,-1,0,0,0,1,0,0,1,0,0,0, 
		-1,1,-1,-1,0,-1, 
		5*0,1,0,0,1,0,1,0,-1,0,1,-1,-1,1,2,-2,0,2,2,1,0,0,-1,0,-1,0,0, 
		1,0,2,-1,1,0,1,0,0,1,2,1,-2,0,1,0,0,2,2,0,1,1,0,0,1,-2,1,1,1,-1,3,0, 
		0,2,2,0,0,0,2,2,2,2,0,2,2,0,0,2,0,2,0,2,2,2,0,2,2,2,2,0,0,2,0, 
		0,0,-2,2,2,2,0,2,2,0,2,2,0,0,0,2,0,2,0,2,-2,0,0,0,2,2,0,0,2,2,2,2, 
		1,2,2,2,0,0,2,1,2,2,0,1,2,0,1,2,1,1,0,1,2,2,0,2,0,0,1,0,1,2,1, 
		1,1,0,1,2,2,0,2,1,0,2,1,1,1,0,1,1,1,1,1,0,0,0,0,0,2,0,0,2,2,2,2];
  rows = 63;
  cols = 5;
  List<List<int>> IARG22 = List.generate(rows, (i) => List.filled(cols, 0));
  for (int i = 0; i < values2.length; i++) {
    int row = i % rows;
    int col = i ~/ rows;
    IARG22[row][col] = values2[i];
  }
  
  List<double> values3 = [-171996.00,-13187.00,-2274.00,2062.00,1426.00,712.00,-517.00,-386.00,-301.00, 
		217.00,-158.00,129.00,123.00,63.00,63.00,-59.00,-58.00,-51.00,48.00,46.00,-38.00, 
		-31.00,29.00,29.00,26.00,-22.00,21.00,17.00,16.00,-16.00,-15.00, 
		-13.00,-12.00,11.00,-10.00,-8.00,7.00,-7.00,-7.00,-7.00,6.00,6.00,6.00,-6.00,-6.00, 
		5.00,-5.00,-5.00,-5.00,4.00,4.00,4.00,-4.00,-4.00,-4.00,3.00,...List.filled(7,-3.00), 
		-174.200,-1.600,-.200,.200,-3.400,.100,1.200,-.400,0.00,-.500,0.00,.100,0.00,0.00,.100, 
		0.00,-.100,...List.filled(10,0.00),-.100,0.00,.100,...List.filled(33,0.00)];

  rows = 63;
  cols = 2;
  List<List<double>> SIN22 = List.generate(rows, (i) => List.filled(cols, 0));
  for (int i = 0; i < values3.length; i++) {
    int row = i % rows;
    int col = i ~/ rows;
    SIN22[row][col] = values3[i];
  }

  List<double> values4 = [92025.00,5736.00,977.00,-895.00,54.00,-7.00,224.00,200.00,129.00,-95.00,0.00,-70.00, 
		-53.00,0.00,-33.00,26.00,32.00,27.00,0.00,-24.00,16.00,13.00,0.00,-12.00,0.00,0.00,-10.00, 
		0.00,-8.00,7.00,9.00, 
		7.00,6.00,0.00,5.00,3.00,-3.00,0.00,3.00,3.00,0.00,-3.00,-3.00,3.00,3.00,0.00,3.00,3.00,3.00,
		...List.filled(14,0.00), 8.900,-3.100,-.500,.500,-.100,0.00,-.600,0.00,-.100,.300,...List.filled(53,0.00)];

  List<List<double>> COS22 = List.generate(rows, (i) => List.filled(cols, 0));
  for (int i = 0; i < values4.length; i++) {
    int row = i % rows;
    int col = i ~/ rows;
    COS22[row][col] = values4[i];
  }


  double Z = hr.toDouble();
 
  int YEAR = IY;    // FOR FURTHER CALCULATIONS 
  int MONTH = M;
  double TIM = Z;
	// convert time to Universal Time and minutes to hours 
	Z = Z + MIN/60.0 - zone;
	// Z = DINT(Z/100.D0) + DMOD(Z,100.D0)/60.D0 
	D = D + Z/24.0;
//   calculate DT IN SECOND for Dynamical Time and add it to Day D
	double DT = 0.0;
    double T = (IY - 2000.0)/100.0;
	if(IY < 948) {DT = 2177 + 497*T + 44.1*T*T;}
	if(IY > 948) {DT = 102+T*(102 + 25.3*T);} 
	if(IY>=2000 && IY<=2100) {DT = DT + 0.37*(IY - 2100);}
	D = D + DT/86400.0;
	if(M < 3) { 
		IY = IY - 1;
		M = M + 12;
	}
	int IA = (IY/100.0).floor();
	int IB = 2 - IA + (IA/4.00).floor();
	if(IY < 0) {IB = 0;}
	double JD = (365.250*(IY+4716)).toInt() + (30.60010*(M+1)).toInt() + D + IB - 1524.5;
//	JDE= INT(365.25D0*(IY+4716))+INT(30.6001D0*(M+1)) + D+DT/86400.D0 +IB - 1524.5
//	WRITE(*,*) JD
	T = (JD - 2451545.0)/36525.0;
	double THO = 280.460618370 + 360.98564736629*(JD-2451545.00)+ 
		0.0003879330*T*T - T*T*T/38710000.0;
	// Limit the value of THO between 0 and 360.
    THO = limit(THO);  // call function limit()
//!	PRINT*,' T  tho = ', T, THO
//! MOON ARGUMENTS	
	double LP = 218.31644770 + 481267.881234210*T - 0.00157860*T*T + T*T*T/538841.0 - T*T*T*T/65194000.0;
	double DM = 297.85019210 + 445267.11140340*T - 0.00188190*T*T + T*T*T/545868.0 - T*T*T*T/113065000.0;
	double MS = 357.52910920 + 35999.05029090*T - 0.00015360*T*T + T*T*T/24490000.0;
	double MP = 134.96339640 + 477198.86750550*T + 0.00874140*T*T + T*T*T/69699.0 -	T*T*T*T/14712000.0;
	double F = 93.27209500 + 483202.01752330*T - 0.00365390*T*T - T*T*T/35260000 + T*T*T*T/863310000.0;
    LP = limit(LP);
    DM = limit(DM);
    MS = limit(MS);
    MP = limit(MP);
    F = limit(F);
    double A1 = 119.750 + 131.8490*T;
	double A2 = 53.090 + 479264.2900*T;
	double A3 = 313.450 + 481266.4840*T;
    A1 = limit(A1);
    A2 = limit(A2);
    A3 = limit(A3);
    double E = 1.0 - 0.0025160*T - 0.00000740*T*T;

	double SUML = 0.0;
	double SUMR = 0.0;
	for(int I = 0; I<= 59; I++){
		double COFSIN = SIN1[I]*pow(E, IARG1[I][1].abs());
		double COFCOS = COS1[I]*pow(E, IARG1[I][1].abs());
		double ARG = IARG1[I][0]*DM + IARG1[I][1]*MS + IARG1[I][2]*MP + IARG1[I][3]*F;
        SUML = SUML + COFSIN*SIND(ARG);
		SUMR = SUMR + COFCOS*COSD(ARG);
    }
	double SUMB = 0.0;
	for(int I = 0; I <= 59; I++){
		double COFSIN = SIN2[I]*pow(E, IARG2[I][1].abs());
		double ARG = IARG2[I][0]*DM + IARG2[I][1]*MS + IARG2[I][2]*MP + IARG2[I][3]*F;
		SUMB = SUMB + COFSIN*SIND(ARG);
	}
// the additive terms to suml and sumb
	SUML = SUML + 3958.0*SIND(A1)+1962.0*SIND(LP-F) + 318.0*SIND(A2);
	SUMB = SUMB - 2235.0*SIND(LP)+ 382.0*SIND(A3) + 175.0*SIND(A1-F) + 
		175.0*SIND(A1+F) + 127.0*SIND(LP-MP) - 115.0*SIND(LP+MP);
	double LAMDA = LP + SUML/1.0e6;
	double BETA = SUMB/1.0e6;
	double DELTA = 385000.560 + SUMR/1000.0;
// Chapter 22
	DM = 297.850360 + 445267.1114800*T - 0.00191420*T*T + T*T*T/189474.0;
	MS = 357.527720 + 35999.0503400*T - 0.00016030*T*T - T*T*T/300000.0;
	MP = 134.962980 + 477198.8673980*T + 0.00869720*T*T + T*T*T/56250.0;
	F  = 93.271910 + 483202.0175380*T - 0.00368250*T*T + T*T*T/327270.0;
	double OM = 125.044520 - 1934.1362610*T + 0.00207080*T*T + T*T*T/450000.0;
	double SUM1 = 0.0;
	double SUM2 = 0.0;
	for( int I = 1; I<= 62; I++){
		double COFSIN = SIN22[I][0]+SIN22[I][1]*T;
		double COFCOS = COS22[I][0]+COS22[I][1]*T;
		double ARG = IARG22[I][0]*DM + IARG22[I][1]*MS + IARG22[I][2]*MP + IARG22[I][3]*F +   
			  IARG22[I][4]*OM;
		SUM1 = SUM1 + COFSIN*SIND(ARG);
		SUM2 = SUM2 + COFCOS*COSD(ARG);
	}
	double DEPSI = SUM1/10000.0;		// IN SECONDS
	double DEPSILON  = SUM2/10000.0;   // IN SECONDS
	double U = T/100.0;
	double EPSO = 21.4480 + U*(-4680.930 + U*(-1.550 + U*(1999.250 + U*(-51.380 + 
					U*(-249.670 + U*(-39.050 + U*(7.120 + U*(27.870 + 
					U*(5.790 + U*2.450)))))))));		// THIS IS SECONDS' PART
	EPSO = EPSO + 23.0*3600.0 + 26.0*60.0;			// EPSO IN SECONDS
	double EPS  = (EPSO + DEPSILON)/3600.0;     	//      EPS IN DEG
// Chapter 13
// Azimuth and Elevation of moon
	LAMDA = LAMDA + DEPSI/3600.0;
	double ALFA = ATAN2D(SIND(LAMDA)*COSD(EPS)-TAND(BETA)*SIND(EPS),COSD(LAMDA));
	double DEL  = ASIND(SIND(BETA)*COSD(EPS) + COSD(BETA)*SIND(EPS)*SIND(LAMDA));
	double H = THO + LONG - ALFA;  // LONg IS OBSERVER LONGITUDE AND FI IS HIS LATITUDE, BOTH MUST BE KNOWN
	double AZIMUTH = ATAN2D(SIND(H),(COSD(H)*SIND(FI) - TAND(DEL)*COSD(FI)));
	double ALTITUDE  = ASIND(SIND(FI)*SIND(DEL)+COSD(FI)*COSD(DEL)*COSD(H));
	AZIMUTH = ((AZIMUTH+180.0)*100).round()/100;
	ALTITUDE = (ALTITUDE*100).round()/100;

//!------------------------------------------------------------------
//! ...............ILLUMINATED FRACTION OF MOOD......................
//!...............          CHAPTER 48           ....................
//!...............      EQS. 48.1  AND 48.4      ....................
	double II = 180.0 - DM -6.2890*SIND(MP) + 2.10*SIND(MS) - 1.2740*SIND(2.0*DM-MP) 
		- 0.658*SIND(2.0*DM) - 0.2140*SIND(2.0*MP) - 0.110*SIND(DM);  
	double ILU = 0.50*(1.0 + COSD(II));
    ILU = (ILU*10000).round()/100;	// already converted to percent therefore not divided by 1000
//    print('Illium fraction ${ILU*100}  %');
//!	PRINT*,' ------------ILLUMINATED FRACTION OF MOON---------------'
//!	PRINT*,' '
//	WRITE(*,'("  ILLUMINATION ", F8.3,"%")')ILU*100.

return [AZIMUTH, ALTITUDE, ILU];
}

//        -----  PAUSE  FUNCTION ---
void pause(){
  print(' press Enter to continue ...');
  stdin.readLineSync();
} 
double limit(double x){
  do  {
    if(x >= 0.0 && x<= 360.0){return x;}
    if(x < 0.0) { x += 360.0;}
    if(x > 360.0){x -= 360.0;}
  } while (true);
}

//double SIND(double x){
//  return sin(x*pi/180.0);
//}

double COSD(double x){
  return cos(x*pi/180.0);
}
double TAND(double x){
    return tan(x*pi/180.0);
}
double ATAN2D(double x, double y){
    return atan2(x, y)*180.0/pi;
}
double ASIND(double x){
    return asin(x)*180.0/pi;
}
double ACOSD(double x){
    return acos(x)*180.0/pi;
}



// ***************** END OF WIDGET BUILD
}
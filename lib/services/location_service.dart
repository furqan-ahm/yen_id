import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {

  String? currentAddress;

  LocationService._(){
    getLocation();
  }

  static final LocationService _service=LocationService._();

  static LocationService instance()=>_service;

  Geolocator geolocator=Geolocator();
  
  Future getLocation()async{

    bool enabled= await Geolocator.isLocationServiceEnabled();
    if(!enabled){
      currentAddress='Location Services Disabled';
      return;
    }

    var permission=await Geolocator.checkPermission();

    if(permission==LocationPermission.denied)await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return currentAddress='Location denied';
    }

    Position pos=await Geolocator.getCurrentPosition();



    List<Placemark> places=await GeocodingPlatform.instance.placemarkFromCoordinates(pos.latitude, pos.longitude);

    currentAddress=places.first.locality;

  }


}
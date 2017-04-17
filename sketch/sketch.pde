// import external libraries
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.events.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.mapdisplay.shaders.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.texture.*;
import de.fhpotsdam.unfolding.tiles.*;
import de.fhpotsdam.unfolding.ui.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.utils.*;
import java.util.Date;
import java.text.SimpleDateFormat;

// input file
String allTripsFile = "../output.csv";
String dataFile = allTripsFile;

// how many frames to create?
int totalFrames = 7200;

// initialize screen position and location variables
ScreenPosition startPos;
ScreenPosition endPos;
Location startLocation;
Location endLocation;

// initialize date variables For parsing dates
Date minDate;
Date maxDate;
Date startDate;
Date endDate;
Date thisStartDate;
Date thisEndDate;

// initialize unfolding map object and base map providers
UnfoldingMap map;
AbstractMapProvider provider1;
AbstractMapProvider provider2;
AbstractMapProvider provider3;
AbstractMapProvider provider4;
AbstractMapProvider provider5;
AbstractMapProvider provider6;
AbstractMapProvider provider7;
AbstractMapProvider provider8;
AbstractMapProvider provider9;
AbstractMapProvider provider0;

// initialize trip table and arrays
Table tripTable;
ArrayList<Trips> trips = new ArrayList<Trips>();
ArrayList<Integer> types = new ArrayList<Integer>();

// initialize some other stuff
PFont f;
int cab_type;
PImage img;
int totalSeconds;

void setup() {
  fullScreen(P2D);
  smooth();
  loadData();
  println("Finished loading data");
  
  // initialize unfolding map object
  map = new UnfoldingMap(this); // default
  MapUtils.createDefaultEventDispatcher(this, map);
  
  // center map on NYC
  Location nyc = new Location(40.72, -74.0);
  int zoom = 11;
  map.zoomAndPanTo(zoom, nyc);
  MapUtils.createDefaultEventDispatcher(this, map);
  
  // define base map providers
  provider1 = new OpenStreetMap.OpenStreetMapProvider();
  provider2 = new StamenMapProvider.TonerBackground();
  provider3 = new Microsoft.AerialProvider();
  provider4 = new Microsoft.RoadProvider();
  provider5 = new Yahoo.RoadProvider();
  provider6 = new Yahoo.HybridProvider();
  provider7 = new AcetateProvider.Hillshading();
  provider8 = new Google.GoogleTerrainProvider();
  provider9 = new Google.GoogleMapProvider();

  
}

void loadData() {
  // load input data into a table
  Table tripTable = loadTable(dataFile, "header");
  println(str(tripTable.getRowCount()) + " records loaded...");
  
  // define date format of raw data
  SimpleDateFormat myDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
  
  // calculate min and max start times (must be sorted ascending)
  String first = tripTable.getString(0, "starttime");
  String last = tripTable.getString(tripTable.getRowCount()-1, "stoptime");
  
  // try getting min and max dates to calculate total seconds
  try {
    minDate = myDateFormat.parse(first);
    maxDate = myDateFormat.parse(last);
    totalSeconds = int(maxDate.getTime()/1000) - int(minDate.getTime()/1000);
  } 
  catch (Exception e) {
    println("Unable to parse date stamp");
  }
  
  println("Min starttime:", minDate, ". In epoch:", minDate.getTime()/1000);
  println("Max starttime:", maxDate, ". In seconds:", maxDate.getTime()/1000);
  println("Total seconds in dataset:", totalSeconds);
  
  // run through each row in the data table
  for (TableRow row : tripTable.rows()) {
    int type_id = row.getInt("type_id");
    types.add(type_id);
    
    int tripduration = row.getInt("tripduration");
    int duration = round(map(tripduration, 0, totalSeconds, 0, totalFrames));
    
    try {
      thisStartDate = myDateFormat.parse(row.getString("starttime"));
      thisEndDate = myDateFormat.parse(row.getString("stoptime"));
    } catch (Exception e) {
      println("Unable to parse destination");
    }
    
    int startFrame = floor(map(int(thisStartDate.getTime()/1000), float(int(minDate.getTime()/1000)), float(int(maxDate.getTime()/1000)), 0, totalFrames));
    int endFrame = floor(map(thisEndDate.getTime()/1000, float(int(minDate.getTime()/1000)), float(int(maxDate.getTime()/1000)), 0, totalFrames));
    
    float startLat = row.getFloat("start_lat");
    float startLon = row.getFloat("start_lon");
    float endLat = row.getFloat("end_lat");
    float endLon = row.getFloat("end_lon");
    
    startLocation = new Location(startLat, startLon);
    endLocation = new Location(endLat, endLon);

    trips.add(new Trips(duration, startFrame, endFrame, startLocation, endLocation));
  }
}

void draw() {
  
  if(frameCount < totalFrames) {
    
  map.draw();
  noStroke();
  fill(0,100);
  rect(0,0,width,height);
  
  // convert time to epoch
  float epoch_float = map(frameCount, 0, totalFrames, int(minDate.getTime()/1000), int(maxDate.getTime()/1000));
  int epoch = int(epoch_float);
  
  // String date = new java.text.SimpleDateFormat("MM/dd/yyyy hh:mm a").format(new java.util.Date(epoch * 1000L));
  String date = new java.text.SimpleDateFormat("EEEE MMMM d, yyyy").format(new java.util.Date(epoch * 1000L));
  String time = new java.text.SimpleDateFormat("h:mm a").format(new java.util.Date(epoch * 1000L));
  
  // Airport locations
  Location JFK = new Location(40.6413111,-73.7781391);
  Location LGA = new Location(40.7769271,-73.8761546);
  Location EWR = new Location(40.6895314,-74.1744624);
     
  // Create point markers for locations
  SimplePointMarker JFKMarker = new SimplePointMarker(JFK);
  SimplePointMarker LGAMarker = new SimplePointMarker(LGA);
  SimplePointMarker EWRMarker = new SimplePointMarker(EWR);
  
  // Load white font
  fill(255,255,255);
  f = createFont("AppleSDGothicNeo-Bold", 40, true);
  
  // Draw airport text labels
  textFont(f, 18);
  text("JFK", map.getScreenPosition(JFK).x-15, map.getScreenPosition(JFK).y+30);
  text("LGA", map.getScreenPosition(LGA).x, map.getScreenPosition(LGA).y-5);
  text("EWR", map.getScreenPosition(EWR).x-20, map.getScreenPosition(EWR).y+30);
  
  // draw trips
  for (int i=0; i < trips.size(); i++) {
    
    Trips trip = trips.get(i);
    
    if (types.get(i) == 3){ // brooklyn bus
      color c = color(0,173,253);
      fill(c, 100);
      trip.plotBusRide();
    } else if (types.get(i) == 4){ // queens bus
      color c = color(0,173,253);
      fill(c, 100);
      trip.plotBusRide();
    } else if (types.get(i) == 5){ // manhattan bus
      color c = color(0,173,253);
      fill(c, 100);
      trip.plotBusRide();
    } else if (types.get(i) == 6){ // bronx bus
      color c = color(0,173,253);
      fill(c, 100);
      trip.plotBusRide();
    } else if (types.get(i) == 7){ // staten island bus
      color c = color(0,173,253);
      fill(c, 100);
      trip.plotBusRide();
    } else if(types.get(i) == 1){ //yellow cab
      color c = color(255, 255, 0);
      fill(c, 200);
      trip.plotTaxiRide();
    } else if (types.get(i) == 2){ // green cab
      color c = color(79, 255, 1);
      fill(c, 255);
      trip.plotTaxiRide();
    } else if (types.get(i) == 8){ // subway
      color c = color(255, 0, 0);
      fill(c, 200);
      trip.plotSubwayRide();
    } else if (types.get(i) == 9){ // ferry
      color c = color(238,130,238);
      fill(c, 150);
      trip.plotBigFerryRide();
    } else if (types.get(i) == 10){ // citibike
      color c = color(0,0,255);
      fill(c, 150);
      trip.plotBikeRide();
    } else if (types.get(i) == 11){ // amtrak
      color c = color(255,140,0);
      fill(c, 150);
      trip.plotBigTrainRide();
    } else if (types.get(i) == 12){ // PATH
      color c = color(166,97,26);
      fill(c, 225);
      trip.plotSubwayRide();
    } else if (types.get(i) == 13){ // Bus Company
      color c = color(0,173,253);
      fill(c, 150);
      trip.plotBusRide();
    } else if (types.get(i) == 14){ // LIRR
      color c = color(255,140,0);
      fill(c, 150);
      trip.plotSmallTrainRide();
    } else if (types.get(i) == 15){ // MetroNorth
      color c = color(117,107,177);
      fill(c, 245);
      trip.plotSmallTrainRide();
    } else if (types.get(i) == 16){ // waterways
      color c = color(238,130,238);
      fill(c, 150);
      trip.plotSmallFerryRide();
  }
  } 
  
  // Text objects
  f = createFont("AppleSDGothicNeo-Light", 36, true);  // Loading font
  fill(255, 255, 255, 255);
  textFont(f, 44);
  text("Multimodal Symphony", 40, 100);
  textFont(f, 26);
  text("24 Hours of Transit in New York City",40, 140);
  
  f = createFont("AppleSDGothicNeo-Light", 36, true);  // Loading font
  fill(255, 255, 255, 255);
  textFont(f, 22);
  //text(date, 40, 200);
  
  f = createFont("AppleSDGothicNeo-Light", 36, true);  // Loading font
  fill(255, 255, 255, 255);
  textFont(f, 28);
  text(time, 40, 225);
  
  f = createFont("AppleSDGothicNeo-Light", 20, true);  // Loading font
  fill(128, 128, 128);
  textFont(f, 22);
  text("@wgeary", 40, 860);

  // Legend
  fill(255, 255, 0, 200);
  ellipse(52, 270, 20, 20);
  fill(255, 255, 255);
  textFont(f, 20);
  text("Yellow Cab", 72, 277);

  fill(79, 255, 1, 200);
  ellipse(52, 310, 20, 20);
  fill(255, 255, 255);
  textFont(f, 20);
  text("Green Cab", 72, 317);
  
  fill(0,173,253, 200);
  ellipse(52, 350, 20, 20);
  fill(255, 255, 255);
  textFont(f, 20);
  text("Bus", 72, 357);
  
  fill(255,0,0, 200);
  ellipse(52, 390, 20, 20);
  fill(255, 255, 255, 255);
  textFont(f, 20);
  text("Subway", 72, 397);
  
  fill(238,130,238, 200);
  ellipse(52, 430, 20, 20);
  fill(255, 255, 255, 255);
  textFont(f, 20);
  text("Ferry", 72, 437);
  
  fill(0,0,255, 200);
  ellipse(52, 470, 20, 20);
  fill(255, 255, 255, 255);
  textFont(f, 20);
  text("Citibike", 72, 477);
  
  fill(255,140,0, 200);
  ellipse(52, 510, 20, 20);
  fill(255, 255, 255, 255);
  textFont(f, 20);
  text("Amtrak", 72, 517);
  
  fill(166,97,26, 225);
  ellipse(52, 550, 20, 20);
  fill(255, 255, 255, 255);
  textFont(f, 20);
  text("PATH Train", 72, 557);
  
  fill(117,107,177, 225);
  ellipse(52, 590, 20, 20);
  fill(255, 255, 255, 255);
  textFont(f, 20);
  text("MetroNorth", 72, 597);
    
    //saveFrame("frames/######.png");
    
  } else {
    return;
  }
}

// change base map provider on the fly
void keyPressed() {
    if (key == '1') {
        map.mapDisplay.setProvider(provider1);
    } else if (key == '2') {
        map.mapDisplay.setProvider(provider2);
    } else if (key == '3') {
        map.mapDisplay.setProvider(provider3);
    } else if (key == '4') {
        map.mapDisplay.setProvider(provider4);
    } else if (key == '5') {
        map.mapDisplay.setProvider(provider5);
    } else if (key == '6') {
        map.mapDisplay.setProvider(provider6);
    } else if (key == '7') {
        map.mapDisplay.setProvider(provider7);
    } else if (key == '8') {
        map.mapDisplay.setProvider(provider8);
    } else if (key == '9') {
        map.mapDisplay.setProvider(provider9);
    } else if (key == '0') {
        map.mapDisplay.setProvider(provider0);
    }
}
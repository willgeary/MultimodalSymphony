// Adapted from https://github.com/juanfrans-courses/DataScienceSocietyWorkshop/blob/master/03_ProcessingSketches/sketch_161114_TripAnimation/sketch_161114_TripAnimation.pde

class Trips {
 int tripFrames;
 int startFrame;
 int endFrame;
 Location start;
 Location end;
 Location currentLocation;
 ScreenPosition currentPosition;
 
 // class constructor
 Trips(int duration,
       int start_frame,
       int end_frame,
       Location startLocation,
       Location endLocation)
       
       {  
       tripFrames = duration;
       startFrame = start_frame;
       endFrame = end_frame;
       start = startLocation;
       end = endLocation;
     }
   
   // function to draw each trip
   void plotTaxiRide(){
     if (frameCount >= startFrame && frameCount < endFrame){
       float percentTravelled = (float(frameCount) - float(startFrame)) / float(tripFrames);
       
       currentLocation = new Location(
         
         lerp(start.x, end.x, percentTravelled),
         lerp(start.y, end.y, percentTravelled));
         
       currentPosition = map.getScreenPosition(currentLocation);

       ellipse(currentPosition.x, currentPosition.y, 3, 3);
       
     }
   }
   
   void plotBusRide(){
     if (frameCount >= startFrame && frameCount < endFrame){
       float percentTravelled = (float(frameCount) - float(startFrame)) / float(tripFrames);
       
       currentLocation = new Location(
         
         lerp(start.x, end.x, percentTravelled),
         lerp(start.y, end.y, percentTravelled));
         
       currentPosition = map.getScreenPosition(currentLocation);

       ellipse(currentPosition.x, currentPosition.y, 4, 4);
      
     }
   }
   
   void plotSubwayRide(){
     if (frameCount >= startFrame && frameCount < endFrame){
       float percentTravelled = (float(frameCount) - float(startFrame)) / float(tripFrames);
       
       currentLocation = new Location(
         
         lerp(start.x, end.x, percentTravelled),
         lerp(start.y, end.y, percentTravelled));
         
       currentPosition = map.getScreenPosition(currentLocation);

       ellipse(currentPosition.x, currentPosition.y, 6, 6);
      
     }
   }
   
   void plotBigFerryRide(){
     if (frameCount >= startFrame && frameCount < endFrame){
       float percentTravelled = (float(frameCount) - float(startFrame)) / float(tripFrames);
       
       currentLocation = new Location(
         
         lerp(start.x, end.x, percentTravelled),
         lerp(start.y, end.y, percentTravelled));
         
       currentPosition = map.getScreenPosition(currentLocation);

       ellipse(currentPosition.x, currentPosition.y, 8, 8);
      
     }
   }
   
   void plotSmallFerryRide(){
     if (frameCount >= startFrame && frameCount < endFrame){
       float percentTravelled = (float(frameCount) - float(startFrame)) / float(tripFrames);
       
       currentLocation = new Location(
         
         lerp(start.x, end.x, percentTravelled),
         lerp(start.y, end.y, percentTravelled));
         
       currentPosition = map.getScreenPosition(currentLocation);

       ellipse(currentPosition.x, currentPosition.y, 6, 6);
      
     }
   }
   
   void plotBikeRide(){
     if (frameCount >= startFrame && frameCount < endFrame){
       float percentTravelled = (float(frameCount) - float(startFrame)) / float(tripFrames);
       
       currentLocation = new Location(
         
         lerp(start.x, end.x, percentTravelled),
         lerp(start.y, end.y, percentTravelled));
         
       currentPosition = map.getScreenPosition(currentLocation);

       ellipse(currentPosition.x, currentPosition.y, 5, 5);
      
     }
   }
   
   void plotBigTrainRide(){
     if (frameCount >= startFrame && frameCount < endFrame){
       float percentTravelled = (float(frameCount) - float(startFrame)) / float(tripFrames);
       
       currentLocation = new Location(
         
         lerp(start.x, end.x, percentTravelled),
         lerp(start.y, end.y, percentTravelled));
         
       currentPosition = map.getScreenPosition(currentLocation);

       ellipse(currentPosition.x, currentPosition.y, 10, 10);
      
     }
   }
   
   void plotSmallTrainRide(){
     if (frameCount >= startFrame && frameCount < endFrame){
       float percentTravelled = (float(frameCount) - float(startFrame)) / float(tripFrames);
       
       currentLocation = new Location(
         
         lerp(start.x, end.x, percentTravelled),
         lerp(start.y, end.y, percentTravelled));
         
       currentPosition = map.getScreenPosition(currentLocation);

       ellipse(currentPosition.x, currentPosition.y, 7, 7);
      
     }
   }
}
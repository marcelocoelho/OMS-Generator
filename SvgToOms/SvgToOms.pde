/* //////////////////////////////////////////////////////////////////////

  Marcelo Coelho
  November 6, 2011
  MIT Media Lab
  
  App for transforming SVG files into Resonetics toolpath.
  
  It only scans for simple lines in SVG and ignores paths and polylines.

////////////////////////////////////////////////////////////////////////*/

XMLElement xml;
PrintWriter output;


void setup() {
  size(200, 200);
  
  String loadPath = selectInput();  // Opens file chooser
    if (loadPath == null) {
      // If a file was not selected
      println("No file was selected...");
    } else {
      // If a file was selected, print path to file
      println(loadPath);
    }  
  
  
  // LOAD FILES AND OPEN WRITER
  xml = new XMLElement(this, loadPath);
  int numSites = xml.getChildCount();
  
  // EXTRACT FILE NAME
  String[] fullPath = split(loadPath, '/');                     //split path
  String[] filename = split(fullPath[fullPath.length-1], '.');  //split filename

  // USE FILENAME TO CREATE OUTPUT FILE
  output = createWriter("data/"+filename[0]+".oms"); 
  
  // WRITE OMS HEADER
  output.println("AA LP0,0,0,0,0");  
  output.println("PP10000");    

  
  for (int i = 0; i < numSites; i++) {
    XMLElement kid = xml.getChild(i);
    
    float x1 = kid.getFloat("x1");
    float x2 = kid.getFloat("x2");
    float y1 = kid.getFloat("y1");
    float y2 = kid.getFloat("y2");    

  // WRITE MOVE TO BEGINNING OF PATH
  output.println("VL1.0,1.0");  
  output.println("AC5.0,5.0");
  output.println("MA"+x1/1000+","+y1/1000);
  
  // WRITE ETCHING PATH
  output.println("VL0.1,0.1"); 
  output.println("AC5.0,5.0");
  output.println("WT100");
  output.println("CutAbs "+x2/1000+","+y2/1000);

  ////// REPEAT TO MAKE THE CUT DEEPER /////////
  // WRITE MOVE TO BEGINNING OF PATH
  output.println("VL1.0,1.0");  
  output.println("AC5.0,5.0");
  output.println("MA"+x1/1000+","+y1/1000);
  
  // WRITE ETCHING PATH
  output.println("VL0.1,0.1"); 
  output.println("AC5.0,5.0");
  output.println("WT100");
  output.println("CutAbs "+x2/1000+","+y2/1000);
  
  }

  // GO BACK TO ZERO
  output.println("VL1.0,1.0");  
  output.println("AC5.0,5.0");
  output.println("MA0,0");


  // WRITE OMS FOOTER
  output.println("END");


  // CLOSE FILE
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  println("DONE!");
  exit(); // Stops the program


}






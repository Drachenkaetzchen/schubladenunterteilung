/*
 * Variable Schubladenunterteilung
 * Author: Felicia <felicia@drachenkatze.org>
 */

/* Width of the paper rail
 * If you use clips, this should be your paper
 * width plus the clip height. If your 3D printer isn't
 * precise and tends to print gaps larger than they are,
 * you might need to test it with 0.1mm increments.
 */
paperwidth=3.2; 
      
/* The length of the paper guide rails */      
guidelen=20;

/* The outside width of the rails. Depends on your
 * 3D Printer. A 2mm thick rail is usually good */
guidewidth=2;   // How thick should the rails be

/* The rail height */
height=10;      // How high should the rails be

/* The base thickness */
bottomwidth=2;  // Base thickness

tri=false;       // Should it be a quad or tri piece
edge=false;      // If true, renders an edge piece

// Advanced
clips=true;     // If true, adds clips to hold the paper
clipsize=0.5;   // The clip height
clipwidth=5;       // The width of the clips
clipheight = 2; // The offset of the clips relative to the model's centre

module maincube () {
cube([
    (2*guidelen)+(2*guidewidth)+paperwidth,
    (2*guidelen)+(2*guidewidth)+paperwidth,
    height],
    center=true);
}

module paperguides (trilen) {
    vlen = (2*guidelen)+(2*guidewidth)+paperwidth;
    trilen = vlen;
    
    if (tri) {
        trilen = guidelen;
    } else {
        trilen = vlen;
    }
        
    translate([0,0,bottomwidth]) {
    cube([
    vlen,
    paperwidth,
    height],
    center=true);
        
        cube([
        paperwidth-0.15,
        trilen,
    height],
    center=true);
    }
}

module cutawaycube () {
cube([guidelen,guidelen,height],center=true);
}

cutawayoffset=guidelen/2+paperwidth/2+guidewidth;

module all () {
difference () {
    maincube();
    paperguides(tri);
    
    translate([cutawayoffset,cutawayoffset,0]) {
    cutawaycube();
    }
    
    
    translate([-cutawayoffset,cutawayoffset,0]) {
    cutawaycube();
    }
    
    translate([cutawayoffset,-cutawayoffset,0]) {
    cutawaycube();
    }
    
    translate([-cutawayoffset,-cutawayoffset,0]) {
    cutawaycube();
    }
    
}

    if (clips) {
    rotate([0,0,0]) {
    clips();
    }
    rotate([0,0,90]) {
    clips();
    }
    rotate([0,0,180]) {
    clips();
    }
    rotate([0,0,270]) {
    clips();
    }
}
}

difference() {
    all();
    
    if (tri || edge) {
        translate([0,paperwidth+(2*guidewidth)+guidelen]) {
        cube([(2*guidelen)+(2*guidewidth)+paperwidth,
               (2*guidelen)+(2*guidewidth)+paperwidth,
        height],center=true);
        }
    }
    
    if (edge) {
        rotate([0,0,90]) {
        translate([0,paperwidth+(2*guidewidth)+guidelen]) {
        cube([(2*guidelen)+(2*guidewidth)+paperwidth,
               (2*guidelen)+(2*guidewidth)+paperwidth,
        height],center=true);
        }
    }
    }
    
    
}

// Generates a single, 45° rotated clip
module clip () {
    translate([0,0,clipheight]) {
    rotate([45,0,0]) {
     cube([clipwidth, clipsize*2, clipsize*2],center=true);
    }
    }
}

module twoclips () {
    translate([guidelen/4*2,0,0]) {
    clip();
    }
    
    translate([guidelen/4*4,0,0]) {
    clip();
    }
}

module clips () {
    translate([0,paperwidth/2,0]) {
    twoclips();
    }
    
    translate([0,0-paperwidth/2,0]) {
    twoclips();
    }
}


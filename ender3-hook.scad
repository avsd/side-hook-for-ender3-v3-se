/**
 * Hook on the corner of Ender 3 V3 SE's gantry
 */

// Width of the vertical part of the gantry
gantryWidth = 39.78;

// Thickness of the vertical part of the gantry
gantryThickness = 2.80;

// Height of the top gantry
topGantryHeight = 18.00;


hookTopWidth = 20;
hookLength = 20;
hookTipLength = 5;
hookCutDepth = 5;
hookCutWidth = 2;

thickness = 3;

frameDistance = 5;
frameHeightBig = 30;
frameHeightSmall = 20;

lockDepth = 1.2;

roundingRadius = 0.5;

allowance = 0.2;

totalLength = gantryWidth + hookLength + hookCutWidth + hookTipLength;
totalHeight = thickness + topGantryHeight + frameDistance + frameHeightBig;

module halfHook(mirrorIndex)
    translate([hookTopWidth / 2, roundingRadius, 0]) mirror([mirrorIndex, 0, 0]) difference() {
        square([hookTopWidth / 2 - roundingRadius, totalLength - roundingRadius * 2]);
        translate([hookTopWidth / 2, totalLength - hookTipLength, 0])
            square([
                2 * (hookCutDepth + roundingRadius),
                hookCutWidth + roundingRadius * 2
            ], center=true);
    }

module hook() linear_extrude(thickness) minkowski() {
    union() { halfHook(0); halfHook(1); }
    circle(roundingRadius, $fn=50);
}

module sidePanel() linear_extrude(totalHeight) minkowski() {
    translate([roundingRadius, roundingRadius, 0])
        square([thickness - roundingRadius * 2, gantryWidth + (thickness + allowance) * 2 - roundingRadius * 2]);
    circle(roundingRadius, $fn=50);
}

totalLockThickness = thickness * 2 + gantryThickness + allowance * 2;
totalLockWidth = thickness * 2 + gantryWidth + allowance * 2;
module locks() translate([0, 0, totalHeight - frameHeightBig]) intersection() {

    difference() {

        // Squared frame
        linear_extrude(frameHeightBig, convexity=10) difference() {
            square([totalLockThickness, totalLockWidth]);
            translate([thickness, thickness]) square([gantryThickness + allowance * 2, gantryWidth + allowance * 2]);
            translate([thickness + gantryThickness + allowance, thickness + lockDepth])
                polygon([
                    [0, 0],
                    [thickness + allowance * 2, -lockDepth * 2],
                    [thickness + allowance * 2, gantryWidth],
                    [0, gantryWidth - lockDepth * 2],
                ]);
        }

        // Angle cut
        mirror([1, 0, 0]) translate([-totalLockThickness, 0, 0])
            linear_extrude(frameHeightBig - frameHeightSmall, scale=[0, 1], convexity=10)
                square([totalLockThickness, totalLockWidth]);

    }

    // Rounded box
    linear_extrude(frameHeightBig) minkowski() {
        translate([roundingRadius, roundingRadius, 0])
            square([totalLockThickness - roundingRadius * 2, totalLockWidth - roundingRadius * 2]);
        circle(roundingRadius, $fn=50);
    };

}

mirror([isMirrored == 1 ? 1 : 0, 0, 0]) union() {
    hook();
    sidePanel();
    locks();
}

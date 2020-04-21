run("Blobs (25K)");
thresholdFraction(0.5);
waitForUser("Hodor");
close()


function thresholdFraction (fraction) {
	bitDepthImage=bitDepth();
	upper=pow(2, bitDepthImage);
	print(upper);
	setThreshold(fraction*upper, upper);
	run("Make Binary");
}
setTool("rectangle");
waitForUser("Make a rectangular selection");
selection=selectionType(); // 0 = rectangle
while (selection != 0) {
	setTool("rectangle");
	run("Select None");
	waitForUser("Make a rectangular selection");
	selection=selectionType();
}

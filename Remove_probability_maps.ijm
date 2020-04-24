dir=getDirectory("Choose a Directory");
dirName=File.getName(dir);
dirParent=File.getParent(dir);
outputDir=dirParent+File.separator+dirName+"_original_files";
File.makeDirectory(outputDir);
list=getFileList(dir);
setBatchMode(true);
for (i=0; i<list.length; i++) {
	if (endsWith(list[i], "tif") && indexOf(list[i], "Probabilities") == -1) {
		print("Processing", list[i]);
		open(dir+File.separator+list[i]);
		formatIndex=lastIndexOf(list[i], ".tif");
		saveName=substring(list[i], 0, formatIndex);
		saveAs("tif", outputDir+File.separator+saveName);
		close();
	}
}
print("End of process");
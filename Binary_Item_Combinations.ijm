// ask for the number of items to be combined
#@ Integer (label="Items", value=3, persist=true) items

// calculate the number of combinations
nCombinations=pow(2, items);
combinations=newArray(nCombinations);

// for each possible combination
for (i=0; i<nCombinations; i++) {
	
	// repeat (while) if the binary sequence has been already obtained
	again=true;
	while (again) {

		// obtain a radom binary sequence (length=items)
		for (j=0; j<items; j++) {
			digit=round(random);
			digit=d2s(digit, 0);
			if (j == 0) {
				sequence=digit;
			} else {
				sequence+=digit;
			}
		}

		// check that the binary sequence has not been already used
		if (i==0) {
			used=false;
		} else {
			used=false;
			for (k=0; k<nCombinations; k++) {
				currentCombination=combinations[k];
				check=matches(currentCombination, sequence);
				if (check) {
					used=true;
				}
			}
		}

		// if it has not, store it within the array
		if (!used) {
			combinations[i]=sequence;
			again=false;
		}
	}
}

// sort and print the array
Array.sort(combinations);
Array.print(combinations);

// print te number of combinations
print(combinations.length);
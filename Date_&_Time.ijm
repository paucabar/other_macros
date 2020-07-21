macro "Date & Time" {
	getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
	dayOfMonth=d2s(dayOfMonth, 0);
	while (lengthOf(dayOfMonth) < 2) {
		dayOfMonth="0"+dayOfMonth;
	}
	month+=1;
	month=d2s(month, 0);
	while (lengthOf(month) < 2) {
		month="0"+month;
	}
	hour=d2s(hour, 0);
	while (lengthOf(hour) < 2) {
		hour="0"+hour;
	}
	minute=d2s(minute, 0);
	while (lengthOf(minute) < 2) {
		minute="0"+minute;
	}

	print("Date (DD/MM/YY)     "+ dayOfMonth+"/"+month+"/"+year);
	print("Time (24h clock)       " + hour+":"+minute);
}





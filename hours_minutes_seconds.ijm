
print(hours_minutes_seconds(3661));

function hours_minutes_seconds(seconds) {
	hours=seconds/3600;
	hours_floor=floor(hours);
	remaining_seconds=seconds-(hours_floor*3600);
	remaining_minutes=remaining_seconds/60;
	minutes_floor=floor(remaining_minutes);
	remaining_seconds=remaining_seconds-(minutes_floor*60);
	hours_floor=d2s(hours_floor, 0);
	minutes_floor=d2s(minutes_floor, 0);
	remaining_seconds=d2s(remaining_seconds, 0);
	if (lengthOf(hours_floor) < 2) hours_floor="0"+hours_floor;
	if (lengthOf(minutes_floor) < 2) minutes_floor="0"+minutes_floor;
	if (lengthOf(remaining_seconds) < 2) remaining_seconds="0"+remaining_seconds;
	return hours_floor+":"+minutes_floor+":"+remaining_seconds;
}
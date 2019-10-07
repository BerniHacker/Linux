# This script is a template for running loops in Linux with consolle feedback.

# Getting the start time
start_time=$(date +"%T")  # HH:MM:SS format
start_times=$(date +%s)  # seconds format
# Printing the script's start time
echo "Script's start time: $start_time"

# Starting a loop from 1 to 100
i=1  # Initializing the loop variable
increment=10
total=100
while [ $i -le $total ]
do
	# Doing something which takes some time
	sleep 10  # Waiting 10 seconds
	echo "action executed"
	# Getting the current time
	current_time=$(date +"%T") # HH:MM:SS format
	current_times=$(date +%s)  # in seconds format
	# Calculating the number of handled items so far
        sofar=$(($i + $increment - 1))
	# Calculating the speed as handled items per second
	elapsed_time=$(($current_times - $start_times))
	speed=$(($sofar / $elapsed_time))
	# Calculating the estimated remaining seconds
	remaining_items=$(($total - $sofar))
	estimated_seconds=$(($remaining_items / $speed))
	# Printing on the consolle to show progress
	echo "ids from $i to `expr $i + $increment - 1` processed at $current_time"
	echo "items handled so far $sofar"
	echo "remaining time:"
	printf '%02d:%02d:%02d\n' $(($estimated_seconds/3600)) $(($estimated_seconds%3600/60)) $(($estimated_seconds%60))
	# Incrementing the loop variable
	i=`expr $i + $increment`
done

# Getting the end time
end_time=$(date +"%T")  # HH:MM:SS format
end_times=$(date +%s)  # in seconds format
# Calculating the duration
duration=$(($end_times - $start_times))
# Printing the script's end time
echo "Script's end time: $end_time"
# Printing the script's duration
echo "Script's duration:"
printf '%02d:%02d:%02d\n' $(($duration/3600)) $(($duration%3600/60)) $(($duration%60))
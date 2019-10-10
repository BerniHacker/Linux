
# This script allows dumping a defined table
# from a defined origin MySQL database into a defined destination
# MySQL database.
# It is assumed that the destination database contains a table with same name
# and with identical structure as the table to be copied.
# The dumps are split into chunks, each checking a range of ids (each range
# covers a range of id values defined by the variable INCREMENT).
# Note that it is assumed that the table has a variable called 'id'.

# Defining the setting variables
INCREMENT=1000  # integer
TOTAL=3000  # integer (it shall be a multiple of INCREMENT)
# Origin database credentials
ORIGIN_DB_USER='username'  # string
ORIGIN_DB_PASSWORD='password'  # string
ORIGIN_DB_ADDRESS='address'  # string
ORIGIN_DB_NAME='dbname'  # string
TABLE_NAME='tablename'  # string
# Destination database credentials
DEST_DB_USER='username'  # string
DEST_DB_PASSWORD='password'  # string
DEST_DB_ADDRESS='address'  # string
DEST_DB_NAME='dbname'  # string

# Getting the start time
start_time=$(date +"%T")  # HH:MM:SS format
start_time_s=$(date +%s)  # seconds format
# Printing the script's start time
printf "\nScript's start time: $start_time \n\n"
printf "****************************************\n\n"

# Starting a loop from 1 to TOTAL
i=1
while [ $i -le $TOTAL ]  # using the less or equal condition
do
    # Dumping data into the dump.sql file
    mysqldump -u $ORIGIN_DB_USER --password=$ORIGIN_DB_PASSWORD \
    --host=$ORIGIN_DB_ADDRESS $ORIGIN_DB_NAME $TABLE_NAME \
    --where="id >= $i and id < $i+$INCREMENT" \
    --skip-add-drop-table --no-create-info > dump.sql
    printf "partial dumping into file executed \n\n"

    # Inserting the dumped data into the destination database
    mysql -u $DEST_DB_USER --password=$DEST_DB_PASSWORD \
    --host=$DEST_DB_ADDRESS $DEST_DB_NAME < dump.sql
    printf "data inserted in the destination DB \n\n"

    # Getting the current time
    current_time=$(date +"%T") # HH:MM:SS format
    current_time_s=$(date +%s)  # in seconds format
    # Calculating the number of handled items so far
    sofar=$(($i + $INCREMENT - 1))
    # Providing feedback about the number of handled items on the consolle
    printf "ids from $i to $sofar processed at $current_time \n\n"

    # Providing additional consolle feedback
    # Calculating the elapsed time
    elapsed_time=$(($current_time_s - $start_time_s))
    # Avoiding divisions by zero
    if [ $elapsed_time -gt 0 ]; then  # using the 'greater than' operator
        # Calculating the speed as number of handled items per second
        speed=$(($sofar / $elapsed_time))
	# Calculating the estimated remaining seconds
	remaining_items=$(($TOTAL - $sofar))
        # Avoiding divisions by zero
        if [ $speed -gt 0 ]; then  # using the 'greater than' operator
	    estimated_seconds=$(($remaining_items / $speed))
	    # Printing on the consolle the remaining time
	    printf 'remaining time: %02d:%02d:%02d\n' \
            $(($estimated_seconds/3600)) $(($estimated_seconds%3600/60)) \
            $(($estimated_seconds%60))
            printf "\n****************************************\n\n"
        else
            printf "****************************************\n\n"
        fi  # ending the internal if condition
    else
        printf "****************************************\n\n"
    fi  # ending the external if condition

    # Incrementing the loop variable of INCREMENT
    i=`expr $i + $INCREMENT`
done

# Getting the end time
end_time=$(date +"%T")  # HH:MM:SS format
end_time_s=$(date +%s)  # seconds format
# Calculating the duration
duration=$(($end_time_s - $start_time_s))
# Printing the script's end time
printf "Script's end time: $end_time \n"
# Printing the script's duration
printf "Script's duration: %02d:%02d:%02d\n\n" \
$(($duration/3600)) $(($duration%3600/60)) $(($duration%60))
function print_filled_file_template(template, date_str) {
    year=substr(date_str,1,4)
    month=substr(date_str,5,2)
    day=substr(date_str,7,2)
    gsub("%d2", day, template)
    gsub("%m2", month, template)
    gsub("%y4", year, template)
    print template
}

{ 
    # Determine highest frequency token
    if ($1~/%d2/) {
        freq="1 day"
    } else if ($1~/%m2/) {
        freq="1 month"
    } else if ($1~/%y4/) {
        freq="1 year"
    } else {
        freq="None"
    }

    # Print file with all tokens
    if (freq == "None") {
        print $1
    } else {
        # Left bracketing time
        cmd=sprintf("date -d \"%s-%s\" \"+%%Y%%m%%d\"", START_DATE, freq)
        if (!(cmd | getline one_before_date)) {
            exit 1
        }
        close(cmd)
        print_filled_file_template($1, one_before_date)

        # Print for each between START AND END
        date=START_DATE
        while (date < END_DATE) {
            print_filled_file_template($1, date)
            
            cmd=sprintf("date -d \"%s+%s\" \"+%%Y%%m%%d\"", date, freq)
            if (!(cmd | getline date)) {
                exit 1
            }
            close(cmd)
        }

        # Right bracketing time
        print_filled_file_template($1, date)
    }
}
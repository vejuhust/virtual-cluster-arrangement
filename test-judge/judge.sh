#!/bin/bash

INDATADIR=input_data
OUTDATADIR=output_data
WADATADIR=wa_data

if [ $# -eq 0 ];
then
    app=./hybrid.rb
    max_test=-1
    printf "no arguments : script - app - set_count.\n"
else 
    if [ $# -eq 1 ];
    then
        app=$1
        max_test=-1
    else
        if [ $# -eq 2 ];
        then
            app=$1
            max_test=$2
        fi
    fi
fi

printf "'%s' will be tested for %s.\n" "$app" "$max_test"

rm -fr "$WADATADIR"
mkdir "$WADATADIR"

test_index=0
right_count=0
for infile in "$INDATADIR"/input*.txt
do
    printf "[Test %d: %s] ...... " "$test_index" "$infile"
    outfile=${infile//input/output}
    outfile=${outfile//"$INDATADIR"/"$OUTDATADIR"}
    cp "$infile" input.txt

    standard_line=$(head -1 "$outfile")
    if [ "$standard_line" = "#0 solutions" ];
    then
        standard_ans=0
    else
        standard_ans=$[$(echo "$standard_line" | wc -w)]
    fi

    candidate_line=$("$app" | head -1)
    if [ "$candidate_line" = "no solution" ];
    then
        candidate_ans=0
    else
        candidate_ans=$[$(echo "$candidate_line" | wc -w)]
    fi

    if [ "$standard_ans" = "$candidate_ans" ];
    then
        right_count=$[$right_count + 1]
        printf "OK (%d == %d)\n" "$standard_ans" "$candidate_ans"
    else
        wrong_count=$[$wrong_count + 1]
        printf "WA (%d != %d)\n" "$standard_ans" "$candidate_ans"
        cp "$infile" "$WADATADIR"
    fi

    test_index=$[$test_index + 1]
    if [ "$test_index" -eq "$max_test" ];
    then
        break
    fi
done

printf "%d of %d is correct. rate = %.2f%%\n" "$right_count" "$test_index" $(echo 'scale=6; '"$right_count"/"$test_index"'*100' | bc)

rm -f input.txt

exit 0

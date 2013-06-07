#!/bin/bash

INDATADIR=input_data
OUTDATADIR=output_data

if [ $# -ne 1 ];
then
    app=./standard.out
    printf "no arguments.\n"
else
    app=$1
fi
printf "'%s' will be executed to generate output.\n" "$app"

mkdir "$OUTDATADIR"

test_index=0
for infile in "$INDATADIR"/input*.txt
do
    outfile=${infile//input/output}
    outfile=${outfile//"$INDATADIR"/"$OUTDATADIR"}
    cp -f "$infile" input.txt
    "$app" > "$outfile"
    printf "[Output %d: %s] %s\n" "$test_index" "$infile" "$result"
    test_index=$[$test_index + 1]
done

rm -f input.txt

exit 0

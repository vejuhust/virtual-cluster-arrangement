#!/bin/bash

INDATADIR=input_data
OUTDATADIR=output_data
EMTDATADIR=empty_data

rm -fr "$EMTDATADIR"
mkdir "$EMTDATADIR"

for infile in "$INDATADIR"/input*.txt
do
    outfile=${infile//input/output}
    outfile=${outfile//"$INDATADIR"/"$OUTDATADIR"}
    standard_line=$(head -1 "$outfile")

    if [ "$standard_line" = "#0 solutions" ];
    then
        mv "$infile" "$EMTDATADIR"/
        mv "$outfile" "$EMTDATADIR"/
    fi

done

exit 0

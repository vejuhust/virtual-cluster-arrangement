#!/bin/bash

DATADIR=../input_data

mkdir "$DATADIR"

function generate() {
    INDEX_END=$[$INDEX + $1]
    for ((; INDEX < $INDEX_END; INDEX += 1))
    do
        printf "[%.3d] N=%2d M=%2d expect=%2d range=%d\n" $INDEX $2 $3 $4 $5
        filename=$(printf "%s/input%.3d.txt" "$DATADIR" "$INDEX")
        python ./datamaker.py -n $2 -m $3 -e $4 -r $5 > "$filename"
        printf "#N=%2d M=%2d expect=%2d range=%d\n" $2 $3 $4 $5 >> "$filename"
        if [ $? -ne 0 ]
        then
            INDEX=$[$INDEX-1]
        fi
    done
}

INDEX=0

generate 5 2 5 1 1024
generate 5 3 10 1 1024
generate 5 3 10 2 1024
generate 5 4 4 1 1024
generate 5 4 6 2 1024
generate 5 4 8 3 1024
generate 5 5 1 1 1024
generate 5 5 3 2 1024
generate 5 5 5 3 1024
generate 5 5 7 4 1024
generate 5 5 10 1 2048
generate 5 5 10 2 2048
generate 5 5 10 3 2048
generate 5 5 10 4 2048
generate 5 5 10 5 2048
generate 5 8 5 1 4096
generate 5 8 6 2 4096
generate 5 8 5 3 4096
generate 5 8 6 4 4096
generate 5 8 7 5 4096
generate 5 8 6 6 4096
generate 5 8 7 7 4096
generate 5 8 6 8 4096
generate 5 10 5 2 6144
generate 5 10 8 4 6144
generate 5 10 10 6 6144
generate 5 10 12 8 6144
generate 5 12 10 1 8192
generate 5 12 10 2 8192
generate 5 12 10 3 8192
generate 5 12 10 4 8192
generate 5 14 8 1 10240
generate 5 14 10 2 10240
generate 5 14 12 3 10240
generate 5 14 10 4 10240
generate 5 14 12 5 10240
generate 5 16 8 1 20480
generate 5 16 8 2 20480
generate 5 16 8 3 20480
generate 5 16 8 4 20480
generate 5 17 10 1 40960
generate 5 17 10 2 40960
generate 5 17 10 3 40960
generate 5 17 10 4 40960
generate 5 18 12 1 81920
generate 5 18 12 2 81920
generate 5 18 12 3 81920
generate 5 18 12 4 81920
generate 5 19 14 1 163840
generate 5 19 14 2 163840
generate 5 19 14 3 163840
generate 5 19 14 4 163840
generate 5 20 16 1 327680
generate 5 20 16 2 327680
generate 5 20 16 3 327680
generate 5 20 16 4 327680
generate 5 20 16 5 327680
generate 5 20 16 6 327680
generate 5 20 16 8 327680
generate 5 20 16 10 327680
generate 5 21 20 1 655360
generate 5 21 20 2 655360
generate 5 21 20 3 655360
generate 5 21 20 4 655360
generate 5 21 20 5 655360
generate 5 21 20 6 655360
generate 5 21 20 7 655360
generate 5 21 20 8 655360
generate 5 21 20 10 655360
generate 5 21 20 12 655360
generate 5 21 20 14 655360
generate 5 21 20 16 655360
generate 5 22 30 1 655360
generate 5 22 30 2 655360
generate 5 22 30 3 655360
generate 5 22 30 4 655360
generate 5 22 30 6 655360
generate 5 22 30 8 655360
generate 5 22 30 10 655360
generate 5 22 30 12 655360
generate 5 22 30 14 655360
generate 5 22 30 16 655360
generate 5 22 30 18 655360
generate 5 22 30 20 655360
generate 5 23 30 1 655360
generate 5 23 30 2 655360
generate 5 23 30 3 655360
generate 5 23 30 4 655360
generate 5 23 30 6 655360
generate 5 23 30 8 655360
generate 5 23 30 5 655360
generate 5 23 30 12 655360
generate 5 23 30 14 655360
generate 5 23 30 16 655360
generate 5 23 30 18 655360
generate 5 23 30 20 655360
generate 5 24 30 1 655360
generate 5 24 30 2 655360
generate 5 24 30 3 655360
generate 5 24 30 4 655360
generate 5 24 30 6 655360
generate 5 24 30 8 655360
generate 5 24 30 5 655360
generate 5 24 30 12 655360
generate 5 24 30 14 655360
generate 5 24 30 16 655360
generate 5 24 30 18 655360
generate 5 24 30 20 655360
generate 5 25 30 1 655360
generate 5 25 30 2 655360
generate 5 25 30 3 655360
generate 5 25 30 4 655360
generate 5 25 30 6 655360
generate 5 25 30 8 655360
generate 5 25 30 5 655360
generate 5 25 30 12 655360
generate 5 25 30 14 655360
generate 5 25 30 16 655360
generate 5 25 30 18 655360
generate 5 25 30 20 655360


exit 0
